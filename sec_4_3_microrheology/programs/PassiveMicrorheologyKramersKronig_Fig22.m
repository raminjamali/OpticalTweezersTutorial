%% Compute storage G'(f) and loss G''(f) modulus of complex fluid 
%by Passive Microrheology from equilibrium Power Spectral Density (PSD)
%of embedded particle trapped by optical tweezers,
%using Kramers Kronig relation to find real part of response function
%from imaginary part, using Fluctuation-Dissipation theorem.
%A file containing the coordinates of the trapped article and the
%corresponding time is needed, and must be specified in the parameters 
%Filepath and Filename. This line could be replaced by load() is the data
%are provided as MATLAB files

% File CPyCl5mM.txt is needed to run PassiveMicrorheologyKramersKronig and get the plots of Figs. 2(c) and (d).
% This file contains the particle position (first column) and the corresponding time (second column).

clear all
close all
NFFT = 2^17; %number of points to compute PSD

%read files
Filepath = '../data/PassiveMicrorheologyData/';
Filename = 'CPyCl5mM';
Extension = '.txt';

T0=22; %bath temperature
kB=1.38e-23; %Boltzman constant
T0 =T0 + 273.16;
r = (2.0e-6)/2; %particle radius
filname = [Filepath Filename Extension];

%Read data
Data = dlmread(filname,'',1,0);


x = Data(:,1); %position in meters
t = Data(:,2); %time in seconds
fs = 1/(t(2)-t(1)); %sampling frequency


bx1 = 150;     % bordo a sinistra
xwi = 540;    % larghezza riquadro con funzione
bx2 = 30;     % bordino a destra

Xpix = 3*bx1+3*xwi+2*bx2;  % larghezza figura in pixel
Xpix =1400;
by1 = 110;     % bordo in basso
ywi = 500;    % altezza riquadro con funzione
by2 = 50;     % bordo in alto

Ypix = by1+ywi+by2;  % larghezza figura in pixel


%Determine trapstifness by equipartition theorem
k=kB*T0/var(x) 

%Compute PSD
[f,spx] = spectave(detrend(x),fs,NFFT);

% figure(2)
% loglog(f,spx,'b')
% hold on
% xlabel('f [Hz]')
% ylabel('PSD [m^2 Hz]')
% title('Equilibrium PSD of trapped particle')


%Smooth PSD using polynomial fit of degree D
D = 11;
spxn=spx(3:end);
logsx=log(spx(3:end));
logf = log(f(3:end));
coeffx=polyfit(logf,logsx,D);
spx1=exp(polyval(coeffx,(logf),D));
spx(3:end)=spx1;


f = f(3:end);


%Compute imaginary (chi2) and real (chi1) parts of linear response function of x
%to perturbative force
chi2=pi*f.*spx1/2/kB/T0; %Fluctuation-dissi�tion Theorem
chi11=KramersKronig(2*pi*f,chi2');
chi1=chi11';

%Compute storage (G1) and loss (G2) modulus from linear response function
G1 = chi1./(chi1.^2+chi2.^2)/6/pi/r - k/6/pi/r;
G2 = chi2./(chi1.^2+chi2.^2)/6/pi/r;



col3=[0.00,0.45,0.74];
col4=[0.8500, 0.3250, 0.0980];

figure('Position',[10 20 Xpix Ypix]); % crea la figura
axes('Position',[bx1 0 xwi 0]/Xpix + [0 by1 0 ywi]/Ypix);  % fa in modo di centrare il riquadro degli assi nella posizione voluta


loglog(f,spxn*1e18,'color',col3)

xlim([1e-2 1e3])
 ylim([1e-4 1e5])
 yticks([1e-4,1e0,1e5]);
hold on
xlabel('$f \rm (Hz)$', 'Interpreter','Latex', 'FontSize',30)
ylabel('PSD (nm$^2$ Hz$^{-1}$)', 'Interpreter','Latex', 'FontSize',30)

set(gca,'TickLabelInterpreter','latex', 'linewidth',1.5,'FontSize',25,'TickLength',[0.02, 0.01]);

%Smooth PSD using polynomial fit of degree D

loglog(f,spx1*1e18,'--', 'LineWidth',3,'Color','k')

xticks([1e-1,1e0,1e1,1e2,1e3]);

axes('Position',[2*bx1+xwi 0 xwi 0]/Xpix + [0 by1 0 ywi]/Ypix); 
loglog(f,G1,'r o')
hold on
loglog(f,G2,'s','Color',col3)

xlim([2e-2 2e3]);
ylim([3e-3 5e1]);

xticks([1e-2,1e-1,1e0,1e1,1e2,1e3]);

xlabel('$f \rm (Hz)$', 'Interpreter','Latex', 'FontSize',30)
ylabel('$ G'' (f), G'''' (f)(\rm Pa)$', 'Interpreter','Latex', 'FontSize',30)

set(gca,'TickLabelInterpreter','latex', 'linewidth',1.5,'FontSize',25,'TickLength',[0.02, 0.01]);


axes('Position',[bx1+100 0 280 0]/Xpix + [0 by1+80 0 130]/Ypix); 

plot(t,x*1e9)
xlim([0 1e1]);
ylim([-2e2 2e2]);
yticks([-2e2,0,2e2]);
xlabel('$t (\rm s)$','Interpreter','Latex', 'FontSize',30)
ylabel('$x (\rm nm)$','Interpreter','Latex', 'FontSize',30)
set(gca,'TickLabelInterpreter','latex', 'linewidth',1.5,'FontSize',18,'TickLength',[0.02, 0.01]);


axes('Position',[(0) 0 Xpix 0]/Xpix + [0 0 0 Ypix]/Ypix);  
hold on

xt = [bx1-120,bx1+xwi+bx2];
yt = [ by1+ywi+30,by1+ywi+30];
str = {'\bf a','\bf b'};
text(xt,yt,str,'Interpreter','Latex','FontSize',34)

hold off


axis off

xlim([0 Xpix])
ylim([0 Ypix])

%saveas(gcf,'Fig22.eps','epsc')
%saveas(gcf,'Fig22.fig')