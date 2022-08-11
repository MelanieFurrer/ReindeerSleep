clear
close all

%%
d='BL';
path='D:\Work\reindeer\Analyse_mainexperiment\Data\';
datapath=[path,'Mat_power_artcorr_scored_cut\SR_BL2'];
savepath='C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\SWA_plots';

cd(datapath)
filenames=dir('*power*.mat');

nfiles=length(filenames)

sb=15*60*15+1;  %start BL2 (5:00)
eb=39*60*15;

for n=1:nfiles
    
    filename=filenames(n).name;
    load(filename);
    
        
        if strcmp('BL',d)
            STD=vissymb_cut(sb:eb);
            art=artndxn_cut(sb:eb);
        elseif strcmp('SR',d)
            STD=vissymb_cut(1:21600);
            art=artndxn_cut(1:21600);
        else
        end
        
        [episodes(n).wakdura,episodes(n).nremdura,episodes(n).remdura,episodes(n).rumdura,episodes(n).baa]=ecountwnrr(STD);
        episodes(n).reindeer=filename(1:8);
        
        STD_all(n).STD=STD;
        art_all(n).art=art;
        
end

cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\episodes\BL2')
save('episodes.mat','episodes','art_all','STD_all')


%% plot


for n= 1:11

        plot_wak=NaN([1 21600]);
    for t = 1: length(episodes(n).wakdura)
        plot_wak(episodes(n).wakdura(t,2):episodes(n).wakdura(t,3))=1.3;
    end
    
        plot_nrem=NaN([1 21600]);
    for t = 1: length(episodes(n).nremdura)
        plot_nrem(episodes(n).nremdura(t,2):episodes(n).nremdura(t,3))=1.1;
    end
    
    plot_rem=NaN([1 21600]);
    for t = 1: length(episodes(n).remdura)
        plot_rem(episodes(n).remdura(t,2):episodes(n).remdura(t,3))=1;
    end
    
        plot_rum=NaN([1 21600]);
    for t = 1: length(episodes(n).rumdura)
        plot_rum(episodes(n).rumdura(t,2):episodes(n).rumdura(t,3))=1.2;
    end
    


    
        plot_wak_vis=NaN([1 21600]);
    plot_wak_vis(find(STD_all(n).STD == 'w' | STD_all(n).STD == '1'))=1.3;
    
        plot_nrem_vis=NaN([1 21600]);
    plot_nrem_vis(find(STD_all(n).STD == 'n' | STD_all(n).STD == '2'))=1.1;
    
        plot_rum_vis=NaN([1 21600]);
    plot_rum_vis(find(STD_all(n).STD == 't' | STD_all(n).STD == '4'))=1.2;
    
        plot_rem_vis=NaN([1 21600]);
    plot_rem_vis(find(STD_all(n).STD == 'r' | STD_all(n).STD == '3'))=1;
    



    h1=figure('units','normalized','outerposition',[0 0 1 1])
    for p=1:4
    subplot(4,1,p)
    
    plot(plot_nrem(5400*p-5399:p*5400),'LineWidth',15,'Color',[0 0 1 0.5])
    hold on
    plot(plot_wak(5400*p-5399:p*5400),'LineWidth',15,'Color',[1 0 0 0.5])
    hold on
    plot(plot_rum(5400*p-5399:p*5400),'LineWidth',15,'Color',[0 1 0 0.5])
    hold on
    plot(plot_rem(5400*p-5399:p*5400),'LineWidth',15,'Color',[1 0 1 0.5])

    plot(plot_nrem_vis(5400*p-5399:p*5400),'.-','LineWidth',10,'Color','k','MarkerSize',2)
    hold on
    plot(plot_wak_vis(5400*p-5399:p*5400),'.-','LineWidth',10,'Color','k','MarkerSize',2)
    hold on
    plot(plot_rum_vis(5400*p-5399:p*5400),'.-','LineWidth',10,'Color','k','MarkerSize',2)
    hold on
    plot(plot_rem_vis(5400*p-5399:p*5400),'.-','LineWidth',10,'Color','k','MarkerSize',2)
    hold on


    xlim([0 5400])
    xticks([0 900 1800 2700 3600 4500 5400]);
    ylim([0.9 1.4])
    yticks([1:0.1:1.4])
    yticklabels({'REM ep.','NREMs ep.','Rum ep.','Wake ep.'})

        if p == 1
            xticklabels({'06:00','07:00','08:00','09:00','10:00','11:00','12:00'});
        elseif p == 2
            xticklabels({'12:00','13:00','14:00','15:00','16:00','17:00','18:00'});
        elseif p == 3
            xticklabels({'18:00','19:00','20:00','21:00','22:00','23:00','00:00'});
        else 
            xticklabels({'00:00','01:00','02:00','03:00','04:00','05:00','06:00'});
        end

    end

     print(['Episodes_2min',episodes(n).reindeer],'-dpng','-r500')
            close all

end



% %% length episodes per season
% 
% for n= 1:9
% length_nreme(n)=mean(episodes(n).nremdura(:,1))
% end
% 
% length_nreme_means(:,1)=[length_nreme(1) length_nreme(4) length_nreme(7)]
% length_nreme_means(:,2)=[length_nreme(2) length_nreme(5) length_nreme(8)]
% length_nreme_means(:,3)=[length_nreme(3) length_nreme(6) length_nreme(9)]
% 
% 
% for n= 1:9
% length_nreme_sd(n)=std(episodes(n).nremdura(:,1))
% end
% 
% length_nreme_sds(:,1)=[length_nreme_sd(1) length_nreme_sd(4) length_nreme_sd(7)]
% length_nreme_sds(:,2)=[length_nreme_sd(2) length_nreme_sd(5) length_nreme_sd(8)]
% length_nreme_sds(:,3)=[length_nreme_sd(3) length_nreme_sd(6) length_nreme_sd(9)]
% 
% 
% 
% %% nr of episodes per season
% 
% 
% for n= 1:9
% nr_nreme(n)=length(episodes(n).nremdura(:,1))
% end
% 
% nr_nreme_means(:,1)=[nr_nreme(1) nr_nreme(4) nr_nreme(7)]
% nr_nreme_means(:,2)=[nr_nreme(2) nr_nreme(5) nr_nreme(8)]
% nr_nreme_means(:,3)=[nr_nreme(3) nr_nreme(6) nr_nreme(9)]
% 
% 
% 
% %%  characteristics episodes
% 
% clearvars -except episodes
% for n= 1:9
% nreme(n,1)=length(episodes(n).nremdura(:,1))
% nreme(n,2)=mean(episodes(n).nremdura(:,1))./15
% nreme(n,3)=std(episodes(n).nremdura(:,1))./15
% 
% reme(n,1)=length(episodes(n).remdura(:,1))
% reme(n,2)=mean(episodes(n).remdura(:,1))./15
% reme(n,3)=std(episodes(n).remdura(:,1))./15
% 
% rume(n,1)=length(episodes(n).rumdura(:,1))
% rume(n,2)=mean(episodes(n).rumdura(:,1))./15
% rume(n,3)=std(episodes(n).rumdura(:,1))./15
% 
% wake(n,1)=length(episodes(n).wakdura(:,1))
% wake(n,2)=mean(episodes(n).wakdura(:,1))./15
% wake(n,3)=std(episodes(n).wakdura(:,1))./15
% 
% end



%%
% %% delete all episodes shorter than 1min
% 
% for n= 1:9
% episodes2(n).rumdura = episodes(n).wakdura(find(episodes(n).wakdura(:,1) > 14),:);
% 
% episodes2(n).nremdura = episodes(n).nremdura(find(episodes(n).nremdura(:,1) > 14),:);
% 
% episodes2(n).remdura = episodes(n).remdura(find(episodes(n).remdura(:,1) > 14),:);
% 
% episodes2(n).rumdura = episodes(n).rumdura(find(episodes(n).rumdura(:,1) > 14),:);
% end
% 
% 
% %% delete all episodes that contain less than 2min of artefact-free nrem sleep
% 
% for n= 1:9
%      
%      for t = 1: length(episodes2(n).nremdura)
%         if length(find(STD_all(n).STD(episodes2(n).nremdura(t,2):episodes2(n).nremdura(t,3)) == 'n' | STD_all(n).STD(episodes2(n).nremdura(t,2):episodes2(n).nremdura(t,3)) == '2')) > 29
%             nremok(t)=1;
%         else
%             nremok(t)=0;
%         end  
%      end
%      
%   episodes2(n).nremdura=episodes2(n).nremdura(find(nremok),:);
%   clear nremok
%   
%       for t = 1: length(episodes2(n).wakdura)
%         if length(find(STD_all(n).STD(episodes2(n).wakdura(t,2):episodes2(n).wakdura(t,3)) == 'w' | STD_all(n).STD(episodes2(n).wakdura(t,2):episodes2(n).wakdura(t,3)) == '1')) > 29
%             wakok(t)=1;
%         else
%             wakok(t)=0;
%         end  
%      end
%      
%   episodes2(n).wakdura=episodes2(n).wakdura(find(wakok),:);
%   clear wakok 
%   
%   
% end
% 
% cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\episodes')
% save('episodes2.mat','episodes2','art_all','STD_all')
