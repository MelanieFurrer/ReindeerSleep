
clear all
close

cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\SWA_normalized_aligned')
load('SWA_scoring_episodes.mat')


cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\episodes\all')
load('episodes.mat')


for n=1:11
    endepoch_episodes_SR(n).epoch = episodes(n).wakdura(:,2)
    startepoch_episodes_SR(n).epoch = episodes(n).wakdura(:,3)
end

%% calculate SWA for different time windows before and after sleep restriction %%

h=6 %% define how many hours

ssrd= 46*15*60 % start sleep restriction day
esrd= 48*15*60 % end sleep restriction day

ssrn= 58*15*60 % start sleep restriction nigh
esrn= 60*15*60 % end sleep restriction night



for n=1:11
    
    
    epochends = endepoch_episodes_SR(n).epoch( endepoch_episodes_SR(n).epoch < ssrd);
    if isempty(max(epochends)-h*900)
        borders(n,1:2)=NaN;
    else
        borders(n,1)=max(epochends)-h*900;
        borders(n,2)=max(epochends);
    end
    
        epochstarts = startepoch_episodes_SR(n).epoch( startepoch_episodes_SR(n).epoch > esrd);
        borders(n,3)=min(epochstarts);
        borders(n,4)=min(epochstarts)+h*900;
    
        epochends = endepoch_episodes_SR(n).epoch( endepoch_episodes_SR(n).epoch < ssrn);
        borders(n,5)=max(epochends)-h*900;
        borders(n,6)=max(epochends);
    
        epochstarts = startepoch_episodes_SR(n).epoch( startepoch_episodes_SR(n).epoch > esrn);
        borders(n,7)=min(epochstarts);
        borders(n,8)=min(epochstarts)+h*900;
        
    
end






%%% 1h-course of SWA over time period %%%

for i=1:7
    borders_1hcourse(:,i)=borders(:,1)+(i-1)*900;
end

for i=8:14
    borders_1hcourse(:,i)=borders(:,3)+(i-8)*900;
end

for i=15:21
    borders_1hcourse(:,i)=borders(:,5)+(i-15)*900;
end

for i=22:28
    borders_1hcourse(:,i)=borders(:,7)+(i-22)*900;
end




for n=1:11
    
    if n==1
        
     SWA_decrease_SR(n,1:6)= NaN;
     
        for i=7:12
            SWA_decrease_SR(n,i)=nanmean(SWA_normalized(n,borders_1hcourse(n,i+1):borders_1hcourse(n,i+2)));
            vissymbsegment(i,:)=STD_all(n).STD(borders_1hcourse(n,i+1):borders_1hcourse(n,i+2));
            nrem_SR(n,i) = length(find(vissymbsegment(i,:)=='n' | vissymbsegment(i,:)=='2'))/15;
        end
     
        for i=13:18
            SWA_decrease_SR(n,i)=nanmean(SWA_normalized(n,borders_1hcourse(n,i+2):borders_1hcourse(n,i+3)));
            vissymbsegment(i,:)=STD_all(n).STD(borders_1hcourse(n,i+2):borders_1hcourse(n,i+3));
            nrem_SR(n,i) = length(find(vissymbsegment(i,:)=='n' | vissymbsegment(i,:)=='2'))/15;
        end
        
        for i=19:24
            SWA_decrease_SR(n,i)=nanmean(SWA_normalized(n,borders_1hcourse(n,i+3):borders_1hcourse(n,i+4)));
            vissymbsegment(i,:)=STD_all(n).STD(borders_1hcourse(n,i+3):borders_1hcourse(n,i+4));
            nrem_SR(n,i) = length(find(vissymbsegment(i,:)=='n' | vissymbsegment(i,:)=='2'))/15;
        end
      
    else
   
        for i=1:6
            SWA_decrease_SR(n,i)=nanmean(SWA_normalized(n,borders_1hcourse(n,i):borders_1hcourse(n,i+1)));
            vissymbsegment(i,:)=STD_all(n).STD(borders_1hcourse(n,i):borders_1hcourse(n,i+1));
            nrem_SR(n,i) = length(find(vissymbsegment(i,:)=='n' | vissymbsegment(i,:)=='2'))/15;
        end
        
        for i=7:12
            SWA_decrease_SR(n,i)=nanmean(SWA_normalized(n,borders_1hcourse(n,i+1):borders_1hcourse(n,i+2)));
            vissymbsegment(i,:)=STD_all(n).STD(borders_1hcourse(n,i+1):borders_1hcourse(n,i+2));
            nrem_SR(n,i) = length(find(vissymbsegment(i,:)=='n' | vissymbsegment(i,:)=='2'))/15;
        end
        
        for i=13:18
            SWA_decrease_SR(n,i)=nanmean(SWA_normalized(n,borders_1hcourse(n,i+2):borders_1hcourse(n,i+3)));
            vissymbsegment(i,:)=STD_all(n).STD(borders_1hcourse(n,i+2):borders_1hcourse(n,i+3));
            nrem_SR(n,i) = length(find(vissymbsegment(i,:)=='n' | vissymbsegment(i,:)=='2'))/15;
        end
        
       for i=19:24
            SWA_decrease_SR(n,i)=nanmean(SWA_normalized(n,borders_1hcourse(n,i+3):borders_1hcourse(n,i+4)));
            vissymbsegment(i,:)=STD_all(n).STD(borders_1hcourse(n,i+3):borders_1hcourse(n,i+4));
            nrem_SR(n,i) = length(find(vissymbsegment(i,:)=='n' | vissymbsegment(i,:)=='2'))/15;
        end
    
    end
    
end

%% rearrange for R (SWA after SR only)

SWA_after=reshape(SWA_decrease_SR(:,[7:12 19:24])',1,132)';
SWA_before=reshape(SWA_decrease_SR(:,[1:6 13:18])',1,132)';


%% plot mean of each season and mean of everything (no distingtion between timepoint) %%          
      
      
  h5=figure

    errorbar(nanmean(nanmean(cat(3,SWA_decrease_SR([1 4  9],[7:12]), SWA_decrease_SR([1 4 9],[19:24])),3)),nanstd(nanmean(cat(3,SWA_decrease_SR([1 4 9],[7:12]), SWA_decrease_SR([1 4  9],[19:24])),3)),'Color',[0 0.4 0.7],'LineWidth',2)
    
    hold on
    errorbar(nanmean(nanmean(cat(3,SWA_decrease_SR([2 5 7 10],[7:12]), SWA_decrease_SR([2 5 7 10],[19:24])),3)),nanstd(nanmean(cat(3,SWA_decrease_SR([2 5 7 10],[7:12]), SWA_decrease_SR([2 5 7 10],[19:24])),3)),'Color',[0.2 0.6 0.1],'LineWidth',2)
     
    hold on
    errorbar(nanmean(nanmean(cat(3,SWA_decrease_SR([3 6 8 11],[7:12]), SWA_decrease_SR([3 6 8 11],[19:24])),3)),nanstd(nanmean(cat(3,SWA_decrease_SR([3 6 8 11],[7:12]), SWA_decrease_SR([3 6 8 11],[19:24])),3)),'Color',[0.9 0.5 0.1],'LineWidth',2)

    hold on
    plot(nanmean(vertcat(SWA_decrease_SR(:,[7:12]), SWA_decrease_SR(:,[19:24]))),'-ko','MarkerFaceColor','k','LineWidth',2)
      ylim([0.4 2.3])
      xlim([0.5 6.6])
      ylabel('normalized SWA')
      xlabel('time after sleep restriction (h)')
      

%% plot each reindeer separated by season and timepoint %%

% 
% 
% h1=figure
% 
% for n=[1 4 9]
%     subplot(2,3,1)
%     plot(SWA_decrease_SR(n,[7:12]),'o--')
%     hold on
% end
%     plot(nanmean(SWA_decrease_SR([1 4 9],7:12)),'-ko','MarkerFaceColor','k')
%     ylim([0 2])
%     title('Dec-Midday')
%     
% for n=[2 5 7 10]
%     subplot(2,3,2)
%     plot(SWA_decrease_SR(n,[7:12]),'o--')
%     hold on
% end
%     plot(nanmean(SWA_decrease_SR([2 5 7 10],7:12)),'-ko','MarkerFaceColor','k')
%        ylim([0 2])
%     title('July-Midday')
%     
% for n=[3 6 8 11]
%     subplot(2,3,3)
%     plot(SWA_decrease_SR(n,[7:12]),'o--')
%     hold on
% end
%     plot(nanmean(SWA_decrease_SR([3 6 8 11],7:12)),'-ko','MarkerFaceColor','k')
%        ylim([0 2])
%     title('Sep-Midday')
%     
%  for n=[1 4 9]
%     subplot(2,3,4)
%     plot(SWA_decrease_SR(n,[19:24]),'o--')
%     hold on
% end
%     plot(nanmean(SWA_decrease_SR([1 4 9],19:24)),'-ko','MarkerFaceColor','k')
%        ylim([0 2])
%     title('Dec-Midnight')
%     
% for n=[2 5 7 10]
%     subplot(2,3,5)
%     plot(SWA_decrease_SR(n,[19:24]),'o--')
%     hold on
% end
%     plot(nanmean(SWA_decrease_SR([2 5 7 10],19:24)),'-ko','MarkerFaceColor','k')
%        ylim([0 2])
%     title('July-Midnight')
%     
% for n=[3 6 8 11]
%     subplot(2,3,6)
%     plot(SWA_decrease_SR(n,[19:24]),'o--')
%     hold on
% end
%     plot(nanmean(SWA_decrease_SR([3 6 8 11],19:24)),'-ko','MarkerFaceColor','k')
%        ylim([0 2])
%     title('Sep-Midnight')
%     
% %% plot mean of each timepoint, also before sleep restriction for comparison %%    
%     
%   h2=figure
%     subplot(2,3,1)
%       plot(nanmean(SWA_decrease_SR(:,7:12)),'-k')
%       ylim([0.5 1.5])
%     subplot(2,3,2)
%       plot(nanmean(SWA_decrease_SR(:,19:24)),'-k')
%       ylim([0.5 1.5])
%     subplot(2,3,3)
%       plot(nanmean(vertcat(SWA_decrease_SR(:,[7:12]), SWA_decrease_SR(:,[19:24]))),'-k')
%       ylim([0.5 1.5])
%             
%     subplot(2,3,4)
%       plot(nanmean(SWA_decrease_SR(:,1:6)),'-k')
%       ylim([0.5 1.5])
%     subplot(2,3,5)
%       plot(nanmean(SWA_decrease_SR(:,13:18)),'-k')
%       ylim([0.5 1.5])
%     subplot(2,3,6)
%       plot(nanmean(vertcat(SWA_decrease_SR(:,1:6), SWA_decrease_SR(:,13:18))),'-k')
%       ylim([0.5 1.5])
%       
%       
%       
%     
% %% plot mean of each season and mean of each timepoint %%    
% 
% 
%   h3=figure
%     
%    subplot(1,2,1)
%     plot(nanmean(SWA_decrease_SR([1 4 9],7:12)),'-o','Color',[0 0.4 0.7])
%     hold on
%     plot(nanmean(SWA_decrease_SR([2 5 7 10],7:12)),'-o','Color',[0.2 0.6 0.1])
%     hold on
%     plot(nanmean(SWA_decrease_SR([3 6 8 11],7:12)),'-o','Color',[0.9 0.7 0.1])
%     hold on
%     plot(nanmean(SWA_decrease_SR(:,7:12)),'-ko','MarkerFaceColor','k')
%       ylim([0.2 2])
%       title('midday')
%       
%    subplot(1,2,2)
%     plot(nanmean(SWA_decrease_SR([1 4 9],19:24)),'-o','Color',[0 0.4 0.7])
%     hold on
%     plot(nanmean(SWA_decrease_SR([2 5 7 10],19:24)),'-o','Color',[0.2 0.6 0.1])
%     hold on
%     plot(nanmean(SWA_decrease_SR([3 6 8 11],19:24)),'-o')
%     hold on
%     plot(nanmean(SWA_decrease_SR(:,19:24)),'-ko','MarkerFaceColor','k')
%       ylim([0.2 2])
%      title('midnight')
%       
% 
%       
%       
%       
%       h4=figure
%   
%     plot(nanmean(vertcat(SWA_decrease_SR([1 4  9],[7:12]), SWA_decrease_SR([1 4  9],[19:24]))),'-o','Color',[0 0.4 0.7])
% 
%     hold on
%     plot(nanmean(vertcat(SWA_decrease_SR([2 5 7 10],[7:12]), SWA_decrease_SR([2 5 7 10],[19:24]))),'-o','Color',[0.2 0.6 0.1])
%   
%     hold on
%     plot(nanmean(vertcat(SWA_decrease_SR([3 6 8 11],[7:12]), SWA_decrease_SR([3 6 8 11],[19:24]))),'-o','Color',[0.9 0.7 0.1])
% 
% 
%     hold on
%     plot(nanmean(vertcat(SWA_decrease_SR(:,[7:12]), SWA_decrease_SR(:,[19:24]))),'-ko','MarkerFaceColor','k')
%       ylim([0.2 1.8])
% 
%     
% 
% 
%       
%  %% compare decrease between seasons %%     
% 
%  
%   for n=1:11
% 
%     Maxmin_SWAdecrease1(n)=max(SWA_decrease_SR(n,[7:9]))-min(SWA_decrease_SR(n,[10:12]));
%     Maxmin_SWAdecrease2(n)=max(SWA_decrease_SR(n,[19:21]))-min(SWA_decrease_SR(n,[22:24]));
% 
%  end
%   
%   
% mean_SWAdecrease_rd=nanmean(vertcat(Maxmin_SWAdecrease1,Maxmin_SWAdecrease2))
% 
% 
% 
% h6=figure
% boxplot(mean_SWAdecrease_rd',[1,2,3,1,2,3,2,3,1,2,3]') % SWAdecrease1 in excel for statistics (and plots) in R
% 
%  
% horzcat(Maxmin_SWAdecrease_dec1,Maxmin_SWAdecrease_dec2,Maxmin_SWAdecrease_jul1,Maxmin_SWAdecrease_jul2,Maxmin_SWAdecrease_sep1,Maxmin_SWAdecrease_sep2)'
% 
% 
% 
% 
% 
% %% plot each reindeer separated by season and timepoint, include pre sleep restriction %%
% 
% 
% 
% h1=figure
% 
% for n=[ 4 9]
%     subplot(4,3,1)
%     plot(SWA_decrease_SR(n,[1:12]),'o--')
%     hold on
% end
%     plot(nanmean(SWA_decrease_SR([ 4 9],1:12)),'-ko','MarkerFaceColor','k')
%     title('Dec-Midday')
%     ylim([0 2])
%     xlim([0 13])
%     
% for n=[2 5 7 10]
%     subplot(4,3,2)
%     plot(SWA_decrease_SR(n,[1:12]),'o--')
%     hold on
% end
%     plot(nanmean(SWA_decrease_SR([2 5 7 10],1:12)),'-ko','MarkerFaceColor','k')
%     title('July-Midday')
%     ylim([0 2])
%     xlim([0 13])
%     
% for n=[3 6 8 11]
%     subplot(4,3,3)
%     plot(SWA_decrease_SR(n,[1:12]),'o--')
%     hold on
% end
%     plot(nanmean(SWA_decrease_SR([3 6 8 11],1:12)),'-ko','MarkerFaceColor','k')
%     title('Sep-Midday')
%     ylim([0 2])
%     xlim([0 13])
%     
%  for n=[1 4 9]
%     subplot(4,3,7)
%     plot(SWA_decrease_SR(n,[13:24]),'o--')
%     hold on
% end
%     plot(nanmean(SWA_decrease_SR([1 4 9],13:24)),'-ko','MarkerFaceColor','k')
%     title('Dec-Midnight')
%     ylim([0 2])
%     xlim([0 13])
%     
% for n=[2 5 7 10]
%     subplot(4,3,8)
%     plot(SWA_decrease_SR(n,[13:24]),'o--')
%     hold on
% end
%     plot(nanmean(SWA_decrease_SR([2 5 7 10],13:24)),'-ko','MarkerFaceColor','k')
%     title('July-Midnight')
%     ylim([0 2])
%     xlim([0 13])
%     
% for n=[3 6 8 11]
%     subplot(4,3,9)
%     plot(SWA_decrease_SR(n,[13:24]),'o--')
%     hold on
% end
%     plot(nanmean(SWA_decrease_SR([3 6 8 11],13:24)),'-ko','MarkerFaceColor','k')
%     title('Sep-Midnight')
%     ylim([0 2])
%     xlim([0 13])
% 
%     
%     
%     
% for n=[ 4 9]
%     subplot(4,3,4)
%     plot(nrem_SR(n,[1:12]),'o--')
%     hold on
% end
%     plot(nanmean(nrem_SR([ 4 9],1:12)),'-ko','MarkerFaceColor','k')
%     title('Dec-Midday')
%     ylim([0 50])
%     xlim([0 13])
%     
% for n=[2 5 7 10]
%     subplot(4,3,5)
%     plot(nrem_SR(n,[1:12]),'o--')
%     hold on
% end
%     plot(nanmean(nrem_SR([2 5 7 10],1:12)),'-ko','MarkerFaceColor','k')
%     title('July-Midday')
%     ylim([0 50])
%     xlim([0 13])
%     
% for n=[3 6 8 11]
%     subplot(4,3,6)
%     plot(nrem_SR(n,[1:12]),'o--')
%     hold on
% end
%     plot(nanmean(nrem_SR([3 6 8 11],1:12)),'-ko','MarkerFaceColor','k')
%     title('Sep-Midday')
%     ylim([0 50])
%     xlim([0 13])
%     
%  for n=[1 4 9]
%     subplot(4,3,10)
%     plot(nrem_SR(n,[13:24]),'o--')
%     hold on
% end
%     plot(nanmean(nrem_SR([1 4 9],13:24)),'-ko','MarkerFaceColor','k')
%     title('Dec-Midnight')
%     ylim([0 50])
%     xlim([0 13])
%     
% for n=[2 5 7 10]
%     subplot(4,3,11)
%     plot(nrem_SR(n,[13:24]),'o--')
%     hold on
% end
%     plot(nanmean(nrem_SR([2 5 7 10],13:24)),'-ko','MarkerFaceColor','k')
%     title('July-Midnight')
%     ylim([0 50])
%     xlim([0 13])
%     
% for n=[3 6 8 11]
%     subplot(4,3,12)
%     plot(nrem_SR(n,[13:24]),'o--')
%     hold on
% end
%     plot(nanmean(nrem_SR([3 6 8 11],13:24)),'-ko','MarkerFaceColor','k')
%     title('Sep-Midnight')
%     ylim([0 50])
%     xlim([0 13])

%% %%%%%%%%%%%%%%%%%%%% take absolute time for hours and not from when wake episode ends %%%%%%%%%%%%%


clear all
close

cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\SWA_normalized_aligned')
load('SWA_scoring_episodes.mat')



ssrd= 46*15*60 % start sleep restriction day
esrd= 48*15*60 % end sleep restriction day

ssrn= 58*15*60 % start sleep restriction nigh
esrn= 60*15*60 % end sleep restriction night


for n=1:11
    
    for i = 1:6
    SWA_decrease_SR(n,i)=nanmean(SWA_normalized(n,esrd+900*(i-1)+1:esrd+900*i))
    SWA_decrease_SR(n+11,i)=nanmean(SWA_normalized(n,esrn+900*(i-1)+1:esrn+900*i))
    end
    
end
    

%% plot mean of each season and mean of everything (no distingtion between timepoint) %%          
      
      
  h5=figure

    errorbar(nanmean(nanmean(cat(3,SWA_decrease_SR([1 4  9],:), SWA_decrease_SR([12 15 20],:)),3)),nanstd(nanmean(cat(3,SWA_decrease_SR([1 4 9],:), SWA_decrease_SR([12 15 20],:)),3)),'Color',[0 0.4 0.7],'LineWidth',2)
    
    hold on
    errorbar(nanmean(nanmean(cat(3,SWA_decrease_SR([2 5 7 10],:), SWA_decrease_SR([13 16 18 21],:)),3)),nanstd(nanmean(cat(3,SWA_decrease_SR([2 5 7 10],:), SWA_decrease_SR([13 16 18 21],:)),3)),'Color',[0.2 0.6 0.1],'LineWidth',2)
     
    hold on
    errorbar(nanmean(nanmean(cat(3,SWA_decrease_SR([3 6 8 11],:), SWA_decrease_SR([14 17 19 22],:)),3)),nanstd(nanmean(cat(3,SWA_decrease_SR([3 6 8 11],:), SWA_decrease_SR([14 17 19 22],:)),3)),'Color',[0.9 0.5 0.1],'LineWidth',2)

    hold on
    plot(nanmean(SWA_decrease_SR),'-ko','MarkerFaceColor','k','LineWidth',2)
      ylim([0.4 2.3])
      xlim([0.5 6.6])
      ylabel('normalized SWA')
      xlabel('time after sleep restriction (h)')