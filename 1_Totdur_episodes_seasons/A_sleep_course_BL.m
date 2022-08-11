clear
close all

%%  duration nremsleep rum

path='D:\Work\reindeer\Analyse_mainexperiment\Data\';
datapath=[path,'Mat_power_artcorr_scored_cut\SR_BL2'];
savepath='C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\SWA_plots';

cd(datapath)
filenames=dir('*power*.mat');

nfiles=length(filenames);

%%%%%tot. sleep per hour
for n=1:nfiles
    
    filename=filenames(n).name;
    load(filename);
    segmentlength=900;
    nsegments=length(vissymb_cut)/segmentlength;
    
        for i=1:nsegments

            vissymbsegment(i,:)=vissymb_cut(1+segmentlength*(i-1):segmentlength*i);
        
            nrem = find(vissymbsegment(i,:)=='n' | vissymbsegment(i,:)=='2');
            nrem_rum = find(vissymbsegment(i,:)=='n' | vissymbsegment(i,:)=='2' | vissymbsegment(i,:)=='t' | vissymbsegment(i,:)=='4');
            rem = find(vissymbsegment(i,:)=='r' | vissymbsegment(i,:)=='3');
            rum = find(vissymbsegment(i,:)=='t' | vissymbsegment(i,:)=='4');
            length_nrem(n,i)=length(nrem)/15;
            length_nrem_rum(n,i)=length(nrem_rum)/15;
            length_rem(n,i)=length(rem)/15;
            length_rum(n,i)=length(rum)/15;

        end
    
  
end


segments = 16:39 % for 2h bits (5-5)

length_sleep_1h=length_nrem_rum(:,segments)+length_rem(:,segments); % nrem, rum, rem
% length_sleep_1h=length_nrem(:,segments); % nrem

for i=1:12
length_sleep(:,i)=mean(length_sleep_1h(:,i*2-1:i*2),2);
end

figure('units','normalized','outerposition',[0 0 1 0.5])
      

subplot(1,3,1)

% plot(median(length_sleep([1 4 9],:)),'-ko','MarkerFaceColor','k')
% hold on
errorbar(mean(length_sleep([1 4 9],:)),std(length_sleep([1 4 9],:)),'k')
ax = gca
ax.FontSize = 12;
title('December','FontSize',20)
ylim([0,50])
xlim([0,13])
ylabel('sleep (min/h)','FontSize',16)
xticks([1:13])
xticklabels({'6','','','12','','','18','','','00','','','6'}) 
%xticklabels({'6','','','','','','12','','','','','','18','','','','','','00','','','','','','6'}) 
% for n=[1 4 9]   
%     plot(length_sleep(n,segments),'--o')     
%     hold on
% end



subplot(1,3,2)

% plot(median(length_sleep([2 5 7 10],:)),'-ko','MarkerFaceColor','k')
% hold on
errorbar(mean(length_sleep([2 5 7 10],:)),std(length_sleep([2 5 7 10],:)),'k')
ax = gca
ax.FontSize = 12;
title('July','FontSize',20)
ylim([0,50])
xlim([0,13])
ylabel('sleep (min/h)','FontSize',16)
xticks([1:13])
xticklabels({'6','','','12','','','18','','','00','','','6'}) 
%xticklabels({'6','','','','','','12','','','','','','18','','','','','','00','','','','','','6'}) 
    
% for n=[2 5 10 7]   
%     plot(length_sleep(n,segments),'--o')
%     hold on
% end




subplot(1,3,3)

% plot(median(length_sleep([3 6 8 11],:)),'-ko','MarkerFaceColor','k')
% hold on
errorbar(mean(length_sleep([3 6 8 11],:)),std(length_sleep([3 6 8 11],:)),'k')
ax = gca
ax.FontSize = 12;
title('September','FontSize',20)
ylim([0,50])
xlim([0,13])
ylabel('sleep (min/h)','FontSize',16)
xticks([1:13])
xticklabels({'6','','','12','','','18','','','00','','','6'}) 
%xticklabels({'6','','','','','','12','','','','','','18','','','','','','00','','','','','','6'}) 
    
% for n=[3 6 11 8]   
%     plot(length_sleep(n,segments),'--o')
%     hold on
% end

%% plot all seasons in one plot in different colours

h2=figure    
    hold on
    errorbar(mean(length_sleep([1 4 9],:)),std(length_sleep([1 4 9],:))/sqrt(length(length_sleep([1 4 9],:))),'Color',[0 0.4 0.7],'LineWidth',2)
     
    hold on
    errorbar(mean(length_sleep([2 5 7 10],:)),std(length_sleep([2 5 7 10],:))/sqrt(length(length_sleep([2 5 7 10],:))),'Color',[0.2 0.6 0.1],'LineWidth',2)

    hold on
    errorbar(mean(length_sleep([3 6 8 11],:)),std(length_sleep([3 6 8 11],:))/sqrt(length(length_sleep([3 6 8 11],:))),'Color',[0.9 0.5 0.1],'LineWidth',2)
    
    ax = gca
ax.FontSize = 12;

ylim([0,40])
xlim([0,13])
ylabel('sleep (min/h)','FontSize',16)
xticks([1:13])
xticklabels({'6','','','12','','','18','','','00','','','6'}) 


%% plot smaller, in colours

subplot(311)

errorbar(mean(length_sleep([1 4 9],:)),std(length_sleep([1 4 9],:)),'Color',[0 0.4 0.7],'LineWidth',2)
ax = gca
ax.FontSize = 12;
% title('December','FontSize',20)
ylim([0,50])
xlim([0,13])
ylabel('sleep (min/h)','FontSize',16)
xticks([1:13])
set(gca,'xticklabel',{[]})

subplot(312)

errorbar(mean(length_sleep([2 5 7 10],:)),std(length_sleep([2 5 7 10],:)),'Color',[0.2 0.6 0.1],'LineWidth',2)
ax = gca
ax.FontSize = 12;
% title('July','FontSize',20)
ylim([0,50])
xlim([0,13])
ylabel('sleep (min/h)','FontSize',16)
xticks([1:13])
set(gca,'xticklabel',{[]})

subplot(313)

errorbar(mean(length_sleep([3 6 8 11],:)),std(length_sleep([3 6 8 11],:)),'Color',[0.9 0.5 0.1],'LineWidth',2)
ax = gca
ax.FontSize = 12;
% title('September','FontSize',20)
ylim([0,50])
xlim([0,13])
ylabel('sleep (min/h)','FontSize',16)
xticks([1:13])
xticklabels({'6','','','12','','','18','','','00','','','6'}) 

%% plot smaller, black
figure('units','normalized','outerposition',[0 0.5 1 0.5])
subplot(131)

errorbar(mean(length_sleep([1 4 9],:)),std(length_sleep([1 4 9],:)),'-s','MarkerSize',4,...
    'MarkerEdgeColor','k','MarkerFaceColor','k','Color','k')
ax = gca
ax.FontSize = 12;
% title('December','FontSize',20)
ylim([0,46])
xlim([0,13])
%ylabel('sleep (min/h)','FontSize',16)
xticks([1:13])
xticklabels({'6','','','12','','','18','','','00','','','6'}) 
xlabel('clock time','FontSize',14)
 hold on
 plot(mean(length_sleep([1 4 9],:)),'k','LineWidth',1)
 
 
subplot(132)

errorbar(mean(length_sleep([2 5 7 10],:)),std(length_sleep([2 5 7 10],:)),'-s','MarkerSize',4,...
    'MarkerEdgeColor','k','MarkerFaceColor','k','Color','k')
ax = gca
ax.FontSize = 12;
% title('July','FontSize',20)
ylim([0,46])
xlim([0,13])
%ylabel('sleep (min/h)','FontSize',16)
xticks([1:13])
xticklabels({'6','','','12','','','18','','','00','','','6'}) 
xlabel('clock time','FontSize',14)
set(gca,'yticklabel',{[]})
 hold on
 plot(mean(length_sleep([2 5 7 10],:)),'k','LineWidth',1)

subplot(133)

errorbar(mean(length_sleep([3 6 8 11],:)),std(length_sleep([3 6 8 11],:)),'-s','MarkerSize',4,...
    'MarkerEdgeColor','k','MarkerFaceColor','k','Color','k')
ax = gca
ax.FontSize = 12;
% title('September','FontSize',20)
ylim([0,46])
xlim([0,13])
%ylabel('sleep (min/h)','FontSize',16)
xlabel('clock time','FontSize',14)
xticks([1:13])
xticklabels({'6','','','12','','','18','','','00','','','6'}) 
set(gca,'yticklabel',{[]})
 hold on
 plot(mean(length_sleep([3 6 8 11],:)),'k','LineWidth',1)
 
 
  %% save
  
cd(savepath)
print(['sleep_course_per2h_BL2'],'-dpng','-r500')
print(h2,['sleep_course_per2h_BL2_allseasons'],'-dpng','-r500')
close all  

