
clear
close all

cd('C:\Users\schlaf\Documents\GitHub\ReindeerSleep\data')

load('episodes.mat')



transitions=zeros(4,4,11);
episodes_rum_rem = nan(1,1);
episodes_wake_rem = nan(1,1);

for i = 1:11
    
    %find epoch of all episodeends
    endepisodes=nan(1,21600);

    endepisodes(episodes(i).wakdura(:,3))=1;   
    endepisodes(episodes(i).nremdura(:,3))=2;
    endepisodes(episodes(i).remdura(:,3))=3;
    endepisodes(episodes(i).rumdura(:,3))=4;
    
    %keep only order of episodes
    endepisodes=endepisodes(~isnan(endepisodes)); 
    
    %save episode-durations for each episodeend
    endepisodes_dur=nan(1,21600);
    endepisodes_dur(episodes(i).wakdura(:,3))=episodes(i).wakdura(:,1);   
    endepisodes_dur(episodes(i).nremdura(:,3))=episodes(i).nremdura(:,1);  
    endepisodes_dur(episodes(i).remdura(:,3))=episodes(i).remdura(:,1);  
    endepisodes_dur(episodes(i).rumdura(:,3))=episodes(i).rumdura(:,1);  
    
    %keep only episode durations
    endepisodes_dur=endepisodes_dur(~isnan(endepisodes_dur)); 

%     
%     %exclude if two episoodes of the same state follow each other
%     for ii = 1:length(endepisodes)-1   
%         if endepisodes(ii) == endepisodes(ii+1)
%             endepisodes(ii)= NaN;
%         else
%         end               
%     end
%     endepisodes=endepisodes(~isnan(endepisodes));

    
    %transitions
    for ii = 1:length(endepisodes)-1  
        if endepisodes(ii) == 1 && endepisodes(ii+1)==2
            transitions(1,2,i) = transitions(1,2,i)+1
        elseif endepisodes(ii) == 1 && endepisodes(ii+1)==3
            transitions(1,3,i) = transitions(1,3,i)+1
            episodes_wake_rem(length(episodes_wake_rem)+1) = endepisodes_dur(ii);
        elseif endepisodes(ii) == 1 && endepisodes(ii+1)==4
            transitions(1,4,i) = transitions(1,4,i)+1
        elseif endepisodes(ii) == 2 && endepisodes(ii+1)==1
            transitions(2,1,i) = transitions(2,1,i)+1
        elseif endepisodes(ii) == 2 && endepisodes(ii+1)==3
            transitions(2,3,i) = transitions(2,3,i)+1
        elseif endepisodes(ii) == 2 && endepisodes(ii+1)==4
            transitions(2,4,i) = transitions(2,4,i)+1
        elseif endepisodes(ii) == 3 && endepisodes(ii+1)==1
            transitions(3,1,i) = transitions(3,1,i)+1
        elseif endepisodes(ii) == 3 && endepisodes(ii+1)==2
            transitions(3,2,i) = transitions(3,2,i)+1
        elseif endepisodes(ii) == 3 && endepisodes(ii+1)==4
            transitions(3,4,i) = transitions(3,4,i)+1
        elseif endepisodes(ii) == 4 && endepisodes(ii+1)==1
            transitions(4,1,i) = transitions(4,1,i)+1
        elseif endepisodes(ii) == 4 && endepisodes(ii+1)==2
            transitions(4,2,i) = transitions(4,2,i)+1
        elseif endepisodes(ii) == 4 && endepisodes(ii+1)==3
            transitions(4,3,i) = transitions(4,3,i)+1
            episodes_rum_rem(length(episodes_rum_rem)+1) = endepisodes_dur(ii);
        end   
    end

    
end



    
%normalize transition from

for i = 1:11
    
    transitions_perc(1,:,i)=transitions(1,:,i)./sum(transitions(1,:,i))*100
    transitions_perc(2,:,i)=transitions(2,:,i)./sum(transitions(2,:,i))*100
    transitions_perc(3,:,i)=transitions(3,:,i)./sum(transitions(3,:,i))*100
    transitions_perc(4,:,i)=transitions(4,:,i)./sum(transitions(4,:,i))*100
    
end
    
%mean over all BL-recordings

transitions_perc_mean = mean(transitions_perc,3)


% absolute transitions mean

transitions_mean = mean(transitions,3)


% mean length of rumination episodes with transitions to rem vs. wake
% episodes with transitions to rem

mean_dur_rumepi = nanmean(episodes_rum_rem)./15
min_dur_rumepi = min(episodes_rum_rem)./15
mean_dur_wakeepi = nanmean(episodes_wake_rem)./15
max_dur_wakeepi = max(episodes_wake_rem)./15

%normalize transition to

% for i = 1:11
%     
%     transitions_perc(:,1,i)=transitions(:,1,i)./sum(transitions(:,1,i))*100
%     transitions_perc(:,2,i)=transitions(:,2,i)./sum(transitions(:,2,i))*100
%     transitions_perc(:,3,i)=transitions(:,3,i)./sum(transitions(:,3,i))*100
%     transitions_perc(:,4,i)=transitions(:,4,i)./sum(transitions(:,4,i))*100
%     
% end
    
%mean over all BL-recordings

% transitions_perc_mean = mean(transitions_perc,3)


%normalize all transitions together

% for i = 1:11
%     
%     transitions_perc(:,:,i)=transitions(:,:,i)./sum(sum(transitions(:,:,i)))*100
%     
% end
    
%mean over all BL-recordings

% transitions_perc_mean = mean(transitions_perc,3)
    
    
    
% per season
transitions_w = mean(transitions(:,:,[1 4 9]),3)
transitions_s = mean(transitions(:,:,[2 5 7 10]),3)
transitions_a = mean(transitions(:,:,[3 6 8 11]),3)






