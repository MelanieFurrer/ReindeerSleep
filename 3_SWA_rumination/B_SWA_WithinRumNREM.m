%% SWA buildup and decrease within rumination

clear
 close all


cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\SWA_normalized_aligned')
load('SWA_scoring_episodes_rum.mat')

cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\episodes\all')
load('episodes.mat')


%only rum episodes that are more than 30 min long
for n=1:11
     %episodes(n).rumdura = episodes(n).rumdura(find(episodes(n).rumdura(:,1) > 449),:);

    
     for t = 1: length(episodes(n).rumdura)
        if length(find(STD_all(n).STD(episodes(n).rumdura(t,2):episodes(n).rumdura(t,3)) == 't' | STD_all(n).STD(episodes(n).rumdura(t,2):episodes(n).rumdura(t,3)) == '4')) > 449 && ~isnan(nanmean(SWA_normalized(n,episodes(n).rumdura(t,2):episodes(n).rumdura(t,3))))
            rumok(t)=1;
        else
            rumok(t)=0;
        end  
     end
     
  episodes(n).rumdura=episodes(n).rumdura(find(rumok),:);
  clear rumok
  
end


SWAcourse=[];

for n=1:11
    
  SWA=[];  
    for i=1:size(episodes(n).rumdura,1)
    
        SWA_episode=SWA_normalized(n,episodes(n).rumdura(i,2):episodes(n).rumdura(i,3));
        SWA_episode(isnan(SWA_episode)) = [];
        SWA_episode(end:2700)=NaN;
        SWA(i,:)=SWA_episode;
    end
    
    SWAcourse=vertcat(SWAcourse,SWA);
    
end


SWAcourse_perminute=squeeze(nanmean(reshape(SWAcourse,[],15,180),2));

h1=figure
% scatter(1:size(SWAcourse,2),nanmean(SWAcourse),'k','MarkerFaceColor',[0.4 0.4 0.4])   
plot(nanmean(SWAcourse,1),'k')
xlim([0 700])
xticks([0 225 450 675])
xticklabels({'0','15','30','45'})
xlabel('minutes of rumination')
ylabel('SWA relative to baseline')
ylim([0 2])
       ax=gca;
       ax.XLabel.FontSize = 14;
       ax.YLabel.FontSize = 14;

% h2=figure
%     
% plot(nanmean(SWAcourse_perminute,1),'k')
% % xlim([0 705/15])
% % xticks([0 15 30 45])
% % xticklabels({'0','15','30','45'})
% xlabel('minutes of rumination')
% ylabel('normalized SWA')
% ylim([0 2])
%        ax=gca;
%        ax.XLabel.FontSize = 18;
%        ax.YLabel.FontSize = 18;

%% SWA buildup and decrease within NREM sleep

clear


savepath='';

cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\SWA_normalized_aligned')
load('SWA_scoring_episodes.mat')

cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\episodes\all')
load('episodes5min.mat')


% mind. 50% NREM sleep and mind. 30min long

for n=1:11
     %episodes(n).rumdura = episodes(n).rumdura(find(episodes(n).rumdura(:,1) > 449),:);

    
     for t = 1: length(episodes(n).nremdura)
        nremepochs=length(find(STD_all(n).STD(episodes(n).nremdura(t,2):episodes(n).nremdura(t,3)) == '2' | STD_all(n).STD(episodes(n).nremdura(t,2):episodes(n).nremdura(t,3)) == 'n'))
        nrempercentage=(nremepochs/episodes(n).nremdura(t,1))*100
        
        if  nremepochs > 449 & nrempercentage > 50
            nremok(t)=1;
        else
            nremok(t)=0;
        end  
     end
     
  episodes(n).nremdura=episodes(n).nremdura(find(nremok),:);
  clear nremok
  
end


SWAcourse=[];

for n=1:11
    
  SWA=[];  
    for i=1:size(episodes(n).nremdura,1)
    
        SWA_episode=SWA_normalized(n,episodes(n).nremdura(i,2):episodes(n).nremdura(i,3));
        SWA_episode(isnan(SWA_episode)) = [];
        SWA_episode(end:2700)=NaN;
        SWA(i,:)=SWA_episode;
    end
    
    SWAcourse=vertcat(SWAcourse,SWA);
    
end



h3=figure
% scatter(1:size(SWAcourse,2),nanmean(SWAcourse),'k','MarkerFaceColor',[0.4 0.4 0.4])    
plot(nanmean(SWAcourse,1),'k')
xlim([0 790])
xticks([0 225 450 675 ])
xticklabels({'0','15','30','45'})
xlabel('minutes of NREM sleep')
ylabel('normalized SWA')
ylim([0 2])
       ax=gca;
       ax.XLabel.FontSize = 14;
       ax.YLabel.FontSize = 14;
       

% h4=figure       
% SWAcourse_perminute=squeeze(nanmean(reshape(SWAcourse,[],15,180),2));      
% plot(nanmean(SWAcourse_perminute,1),'k')
% % xlim([0 705/15])
% % xticks([0 15 30 45])
% % xticklabels({'0','15','30','45'})
% xlabel('minutes of NREM sleep')
% ylabel('SWA relative to baseline')
% ylim([0 2])
%        ax=gca;
%        ax.XLabel.FontSize = 18;
%        ax.YLabel.FontSize = 18;

%% compare seasons
% 
% season=[];
% season(1:size(episodes(1).rumdura,1))=1;
% season(end+1:end+size(episodes(2).rumdura,1))=2;
% season(end+1:end+size(episodes(3).rumdura,1))=3;
% season(end+1:end+size(episodes(4).rumdura,1))=1;
% season(end+1:end+size(episodes(5).rumdura,1))=2;
% season(end+1:end+size(episodes(6).rumdura,1))=3;
% season(end+1:end+size(episodes(7).rumdura,1))=2;
% season(end+1:end+size(episodes(8).rumdura,1))=3;
% season(end+1:end+size(episodes(9).rumdura,1))=1;
% season(end+1:end+size(episodes(10).rumdura,1))=2;
% season(end+1:end+size(episodes(11).rumdura,1))=3;
% 
%   
% 
% 
% 
% 
% h3=figure
%     subplot(1,3,1)
%     plot(nanmean(SWAcourse_perminute(find(season==1),:),1))
%        xlim([0 900/15])
% xticks([0 15 30 45 60])
%     xticklabels({'0','15','30','45','60'})
%     xlabel('minutes of NREM sleep')
%     ylabel('normalized SWA')
%     ylim([0 2])
%     title('December')
%     
%     subplot(1,3,2)
%     plot(nanmean(SWAcourse_perminute(find(season==2),:),1))
%        xlim([0 900/15])
% xticks([0 15 30 45 60])
%     xticklabels({'0','15','30','45','60'})
%     xlabel('minutes of NREM sleep')
%     ylabel('normalized SWA')
%     ylim([0 2])
%     title('July')
%     
%     subplot(1,3,3)
%     plot(nanmean(SWAcourse_perminute(find(season==3),:),1))
%     xlim([0 900/15])
% xticks([0 15 30 45 60])
%     xticklabels({'0','15','30','45','60'})
%     xlabel('minutes of NREM sleep')
%     ylabel('normalized SWA')
%     ylim([0 2])
%     title('September')
% 
% 
% %% compare SR vs. BL
% 
% season=[];
% season(1:size(episodes(1).rumdura,1))=1;
% season(end+1:end+size(episodes(2).rumdura,1))=2;
% season(end+1:end+size(episodes(3).rumdura,1))=3;
% season(end+1:end+size(episodes(4).rumdura,1))=1;
% season(end+1:end+size(episodes(5).rumdura,1))=2;
% season(end+1:end+size(episodes(6).rumdura,1))=3;
% season(end+1:end+size(episodes(7).rumdura,1))=2;
% season(end+1:end+size(episodes(8).rumdura,1))=3;
% season(end+1:end+size(episodes(9).rumdura,1))=1;
% season(end+1:end+size(episodes(10).rumdura,1))=2;
% season(end+1:end+size(episodes(11).rumdura,1))=3;
% 
% 
% SR=[];
% for n=1:11
% 
% SRe=[];
%     for t = 1: size(episodes(n).rumdura,1)
%         if ismember(episodes(n).rumdura(t,3),[43201:46800 54001:57600])
%             SRe(t)=1;
%         elseif ismember(episodes(n).rumdura(t,3),[57601:79200])
%             SRe(t)=2;
%         else
%             SRe(t)=0; 
%         end
%     end
%     SR=horzcat(SR,SRe);
%     clear SRe
% end
% 
% h4=figure
%     subplot(1,2,1)
%     plot(nanmean(SWAcourse_perminute(find(SR==1),:),1))
%     xlim([0 900/15])
% xticks([0 15 30 45 60])
%     xticklabels({'0','15','30','45','60'})
%     xlabel('minutes of rumination')
%     ylabel('normalized SWA')
%     ylim([0 2.5])
%     title('after sleep restriction')
%     
%     subplot(1,2,2)
%     plot(nanmean(SWAcourse_perminute(find(SR==2),:),1))
%     xlim([0 900/15])
% xticks([0 15 30 45 60])
%     xticklabels({'0','15','30','45','60'})
%     xlabel('minutes of rumination')
%     ylabel('normalized SWA')
%     ylim([0 2.5])
%     title('Baseline 2')
 
    
    

%%
    
% clear 
% close all
% 
% 
% 
% 
% %% durations
% 
% path='D:\Work\reindeer\Analyse_mainexperiment\Data\';
% datapath0=[path,'Mat_power_artcorr_scored_cut\Adapt'];
% datapath1=[path,'Mat_power_artcorr_scored_cut\BL1'];
% datapath2=[path,'Mat_power_artcorr_scored_cut\SR_BL2'];
% 
% savepath='C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\SWA_plots';
% 
% freqrange=[3:5]
% cd(datapath2)
% filenames2=dir('*power*.mat');
% nfiles=length(filenames2)
% 
% 
% for i=[2 5]
%     
%         cd(datapath0)
%         filenames0=dir('*power*.mat')
%         filename=filenames0(i).name;
%         load(filename);       
%         powerEEG_pcut_0=powerEEG_pcut;
%         artndxn_rum_0=artndxn_rum;
%         artefactfreenr=find(artndxn_rum_0);
%         SWA=squeeze(mean(powerEEG_pcut_0(1,freqrange,artefactfreenr),2));          
%         SWA_filled_0=nan(1,18900);
%         SWA_filled_0(artefactfreenr+1080)=SWA;
%         
%         cd(datapath1)
%         filenames1=dir('*power*.mat')
%         filename=filenames1(i-1).name;
%         load(filename);       
%         powerEEG_pcut_1=powerEEG_pcut;
%         artndxn_rum_1=artndxn_rum;
%         artefactfreenr=find(artndxn_rum_1);
%         SWA=squeeze(mean(powerEEG_pcut_1(1,freqrange,artefactfreenr),2));       
%         SWA_filled_1=nan(1,24300);
%         SWA_filled_1(artefactfreenr)=SWA;
%     
%         
%         cd(datapath2)
%         filename=filenames2(i).name;
%         load(filename);
%         powerEEG_pcut_2=powerEEG_pcut;
%         artndxn_rum_2=artndxn_rum;
%         artefactfreenr=find(artndxn_rum_2);
%         SWA=squeeze(mean(powerEEG_pcut_2(1,freqrange,artefactfreenr),2));       
%         SWA_filled_2=nan(1,38700); %43 h
%         SWA_filled_2(artefactfreenr)=SWA;
%         
%         SWA_filled_012=cat(2,SWA_filled_0,SWA_filled_1,SWA_filled_2);
%         SWA_filled_normalized(i,:)=SWA_filled_012/nanmean(SWA_filled_012);  
%         
%         
% end
% 
% 
% % 
% % clear
% % close all
% % 
% % 
% % path='D:\Work\reindeer\Analyse_mainexperiment\Data\';
% % datapath=[path,'Mat_power_artcorr_scored_cut\SR_BL2'];
% % savepath='';
% % cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\episodes\all')
% % load('episodesLr.mat')
% % cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\SWA_plots')
% % load('SWA_all_2hcourse.mat')
% 
% 
% SWA_normalized =  SWA_filled_normalized;
% 
% cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\episodes\all')
% load('episodesLr.mat')
% 
% 
% for n=[2 5]
% %      episodes(n).nremdura = episodes(n).nremdura(find(episodes(n).nremdura(:,1) > 119),:);
% 
%     
%      for t = 1: length(episodes(n).rumdura)
%         if length(find(STD_all(n).STD(episodes(n).rumdura(t,2):episodes(n).rumdura(t,3)) == 't' | STD_all(n).STD(episodes(n).rumdura(t,2):episodes(n).rumdura(t,3)) == '4')) > 119
%             rumok(t)=1;
%         else
%             rumok(t)=0;
%         end  
%      end
%      
%   episodes(n).rumdura=episodes(n).rumdura(find(rumok),:);
%   clear rumok
%   
% end
% 
% 
% SWAcourse=[];
% 
% for n=[2 5]
%     
%   SWA=[];  
%     for i=1:length(episodes(n).rumdura)
%     
%         SWA_episode=SWA_normalized(n,episodes(n).rumdura(i,2):episodes(n).rumdura(i,3));
%         SWA_episode(isnan(SWA_episode)) = [];
%         SWA_episode(end:2700)=NaN;
%         SWA(i,:)=SWA_episode;
%     end
%     
%     SWAcourse=vertcat(SWAcourse,SWA);
%     
% end
% 
% 
% 
% h1=figure
%     
% plot(nanmean(SWAcourse,1))
% xlim([0 900])
% xticks([0 225 450 675 900])
% xticklabels({'0','15','30','45','60'})
% xlabel('minutes of NREM sleep')
% ylabel('normalized SWA')
% ylim([0 2])

