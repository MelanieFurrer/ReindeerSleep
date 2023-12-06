clear 
close all

% dataEpochs_sd15_all=[];

for n = 2
    
% data for cross-freq coupling %
path_cfc = ('D:\Work\reindeer\Analyse_mainexperiment\Data\crossfequcoupling')
%data_cfc = ('EEG_rumination_20s_epochs_4s_overlap_fs256_filter0145_Bipolar_RD3_July_SRBL2.mat')



% results spindle detection %
cd('D:\Work\reindeer\Analyse_mainexperiment\Data\matfiles_swa_std_processS')
load('SWA_STD_episodes_all_rumwn.mat')

% artndxn %
cd('D:\Work\reindeer\Analyse_mainexperiment\Data\Mat_power_artcorr_scored_cut\SR_BL2');
filenames=dir('*power*.mat');
filename=filenames(n).name;
load(filename);

% cut out SR_BL2
spindles_all=spindles_all(:,43201:end);

goodepochs = find(artndxn_rum);
epochl = 20;

fep= epochl/4;
spindle_density_20secepochs=NaN(1,floor(length(goodepochs)/fep));

for i=1:length(goodepochs)/fep
    
    
    if goodepochs(i*fep)==goodepochs(i*fep-4)+4 %
        
            nep=goodepochs(i*fep);
            starts(i)=(nep-fep)+1;
            ends(i)=nep;
            spindle_density_20secepochs(:,i)=sum(spindles_all(n,starts(i):ends(i)))*3;              
    end
    
end
  

  spindle_density_20secepochs(:,find(isnan(spindle_density_20secepochs(1,:))))=[];

epochs_sd6=find(spindle_density_20secepochs>5);
epochs_sd9=find(spindle_density_20secepochs>8);
epochs_sd12=find(spindle_density_20secepochs>11);
epochs_sd15=find(spindle_density_20secepochs>14);

%data cross-frequency coupling
cd(path_cfc)
filenames=dir('*RUM*.mat');
data_cfc=filenames(n).name;
load(data_cfc);
% clear dataEpochs_sd*

dataEpochs_sd6=dataEpochs(:,epochs_sd6);
dataEpochs_sd9=dataEpochs(:,epochs_sd9);
dataEpochs_sd12=dataEpochs(:,epochs_sd12);
dataEpochs_sd15=dataEpochs(:,epochs_sd15);


% save(data_cfc,'dataEpochs*','episodeends','epochl','fs','hicutoff','locutoff')

% dataEpochs_sd12_all = [dataEpochs_sd12_all dataEpochs_sd12];
% dataEpochs_sd15_all = [dataEpochs_sd15_all dataEpochs_sd15];

% clearvars -except dataEpochs_sd*_all

end

% save('EEG_RUM_20s_epochs_4s_overlap_fs128_filter0540_all_SRBL2','dataEpochs_sd15_all')

%  subplot(211)
%  plot(spa(spindle_t5.spistart(10)-256:spindle_t5.spiend(7)+256))
%  subplot(212)
%  plot(data_all(spindle_t5.spistart(10)+20*256-256:spindle_t5.spiend(7)+20*256+256))

%   save(data_cfc,'dataEpochs*','episodeends','fs','locutoff','hicutoff','epochl')
%   
%  clear
%  
 %% plot data with many spindles --> work in progress, doesn't work
%  
%  cd('D:\Work\reindeer\Analyse_mainexperiment\Data\spindle_detection\bipolar_rum')
%  load('RD-2_July_SR_BL2_dataEEG_spindledata_thresh_frq12_15_rum')
%  
%  plot(data_all)
%  hold on
%  plot(spa)
%  hold on
%  plot(spindlesample)
% %  h1=figure
%  
% %  subplot(211)
% %     plot(data_all(fs*20+1:end))
% % subplot(212)
% %     plot(spa)   % (76*fs*20+1:77*fs*20)
% %     hold on
% %     line(spindle_t5.spistart(find(ismember(spindle_t5.spistart+20*fs,59*fs*20+1:60*fs*20))),[-50 50])
% %     ylim([-50 50])
% 
% spindlesample=repelem(-500,1,length(spa));
% spindlesample(spindle_t5.spistart)=500;
% spindlesample(spindle_t5.spiend)=500;
% 
% ep=2
%     
%   h1=figure
%     plot(data_all((ep-1)*fs*20:ep*fs*20))
% hold on
%     plot(spa((ep-1)*fs*20:ep*fs*20)-150)   % (76*fs*20+1:77*fs*20)
% hold on
%    plot(spindlesample((ep-1)*fs*20:ep*fs*20))
%     ylim([-250 150])
%     xlim([1 1024])
%     xticks([1:512:1024])
%     xticklabels({'0','4','8'})
%     
%     
% %% add SW-filtered signal
% cd('D:\Work\reindeer\Analyse_mainexperiment\Data\swdetect')
% load('RD-3_July_SR_BL2_dataEEG_filt0145_fs256_STD_art_aligned_filtered_05_4Hz.mat')
% 
% goodepochs4 = find(artndxn_rum); %artefact free nrem sleep
% 
% spindlesample=repelem(NaN,1,length(spa));
% 
% 
% for i=1:length(spindle_t5.spistart)-1
%     spindlesample(spindle_t5.spistart(i):spindle_t5.spiend(i))=-150;
%     spindlesample(spindle_t5.spistart(i))=-200;
%     spindlesample(spindle_t5.spistart(i)+1)=-100;
%     spindlesample(spindle_t5.spiend(i))=-100;
%     spindlesample(spindle_t5.spiend(i)-1)=-200;
% end
% 
% 
% data_swfilt=[];
% for i=1:length(goodepochs4)/5
%     
%     if goodepochs4(i*5)==goodepochs4(i*5-4)+4 %
%         
%             nep=goodepochs4(i*5);
%             starts(i)=(nep-5)*4*fs+1;
%             ends(i)=nep*4*fs;
%             dsw = EEG.data(1,starts(i):ends(i));   
%             data_swfilt=[data_swfilt dsw];
%     else
%     end
%     
% end
% 
% swsample=repelem(NaN,1,length(EEG.data));
% 
% for i=1:length(sw_result_rum.waves(1).wvstart)-1
%     swsample(sw_result_rum.waves(1).wvstart(i):sw_result_rum.waves(1).wvend(i))=-300;
%     swsample(sw_result_rum.waves(1).wvstart(i))=-350;
%     swsample(double(sw_result_rum.waves(1).wvstart(i))-1)=-250;
%     swsample(sw_result_rum.waves(1).wvend(i))=-250;
%     swsample(double(sw_result_rum.waves(1).wvend(i))+1)=-350;
% end
% 
% dc=[];
% for i= 1:length(starts)
%     d=starts(i):ends(i);
%     dc=[dc d];
% end
% swsample(setdiff(1:end,dc)) = [];
%   
%   
% ep=340
% 
% close all
% 
% h1=figure
%     plot(data_all(fs*20+1+(ep-1)*fs*20:fs*20+1+ep*fs*20),'color',[.1 .1 .1])
% hold on
%    plot(spindlesample((ep-1)*fs*20:ep*fs*20),'color',[.7 .7 .7],'linewidth',2)
% hold on
%     plot(spa((ep-1)*fs*20:ep*fs*20)-150,'color',[0 0 0])   % (76*fs*20+1:77*fs*20)
% hold on
%     plot(swsample(fs*20+1+(ep-1)*fs*20:fs*20+1+ep*fs*20),'color',[.7 .7 .7],'linewidth',2)
% hold on
%     plot(data_swfilt(fs*20+1+(ep-1)*fs*20:fs*20+1+ep*fs*20)-300,'color',[0 0 0],'linewidth',1)
% 
%     
%     ylim([-400 150])
%     yticks([-350 -300 -250 -200 -150 -100 -50 0 50])
%     yticklabels({'-50','0','50','-50','0','50','-50','0','50'})
%     xlim([3072 5120])
%     xticks([3072:256:5120])
%     xticklabels({'0','1','2','3','4','5','6','7','8'})
%     title('Rumination')
%     xlabel('time (sec)')
%     grid on
%     