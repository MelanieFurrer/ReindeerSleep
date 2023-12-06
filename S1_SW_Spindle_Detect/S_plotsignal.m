%% rumination


clear 
close all

% data for cross-freq coupling %
path_cfc = ('D:\Work\reindeer\Analyse_mainexperiment\Data\crossfequcoupling')
%data_cfc = ('EEG_rumination_20s_epochs_4s_overlap_fs256_filter0145_Bipolar_RD3_July_SRBL2.mat')
 data_cfc = ('EEG_RUM_20s_epochs_4s_overlap_fs128_filter0540_RD3_July_SRBL2.mat');

 cd(path_cfc)
load(data_cfc)
clear dataEpochs_sd*
data_all = reshape(dataEpochs(257:2816,:),1,[]);


% results spindle detection %

cd('D:\Work\reindeer\Analyse_mainexperiment\Data\spindle_detection\RD3_July_ch1_fs256')
% load('RD-3_July_SR_BL2_dataEEG_spindledata_thresh_frq12_15_nrem')
load('RD-3_July_SR_BL2_dataEEG_spindledata_thresh_frq12_15_rum.mat')


% plot data with many spindles
spindlesample=repelem(-500,1,length(spa));
spindlesample(spindle_t5.spistart)=500;
spindlesample(spindle_t5.spiend)=500;

data_all=resample(data_all,2,1);
fs=256;

ep=340
    
  h1=figure

    plot(data_all(fs*20+1+(ep-1)*fs*20:fs*20+1+ep*fs*20))
hold on

    plot(spa((ep-1)*fs*20:ep*fs*20)-150)   % (76*fs*20+1:77*fs*20)
hold on
   plot(spindlesample((ep-1)*fs*20:ep*fs*20))
    ylim([-250 150])
    xlim([3072 5120])
    xticks([3072:1024:5120])
    xticklabels({'0','4','8'})
    
    
% add SW-filtered signal
cd('D:\Work\reindeer\Analyse_mainexperiment\Data\swdetect')
load('RD-3_July_SR_BL2_dataEEG_filt0145_fs256_STD_art_aligned_filtered_05_4Hz.mat')

goodepochs4 = find(artndxn_rum); %artefact free nrem sleep

spindlesample=repelem(NaN,1,length(spa));


for i=1:length(spindle_t5.spistart)-1
    spindlesample(spindle_t5.spistart(i):spindle_t5.spiend(i))=-150;
    spindlesample(spindle_t5.spistart(i))=-200;
    spindlesample(spindle_t5.spistart(i)+1)=-100;
    spindlesample(spindle_t5.spiend(i))=-100;
    spindlesample(spindle_t5.spiend(i)-1)=-200;
end


data_swfilt=[];
for i=1:length(goodepochs4)/5
    
    if goodepochs4(i*5)==goodepochs4(i*5-4)+4 %
        
            nep=goodepochs4(i*5);
            starts(i)=(nep-5)*4*fs+1;
            ends(i)=nep*4*fs;
            dsw = EEG.data(1,starts(i):ends(i));   
            data_swfilt=[data_swfilt dsw];
    else
    end
    
end

swsample=repelem(NaN,1,length(EEG.data));

for i=1:length(sw_result_rum.waves(1).wvstart)-1
    swsample(sw_result_rum.waves(1).wvstart(i):sw_result_rum.waves(1).wvend(i))=-300;
    swsample(sw_result_rum.waves(1).wvstart(i))=-350;
    swsample(double(sw_result_rum.waves(1).wvstart(i))-1)=-250;
    swsample(sw_result_rum.waves(1).wvend(i))=-250;
    swsample(double(sw_result_rum.waves(1).wvend(i))+1)=-350;
end

dc=[];
for i= 1:length(starts)
    d=starts(i):ends(i);
    dc=[dc d];
end
swsample(setdiff(1:end,dc)) = [];
  
  
ep=340

close all

h1=figure
    plot(data_all(fs*20+1+(ep-1)*fs*20:fs*20+1+ep*fs*20),'color',[.1 .1 .1])
hold on
   plot(spindlesample((ep-1)*fs*20:ep*fs*20),'color',[.7 .7 .7],'linewidth',2)
hold on
    plot(spa((ep-1)*fs*20:ep*fs*20)-150,'color',[0 0 0])   % (76*fs*20+1:77*fs*20)
hold on
    plot(swsample(fs*20+1+(ep-1)*fs*20:fs*20+1+ep*fs*20),'color',[.7 .7 .7],'linewidth',2)
hold on
    plot(data_swfilt(fs*20+1+(ep-1)*fs*20:fs*20+1+ep*fs*20)-300,'color',[0 0 0],'linewidth',1)

    
    ylim([-400 150])
    yticks([-350 -300 -250 -200 -150 -100 -50 0 50])
    yticklabels({'-50','0','50','-50','0','50','-50','0','50'})
    xlim([3072 5120])
    xticks([3072:256:5120])
    xticklabels({'0','1','2','3','4','5','6','7','8'})
    title('Rumination')
    xlabel('time (sec)')
    grid on
    
    
    %% nrem sleep
    
    
 clear 
close all

% data for cross-freq coupling %
path_cfc = ('D:\Work\reindeer\Analyse_mainexperiment\Data\crossfequcoupling\NREM')
%data_cfc = ('EEG_rumination_20s_epochs_4s_overlap_fs256_filter0145_Bipolar_RD3_July_SRBL2.mat')
 data_cfc = ('EEG_NREMsleep_20s_epochs_4s_overlap_fs128_filter0540_RD3_July_SRBL2.mat');

 
 cd(path_cfc)
load(data_cfc)
clear dataEpochs_sd*
data_all = reshape(dataEpochs(257:2816,:),1,[]);


% results spindle detection %

cd('D:\Work\reindeer\Analyse_mainexperiment\Data\spindle_detection\RD3_July_ch1_fs256')
% load('RD-3_July_SR_BL2_dataEEG_spindledata_thresh_frq12_15_nrem')
load('RD-3_July_SR_BL2_dataEEG_spindledata_thresh_frq12_15_nrem.mat')


% plot data with many spindles

spindlesample=repelem(-500,1,length(spa));
spindlesample(spindle_t5.spistart)=500;
spindlesample(spindle_t5.spiend)=500;

data_all=resample(data_all,2,1);
fs=256;

ep=340
    
  h1=figure
    plot(data_all(fs*20+1+(ep-1)*fs*20:fs*20+1+ep*fs*20))
hold on
    plot(spa((ep-1)*fs*20:ep*fs*20)-150)   % (76*fs*20+1:77*fs*20)
hold on
   plot(spindlesample((ep-1)*fs*20:ep*fs*20))
    ylim([-250 150])
    xlim([3072 5120])
    xticks([3072:1024:5120])
    xticklabels({'0','4','8'})
    
    
% add SW-filtered signal
cd('D:\Work\reindeer\Analyse_mainexperiment\Data\swdetect')
load('RD-3_July_SR_BL2_dataEEG_filt0145_fs256_STD_art_aligned_filtered_05_4Hz.mat')

goodepochs = find(artndxn_cut(1:end)); %artefact free nrem sleep

spindlesample=repelem(NaN,1,length(spa));


for i=1:length(spindle_t5.spistart)-1
    spindlesample(spindle_t5.spistart(i):spindle_t5.spiend(i))=-150;
    spindlesample(spindle_t5.spistart(i))=-200;
    spindlesample(spindle_t5.spistart(i)+1)=-100;
    spindlesample(spindle_t5.spiend(i))=-100;
    spindlesample(spindle_t5.spiend(i)-1)=-200;
end

data_swfilt=[];
dc=[];
for i=1:length(goodepochs)/5
    
    if goodepochs(i*5)==goodepochs(i*5-4)+4 %
        
            nep=goodepochs(i*5);
            starts(i)=(nep-5)*4*fs+1;
            ends(i)=nep*4*fs;
            dsw = EEG.data(1,starts(i):ends(i));   
            data_swfilt=[data_swfilt dsw];
            
            d=starts(i):ends(i);
            dc=[dc d];

    else
    end
    
end


swsample=repelem(NaN,1,length(EEG.data));

for i=1:length(sw_result.waves(1).wvstart)-1
    swsample(sw_result.waves(1).wvstart(i):sw_result.waves(1).wvend(i))=-300;
    swsample(sw_result.waves(1).wvstart(i))=-350;
    swsample(double(sw_result.waves(1).wvstart(i))-1)=-250;
    swsample(sw_result.waves(1).wvend(i))=-250;
    swsample(double(sw_result.waves(1).wvend(i))+1)=-350;  %% for high numbers it doesn't compute +1....
end

swsample(setdiff(1:end,dc)) = [];
  

 ep=745


close all

h1=figure
    plot(data_all(fs*20+1+(ep-1)*fs*20:fs*20+1+ep*fs*20),'color',[.1 .1 .1])
hold on
   plot(spindlesample((ep-1)*fs*20:ep*fs*20),'color',[.7 .7 .7],'linewidth',2)
hold on
    plot(spa((ep-1)*fs*20:ep*fs*20)-150,'color',[0 0 0])   % (76*fs*20+1:77*fs*20)
hold on
    plot(swsample(fs*20+1+(ep-1)*fs*20:fs*20+1+ep*fs*20),'color',[.7 .7 .7],'linewidth',2)
hold on
    plot(data_swfilt(fs*20+1+(ep-1)*fs*20:fs*20+1+ep*fs*20)-300,'color',[0 0 0],'linewidth',1)
   
    ylim([-400 150])
    yticks([-350 -300 -250 -200 -150 -100 -50 0 50])
    yticklabels({'-50','0','50','-50','0','50','-50','0','50'})
    xlim([2048 4096])
    xticks([2048:256:4096])
    xticklabels({'0','1','2','3','4','5','6','7','8'})
%     title('NREM sleep')
    xlabel('time (sec)')
    grid on
       
    
    
    
    
    