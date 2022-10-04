%% SWA decrease across rum
clear
close all

%%%% adapt (15*x indicates how many minutes, e.g. 15*1 -> 1min)%%%%%

d_before_max=15*15;
d_after_max=15*15;
nrem_swa_min=15*1-1;
rumep_min=15*5-1;


%%%load data%%%%%%
cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\SWA_normalized_aligned')
load('SWA_scoring_episodes.mat')

% replace episodes with "sleep episodes" (inactivity incl. nrem, rem and
% rum with max. 5min wake-breaks)
cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\episodes\all')
load('episodes_sleep.mat')



%%%%check for each episode how much nrem, and rum there is (1 = epoch with the indicated state), and calculate SWA and startepoch for each episode

nremepochs=[];
rumepochs=[];

SWA=[];
recording=[];

startepo=[];
endepo=[];

for n=1:11
    
    for t = 1: size(episodes(n).sleepdura,1)
        
        nreme{t,:}=STD_all(n).STD(episodes(n).sleepdura(t,2):episodes(n).sleepdura(t,3)) == '2' | STD_all(n).STD(episodes(n).sleepdura(t,2):episodes(n).sleepdura(t,3)) == 'n';
        rume{t,:}=STD_all(n).STD(episodes(n).sleepdura(t,2):episodes(n).sleepdura(t,3)) == '4' | STD_all(n).STD(episodes(n).sleepdura(t,2):episodes(n).sleepdura(t,3)) == 't';
        rec(t)=n;
        starte(t)=episodes(n).sleepdura(t,2);
        ende(t)=episodes(n).sleepdura(t,3);
        SWA_episode=SWA_normalized(n,episodes(n).sleepdura(t,2):episodes(n).sleepdura(t,3));
%         SWA_episode(isnan(SWA_episode)) = [];
        SWA_episode(end:3600)=NaN;
        SWAe(t,:)=SWA_episode;
    end
    
    nremepochs=vertcat(nremepochs, nreme);
    rumepochs=vertcat(rumepochs, rume);
    
    startepo = horzcat(startepo, starte);
    endepo = horzcat(endepo, ende);
   
    SWA = vertcat(SWA, SWAe);
    recording = horzcat(recording, rec);
    
    clear nreme rume rec starte ende SWAe  
    
end



%%%%%find epochs with rum (> rumep_min)%%%%%%

with_rum=zeros(length(rumepochs),1);
for i=1:length(rumepochs)
    
    rumep = cell2mat(rumepochs(i));
    
    if sum(rumep) > rumep_min
        with_rum(i)=1;
    else
    end
end
    
r=find(with_rum);
recording_r=recording(r);

%%%calculate SWA during NREM sleep before and after%%%%
for i=1:length(r)
    
    rumep = cell2mat(rumepochs(r(i)));
    nremep = cell2mat(nremepochs(r(i)));
    
    start_rum=find(rumep,1,'first');
    end_rum=find(rumep,1,'last');
    
    length_rum(i)=sum(rumep(start_rum:end_rum))/15;
    length_nrem(i)=sum(nremep(start_rum:end_rum))/15;
    
    SWA_before(i)=nanmean(SWA(r(i),max(start_rum-d_before_max,1):start_rum-1));
    SWA_after(i)=nanmean(SWA(r(i),end_rum+1:end_rum+d_after_max));
    
    nepochs_before(i)=length(find(~isnan(SWA(r(i),max(start_rum-d_before_max,1):start_rum-1))));
    nepochs_after(i)=length(find(~isnan(SWA(r(i),end_rum+1:end_rum+d_after_max))));
end

%%%exclude if there was less than nrem_swa_min of NREM sleep %%%
SWA_before(nepochs_before<nrem_swa_min | nepochs_after<nrem_swa_min)=NaN;
SWA_after(nepochs_before<nrem_swa_min | nepochs_after<nrem_swa_min)=NaN;
nepochs_before(nepochs_before<nrem_swa_min | nepochs_after<nrem_swa_min)=NaN;
nepochs_after(nepochs_before<nrem_swa_min | nepochs_after<nrem_swa_min)=NaN;
SWA_change = SWA_after - SWA_before;


%%%plots %%%
h1=figure
    subplot(1,2,1)

    [h,p,ci,stats] = ttest(SWA_before,SWA_after)
    for i=1:length(SWA_change)
        
        plot([1:2],[SWA_before(i),SWA_after(i)],'-o','Color', [0.4 0.4 0.4],'MarkerFaceColor', [0.8 0.8 0.8], 'MarkerEdgeColor', 'k')
        hold on
        xlim([0.5 2.5])
    end
    
    
   
    plot([1:2],[nanmean(SWA_before),nanmean(SWA_after)],'-ko','MarkerFaceColor','black','LineWidth',2)
     ylim([0 3])
     xlim([0.8 2.2])
     xticks([1 2]);
     xticklabels({'before','after'});
     ax=gca;
     ax.XAxis.FontSize = 18;
     
    %title(num2str(p))
      ylabel('normalized SWA','FontSize',18)
    
    subplot(1,2,2)
        [coef,p] = corr(length_rum',SWA_change','rows','complete')
        scatter(length_rum,SWA_change,'k','MarkerFaceColor',[0.8 0.8 0.8])
        l = lsline;
        l.LineWidth = 2;
        l.Color = 'black';
        %title(num2str(p))
     set ( gca, 'ydir', 'reverse' )
       ylabel('SWA change')
       xlabel('rumination duration (min)')
       ax=gca;
       ax.XLabel.FontSize = 18;
       ax.YLabel.FontSize = 18;
       

%%%% find epochs with rum for modelling of process S %%%%%%%

episodes_sleep_rum(:,1)=recording_r;
episodes_sleep_rum(:,2)=startepo(r);
episodes_sleep_rum(:,3)=endepo(r);

episodes_sleep_rum(find(isnan(SWA_change)),:)=[];





       