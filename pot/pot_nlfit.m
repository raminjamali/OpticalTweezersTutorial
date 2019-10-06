function [k_pot, sigma2_k_pot, x_alpha, mrho, sigma2_rho, mU, sigma2_U, rho0, x_eq]=pot_nlfit(x,T,varargin)
    %POT_NLFIT   1D implementation of the POTENTIAL METHOD using non-linear fitting.
    %   POT_NLFIT(X,T, P) generates a estimator of the stiffness k_pot
    %   for the potential method using non-linear fitting. 
    %
    %   Inputs
    %   x: time series of the position of the particle
    %   T: temperature
    %   P: (optional) number of bins for the histogram, default is 50
    %
    %   Outputs
    %   k_pot: estimated stiffness using  non-linear fitting for the potential
    %   analysis
    %   sigma2_k_pot: standard deviation squared of the stiffness
    %   x_alpha: x -edges for the histogram
    %   mrho: mean of the probablility distribution, average over experiments
    %   sigma2_rho: standard deviation squared of the probablility distribution
    %   mU: mean of the potential energy, average over experiments
    %   sigma2_U: standard deviation squared of the potential energy
    %   rho0: normalization factor
    %   x_eq: equilibrium position

kb=1.38064852e-23;

%translate everithing to zero
x = x - repmat(mean(x),size(x,1),1);

%obtain number of experiments
[~,Nexp]=size(x);

%default number of bins
P=50;

%user defined number of bins
if nargin>2
    P=varargin{1};
end

%defines the bins edges
edges=linspace(min(x(:)),max(x(:)),P);

%defines the lenght of bins
dx=edges(2)-edges(1);

%defines central position of the bins
x_alpha=(edges(2:end)+edges(1:end-1))/2;

%define the histogram
for j=1:Nexp
    
    xx=x(:,j);
    
    [frequency(:,j)]=histcounts(xx,edges);

end


% after normalization it becomes the probability density
frequency=frequency./(sum(frequency,1)*dx);

%mean probability distribution
mrho=mean(frequency,2);

%standard deviation squared of probability distribution
sigma2_rho=std(frequency,[],2);

%delete zeros to avoid Inf in weights
sigma2_rho(sigma2_rho==0)=[];

% weights for fitting
w=1./sigma2_rho.^2;

%in case any other Inf value arises
w(isinf(w))=1;

%delete zeros to avoid Inf in weights
sigma2_rho(sigma2_rho==0)=1;

%normalization to avoid "Equation is badly conditioned"
maxbin=x_alpha(end); 
x_alpha=x_alpha/maxbin; 

ind=find(mrho==Inf);

mrho(ind)=[];

x_alpha(ind)=[];

w(ind)=[];

% Guess for the initial conditions for the non-linear fitting
a0=(max(mrho)*sqrt(pi))^2;

b0=0;


%Using non-linear fitting with weights

ft=fittype('sqrt(a/pi)*exp(-a*(x-b)^2)');

c=fit(x_alpha',mrho*maxbin,ft,'weights',w/maxbin^2,'StartPoint',[a0*maxbin^2,b0]);

%return to original variables after fit

x_alpha=x_alpha*maxbin;

%stiffness
k_pot=2*kb*T*c.a/maxbin^2; 

x_eq=c.b*maxbin^2;

%0.68 corresponds to one standard deviation
cint=confint(c,0.68);  

sigma2_k_pot=2*kb*T/maxbin^2*(cint(2,1)-cint(1,1))/2;

%estimate energy potential
logh=log(frequency);

mlogh=mean(logh,2);

Delta_logh=std(logh,[],2);

mU=-kb*T*(mlogh-max(mlogh));

sigma2_U=-kb*T*Delta_logh;

%estimation for the normalization factor
rho0=sqrt(c.a/pi)*1/maxbin;  

disp('...')

disp('Potential analysis using non linear fitting')

disp(['k_pot: ' num2str(k_pot*1e6) '+-' num2str(sigma2_k_pot*1e6) ' pN/um']);

