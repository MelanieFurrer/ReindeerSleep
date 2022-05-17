%% adapt!! %%
clear all; close all;

reindeer='RD-3';
season='July';
condition='SR_BL2';
cutbeg_h=14;        %starttime (hour) e.g. 8 for 8:00
duration_h=43;      %duration in hours

path='D:\Work\reindeer\Analyse_mainexperiment\Data\';
datapath=[path,'matfiles\',season,'\',reindeer,'\',condition,'\'];
savepath=[path,'Mat_power_artcorr_scored_cut\',condition];

%% load .STD and artndxn files

cd(savepath)
load([reindeer,'_',season,'_',condition,'_power_filt_STD_art_aligned.mat'])

%% load EEG

cd(datapath)
filenames=dir('*_256Hz.mat');

%%%define parameters for cutting data%%%%
hours=str2double(filenames(1).name(12:13));
minutes=str2double(filenames(1).name(15:16));
seconds=str2double(filenames(1).name(18:19));

duration=duration_h*15*60;
cutend=round(duration-((hours-cutbeg_h)*3600+minutes*60+seconds)/4);
cutbeg=cutend-duration;


%%%load EEG%%%%
nfiles=length(filenames)

for i=1:nfiles

filename=filenames(i).name;
load(filename);

%%%cut data at the end (for 4s epochs)%%%
    EpochNo=(floor(length(datr.data)/fs/4));
    NrSamples=EpochNo*fs*4;

%%%data EEG-channels%%%
        for ch=1:datr.nbchan-2      
            dataEEG(i).EEG(ch,:)=datr.data(ch,1:NrSamples);
        end
 
%%%data EEG-bipolar%%%
    dataEEG(i).BP=datr.data(1,1:NrSamples)-datr.data(2,1:NrSamples); 
 
%%%data EMG-channels%%%
    dataEEG(i).EMG=[datr.data(datr.nbchan-1,1:NrSamples);datr.data(datr.nbchan,1:NrSamples)];
    %dataEEG(i).EMGBP=(datr.data(datr.nbchan-1,1:NrSamples)-datr.data(datr.nbchan,1:NrSamples));
    %dataEEG(i).EMGBPf=eegfilt(dataEEG(i).EMGBP,128,20,40);
    
    
end


%% put together all EEG 

EEG_all=horzcat(dataEEG.EEG);
EEG_dcut=EEG_all(:,cutbeg*4*fs+1:cutend*4*fs);

BP_all=horzcat(dataEEG.BP);
BP_dcut=BP_all(:,cutbeg*4*fs+1:cutend*4*fs);

EMG_all=horzcat(dataEEG.EMG);
EMG_dcut=EMG_all(:,cutbeg*4*fs+1:cutend*4*fs);


%% save 1x mat with power, artndxn, STD and 1x filtered/cut... EEG with power, artndxn

cd([savepath,'\alternative_filter_fs'])

save([reindeer,'_',season,'_',condition,'_dataEEG_filt0145_fs256_STD_art_aligned.mat'],'*_cut','*_dcut','*_rum','*plot','fs');
