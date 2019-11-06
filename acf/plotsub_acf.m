function [k_acf_lf,Ek_acf_lf,D_acf_lf,ED_acf_lf,gamma_acf_lf, sigma2_gamma_acf_lf , k_acf_nl, Ek_acf_nl, D_acf_nl, ED_acf_nl,gamma_acf_nl, sigma2_gamma_acf_nl, tau0_exp_lf, tau0_exp_nl,Xpix, Ypix]=plotsub_pot(filename, positioninthefig1, title1, T, subsample, partau0, end_plot,aa)
load(filename);
disp(filename);
kb=1.38e-23;

%blue color
col1=[73/255,4/255,10/255];
	
%yellow
col2=[241/255,185/255,14/255];
%gray color for experimental data

%colbar=[4/255,45/255,73/255];
colbar=[7/255, 79/255, 129/255];
% xwi = 400;    % width of the plot square
% bx1 = 80;     % extra space at the left
% bx2 = 20;     % extra space at the right
% 
% Xpix = 3.5*xwi+3*bx1+3*bx2;  % total
% 
% ywi = 300;    % length riquadro con funzione
% by1 = 60;     % extra space below
% by2 = 30;     % extra space up
% Ypix = 2*by1+2*ywi+3*by2;  % larghezza figura in pixel

P=50;

%number of bins of the histogram, if not set default is 50
%linear fit
[k_acf_lf, Ek_acf_lf, D_acf_lf, ED_acf_lf,gamma_acf_lf, sigma2_gamma_acf_lf,tau_acf_lf, mc, Ec,indc, tau0_exp_lf, c0_exp_lf]=acf_lfit(x(1:subsample:size(x,1),:),T,dt*subsample);
%[k_acf_lf, Ek_acf, D_acf, ED_acf, tau_lf, mc, Ec,indc, tau0_exp_lf, c0_exp_lf]=acf_lfit(x(1:subsample:size(x,1),:),T,dt*subsample);
%non linear fit
[k_acf_nl, Ek_acf_nl, D_acf_nl, ED_acf_nl,gamma_acf_nl, sigma2_gamma_acf_nl, tau_nl, mc, Ec, indc, tau0_exp_nl, c0_exp_nl]=acf_nlfit(x(1:subsample:size(x,1),:),T,dt*subsample);

axes( 'Position',positioninthefig1);  % fa in modo di centrare il riquadro degli assi nella posizione voluta
%bar(x_alpha_lf*1e6, mrho_lf*1e-6, 'EdgeColor', 'white', 'FaceColor', colbar, 'facealpha', 0.8, 'HandleVisibility','off')

col2=[1,0,0];
col3=[0.00,0.45,0.74];

%%This is not working anymore%%
%errorbar(tau_acf_lf(1:20:end_plot*indc), mc(1:20:end_plot*indc)*1e12, Ec(1:20:end_plot*indc)*1e12,'.','MarkerSize',10,'LineWidth', 1.5, 'Color', colbar 'DisplayName', 'Experimental autocorrelation function');


e=errorbar(tau_acf_lf(1:20:end_plot*indc)*1e3,mc(1:20:end_plot*indc)*1e18,Ec(1:20:end_plot*indc)*1e18,'.','MarkerSize',25 ,'LineWidth', 1.5,'Color',colbar, 'DisplayName', 'Experimental ACF');
e.Color = col3;
hold on
plot(tau_acf_lf(1:20:end_plot*indc)*1e3,c0_exp_lf*exp(-tau_acf_lf(1:20:end_plot*indc)/tau0_exp_lf)*1e18, 'LineWidth',3,'Color',col2, 'DisplayName',  'Linear fitting')

plot(tau_nl(1:20:end_plot*indc)*1e3,c0_exp_nl*exp(-tau_nl(1:20:end_plot*indc)/tau0_exp_nl)*1e18, '--', 'LineWidth',3,'Color','k', 'DisplayName',  'Non -linear fitting')


  %%This is working
  %  scatter(tau_acf_lf(1:20:end_plot*indc),mc(1:20:end_plot*indc)*1e12,60,'o','markerfacecolor', col3,'markeredgecolor',col3);
 

 

 
%plot(tau(1:20:6*indc),c0_exp*exp(tau(1:20:6*indc)/tau0_exp)*1e12,'b')
% % 
% disp('Integral of the fitted probability distributions')
% disp('Linear fitting')
% disp(sum(rhomodel_lf*1e-6)*((x_alpha_lf(2)-x_alpha_lf(1))*1e6));
% disp('Non-linear fitting')
% disp(sum(rhomodel_nl*1e-6)*((x_alpha_lf(2)-x_alpha_lf(1))*1e6));
% plot(x_alpha_lf*1e6, rhomodel_lf*1e-6, 'LineWidth',3,'Color',col2, 'DisplayName',  'Linear fitting');
% hold on 
% 
% plot(x_alpha_nl*1e6, rhomodel_nl*1e-6,'--','LineWidth',3,'Color',col1, 'DisplayName', 'Non-linear fitting')
% errorbar(x_alpha_lf*1e6,  mrho_lf*1e-6, 1e-6*abs(sigma2_rho_lf),'o','MarkerSize',7 ,'LineWidth', 1.5,'Color',colbar, 'DisplayName', 'Experimental probability distribution');
 box on
% %xticks((-0.5:0.1:0.5)*1e-7);
ntaus=6;
plot([tau0_exp_lf*ntaus,tau0_exp_lf*ntaus]*1e3,[-0.5,400],'--k', 'HandleVisibility','off')
text(tau0_exp_lf*ntaus*partau0*1e3,0.4e2,[num2str(ntaus),'$\tau_0$'],'Interpreter','latex','FontSize',30)
xlim([-0.2 9]);
ylim([-0.1, 3]*1e2)
% set(gca,'TickLabelInterpreter','latex', 'linewidth',1.5,'FontSize',15);
% xlabel('$x(\mu m)$','Interpreter','Latex', 'FontSize',20)
% ylabel('$\rho (\rm{\mu m^{-1}})$','Interpreter','Latex', 'FontSize',20)
% hold off
 
% legend
% 
% %second figure, Energy potential distribution, exp I
% axes('Position',positionintefig2);  
% hold on;
% 
% %scatter(x_alpha_lf*1e6, -log(mrho_lf)-U_0_exp,80,'o', 'markerfacecolor','colbar', 'markeredgecolor', colbar , 'DisplayName', 'Experimental values of potential energy')
% %errorbar(x_alpha_lf*1e6,  -log(mrho_lf)-U_0_exp_nl, -log(1e-6*abs(sigma2_rho_lf)), 'Color', colbar,  'DisplayName', 'Experimental values of potential energy');

% 
% 
% 
% plot(x_alpha_lf*1e6,U_model_lf-U_0_exp_lf, 'LineWidth',3,'Color',col2,'DisplayName',  'Linear fitting')
% hold on
% plot(x_alpha_nl*1e6,U_model_nl-U_0_exp_nl, '--', 'LineWidth',3,'Color',col1, 'DisplayName', 'Non-linear fitting')
% box on
% 
% %xticks((-0.5:0.1:0.5)*1e-7);
% 
% errorbar(x_alpha_lf*1e6,  -log(mrho_lf)-U_0_exp_nl, sigma2_U_lf/(kb*T), 'o','MarkerSize',7,'LineWidth', 1.5, 'Color', colbar,  'DisplayName', 'Experimental values of potential energy');
% 
% xlim([-0.06 0.06]);
% %xlim([x_alpha_lf(1)*1e6 x_alpha_lf(end)*1e6]);
if aa==5
set(gca,'TickLabelInterpreter','latex', 'linewidth',1.5, 'FontSize',25);
else 
   set(gca,'TickLabelInterpreter','latex', 'linewidth',1.5, 'FontSize',25,'Yticklabel',[]);
    end
 
 
 
 xlabel('$\tau(\rm ms)$','Interpreter','Latex', 'FontSize',30)

 
 %% abc
xwi = 400;    % width of the plot square
bx1 = 120;     % extra space at the left
bx2 = 20;     % extra space at the right

Xpix = 3*xwi+bx1+3*bx2;  % total

ywi = 300;    % length riquadro con funzione
by1 = 110;     % extra space below
by2 = 70;     % extra space up

Ypix = 1*by1+1*ywi+1*by2;  % larghezza figura in pixel


 if aa==5
 ylabel('$C(    \rm {nm^2})$','Interpreter','Latex','FontSize',30, 'FontName', 'TimesNewRoman')
%  legend ({'a','b','c'},'Box','off','Position',[2*bx1 Ypix/2+20 0 0])
LL= legend ({'Experimental ACF','Non-linear fitting','Linear fitting'},'Box','off','Position',[0.2 0.6 0.1 0.2])

LL.FontSize = 18
 end
 axes('Position',[(0) 0 Xpix 0]/Xpix + [0 0 0 Ypix]/Ypix);  % fa in modo di centrare il riquadro degli assi nella posizione voluta
hold on

xt = [bx1-100,bx1+xwi+bx2,bx1+2*(xwi+bx2)];
yt = [ by1+ywi+30,by1+ywi+30,by1+ywi+30];
str = {'\bf a','\bf b','\bf c'};
text(xt,yt,str,'Interpreter','Latex','FontSize',34)

hold off


axis off

xlim([0 Xpix])
ylim([0 Ypix])

hold off
% 

end