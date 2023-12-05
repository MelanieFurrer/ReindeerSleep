clear 
close all

path='D:\Work\reindeer\Analyse_mainexperiment\Data\';
datapath=[path,'Mat_power_artcorr_scored_cut\SR_BL2'];
savepath='D:\Work\reindeer\Analyse_mainexperiment\Data\swdetect';

cd(datapath)
filenames=dir('*dataEEG*.mat');


for s=1:length(filenames) 

%%%% load data (EEG, artndxn and STD)

load(filenames(s,1).name)


%%% filter
locutoff=0.5;
hicutoff=4;

data=vertcat(EEG_dcut,BP_dcut);

    nch=size(data,1);


        dataf=eegfilt(data,fs,0,hicutoff);
        dataf2=eegfilt(dataf,fs,locutoff,0);
        data=dataf2;


    EEG.data=data;
    EEG.srate=fs;
    EEG.pnts=length(data);
    EEG.chanlocs=[];

cd(savepath)
save([num2str(filenames(s,1).name(1:end-4)),'_filtered_05_4Hz'],'EEG',...
    'artndxn_cut','artndxn_rum','fs','vissymb_cut')

clearvars -except *path savepath filenames
cd(datapath)

end