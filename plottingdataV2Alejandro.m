close all, clear all;

%%  ==============Parameter declaration============


kB=1.38e-23; % Boltzmann constant [m^2kg/s^2K]
T=300;  % Temperature [K]
r=1.03E-6;      % Particle radius [m]
v=0.00002414*10^(247.8/(-140+T));  % Water viscosity [Pa*s]
gamma=pi*6*r*v; %[m*Pa*s]


%%  ==============Selecting file============
% 
% [filename,pathname,d] = uigetfile('*.mat;');
% [pathstr,name,ext] = fileparts(filename);


%%  =========Loading selected file============

X=load('X.mat');
Y=load('Y.mat');
Z=load('Z.mat');


%%  ==============Reading data===============
N=length(X.Vx);

nd=3;
nbins=60;
% dt=A(2,1)-A(1,1);
dt=1E-5;
fs=1/dt;
t=[0:dt:dt*(N-1)]';

    
% t=A(:,1);
%     x=A(:,2); 
    x=X.Vx(:,nd); 
    x=x-mean(x);

   
%     y=A(:,3);
    y=Y.Vy(:,nd);
    y=y-mean(y);
    
%     z=A(:,4); 
     z=Z.Vz(:,nd); 
    z=z-mean(z);
      
      
      

%%  ==============Plotting tracks===============
% 
% 
%     figure
%     plot(t,x);   
%     title('SIGNALx');
%     xlabel('Time (s)');
%     ylabel('x (volts)');
%
%
% %
%     figure
%     plot(t,y);
%     title('SIGNALy');
%     xlabel('Time (s)');
%     ylabel('y (volts)');
% 
% 
%     figure
%     plot(t,z);
%     title('SIGNALz');
%     xlabel('Time (s)');
%     ylabel('z (volts)');

%%  ==============Spectrum Calculation===============

% 
% m = length(x); %window length
% n = 8*pow2(nextpow2(m)); %transform length
% y = fft(x,n); %DFT
% f = (0:n-1)*fs/n; %frequency range
% power = y.*conj(y)/n; %Power of the DFT
% 
% y0 = fftshift(y); %Rearange y values
% f0 = (-n/2:n/2-1)*(fs/n); %0_centered freq values
% power0 = y0.*conj(y0)/n; %0_centered power
% 
% %phase = unwrap(angle(y0));
% 
% ydb = mag2db(abs(y0)/n);
% figure;
% plot(t,x)
% figure;
% plot(f0, power0)
% xlabel('Frequency (Hz)')
% xlim([0 1000])
% grid on
% ylabel('Power')
% title('{\bf Periodogram}')

%%  ==============Skewness Calculation===============

Skwx=skewness(x)
Skwy=skewness(y)
Skwz=skewness(z)

%%  ==============Autocorrelations Calculation===============
% 
% N=length(x);
% 
% ACFx = xcov(x,'biased');
% ACFx=ACFx(N:end);
% % 
% ACFy = xcov(y,'biased');
% ACFy=ACFy(N:end);
% 
% ACFz = xcov(z,'biased');
% ACFz=ACFz(N:end);
% 
% %%  ==============Fitting ACF and parameter calculation===============
% 
% % prompt='input the x range value for fitting=';
% %  xset = input(prompt) ;
% %
% 
%  xlimit=500;
%  ACFxl=ACFx(1:xlimit,:);
%  tx=t(1:xlimit,:);
%  modelFun =  @(p,x) p(1).*(exp(-x.*p(2)))+p(3);
% 
% startingVals = [0.00008 50 0];
% coefEsts = nlinfit(tx, ACFxl, modelFun, startingVals);
% 
% Acf.Ax=coefEsts(1);
% Acf.Omx=coefEsts(2);
% Acf.x_y0=coefEsts(3);
% ACFxf = Acf.Ax.*exp(-Acf.Omx.*tx)+Acf.x_y0;
% Acf.kx=Acf.Omx*gamma*1000000; %[PN/um]
% Acf.bx=sqrt(Acf.Ax*Acf.Omx*gamma/(kB*T))/1000000; %[Volt/um]
% 
% 
% 
% 
%  ylimit=500;
%  ACFyl=ACFy(1:ylimit,:);
%  ty=t(1:ylimit,:);
% startingVals = [0.00008 50 0];
% coefEsts = nlinfit(ty, ACFyl, modelFun, startingVals);
% 
% Acf.Ay=coefEsts(1);
% Acf.Omy=coefEsts(2);
% Acf.y_y0=coefEsts(3);
% ACFyf = Acf.Ay.*exp(-Acf.Omy.*ty)+Acf.y_y0;
% Acf.ky=Acf.Omy*gamma*1000000; %[PN/um]
% Acf.by=sqrt(Acf.Ay*Acf.Omy*gamma/(kB*T))/1000000; %[Volt/um]
% 
% 
% % 
%  zlimit=1000;
%  ACFzl=ACFz(1:zlimit,:);
%  tz=t(1:zlimit,:);
%  
% startingVals = [0.0001 100 0];
% coefEsts = nlinfit(tz, ACFzl, modelFun, startingVals);
% 
% Acf.Az=coefEsts(1);
% Acf.Omz=coefEsts(2);
% Acf.z_y0=coefEsts(3);
% ACFzf = Acf.Az.*exp(-Acf.Omz.*t)+Acf.z_y0;
% Acf.kz=Acf.Omz*gamma*1000000; %[PN/um]
% Acf.bz=sqrt(Acf.Az*Acf.Omz*gamma/(kB*T))/1000000; %[Volt/um]
% 
% 
% 
% %%  ==============Saving trap parameters===============
% 
% % save( [num2str(name) '_ACF_param'],'Acf');
% 
% %%  ==============Plotting ACF===============
% 
% 
% figure
% semilogx(tx,ACFxl);
% hold on;
% semilogx(tx,0*ACFxl);
% hold on;
% semilogx(tx,ACFxf);
% xlabel('Lag time [s]');
% ylabel('ACF_{xx} (volts^2)');
% %legend(name);
% 
% 
% 
% figure
% semilogx(ty,ACFyl);
% hold on;
% semilogx(ty,0*ACFyl);
% hold on;
% semilogx(ty,ACFyf);
% xlabel('Lag time [s]');
% ylabel('ACF_{yy} (volts^2)');
% legend(name);
% % 
% 
% figure
% semilogx(t,ACFz);
% hold on;
% semilogx(t,0*ACFz);
% hold on;
% semilogx(t,ACFzf);
% xlabel('Lag time [s]');
% ylabel('ACF_{zz} (volts^2)');
% legend(name);
% 
% 
% 
% 
% %%  ==============Plotting Histogram===============
% 
% %       nbins = 20;
% %     
% %     figure;
% %     
% %     hist(x, nbins);
% %     title('HISTx')
% %     xlabel('x (volts)');
% %     ylabel('Counts (a.u)');
% %     legend(name);
% % 
% %     figure;
% %     hist(y, nbins);
% %     title('HISTy')
% %     xlabel('y (volts)');
% %     ylabel('Counts (a.u)');
% %     legend(name);
% % 
% %     figure;
% %     hist(z, nbins);
% %     title('HISTz')
% %     xlabel('z (volts)');
% %     ylabel('Counts (a.u)');
% %     legend(name);
% 
% 
% %% ==============Power spectrum calcultaion===============
% 
% freqs = 1/(t(2)-t(1)) ;
% freq = 0:freqs/N:freqs/2;
% 
% 
% 
%     xdft = fft(x);
%     xdft = xdft(1:N/2+1);
%     psdx = (1/(freqs*N)) * abs(xdft).^2;
%     psdx(2:end-1) = 2*psdx(2:end-1);
% 
% 
% 
%    ydft = fft(y);
%    ydft = ydft(1:N/2+1);
%    psdy = (1/(freqs*N)) * abs(ydft).^2;
%    psdy(2:end-1) = 2*psdy(2:end-1);
% 
% 
%    zdft = fft(z);
%    zdft = zdft(1:N/2+1);
%    psdz = (1/(freqs*N)) * abs(zdft).^2;
%    psdz(2:end-1) = 2*psdz(2:end-1);
% 
%    
% %%============PSD analysys=========
%    
%     %======X Analisys ========
%     
% modelFun =  @(p,x) p(1)./(x.^2+p(2).^2);
% 
% startingVals = [0.000001 200];
% coefEsts = nlinfit(freq', psdx, modelFun, startingVals);
% 
% Pws.Ax=coefEsts(1);
% Pws.Omx=abs(coefEsts(2));
% Pws.kx=2*pi*Pws.Omx*gamma*1000000; %[PN/um]
% Pws.bx=sqrt(Pws.Ax*gamma*2*pi^2/(kB*T))/1000000; %[Volt/um]
% 
% PSDfcurvex=Pws.Ax./(freq'.^2+Pws.Omx.^2);
% 
% %======Y Analisys ========
%     
% modelFun =  @(p,x) p(1)./(x.^2+p(2).^2);
% 
% startingVals = [0.000001 200];
% coefEsts = nlinfit(freq', psdy, modelFun, startingVals);
% 
% Pws.Ay=coefEsts(1);
% Pws.Omy=abs(coefEsts(2));
% Pws.ky=2*pi*Pws.Omy*gamma*1000000; %[PN/um]
% Pws.by=sqrt(Pws.Ay*gamma*2*pi^2/(kB*T))/1000000; %[Volt/um]
% 
% PSDfcurvey=coefEsts(1)./(freq'.^2+coefEsts(2).^2);
% 
% 
% 
% %======Z Analisys ========
%     
% modelFun =  @(p,x) p(1)./(x.^2+p(2).^2);
% 
% startingVals = [0.000001 300];
% coefEsts = nlinfit(freq', psdz, modelFun, startingVals);
% 
% Pws.Az=coefEsts(1);
% Pws.Omz=abs(coefEsts(2));
% Pws.kz=2*pi*Pws.Omz*gamma*1000000; %[PN/um]
% Pws.bz=sqrt(Pws.Az*gamma*2*pi^2/(kB*T))/1000000; %[Volt/um]
% 
% PSDfcurvez=coefEsts(1)./(freq'.^2+coefEsts(2).^2);
% 
% % 
% % save( [num2str(name) '_PWS_param'],'Pws');
% % % 
% % figure
% % scatter(freq',psdz);
% % set(gca,'xscale','log','yscale','log')
% % hold on
% % loglog(freq,PSDfcurvez);
% % box on
% 
% 
% 
% %%  ==============Power spectrum plotting===============
% % 
% % 
% figure
% 
% loglog(freq,psdx);
% grid on;
% title('PWRx');
% xlabel('Frequency (Hz)');
% ylabel('Power spectrum (volts^2/Hertz)');
% hold on 
% loglog(freq,PSDfcurvex);
% 
% legend(name);
% 
% 
%     figure
%     loglog(freq,psdy);
%     grid on;
%     title('PWRy');
%     xlabel('Frequency (Hz)');
%     ylabel('Power spectrum (volts^2/Hertz)');
%     hold on 
%     loglog(freq,PSDfcurvey);
%     legend(name);
% 
%     figure
%     loglog(freq,psdz);
%     grid on;
%     title('PWRz');
%     xlabel('Frequency (Hz)');
%     ylabel('Power spectrum (volts^2/Hertz)');
%     hold on 
%     loglog(freq,PSDfcurvez);
%     legend(name);
% % 
% % 
% % 
% % 
% 
% %  ==============Calculating MSD ==============
% 
%  for n = 1:N-1
% 
%      msdx(n)=sum((x(1+n:end)- x(1:end-n)).^2)/(N-n);
%       msdy(n)=sum((y(1+n:end)- y(1:end-n)).^2)/(N-n);
%       msdz(n)=sum((z(1+n:end)- z(1:end-n)).^2)/(N-n);
% 
%  end
% 
% s = (t(2,1)-t(1,1))*[1:length(msdx)];
% 
% 
% %%  ==============MSD Fitting and analisys ==============
% 
% %      ==============X Analisys ==============
% modelFun =  @(p,x) p(1)*(1-exp(-p(2).*x));
% 
% startingVals = [0.0001 0.1];
% coefEsts = nlinfit(s, msdx, modelFun, startingVals);
% 
% MSD.Ax=coefEsts(1);
% MSD.Omx=coefEsts(2);
% MSDfcurvex=MSD.Ax*(1-exp(-MSD.Omx*s));
% 
% MSD.kx=MSD.Omx*gamma*1000000; %[PN/um]
% MSD.bx=sqrt(MSD.Ax*MSD.Omx*gamma/(kB*T))/1000000; %[Volt/um]
% 
% 
% 
% %  ==============Y Analisys ==============
% 
% startingVals = [0.0001 0.001];
% coefEsts = nlinfit(s, msdy, modelFun, startingVals);
% 
% MSD.Ay=coefEsts(1);
% MSD.Omy=coefEsts(2);
% MSDfcurvey=MSD.Ay*(1-exp(-MSD.Omy*s));
% 
% 
% MSD.ky=MSD.Omy*gamma*1000000; %[PN/um]
% MSD.by=sqrt(MSD.Ay*MSD.Omy*gamma/(kB*T))/1000000; %[Volt/um]
% 
% %  ==============Z Analisys ==============
% 
% startingVals = [0.0001 0.001];
% coefEsts = nlinfit(s, msdz, modelFun, startingVals);
% 
% MSD.Az=coefEsts(1);
% MSD.Omz=coefEsts(2);
% MSDfcurvez=MSD.Az*(1-exp(-MSD.Omz*s));
% 
% MSD.kz=MSD.Omz*gamma*1000000; %[PN/um]
% MSD.bz=sqrt(MSD.Az*MSD.Omz*gamma/(kB*T))/1000000; %[Volt/um]
% % % 
% % save( [num2str(name) '_MSD_param'],'MSD');
% %
% % %%  ==============MSD plotting===============
% figure
% loglog(s,msdx);
% xlabel('s [s]')
% ylabel('MSD_x [m^2]')
% hold on
% loglog(s,MSDfcurvex)
% 
% legend(name);
% %
% 
% figure
% loglog(s,msdy);
% xlabel('s [s]')
% ylabel('MSD_y [m^2]')
% hold on
% loglog(s,MSDfcurvey)
% legend(name);
% %
% figure
% loglog(s,msdz);
% xlabel('s [s]')
% ylabel('MSD_z [m^2]')
% hold on
% loglog(s,MSDfcurvez)
% 
% legend(name);
% 
% 
% xdt=log(freq');
% ydt=log(psdy);
% % [fitresult, gof] =createFit1(xdt, ydt);
% %  psdy=psdy';
% %



%%  ==============Plotting kx from different methods ===============
% 
% trend=[Pws.kx,Acf.kx,0,0,0,0,Pws.kx,Acf.kx,0,0,0,0,Pws.kz,Acf.kz];
% plot(trend);



%%  ==============X Potential analysis===============
 

% Cal=Acf;
% xmic=x/Cal.bx;
[a,b]=hist(x, nbins);
f = fit(b.',a.','gauss1');
cfx = coeffvalues(f);
a1=cfx(1);
b1=cfx(2);
c1=cfx(3);

fnx=  a1*exp(-((b-b1)/c1).^2);


% 
%     figure()
%     
%     bar(b,a)
%     %       xlim([-10 10]);
%     hold on
%     %         plot(f,b,a)
%     %         hold on
%     plot(b,fnx,'r')
% %     title('SIGNALx');
%     xlabel('x (um)');
%     ylabel('x probability distribution (counts)');

    ptx=-log(a);
%          figure()
%          plot(b,ptx)
         
    modelFun =  @(p,x) 0.5*((x+p(1)).^2).*p(2)+p(3);

startingVals = [0 10 11.07];
coefEsts = nlinfit(b, ptx, modelFun, startingVals);

Pot.x_0=coefEsts(1);
Pot.k_x=coefEsts(2);
Pot.Ax_0=coefEsts(3);
bl=[-0.27:0.005:0.265];
cppx=0.5*((bl+Pot.x_0).^2).*Pot.k_x+Pot.Ax_0;
% cppx=0.5*((b+0).^2).*2-0;
% 
% figure()
% scatter(b,ptx)
% hold on
% plot(b1,cppx)

% 
% xlabel('x (um)');
% ylabel('x potential(U/k_BT)');

Pot.kx=Pot.k_x*1e12*kB*T/1E6;



         
         

%%  ==============Y Potential analysis===============
% 
% ylimit=400;
% 
% ymic=y/Cal.by;
[ya,yb]=hist(y, nbins);
f = fit(yb.',ya.','gauss1');
cfy = coeffvalues(f);
a1=cfy(1);
b1=cfy(2);
c1=cfy(3);

fny=  a1*exp(-((yb-b1)/c1).^2);


% 
%     figure()
%     
%         bar(yb,ya)
%         %       xlim([-10 10]);
%         hold on
% %         plot(f,b,a)
% %         hold on
%         plot(yb,fny,'r')
%         xlabel('y (um)');
%     ylabel('y probability distribution (counts)');
        
    pty=-log(ya);
%          figure()
%          plot(b,ptx)


 modelFun =  @(p,x) 0.5*((x+p(1)).^2).*p(2)+p(3);

startingVals = [0 300 -11.07];
coefEsts = nlinfit(yb, pty, modelFun, startingVals);
         
   

Pot.y_0=coefEsts(1);
Pot.k_y=coefEsts(2);
Pot.Ay_0=coefEsts(3);
cppy=0.5*((yb+Pot.y_0).^2).*Pot.k_y+Pot.Ay_0;
% 
% figure()
% scatter(yb,pty)
% hold on
% plot(yb,cppy)
% 
% 
% xlabel('y (um)');
% ylabel('y potential(U/k_BT)');
% 
% xt = [-2 2];
% yt = [16 -16];
% str = {'local max','local min'};
% text(xt,yt,str)


Pot.ky=Pot.k_y*1e12*kB*T/1E6;


        

%%  ==============Z Potential analysis===============

% zmic=z/Cal.bz;
[za,zb]=hist(z, nbins);
fz = fit(zb.',za.','gauss1');
cfz = coeffvalues(fz);
a1=cfz(1);
b1=cfz(2);
c1=cfz(3);

fnz=  a1*exp(-((zb-b1)/c1).^2);

% 
% 
%     figure()
%     
%         bar(zb,za)
%         %       xlim([-10 10]);
%         hold on
% %         plot(f,b,a)
% %         hold on
%         plot(zb,fnz,'r')
%         xlabel('z (um)');
%         ylabel('z probability distribution (counts)');
%         
    ptz=-log(za);
%          figure()
%          plot(b,ptx)
         
    modelFun =  @(p,x) 0.5*((x+p(1)).^2).*p(2)+p(3);

startingVals = [0 200 -11.07];
coefEsts = nlinfit(zb, ptz, modelFun, startingVals);

Pot.z_0=coefEsts(1);
Pot.k_z=coefEsts(2);
Pot.Az_0=coefEsts(3);
cppz=0.5*((zb+Pot.z_0).^2).*Pot.k_z+Pot.Az_0;
% 
% figure()
% scatter(zb,ptz)
% hold on
% plot(zb,cppz)
% 
% xlabel('z (um)');
% ylabel('z potential(U/k_BT)');


Pot.kz=Pot.k_z*1e12*kB*T*1E6;
% 
% % 
% inizio
% figure();
% 
% clf
% 
% 
% col1=[0,0.6,0.8];
% 
% col2=[0.9,0.4,0.2];
% 
% set(gcf,'Position',[150 300 2000 600])
% % set(gcf,'Position',[22.5 45 300 90])
% 
%  axes('OuterPosition',[0 0 0.34 1])
%      
% 
% 
% plot(t,x);  
%  xticks(0:1:10);
%  set(gca,'TickLabelInterpreter','latex', 'linewidth',1.5,'FontSize',20);
% %  xlim([-0.3 0.3001]);
% 
% 
% xlabel('$t(s)$','Interpreter','Latex','FontSize',30 );
% ylabel('$x(\mu m)$','Interpreter','Latex','FontSize',30);
% 
% 
%  
% 
% 
%    
%     
% 
% 
% 
% axes('OuterPosition',[0.31 0 0.34 1])
% 
% 
%  bar(b,a)
%  hold on 
%  plot(b,fnx,'LineWidth',3,'Color',col2)
%  xticks(-0.3:0.1:0.3);
%  xlim([-0.3 0.3001]);
% 
% set(gca,'TickLabelInterpreter','latex', 'linewidth',1.5,'FontSize',20);
% 
% 
% 
% xlabel('$x(\mu m)$','Interpreter','Latex', 'FontSize',30)
% 
% ylabel('$\rho (\rm {counts})$','Interpreter','Latex', 'FontSize',30)
%   
% 
% 
% axes('OuterPosition',[0.63 0 0.34 1])
% 
% 
% 
% scatter(b(5:(end-2)),ptx(5:(end-2)),60,'o')
% 
% 
% scatter(b,ptx,60,'o','markerfacecolor', [0.00,0.45,0.74])
% 
% % set(gca,'xtick', 0.1)
% 
% 
% hold on
% % plot(b(5:(end-2)),cppx(5:(end-2)),'LineWidth',3,'Color',col2)
% plot(bl,cppx,'LineWidth',3,'Color',col2)
% box on
% %   xlim([-0.3 0.3001])
% %      set(gca,'XTick',[Min : 0.1 : Max]);
% xticks(-0.3:0.1:0.3);
%  xlim([-0.3 0.3001]);
%  
%   ylim([-12 2 ]);
% 
% 
% 
% set(gca,'TickLabelInterpreter','latex', 'linewidth',1.5, 'FontSize',20);
% 
% xlabel('$x(\mu m)$','Interpreter','Latex', 'FontSize',30)
% 
% % set(gca,'fontsize',25) 
% 
% ylabel('$U(k_BT)$','Interpreter','Latex','FontSize',30)
% %  ylabel(y_string, 'FontName', 'Palatino')
%     
%    %fine 


col1=[0,0.6,0.8];

col2=[0.9,0.4,0.2];
col2=[1,0,0];

col3=[0.00,0.45,0.74];

bx1 = 120;     % bordo a sinistra
xwi = 400;    % larghezza riquadro con funzione
bx2 = 30;     % bordino a destra

Xpix = 3*bx1+3*xwi+2*bx2;  % larghezza figura in pixel

by1 = 110;     % bordo in basso
ywi = 300;    % altezza riquadro con funzione
by2 = 50;     % bordo in alto

Ypix = by1+ywi+by2;  % larghezza figura in pixel


figure('Position',[10 20 Xpix Ypix]); % crea la figura
axes('Position',[bx1 0 xwi 0]/Xpix + [0 by1 0 ywi]/Ypix);  % fa in modo di centrare il riquadro degli assi nella posizione voluta
hold on;
plot(t,x*1000,'color', col3);  



box on
 xticks(0:1:10);
   ylim([-300 300]);
   yticks(-300:100:300);
 set(gca,'TickLabelInterpreter','latex', 'linewidth',1.5,'FontSize',25);
%  xlim([-0.3 0.3001]);


xlabel('$t(s)$','Interpreter','Latex','FontSize',30 );
ylabel('$x(\rm{nm})$','Interpreter','Latex','FontSize',30);

axes('Position',[(2*bx1+xwi+bx2) 0 xwi 0]/Xpix + [0 by1 0 ywi]/Ypix);  % fa in modo di centrare il riquadro degli assi nella posizione voluta
hold on;





 scatter(b(5:(end-2))*1000,ptx(5:(end-2)),60,'o')


 scatter(b*1000,ptx,60,'o','markerfacecolor', col3,'markeredgecolor',col3)

% set(gca,'xtick', 0.1)


hold on
% plot(b(5:(end-2)),cppx(5:(end-2)),'LineWidth',3,'Color',col2)
plot(bl*1000,cppx,'LineWidth',3,'Color',col2)

% 
% xt = [-0.4];
% yt = [3 ];
% str = {'c'};
% text(xt,yt,str,'FontSize',34)



box on
%   xlim([-0.3 0.3001])
%      set(gca,'XTick',[Min : 0.1 : Max]);
 xticks(-300:100:300);
  xlim([-300 300]);
  yticks(-12:2:2);
   ylim([-12 2 ]);


xlabel('$x( \rm nm)$','Interpreter','Latex', 'FontSize',30)

ylabel('$U(k_BT)$','Interpreter','Latex','FontSize',30)
set(gca,'TickLabelInterpreter','latex', 'linewidth',1.5, 'FontSize',25);

  
axes('Position',[(3*bx1+2*xwi+bx2) 0 xwi 0]/Xpix + [0 by1 0 ywi]/Ypix);  % fa in modo di centrare il riquadro degli assi nella posizione voluta
hold on;
      

 bar(b*1000,a)
 hold on 
 plot(b*1000,fnx,'LineWidth',3,'Color',col2)
 box on
 xticks(-300:100:300);
 xlim([-300 300]);
 yticks(-0:1E4: 7.0001E4);
 ylim([-0 7E4]);

set(gca,'TickLabelInterpreter','latex', 'linewidth',1.5,'FontSize',25);





ylabel('$\rho (\rm {counts})$','Interpreter','Latex', 'FontSize',30)
xlabel('$x( \rm nm)$','Interpreter','Latex', 'FontSize',30)

% set(gca,'fontsize',25) 

%  ylabel(y_string, 'FontName', 'Palatino')

 axes('Position',[(0) 0 Xpix 0]/Xpix + [0 0 0 Ypix]/Ypix);  % fa in modo di centrare il riquadro degli assi nella posizione voluta
hold on

xt = [bx1-110,bx1+xwi+bx1-70,2*bx1+2*xwi+bx1-35];
yt = [ by1+ywi+20,by1+ywi+20,by1+ywi+20];
str = {'\bf a','\bf b','\bf c'};
text(xt,yt,str,'Interpreter','Latex','FontSize',34)

hold off


axis off

xlim([0 Xpix])
ylim([0 Ypix])