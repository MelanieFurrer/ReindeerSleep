
clear
close all

cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\SWA_normalized_aligned')
load('SWA_scoring_episodes.mat')


%% define 2h as before first sleep and after last sleep %%%%


h=2 %% define how many hours

ssrd= 46*15*60 % start sleep restriction day
esrd= 48*15*60 % end sleep restriction day

ssrn= 58*15*60 % start sleep restriction nigh
esrn= 60*15*60 % end sleep restriction night




cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\episodes\all')
load('episodes.mat')

for n=1:11
    endepoch_episodes_SR(n).epoch = episodes(n).wakdura(:,2)
    startepoch_episodes_SR(n).epoch = episodes(n).wakdura(:,3)
end


for n=1:11 
    
    epochends = endepoch_episodes_SR(n).epoch( endepoch_episodes_SR(n).epoch < ssrd);
    if isempty(max(epochends)-h*900)
        borders(n,1:4)=NaN;
    else
        borders(n,1)=max(epochends)-h*900;
        borders(n,2)=max(epochends);

        epochstarts = startepoch_episodes_SR(n).epoch( startepoch_episodes_SR(n).epoch > esrd);
        borders(n,3)=min(epochstarts);
        borders(n,4)=min(epochstarts)+h*900;
        
        wake_length_midday(n)=(min(epochstarts)-max(epochends))/15/60;
    end

        epochends = endepoch_episodes_SR(n).epoch( endepoch_episodes_SR(n).epoch < ssrn);
        borders(n,5)=max(epochends)-h*900;
        borders(n,6)=max(epochends);
    
        epochstarts = startepoch_episodes_SR(n).epoch( startepoch_episodes_SR(n).epoch > esrn);
        borders(n,7)=min(epochstarts);
        borders(n,8)=min(epochstarts)+h*900;
        
        wake_length_midnight(n)=(min(epochstarts)-max(epochends))/15/60;
            
end


%%% summarize SWA over whole time period %%%

for n=1:11
    
    if n==1
      SWA_episodes_SR(n,1:2)= NaN;
      SWA_episodes_SR(n,3)=nanmean(SWA_normalized(n,borders(n,5):borders(n,6)));
      SWA_episodes_SR(n,4)=nanmean(SWA_normalized(n,borders(n,7):borders(n,8)));  
      
    else
   
    SWA_episodes_SR(n,1)=nanmean(SWA_normalized(n,borders(n,1):borders(n,2)));
    SWA_episodes_SR(n,2)=nanmean(SWA_normalized(n,borders(n,3):borders(n,4)));
    SWA_episodes_SR(n,3)=nanmean(SWA_normalized(n,borders(n,5):borders(n,6)));
    SWA_episodes_SR(n,4)=nanmean(SWA_normalized(n,borders(n,7):borders(n,8))); 
    
    end
    
end

SWA_SR=vertcat(SWA_episodes_SR(2:11,1),SWA_episodes_SR(2:11,2),SWA_episodes_SR(:,3),SWA_episodes_SR(:,4))


%% alternative: %%%%% define start and end time (exactly 2h before and after sleep
%%%%% restriction period %%%%%%%%%%%

b1=44*60*15+1;
b2=46*60*15+1;
b3=48*60*15+1;
b4=50*60*15+1;
b5=56*60*15+1;
b6=58*60*15+1;
b7=60*60*15+1;
b8=62*60*15+1;
        

for i = 1:11
        
    SWA_SR(i,1) = nanmean(SWA_normalized(i,b1:b2-1));  
    SWA_SR(i,2) = nanmean(SWA_normalized(i,b3:b4-1));    
    SWA_SR(i,3) = nanmean(SWA_normalized(i,b5:b6-1));    
    SWA_SR(i,4) = nanmean(SWA_normalized(i,b7:b8-1));  

end


SWA_SR=SWA_SR'
