
clear; close all;

path='D:\Work\reindeer\Analyse_mainexperiment\Data\';
datapath=[path,'Mat_power_artcorr_scored_cut\SR_BL2'];

cd(datapath)
filenames=dir('*power*.mat');


nfiles=length(filenames)

for i=1
    
    filename=filenames(i).name;
    load(filename);
    clear artndxn_rum
  
    Index_s=find(vissymb_cut=='t' | vissymb_cut=='4')';
    maxep=length(vissymb_cut);
    VisNum=numvisRDvissymb(vissymb_cut);
    
    filestr=1;
    fft1=squeeze(powerEEG_pcut(1,:,:));
    fft2=squeeze(powerEEG_pcut(2,:,:)); 
    [Index1,Aborted,Upper1,Factor1,NBins1]=exclude(0.75,4.5,fft1,Index_s,12,15,maxep,VisNum,'SWA_ch1',0);   %0:plot/prompting, 2:nothing
    [Index2,Aborted,Upper2,Factor2,NBins2]=exclude(20,30,fft1,Index_s,5,25,maxep,VisNum,'Muscle_ch1',0);
    [Index3,Aborted,Upper3,Factor3,NBins3]=exclude(0.75,4.5,fft2,Index_s,12,15,maxep,VisNum,'SWA_ch1',0);   %0:plot/prompting, 2:nothing
    [Index4,Aborted,Upper4,Factor4,NBins4]=exclude(20,30,fft2,Index_s,5,25,maxep,VisNum,'Muscle_ch1',0);
    index=intersect(intersect(Index1,Index2),intersect(Index3,Index4));
    artndxn_rum(1:size(fft1,2))=0;
    artndxn_rum(index)=1;

    save(filename,'artndxn_rum','-append')
    clear artndxn_rum
end



