
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

h=3 %% how many 2h-segments before and after


ssrd= 46*15*60 % start sleep restriction day
esrd= 48*15*60 % end sleep restriction day

ssrn= 58*15*60 % start sleep restriction nigh
esrn= 60*15*60 % end sleep restriction night



for n=1:11
    
    
    epochends = endepoch_episodes_SR(n).epoch( endepoch_episodes_SR(n).epoch < ssrd);
    if isempty(max(epochends)-h*1800)
        borders(n,1:2)=NaN;
    else
        borders(n,1)=max(epochends)-h*1800;
        borders(n,2)=max(epochends);
    end
    
        epochstarts = startepoch_episodes_SR(n).epoch( startepoch_episodes_SR(n).epoch > esrd);
        borders(n,3)=min(epochstarts);
        borders(n,4)=min(epochstarts)+h*1800;
    
        epochends = endepoch_episodes_SR(n).epoch( endepoch_episodes_SR(n).epoch < ssrn);
        borders(n,5)=max(epochends)-h*1800;
        borders(n,6)=max(epochends);
    
        epochstarts = startepoch_episodes_SR(n).epoch( startepoch_episodes_SR(n).epoch > esrn);
        borders(n,7)=min(epochstarts);
        borders(n,8)=min(epochstarts)+h*1800;
        
    
end






%%% 2h-course of SWA over time period %%%

for i=1:4
    borders_2hcourse(:,i)=borders(:,1)+(i-1)*1800;
end

for i=5:8
    borders_2hcourse(:,i)=borders(:,3)+(i-5)*1800;
end

for i=9:12
    borders_2hcourse(:,i)=borders(:,5)+(i-9)*1800;
end

for i=13:16
    borders_2hcourse(:,i)=borders(:,7)+(i-13)*1800;
end




for n=1:11
    
    if n==1
        
     SWA_decrease_SR(n,1:3)= NaN;
     
        for i=4:6
            SWA_decrease_SR(n,i)=nanmean(SWA_normalized(n,borders_2hcourse(n,i+1):borders_2hcourse(n,i+2)));
            vissymbsegment(i,:)=STD_all(n).STD(borders_2hcourse(n,i+1):borders_2hcourse(n,i+2));
            nrem_SR(n,i) = length(find(vissymbsegment(i,:)=='n' | vissymbsegment(i,:)=='2'))/15;
        end
     
        for i=7:9
            SWA_decrease_SR(n,i)=nanmean(SWA_normalized(n,borders_2hcourse(n,i+2):borders_2hcourse(n,i+3)));
            vissymbsegment(i,:)=STD_all(n).STD(borders_2hcourse(n,i+2):borders_2hcourse(n,i+3));
            nrem_SR(n,i) = length(find(vissymbsegment(i,:)=='n' | vissymbsegment(i,:)=='2'))/15;
        end
        
        for i=10:12
            SWA_decrease_SR(n,i)=nanmean(SWA_normalized(n,borders_2hcourse(n,i+3):borders_2hcourse(n,i+4)));
            vissymbsegment(i,:)=STD_all(n).STD(borders_2hcourse(n,i+3):borders_2hcourse(n,i+4));
            nrem_SR(n,i) = length(find(vissymbsegment(i,:)=='n' | vissymbsegment(i,:)=='2'))/15;
        end
      
    else
   
        for i=1:3
            SWA_decrease_SR(n,i)=nanmean(SWA_normalized(n,borders_2hcourse(n,i):borders_2hcourse(n,i+1)));
            vissymbsegment(i,:)=STD_all(n).STD(borders_2hcourse(n,i):borders_2hcourse(n,i+1));
            nrem_SR(n,i) = length(find(vissymbsegment(i,:)=='n' | vissymbsegment(i,:)=='2'))/15;
        end
        
        for i=4:6
            SWA_decrease_SR(n,i)=nanmean(SWA_normalized(n,borders_2hcourse(n,i+1):borders_2hcourse(n,i+2)));
            vissymbsegment(i,:)=STD_all(n).STD(borders_2hcourse(n,i+1):borders_2hcourse(n,i+2));
            nrem_SR(n,i) = length(find(vissymbsegment(i,:)=='n' | vissymbsegment(i,:)=='2'))/15;
        end
        
        for i=7:9
            SWA_decrease_SR(n,i)=nanmean(SWA_normalized(n,borders_2hcourse(n,i+2):borders_2hcourse(n,i+3)));
            vissymbsegment(i,:)=STD_all(n).STD(borders_2hcourse(n,i+2):borders_2hcourse(n,i+3));
            nrem_SR(n,i) = length(find(vissymbsegment(i,:)=='n' | vissymbsegment(i,:)=='2'))/15;
        end
        
       for i=10:12
            SWA_decrease_SR(n,i)=nanmean(SWA_normalized(n,borders_2hcourse(n,i+3):borders_2hcourse(n,i+4)));
            vissymbsegment(i,:)=STD_all(n).STD(borders_2hcourse(n,i+3):borders_2hcourse(n,i+4));
            nrem_SR(n,i) = length(find(vissymbsegment(i,:)=='n' | vissymbsegment(i,:)=='2'))/15;
        end
    
    end
    
end

%% rearrange for R (SWA after SR only)

SWA_R=reshape(SWA_decrease_SR(:,[3 4:6 9 10:12])',1,88)';
