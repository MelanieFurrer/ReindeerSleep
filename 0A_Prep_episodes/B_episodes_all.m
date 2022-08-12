clear
close all

%%

path='D:\Work\reindeer\Analyse_mainexperiment\Data\';
datapath0=[path,'Mat_power_artcorr_scored_cut\Adapt'];
datapath1=[path,'Mat_power_artcorr_scored_cut\BL1'];
datapath2=[path,'Mat_power_artcorr_scored_cut\SR_BL2'];
savepath='C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\episodes\all';

cd(datapath2)
filenames2=dir('*power*.mat');

nfiles=length(filenames2)


for n=1:nfiles
    
        if n==1
            cd(datapath0)
            filenames0=dir('*power*.mat')
            filename=filenames0(n).name;
            load(filename); 
            
            STD_0=vissymb_cut;
            STD_0(end+1:18900)='m';
            art_0=artndxn_cut;
            art_0(end:18900)=0;
            
            % BL1 missing except for last 2 hours wake
            STD_1=nan(1,24300); %27 h
            art_1=nan(1,24300); %27 h
            STD_1(1,22501:24300)='w'; % sleep deprivation
            
        else
            cd(datapath0)
            filenames0=dir('*power*.mat')
            filename=filenames0(n).name;
            load(filename); 

            
        %shift data according to starttime
        if n==4 || n==7 || n==9 || n==10 %starttime 14h
            STD_0=vissymb_cut;
            STD_0(end+1:18900)='w';
            art_0=artndxn_cut;
            art_0(end:18900)=0;
        elseif n==2 || n==5 %starttime 15.2h
            STD_0=repelem('w',18900); %21 h
            STD_0(1081:length(vissymb_cut)+1080)=vissymb_cut;
            STD_0(end+1:18900)='w';
            art_0(1081:length(artndxn_cut)+1080)=artndxn_cut;
            art_0(end+1:18900)=0;
        elseif n==3 %starttime 13h
            STD_00=vissymb_cut;
            STD_0=vissymb_cut(901:19800);
            art_00=artndxn_cut;
            art_0=artndxn_cut(901:19800);
        elseif n==11 %starttime 12h (only 2 hours recording, rest missing)
            STD_0=vissymb_cut(1801:end);
            STD_0(end+1:18900)='m';
            art_0=artndxn_cut(1801:end);
            art_0(end+1:18900)=0;
        elseif n==6 || n==8 %starttime 14.5h
            STD_0(451:length(vissymb_cut)+450)=vissymb_cut;
            STD_0(end+1:18900)='w';
            art_0(451:length(artndxn_cut)+450)=artndxn_cut;
            art_0(end+1:18900)=0;
        end
                      
            cd(datapath1)
            filenames1=dir('*power*.mat')
            filename=filenames1(n-1).name;
            load(filename); 
            STD_1=vissymb_cut;
            STD_1(end:24300)='w';
            
        end
        
        cd(datapath2)
        filename=filenames2(n).name;
        load(filename);
        STD_2=vissymb_cut;
        STD_2(end:38700)='w';
        art_2=artndxn_cut;
        art_2(end:38700)=0;
        
        STD=horzcat(STD_0,STD_1,STD_2);
        art=horzcat(art_0,art_1,art_2);

        [episodes(n).wakdura,episodes(n).nremdura,episodes(n).remdura,episodes(n).rumdura,episodes(n).baa]=ecountwnrr(STD);
        % [episodes(n).sleepdura, sleeph(n)]=ecountsleepL(STD)
        episodes(n).reindeer=filename(1:8);
        
        STD_all(n).STD=STD;
        art_all(n).art=art;
        
end

cd(savepath)
%save('episodes_sleep.mat','episodes','art_all','STD_all')
save('episodes.mat','episodes','art_all','STD_all')

% %%
% 
% clear; close all;
% 
% cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\episodes\all')
% load('episodesLr.mat')
% load('SWA_all.mat')
% 
% 
% %%% adapt min. length rum, min length nrem and max gap betwenn rum and nrem %%
% minlength_rum=20;
% nep_rum=minlength_rum*15-1;
% minlength_nrem=5;
% nep_nrem=minlength_nrem*15-1;
% maxgap=10;
% nep_gap=maxgap*15-1;
% 
% 
% % keep only rum episodes containing mind. xxxmin rum and nrem episodes
% % containing mind. xxx min sleep
% 
% episodes2=episodes;
% 
% for n= 1:11
% 
%     
%      for t = 1: length(episodes(n).rumdura)
%         if length(find(STD_all(n).STD(episodes(n).rumdura(t,2):episodes(n).rumdura(t,3)) == 't' | STD_all(n).STD(episodes(n).rumdura(t,2):episodes(n).rumdura(t,3)) == '4')) > nep_rum
%             rumok(t)=1;
%         else
%             rumok(t)=0;       
%         end
%      end
% 
%      for t = 1: length(episodes(n).nremdura)
%         if length(find(STD_all(n).STD(episodes(n).nremdura(t,2):episodes(n).nremdura(t,3)) == '2' | STD_all(n).STD(episodes(n).nremdura(t,2):episodes(n).nremdura(t,3)) == 'n')) > nep_nrem
%             nremok(t)=1;
%         else
%             nremok(t)=0;
%         end  
%      end
%         
%      
%   episodes2(n).rumdura=episodes(n).rumdura(find(rumok),:);
%   episodes2(n).nremdura=episodes(n).nremdura(find(nremok),:);
%   clear nremok rumok
%   
% end
% 
% 
% % find episodes where there is a NREM episode before and after with less
% % than 10min of wake inbetween
% 
% for n=1:11
%     
%         for i=1:size(episodes2(n).rumdura,1)
%             
%             en=intersect([episodes2(n).rumdura(i,2)-nep_gap:episodes2(n).rumdura(i,2)],episodes2(n).nremdura(:,3));
%             bn=intersect([episodes2(n).rumdura(i,3):episodes2(n).rumdura(i,3)+nep_gap],episodes2(n).nremdura(:,2));
%                 if isempty(en) || isempty(bn)
%                 else
%                     nrepi_before=find(episodes2(n).nremdura(:,3)==en);
%                     nrem_before(n).borders(i,:)=[episodes2(n).nremdura(nrepi_before,2),episodes2(n).nremdura(nrepi_before,3)];
%                     nrepi_after=find(episodes2(n).nremdura(:,2)==bn);
%                     nrem_after(n).borders(i,:)=[episodes2(n).nremdura(nrepi_after,2),episodes2(n).nremdura(nrepi_after,3)];
%                 end
%         end
%                      
%      
% end
%  
% 
% for n=1:length(nrem_before)
% 
%     if isempty(nrem_before(n).borders)
%     else
%         nrem_before(n).borders(find(nrem_before(n).borders(:,1) == 0),:)=[]
%         nrem_after(n).borders(find(nrem_after(n).borders(:,1) == 0),:)=[]
%     end
% 
% end
% 
% 
% SWA_before=[];
% SWA_after=[];
% length_nrem_before=[];
% nepochs_nrem_before=[];
% length_nrem_after=[];
% nepochs_nrem_after=[];
% 
% for n=1:length(nrem_before)
%     
%     for i=1:size(nrem_before(n).borders,1)
%         SWA_b=nanmean(SWA_normalized(n,nrem_before(n).borders(i,1):nrem_before(n).borders(i,2)));
%         SWA_before=[SWA_before SWA_b];
%         SWA_a=nanmean(SWA_normalized(n,nrem_after(n).borders(i,1):nrem_after(n).borders(i,2)));
%         SWA_after=[SWA_after SWA_a];
%         
%         length_nrem_b=length(nrem_before(n).borders(i,1):nrem_before(n).borders(i,2));
%         length_nrem_before=[length_nrem_before length_nrem_b];
%         nepochs_nrem_b=length(find(STD_all(n).STD(nrem_before(n).borders(i,1):nrem_before(n).borders(i,2)) == '2' | STD_all(n).STD(nrem_before(n).borders(i,1):nrem_before(n).borders(i,2)) == 'n'));
%         nepochs_nrem_before=[nepochs_nrem_before nepochs_nrem_b];
%         
%         length_nrem_b=length(nrem_after(n).borders(i,1):nrem_after(n).borders(i,2));
%         length_nrem_after=[length_nrem_after length_nrem_b];
%         nepochs_nrem_b=length(find(STD_all(n).STD(nrem_after(n).borders(i,1):nrem_after(n).borders(i,2)) == '2' | STD_all(n).STD(nrem_after(n).borders(i,1):nrem_after(n).borders(i,2)) == 'n'));
%         nepochs_nrem_after=[nepochs_nrem_after nepochs_nrem_b];
%     end
% 
% end
% 
% % %%%% normalize SWA by nepochs within one episode %%%%%%%
% % SWA_before=SWA_before./nepochs_nrem_before;
% % SWA_after=SWA_after./nepochs_nrem_after;
% 
% h1=figure
% scatter([repelem(1,length(SWA_before)) repelem(2,length(SWA_before))],[SWA_before SWA_after])
% hold on
% 
% for i=1:length(SWA_before)
%     
%     plot([SWA_before(i),SWA_after(i)],'--o')
%     hold on
%     
% end
% 
% 
% plot([mean(SWA_before),mean(SWA_after)],'-ko','MarkerFaceColor','k')
% xlim([0.5 2.5])
% [h,p]=ttest(SWA_before,SWA_after)
% title(num2str(p))
% 
% %%% summarize nrem epochs to compare before after %%%%
% nrem_epochs_before=[length_nrem_before' nepochs_nrem_before' nepochs_nrem_before'./length_nrem_before' ];
% nrem_epochs_after=[length_nrem_after' nepochs_nrem_after' nepochs_nrem_after'./length_nrem_after'];
% 
% h2=figure
% for i=1:3
% 
%     subplot(1,3,i)
% boxplot([nrem_epochs_before(:,i) nrem_epochs_after(:,i)])
% hold on
% for ii=1:length(nrem_epochs_before)
% plot([nrem_epochs_before(ii,i) nrem_epochs_after(ii,i)],'--o')  
% end
% [h,p]=ttest(nrem_epochs_before(:,i),nrem_epochs_after(:,i))
% title(num2str(p))
% plot([mean(nrem_epochs_before(:,i)),mean(nrem_epochs_after(:,i))],'-ko','MarkerFaceColor','k')
% end
% 
% %%%%%%%%%%%%%%
% %%%%save%%%%%%
% 
% cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\SWA_rum')
% print(h1,['SWA_RUM',num2str(minlength_rum),'_NREM',num2str(minlength_nrem),'_GAP',num2str(maxgap)],'-dpng','-r500')
% print(h2,['Compare_epi',num2str(minlength_rum),'_NREM',num2str(minlength_nrem),'_GAP',num2str(maxgap)],'-dpng','-r500')
% close all
% 
% %% same with wake instead of rum
% 
% for n= 1:11
% 
%     
%      for t = 1: length(episodes(n).wakdura)
%         if length(find(STD_all(n).STD(episodes(n).wakdura(t,2):episodes(n).wakdura(t,3)) == 'e' | STD_all(n).STD(episodes(n).wakdura(t,2):episodes(n).wakdura(t,3)) == 'w')) > 224
%             rumok(t)=1;
%         else
%             rumok(t)=0;       
%         end
%      end
% 
%      for t = 1: length(episodes(n).nremdura)
%         if length(find(STD_all(n).STD(episodes(n).nremdura(t,2):episodes(n).nremdura(t,3)) == '2' | STD_all(n).STD(episodes(n).nremdura(t,2):episodes(n).nremdura(t,3)) == 'n')) > 74
%             nremok(t)=1;
%         else
%             nremok(t)=0;
%         end  
%      end
%         
%      
%   episodes2(n).wakdura=episodes(n).wakdura(find(rumok),:);
%   episodes2(n).nremdura=episodes(n).nremdura(find(nremok),:);
%   clear nremok rumok
%   
% end
% 
% 
% % find episodes where there is a NREM episode before and after with less
% % than 5min of wake inbetween
% 
% for n=1:11
%     
%         for i=1:size(episodes2(n).wakdura,1)
%             
%             en=intersect([episodes2(n).wakdura(i,2)-149:episodes2(n).wakdura(i,2)],episodes2(n).nremdura(:,3));
%             bn=intersect([episodes2(n).wakdura(i,3):episodes2(n).wakdura(i,3)+74],episodes2(n).nremdura(:,2));
%                 if isempty(en) || isempty(bn)
%                 else
%                     nrepi_before=find(episodes2(n).nremdura(:,3)==en);
%                     nrem_before(n).borders(i,:)=[episodes2(n).nremdura(nrepi_before,2),episodes2(n).nremdura(nrepi_before,3)];
%                     nrepi_after=find(episodes2(n).nremdura(:,2)==bn);
%                     nrem_after(n).borders(i,:)=[episodes2(n).nremdura(nrepi_after,2),episodes2(n).nremdura(nrepi_after,3)];
%                 end
%         end
%                      
%      
% end
%  
% 
% for n=1:length(nrem_before)
% 
%     if isempty(nrem_before(n).borders)
%     else
%         nrem_before(n).borders(find(nrem_before(n).borders(:,1) == 0),:)=[]
%         nrem_after(n).borders(find(nrem_after(n).borders(:,1) == 0),:)=[]
%     end
% 
% end
% 
% 
% SWA_before=[];
% SWA_after=[];
% 
% for n=1:length(nrem_before)
%     
%     for i=1:size(nrem_before(n).borders,1)
%         SWA_b=nanmean(SWA_normalized(n,nrem_before(n).borders(i,1):nrem_before(n).borders(i,2)));
%         SWA_before=[SWA_before SWA_b];
%         SWA_a=nanmean(SWA_normalized(n,nrem_after(n).borders(i,1):nrem_after(n).borders(i,2)));
%         SWA_after=[SWA_after SWA_a];
%     end
% 
% end
% 
% 
% for i=1:length(SWA_before)
%     
%     plot([SWA_before(i),SWA_after(i)],'--o')
%     hold on
%     
% end
% 
% plot([nanmean(SWA_before),nanmean(SWA_after)],'-ko','MarkerFaceColor','k')
% xlim([0.5 2.5])
% 
% [h,p]=ttest(SWA_before,SWA_after)
% 
