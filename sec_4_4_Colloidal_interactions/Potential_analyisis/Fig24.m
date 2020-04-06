%% INITIALIZATION
clear all; close all; clc;
set(0, 'defaultFigureRenderer', 'painters')

TempeK=300;
radius=1.03e-6;%+0.5*0.05e-6;
eta=0.003;

calc_2D = true;
%calc_2D = false;sc


bw = 0.02; % um

% filepath_expe = ['..' filesep 'Traj16' filesep];
% sottodir_expe='Analysis';
% if ~exist([filepath_expe sottodir_expe filesep],'dir')
%     error('EXPERIMENTAL dir does not exist\n');
%     return
% end


trapdist = 2.38e-6;
% %
% filepath_sim=['..' filesep 'd' num2str(trapdist*1e+9) '_D8' filesep];
% sottodir_sim='Analysis';
% if ~exist([filepath_sim sottodir_sim filesep],'dir')
%     error('SIMULATION dir does not exist\n');
%     return
% end

% experimental
% load([filepath_expe sottodir_expe filesep 'drift_diffu_dataset.mat'],'B','dri_av','dri_std','diffu_av','diffu_std',...
%     'distances','distances_phys','distances_meas','int_TW_list','int_T_list','d_hist',...
%     'Cc','Dc','NCc','NDc','tstep','str_label','T_exp','str_Mac','nt_drift','nt_diffusion','num_files','D0_spherical_bulk')

% set these parameters properly
i_e = 5;    % eta = 0.0019;
i_r = 13;   % radius = 1.040e-6;
i_p2m = 9;  % pix2micron = 0.02800;


load([...filepath_expe sottodir_expe filesep
    'drift_diffu_dataset' ...
    '_' num2str(i_e) '_' num2str(i_r) '_' num2str(i_p2m) '.mat'],'B',...
    'dri_av','dri_std','diffu_av','diffu_std',...
    'distances','distances_phys','distances_meas','int_TW_list','int_T_list','d_hist',...
    'Cc','Dc','NCc','NDc','Ccpar','Dcpar','Ccperp','Dcperp',...
    'tstep','str_label','T_exp','str_Mac','nt_drift','nt_diffusion','bw','num_files',...
    'D0_spherical_bulk','Xrel','Yrel',...
    'dripar_av','dripar_std','diffupar_av','diffupar_std',...
    'driperp_av','driperp_std','diffuperp_av','diffuperp_std'...
    );



ik_list = [3 10 11 12 13];
%ik_list = [3 10 11 12 13];
const_ind_col = numel(ik_list)+1;

if numel(ik_list)>=8
    const_ind_col = 9;
    colo{abs(const_ind_col-1)}=[1    0    0   ];
    colo{abs(const_ind_col-2)}=[1    0.5  0   ];
    colo{abs(const_ind_col-3)}=[1    1    0   ];
    colo{abs(const_ind_col-4)}=[0.1  1    0.05];
    colo{abs(const_ind_col-5)}=[0    0.8  0.9 ];
    colo{abs(const_ind_col-6)}=[0    0    1   ];
    colo{abs(const_ind_col-7)}=[0.05 0    0.7 ];
    colo{abs(const_ind_col-8)}=[0.5  0    0.5 ];
end
if numel(ik_list)==5
    colo{abs(const_ind_col-1)}=[1    0    0   ];
    colo{abs(const_ind_col-2)}=[1    0.5  0   ];
    colo{abs(const_ind_col-3)}=[1    0.7    0   ];
    colo{abs(const_ind_col-4)}=[0.1  1    0.05];
    colo{abs(const_ind_col-5)}=[0    0    1   ];
end
if numel(ik_list)==6
    colo{abs(const_ind_col-1)}=[1    0    0   ];
    colo{abs(const_ind_col-2)}=[1    0.5  0   ];
    colo{abs(const_ind_col-3)}=[1    0.7    0   ];
    colo{abs(const_ind_col-4)}=[0.1  1    0.05];
    colo{abs(const_ind_col-5)}=[0    0.75 1];
    colo{abs(const_ind_col-6)}=[0    0    1   ];
end

for i = 1:numel(colo)
    colo_light{i} = 0.4*colo{i}+0.6;
end

for i = 1:numel(colo)
    colo_dark{i} = 1*colo{i};
end





load('propagator_traj_choices.mat','i_peak_peak','i_opt_peak','i_peak_opt','i_opt_opt');

for ik = 1:numel(ik_list)
    k = ik_list(ik);
    fh{k}=open(['propagator_' num2str(k) '.fig']);
    ah{k}=get(fh{k},'Children');
end


name_fig{1} = 'h3_xi10_NL.fig';
name_fig{2} = 'h10_xi24_NL.fig';
name_fig{3} = 'h11_xi28_NL.fig';
name_fig{4} = 'h13_xi34_NL.fig';

letter{1} = 'a';
letter{2} = 'b';
letter{3} = 'c';
letter{4} = 'd';

numfig=numel(name_fig);

for i=1:numfig
    
    hf{i} = open(name_fig{i});
    
end

%% get the info for a new figure




for ik = 1:(numel(ik_list))
    k = ik_list(ik);
    
    posi = get(fh{k},'Position');
    xwi(ik) = posi(3);
    ywi(ik) = posi(4);
    posi = get(ah{k},'Position');
    xwi_norm(ik) = posi(3);
    xwi_norm(ik) = 0.5;
    ywi_norm(ik) = 1;
    x_range(ik,:) = get(ah{k},'XLim');
    y_range(ik,:) = get(ah{k},'YLim');
    x_tick{ik} = get(ah{k},'XTick');
    y_tick{ik} = get(ah{k},'YTick');
    x_tick_lab{ik} = get(ah{k},'XTickLabel');
    y_tick_lab{ik} = get(ah{k},'YTickLabel');
end

%% new figure
xwi_ff = xwi.*xwi_norm;
ywi_ff = ywi.*ywi_norm;


% all in a row

dyt = 45;
dyb = 100;
dym=50;
dxl = 80;
dxm = 10;
dxr = 10;

xwi = 200;
ywi = 200;
Ypix = dyt + ywi_ff(1)+ywi+ dyb+ 60 ;
Xpix = dxl + sum(xwi_ff(1:(end-1))) + (numel(ik_list)-2)*dxm + dxr;


ffh = figure('Position',[10 10 Xpix Ypix]);

fsa = 25;
fsl = 25;

for ik = 1:(numel(ik_list)-1)
    
    if ik<(numel(ik_list)-1)
        
        
        k = ik_list(ik);
        
        fah{ik} = axes('Position',[dxl+sum(xwi_ff(1:(ik-1)))+(ik-1)*dxm 0 xwi_ff(ik) 0]/Xpix+...
            [0 dyb+ywi+2*dym-30 0 ywi_ff(ik)]/Ypix);
        
        kids = get(ah{k},'Children');
        
        for i = numel(kids):-1:1
            copyobj(kids(i),fah{ik});
        end
        
        set(fah{ik},'XLim',x_range(ik,:));
        set(fah{ik},'YLim',y_range(ik,:));
        set(fah{ik},'fontsize',fsa);
        set(fah{ik},'Tickdir','out');
        set(fah{ik},'XMinorTick','on');
        set(fah{ik},'YMinorTick','on');
        set(fah{ik},'XTick',x_tick{ik});
        set(fah{ik},'XTickLabel',x_tick_lab{ik});
        xlabel('$t$(ms)','Interpreter','Latex','fontsize',fsl);
        if ik == 1
            set(fah{ik},'YTick',y_tick{ik});
            set(fah{ik},'YTickLabel',y_tick_lab{ik});
            ylabel('$r$($\mu$m)','Interpreter','Latex','fontsize',fsl);
        else
            set(fah{ik},'YTick',[]);
        end
        
        
        
    else
        k = ik_list(ik+1);
        
        fah{ik} = axes('Position',[dxl+sum(xwi_ff(1:(ik-1)))+(ik-1)*dxm 0 xwi_ff(ik) 0]/Xpix+...
            [0 dyb+ywi+2*dym-30 0 ywi_ff(ik)]/Ypix);
        
        kids = get(ah{k},'Children');
        
        for i = numel(kids):-1:1
            copyobj(kids(i),fah{ik});
        end
        
        set(fah{ik},'XLim',x_range(ik,:));
        set(fah{ik},'YLim',y_range(ik,:));
        set(fah{ik},'fontsize',fsa);
        set(fah{ik},'Tickdir','out');
%         set(fah{ik},'linewidth',1.5);
         set(fah{ik},'TickLength',[0.02, 0.01]);
        set(fah{ik},'XMinorTick','off');
        set(fah{ik},'YMinorTick','on');
        set(fah{ik},'XTick',x_tick{ik});
        set(fah{ik},'XTickLabel',x_tick_lab{ik});
        xlabel('$t$(ms)','Interpreter','Latex','fontsize',fsl);
        if ik == 1
            set(fah{ik},'YTick',y_tick{ik});
            set(fah{ik},'YTickLabel',y_tick_lab{ik});
            ylabel('$r$ ($\mu$m)','Interpreter','Latex','fontsize',fsl);
        else
            set(fah{ik},'YTick',[]);
              
   
        end
    end
    drawnow;
          set(gca,'TickLabelInterpreter','latex', 'linewidth',1.5,'FontSize',25,'XMinorTick','off','Tickdir','out');
end
 
xl = 120;
xm = [1 1 1]*20;
xm_2 = [1 1 1]*60;
xr = 10;

yt = 10;
yb = 100;



for i=1:numfig
    
%      ah_2{i} = axes('Position',[xl+(i-1)*xwi+sum(xm_2(1:(i-1))) 0 xwi 0 ]/XpixTot_2 + [0 yb 0 ywi]/YpixTot);
    
     
     
    ah_2{i} = axes('Position',[dxl+(xwi-1.2*dxm)*(i-1) 0 (xwi-5*dxm) 0]/Xpix+...
            [0 dyb-30 0 ywi-2*dxm]/Ypix);
     
    xlim([2.0 2.7]);
    axis on; box on;
    
    if i==1
        ylabel('$P(r)$($\mu$m$^{-1}$)','Interpreter','Latex','fontsize',16);
    end
    xlabel('$r$($\mu$m)','Interpreter','Latex','fontsize',16);
    
    kid0 = get(hf{i},'Children');
    kid1 = get(kid0,'Children');
    
    for j=1:numel(kid1)
        copyobj(kid1(end-j+1),ah_2{i});
    end
    
    hold on
    plot([2.0 2.7],[0 0],'k')
    hold off
    
    if i==1 
        ylim([0 0.20]);
        %
        yti1{i} = 0:0.02:0.20;
        %
        for j=1:numel(yti1{i})
            if mod(j-1,5)==0
                ytilab1{i,j} = num2str(yti1{i}(j)*50,'%2.0f');
            else
                ytilab1{i,j} = '';
            end
        end
    end
    if i==2 
        ylim([0 0.20]);
        %
        yti1{i} = 0:0.02:0.20;
        %
        for j=1:numel(yti1{i})
            if mod(j-1,5)==0
                ytilab1{i,j} = num2str(yti1{i}(j)*50,'%2.0f');
            else
                ytilab1{i,j} = '';
            end
        end
    end
    if i==3 
        ylim([0 0.20]);
        %
        yti1{i} = 0:0.02:0.20;
        %
        for j=1:numel(yti1{i})
            if mod(j-1,5)==0
                ytilab1{i,j} = num2str(yti1{i}(j)*50,'%2.0f');
            else
                ytilab1{i,j} = '';
            end
        end
    end
    if i==4 
        ylim([0 0.60]);
        %
        yti1{i} = 0:0.05:0.60;
        %
        for j=1:numel(yti1{i})
            if mod(j-1,4)==0
                ytilab1{i,j} = num2str(yti1{i}(j)*50,'%2.0f');
            else
                ytilab1{i,j} = '';
            end
        end
    end
    
  
    set(gca,'YTick',yti1{i});
    set(gca,'YTickLabel',{ytilab1{i,:}});
%     set(gca,'fontsize',10);
      set(gca,'TickLabelInterpreter','latex', 'linewidth',1.5,'FontSize',25,'XMinorTick','off','Tickdir','in','TickLength',[0.02, 0.01]);
         
    
%     set(gca,'Tickdir','out');
    
    y_range=get(gca,'Ylim');
    
    xticks([2, 2.2,2.4,2.6]);
%     text( 2.03, y_range(2)-(y_range(2)-y_range(1))/ywi*40,['{\bf ' letter{i} '}'],'Interpreter','Latex','fontsize',24,...
%         'HorizontalAlignment','left','VerticalAlignment','baseline');
    
    drawnow

end


Xpix_new = 1400;
Ypix_new = Ypix/Xpix*Xpix_new;

fs = 34;


set(ffh,'Position',[10 10 Xpix_new Ypix_new]);

drawnow;



Oldpos=get(ffh, 'position');
% newpos=[Oldpos(1),Oldpos(2),1400,Oldpos(4)/Oldpos(3)*1400];
 newpos=[300,-400,1400,Oldpos(4)/Oldpos(3)*1400];
set(ffh, 'position', newpos)


stringalettera{1} = '{\bf a}';
stringalettera{2} = '{\bf b}';
stringalettera{3} = '{\bf c}';
stringalettera{4} = '{\bf d}';
stringalettera{5} = '{\bf e}';
stringalettera{6} = '{\bf f}';
stringalettera{7} = '{\bf g}';
stringalettera{8} = '{\bf h}';
axes('Position',[0 0 1 1]);
hold on
for ik=1:(numel(ik_list)-1)
    
    text((dxl+sum(xwi_ff(1:(ik-1)))+(ik-1)*dxm)/Xpix,...
        (dyb+ywi_ff(ik)+ywi+2*dym-20)/Ypix,stringalettera{ik},'Interpreter','Latex','fontsize',fs,...
        'HorizontalAlignment','left','VerticalAlignment','baseline')
    
     text((dxl+sum(xwi_ff(1:(ik-1)))+(ik-1)*(dxm+6))/Xpix,...
        (dyb+ywi-35)/Ypix,stringalettera{ik+4},'Interpreter','Latex','fontsize',fs,...
        'HorizontalAlignment','left','VerticalAlignment','baseline')
    
%     end
end


 
hold off
axis off

