
clear
close all


cd('C:\Users\schlaf\Documents\GitHub\ReindeerSleep\Z_processS\docs')
load('FittedResults_BLnorm.mat')

cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\episodes\all')
load('episodes.mat')


%% example of one reindeer, incl. SWA and episodes

close all

for n = 2
%timewin = [41401:63000];
timewin = [1:81000];
%timewin = [41401:48600];


h1=figure
subplot(311)
plot(ProcessS_fitted(n,timewin),'LineWidth',3,'Color','k')
ylim([1 3])
% xticks([1:900:8100]);
% xticklabels({'00','01','02','03','04','05','06','07','08'}) 
% xlim([-300 7350])
 xlim([0 81900])
 xticks([3600:5400:79200])
 xticklabels({'18','00','06','12','18','00','06','12','18','00','06','12','18','00','06'}) 
ylabel('Process S')
grid on

           ax=gca;
       ax.XAxis.FontSize = 14;
       ax.YAxis.FontSize = 14;             
       ax.XLabel.FontSize = 14;
       ax.YLabel.FontSize = 14;

subplot(312)
plot(SWA_normalized(n,timewin),'k')
 xlim([0 81900])
 xticks([3600:5400:79200])
 xticklabels({'18','00','06','12','18','00','06','12','18','00','06','12','18','00','06'}) 
% xticks([1:900:8100]);
% xticklabels({'00','01','02','03','04','05','06','07','08'}) 
ylim([-0.5 10])
yticks([1 5])
ylabel('SWA')

           ax=gca;
       ax.XAxis.FontSize = 14;
       ax.YAxis.FontSize = 14;             
       ax.XLabel.FontSize = 14;
       ax.YLabel.FontSize = 14;


subplot(313)

        plot_wak=NaN([1 timewin(end)]);
    for t = 1: length(episodes(n).wakdura)
        plot_wak(episodes(n).wakdura(t,2):episodes(n).wakdura(t,3))=1.3;
    end
    
        plot_nrem=NaN([1 timewin(end)]);
    for t = 1: length(episodes(n).nremdura)
        plot_nrem(episodes(n).nremdura(t,2):episodes(n).nremdura(t,3))=1.1;
    end
    
    plot_rem=NaN([1 timewin(end)]);
    for t = 1: length(episodes(n).remdura)
        plot_rem(episodes(n).remdura(t,2):episodes(n).remdura(t,3))=1;
    end
    
        plot_rum=NaN([1 timewin(end)]);
    for t = 1: length(episodes(n).rumdura)
        plot_rum(episodes(n).rumdura(t,2):episodes(n).rumdura(t,3))=1.2;
    end
    
      plot_wak=plot_wak(timewin);
      plot_wak(plot_wak==0)=NaN;
      plot_nrem= plot_nrem(timewin);
      plot_nrem(plot_nrem==0)=NaN;
      plot_rem=plot_rem(timewin);
      plot_rem(plot_rem==0)=NaN;
      plot_rum=plot_rum(timewin);
      plot_rum(plot_rum==0)=NaN;
    
    STD=STD_all(n).STD(timewin);

    
        plot_wak_vis=NaN([1 length(timewin)]);
    plot_wak_vis(find(STD == 'w' | STD == '1'))=1.3;
    
        plot_nrem_vis=NaN([1 length(timewin)]);
    plot_nrem_vis(find(STD == 'n' | STD == '2'))=1.1;
    
        plot_rum_vis=NaN([1 length(timewin)]);
    plot_rum_vis(find(STD == 't' | STD == '4'))=1.2;
    
        plot_rem_vis=NaN([1 length(timewin)]);
    plot_rem_vis(find(STD == 'r' | STD == '3'))=1;
    
   
%     plot(plot_nrem,'LineWidth',15,'Color',[0 0 1 0.5])
%     hold on
%     plot(plot_wak,'LineWidth',15,'Color',[1 0 0 0.5])
%     hold on
%     plot(plot_rum,'LineWidth',15,'Color',[0 1 0 0.5])
%     hold on
%     plot(plot_rem,'LineWidth',15,'Color',[1 0 1 0.5])

    plot(plot_nrem_vis,'-','LineWidth',10,'Color','k','MarkerSize',2)
    hold on
    plot(plot_wak_vis,'-','LineWidth',10,'Color','k','MarkerSize',2)
    hold on
    plot(plot_rum_vis,'-','LineWidth',10,'Color','k','MarkerSize',2)
    hold on
    plot(plot_rem_vis,'-','LineWidth',10,'Color','k','MarkerSize',2)
    hold on
    plot(plot_nrem_vis,'-','LineWidth',10,'Color','k','MarkerSize',2)

%     xticks([1:900:8100]);
%     xticklabels({'00','01','02','03','04','05','06','07','08'}) 
%     xlabel('clock time')
%     xlim([-300 7350])
    ylim([0.9 1.4])
    yticks([1:0.1:1.3])
    yticklabels({'REM sleep','NREM sleep','Rumination','Wake'})
    ax.XGrid = 'on'
 xlim([0 81900])
 xticks([3600:5400:79200])
 xticklabels({'18','00','06','12','18','00','06','12','18','00','06','12','18','00','06'}) 
 xlabel('clock time')   
    set(gcf,'Position',[100 100 1200 400])
    
           ax=gca;
       ax.XAxis.FontSize = 14;
       ax.YAxis.FontSize = 14;             
       ax.XLabel.FontSize = 14;
       ax.YLabel.FontSize = 14;
    
    cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\processS')
    print(h1,['example_processS_' num2str(n)],'-dpng','-r1000')

end


close all