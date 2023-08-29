%% Elena Krugliakova EK 30/01/22 ********************
clc, clear all%, close all5

% path to fiedltrip
addpath ('L:\Somnus-Data\User\Melanie_Furrer\Documents\reindeer\analysis\crossfreqcoupling\fieldtrip-20210606\'); ft_defaults
addpath ('L:\Somnus-Data\User\Melanie_Furrer\Documents\reindeer\analysis\crossfreqcoupling\eeglab14_1_1b\functions\sigprocfunc');

Folder_data  = 'L:\Somnus-Data\User\Melanie_Furrer\Documents\reindeer\analysis\crossfreqcoupling\data';
Save_images  = 'L:\Somnus-Data\User\Melanie_Furrer\Documents\reindeer\analysis\crossfreqcoupling\results';

cd(Folder_data)
Filenames  = dir('EEG_*');

f1 = 0.75:0.25:4;       %  low frequency range of CFC ("freq for phase")
f2 = 4:1:40;            %  high frequency range of CFC ("freq for power")

cond = {'RUM','NREM'};
% fs = 256;


%% load data and wrap into FT format

      
    for COND = 1:2
    
    cd(Folder_data)
    if COND == 1
%       load('EEG_rumination_20s_epochs_RD6_Sep_SRBL2.mat', 'dataEpochs')
%         load('EEG_rumination_20s_epochs_4s_overlap_fs256_filter0145_RD3_July_SRBL2.mat', 'dataEpochs')
        load('EEG_RUM_20s_epochs_4s_overlap_fs128_filter0540_RD2_July_SRBL2.mat')
        dataEpochs=dataEpochs_sd15;
        fs=128;
        nepoRUM=size(dataEpochs,2);
        
    else
        %load('EEG_NREMsleep_20s_epochs_RD6_Sep_SRBL2.mat', 'dataEpochs')
%       load('EEG_NREMsleep_20s_epochs_4s_overlap_fs256_filter0145_RD3_July_SRBL2.mat', 'dataEpochs')
        load('EEG_NREMsleep_20s_epochs_4s_overlap_fs128_filter0540_RD2_July_SRBL2.mat')
        dataEpochs=dataEpochs_sd15(:,1:nepoRUM);
                fs=128;
        nepoRUM=size(dataEpochs,2);
%         nepoNREM=size(dataEpochs,2);
    end
    

% 
%         for i = 1:length(dataEpochs_perepisode) % for i = 1:length(dataEpochs_perepisode)
%           dataEpochs=cell2mat(dataEpochs_perepisode(i)); %%dataEpochs=squeeze(dataEpochs_episodes(:,:,i)) ;   % dataEpochs=cell2mat(dataEpochs_perepisode(i));
    
    % shape data to ft format ---------------------------------
    data_ft.fsample      = fs;
    data_ft.label        = {'sl_elec'};
    data_ft.time(1,1:size(dataEpochs,2)) = {0:1/fs:((size(dataEpochs,1)-1)/fs)};
    data_ft.trial        = mat2cell(dataEpochs,size(dataEpochs,1),ones(1,size(dataEpochs,2)));
    data_ft.trial        = cellfun(@transpose,data_ft.trial,'UniformOutput',false);
    data_ft.sampleinfo   = [0 size(dataEpochs,1)];
    
    % time-freq transform ---------------------------------
    cfg              = [];
    cfg.output       = 'fourier';
    cfg.method       = 'mtmconvol';
    cfg.taper        = 'hanning';
    cfg.pad          = 'nextpow2';
    cfg.toi          = 2:0.025:22; % it needs some space before and after
    
    % extract low frequncy phase information ===========
    cfg.foi          = f1;
    cfg.t_ftimwin    = 3./cfg.foi; % 3 oscillation cycles per window 
    LF_phase         = ft_freqanalysis(cfg, data_ft);
    
    % extract high frequency envelope signal ===========
    cfg.foi          = f2;
    cfg.t_ftimwin    = 4./cfg.foi; % 4 oscillation cycles per window 
    HF_power         = ft_freqanalysis(cfg, data_ft);
    clear dataEpochs
    
    % calculate actual MI ---------------------------------
    cfg = [];
    cfg.method      = 'mi';
    cfg.keeptrials  = 'no';
    cfc_orig        = ft_crossfrequencyanalysis(cfg, LF_phase,HF_power); 
    
    % calculate MI for shuffled data ---------------------------------
    for SHUFL = 1:200
        disp('shuffling number  ')
        disp(SHUFL)
        shuf_HF_power                 = HF_power;
        shuf_HF_power.fourierspctrm   = shuffle(HF_power.fourierspctrm,4); %mixing time in each trial
        
        cfg = [];
        cfg.method      = 'mi';
        cfg.keeptrials  = 'no';
        crossfreq       = ft_crossfrequencyanalysis(cfg, LF_phase,shuf_HF_power);
        ditr_shuff_MI(SHUFL,:,:,:) = crossfreq.crsspctrm;
    end
    ditr_shuff_MI_mean  = mean(ditr_shuff_MI,1); %  SHUFL chan LF HF
    ditr_shuff_MI_std   = std(ditr_shuff_MI,0,1);
    z = size(ditr_shuff_MI_mean);
    ditr_shuff_MI_mean  = reshape(ditr_shuff_MI_mean,[z(2:end) 1]);
    ditr_shuff_MI_std   = reshape(ditr_shuff_MI_std,[z(2:end) 1]);

    % normalization ---------------------------------
    crossfreqsd_Zscore.(cond{COND}) = cfc_orig;
    crossfreqsd_Zscore.(cond{COND}).crsspctrm =(cfc_orig.crsspctrm-ditr_shuff_MI_mean)./ditr_shuff_MI_std;
%     crossfreq_Zscore.(epis{i}) = cfc_orig;
%     crossfreq_Zscore.(epis{i}).crsspctrm =(cfc_orig.crsspctrm-ditr_shuff_MI_mean)./ditr_shuff_MI_std;
   
    clear ditr* cfc_* *power *phase dataEpochs data_ft data*

    
    end 
     

    %% plot modulation index SUBJECT SEPARATELY (inspection)
close all

crossfreq_1_mean = cat(3, squeeze(crossfreqsd_Zscore.NREM.crsspctrm(1,:,:)));
crossfreq_2_mean = cat(3, squeeze(crossfreqsd_Zscore.RUM.crsspctrm(1,:,:)));

crossfreq_1_mean = squeeze(mean(crossfreq_1_mean,3));
crossfreq_2_mean = squeeze(mean(crossfreq_2_mean,3));
%
% MI =crossfreq_1_mean-crossfreq_2_mean;

h1=figure('Position',[50 500 1100 500])
subplot(121)
im = imagesc(f2, f1, crossfreq_1_mean); axis xy;
  caxis([0 200]);
title('NREM sleep'); colorbar
     ylabel('Frequency for phase (Hz)');
     xlabel('Frequency for power (Hz)');

subplot(122)
im = imagesc(f2, f1, crossfreq_2_mean); axis xy;
  caxis([0 300]);
title('rumination'); colorbar
     ylabel('Frequency for phase (Hz)');
     xlabel('Frequency for power (Hz)');

     
h2=figure('Position',[50 500 1100 500])
subplot(121)
im = imagesc(f2, f1, crossfreq_1_mean); axis xy;
  caxis([0 200]);
  ylim([0.625 1.125]);
title('NREM sleep'); colorbar
     ylabel('Frequency for phase (Hz)');
     xlabel('Frequency for power (Hz)');
     yticks([0.75 1])
subplot(122)
im = imagesc(f2, f1, crossfreq_2_mean); axis xy;
  caxis([0 50]);
  ylim([0.625 1.125]);
title('rumination'); colorbar
     ylabel('Frequency for phase (Hz)');
     xlabel('Frequency for power (Hz)');
     yticks([0.75 1]);
     
 %% only rum
 
close all

crossfreq_2_mean = cat(3, squeeze(crossfreqsd_Zscore.RUM.crsspctrm(1,:,:)));

crossfreq_2_mean = squeeze(mean(crossfreq_2_mean,3));
%
% MI =crossfreq_1_mean-crossfreq_2_mean;

h1=figure('Position',[50 500 1100 500])

subplot(121)
im = imagesc(f2, f1, crossfreq_2_mean); axis xy;
  caxis([0 900]);
title('rumination'); colorbar
     ylabel('Frequency for phase (Hz)');
     xlabel('Frequency for power (Hz)');

subplot(122)
im = imagesc(f2, f1, crossfreq_2_mean); axis xy;
  caxis([0 70]);
  ylim([0.625 1.125]);
title('rumination'); colorbar
     ylabel('Frequency for phase (Hz)');
     xlabel('Frequency for power (Hz)');
     yticks([0.75 1]);