
%% SWA decrease across rum
clear all

d_buildup=15*15;
d_before_max=15*15;
d_before=15*0;
d_after=15*0;
d_after_max=15*25;
%  season=1
%  SR_BL=1
nrem_swa_min=15*1-1;
 
% epochs_high_sleep_pressure=[1:7200 19801:23400 43201:46800 54001:57600 ]; % four hours after sleep restrictions incl. adaptations
% epochs_low_sleep_pressure=[7201:19800 23401:43200 46801:54000 57600:81900]; % rest (BL2 [57601:79200])

epochs_high_sleep_pressure=[43201:46800 54001:57600 ]; % four hours after sleep restrictions
epochs_low_sleep_pressure=[57601:79200]; % rest (BL2 [57601:79200])

cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\SWA_normalized_aligned')
load('SWA_scoring_episodes.mat')

% replace episodes with "sleep episodes" (inactivity incl. nrem, rem and
% rum with max. 5min wake-breaks)
cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\episodes\all')
load('episodes_sleep.mat')



% keep only episodes that are mind. 30min long %
for n=1:11
    
    for t = 1: length(episodes(n).sleepdura)
        
        if  episodes(n).sleepdura(t,1) > 450 %&& episodes(n).sleepdura(t,1) < 1800
            sleepok(t)=1;
        else
            sleepok(t)=0;       
        end
    end
    
     episodes(n).sleepdura=episodes(n).sleepdura(find(sleepok),:);
        clear sleepok
end
    


% check for each episode how much nrem, rem, rum, and wake there is (1 =
% epoch with the indicated state), and SWA for each episode

nremepochs=[];
rumepochs=[];
remepochs=[];
wakeepochs=[];
SWA=[];
startepo=[];
season=[];

for n=1:11
    
    for t = 1: size(episodes(n).sleepdura,1)
        
        nreme{t,:}=STD_all(n).STD(episodes(n).sleepdura(t,2):episodes(n).sleepdura(t,3)) == '2' | STD_all(n).STD(episodes(n).sleepdura(t,2):episodes(n).sleepdura(t,3)) == 'n';
        rume{t,:}=STD_all(n).STD(episodes(n).sleepdura(t,2):episodes(n).sleepdura(t,3)) == '4' | STD_all(n).STD(episodes(n).sleepdura(t,2):episodes(n).sleepdura(t,3)) == 't';
        reme{t,:}=STD_all(n).STD(episodes(n).sleepdura(t,2):episodes(n).sleepdura(t,3)) == '3' | STD_all(n).STD(episodes(n).sleepdura(t,2):episodes(n).sleepdura(t,3)) == 'r';
        wakee{t,:}=STD_all(n).STD(episodes(n).sleepdura(t,2):episodes(n).sleepdura(t,3)) == 'w';
        starte(t)=episodes(n).sleepdura(t,3);
        recording(t)=n;
        
        SWA_episode=SWA_normalized(n,episodes(n).sleepdura(t,2):episodes(n).sleepdura(t,3));
%         SWA_episode(isnan(SWA_episode)) = [];
        SWA_episode(end:3600)=NaN;
        SWAe(t,:)=SWA_episode;
    end
    
    nremepochs=vertcat(nremepochs, nreme);
    rumepochs=vertcat(rumepochs, rume);
    remepochs=vertcat(remepochs, reme);
    wakeepochs=vertcat(wakeepochs, wakee);
    SWA = vertcat(SWA, SWAe);
    startepo = horzcat(startepo, starte);
    season = horzcat(season, recording);
    
    clear nreme rume reme wakee SWAe starte recording
    
end



% find epochs with rum between 20 min and end -5min (to allow for nrem at the end) and no rum before %

with_rum=zeros(length(remepochs),1);
for i=1:length(remepochs)
    
    rumep = cell2mat(rumepochs(i));
    
    if sum(rumep(d_buildup+d_before+1:end-d_after)) > 74 && sum(rumep(d_buildup:d_buildup+d_before)) < 74 && sum(rumep(end-d_after:end)) < 74
        with_rum(i)=1;
    else
    end
end
    
r=find(with_rum);
startepor=startepo(r);
seasonr=season(r);
seasonr(find(ismember(seasonr,[1 4 9]))) = 1;
seasonr(find(ismember(seasonr,[2 5 7 10]))) = 2;
seasonr(find(ismember(seasonr,[3 6 8 11]))) = 3;

for i=1:length(r)
    
    rumep = cell2mat(rumepochs(r(i)));
    nremep = cell2mat(nremepochs(r(i)));
    
    start_rum=find(rumep(d_buildup+d_before+1:end-d_after),1,'first')+d_buildup+d_before;
    end_rum=find(rumep(d_buildup+d_before+1:end-d_after),1,'last')+d_buildup+d_before;
    
    length_rum(i)=sum(rumep(start_rum:end_rum))/15;
    length_nrem(i)=sum(nremep(start_rum:end_rum))/15;
    
    SWA_before(i)=nanmean(SWA(r(i),start_rum-d_before_max:start_rum-1)); %from 10min to start rum
    SWA_after(i)=nanmean(SWA(r(i),end_rum+1:end_rum+d_after_max)); %from end rum to end sleep episode or max. length
    
    nepochs_before(i)=length(find(~isnan(SWA(r(i),start_rum-d_before_max:start_rum-1))));
    nepochs_after(i)=length(find(~isnan(SWA(r(i),end_rum+1:end_rum+d_after_max))));
end

SWA_before(nepochs_before<nrem_swa_min | nepochs_after<nrem_swa_min)=NaN;
SWA_after(nepochs_before<nrem_swa_min | nepochs_after<nrem_swa_min)=NaN;
nepochs_before(nepochs_before<nrem_swa_min | nepochs_after<nrem_swa_min)=NaN;
nepochs_after(nepochs_before<nrem_swa_min | nepochs_after<nrem_swa_min)=NaN;
SWA_change = SWA_after - SWA_before;

%     SR=find(ismember(startepor,epochs_high_sleep_pressure));
%     BL=find(ismember(startepor,epochs_low_sleep_pressure));
%     SWA_before_BL=SWA_before(BL);
%     SWA_after_BL=SWA_after(BL);
%     SWA_before_SR=SWA_before(SR);
%     SWA_after_SR=SWA_after(SR);
%     SWA_change_SR=SWA_after_SR-SWA_before_SR;
%     SWA_change_BL=SWA_after_BL-SWA_before_BL;
      

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
        [r,p] = corr(length_rum',SWA_change','rows','complete')
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
       
%% seasonal differences
% SWA_change_dec=SWA_before(intersect([BL SR],find(seasonr==1)))-SWA_after(intersect([BL SR],find(seasonr==1)));
% SWA_change_jul=SWA_before(intersect([BL SR],find(seasonr==2)))-SWA_after(intersect([BL SR],find(seasonr==2)));    
% SWA_change_sep=SWA_before(intersect([BL SR],find(seasonr==3)))-SWA_after(intersect([BL SR],find(seasonr==3)));
% 
% SWA_change_dec(end+1:length(SWA_change_jul))=NaN;
% SWA_change_sep(end+1:length(SWA_change_jul))=NaN;
% 
% [h,p] = ttest2(SWA_change_jul', SWA_change_dec')
%  h2=figure
%  boxplot([SWA_change_dec ;SWA_change_jul ;SWA_change_sep]')
% 
% [h,p] = ttest2(SWA_change_BL', SWA_change_SR')
% SWA_change_SR(end+1:length(SWA_change_BL))=NaN;
%  h3=figure
%  boxplot([SWA_change_BL ;SWA_change_SR]')
% set(gca, 'YDir','reverse')

