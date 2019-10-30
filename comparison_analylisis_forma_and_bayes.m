clear all
close all
addpath pot
addpath eq
addpath acf
addpath psd
addpath msd
addpath forma
addpath bayesian
load('Data_positions_Fig9_1P2_S.mat')



x = x - repmat(mean(x),size(x,1),1);
kB=1.38e-23; % Boltzmann constant [m^2kg/s^2K]
T=300;  % Temperature [K]
r=1.03E-6;      % Particle radius [m]
v=0.00002414*10^(247.8/(-140+T));  % Water viscosity [Pa*s]
gamma=pi*6*r*v; %[m*Pa*s]
dnn=1e3*(1:1e1:500-1);
disp(length(dnn));
for nj=1:length(dnn)

  
disp(nj);
xn =x(1:dnn(nj), :);
N=size(xn);
disp(N);
 if 9==0 

%Potential
[k_pot(nj), sigma_k_pot(nj), ~, ~, ~, ~, ~, ~, ~,~]=pot_lfit(xn,T,50);
%Equipartition
[k_eq(nj), sigma_k_eq(nj)]=eq1d(xn,T);
%autocorrelation function
[k_acf(nj), sugma_acf(nj), D_acf(nj), sigam_D_acf(nj),gamma_exp(nj), sigma_gamma_exp(nj),~, ~, ~,~, ~, ~]=acf_lfit(xn,T,dt);

%power spectral density
nw=round(size(xn,1)/500); 
[fc_exp,D_exp(nj),sigma_fc_exp,sigma_D_exp(nj),~,~,~,~,~,~]=psd_lfit(xn,dt,nw,1/4);
gamma_psd(nj)=kB*T./D_exp(nj);

sigma_gamma_psd(nj)=kB*T./D_exp(nj)^2*sigma_D_exp(nj);

k_psd(nj)=2*pi*gamma*fc_exp;

sigma_k_psd(nj)=2*pi*gamma*sigma_fc_exp;

%mean square displacement
maxlag=50;
subs=20;
[k_msd(nj),sigma_k_msd(nj),~, ~, D_msd(nj), ED_msd(nj), ~, ~, ~, ~, gamma_msd(nj), sigma2_gamma_msd(nj)]=msd_nfilt(xn(1:subs:size(xn,1),:),T,dt*subs,maxlag);
   end
%especial data format for FORMA and bayesian  analysis
xl=reshape(xn, [size(xn,1)*size(xn,2),1 ]);
subs=10;
%FORMA

[fc_forma,D_forv,Efc_forma,sigma_D_forma_v] = forma1d(xn(1:subs:end, :), dt*subs);
D_forma(nj)=mean(D_forv);
gamma_forma=kB*T./D_forma(nj);
kfor=gamma_forma.*mean(fc_forma);
disp(kfor);
k_forma(nj)=kfor;
sigma_k_forma=gamma_forma.*Efc_forma;
%BAYESIAN
[k_bay(nj), sigma_k_bay(nj), gamma_bay(nj), sigma_gamma_bay(nj), D_bay(nj), sigma_D_bay(nj)]= bayesian(xl(1:subs:end), dt*subs,T, a);

end


%save('results_comparison.mat', 'k_pot', 'sigma_k_pot', 'k_eq', 'sigma_k_eq')
%%
close all
%load('results_comparison.mat')
% semilogx(dnn(1:30), k_pot*1e6, 'DisplayName', 'Potential', 'Color', 'red', 'LineWidth', 3)
% hold on
% semilogx(dnn(1:30), k_eq*1e6, 'DisplayName', 'Equipartition', 'Color', 'blue', 'LineWidth', 3)
% semilogx(dnn(1:30), k_acf*1e6, 'DisplayName', 'ACF', 'Color', 'cyan', 'LineWidth', 3)
% semilogx(dnn(1:30), k_psd*1e6, 'DisplayName', 'PSD', 'Color', 'yellow', 'LineWidth', 3)
% semilogx(dnn(1:30), k_msd*1e6, 'DisplayName', 'MSD', 'Color', 'black', 'LineWidth', 3)

semilogx(dnn, k_forma, 'DisplayName', 'FORMA', 'Color', 'magenta', 'LineWidth', 3)
hold on
semilogx(dnn, k_bay, 'DisplayName', 'BAYESIAN', 'Color', [0.1 0.5 0.7], 'LineWidth', 3)
legend