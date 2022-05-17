%% adapt!! %%
clear all; close all;

reindeer='RD-2';
season='December';
condition='SR_BL2';
cutbeg_h=14;        %starttime (hour) e.g. 8 for 8:00
duration_h=43;      %duration in hours

path='D:\Work\reindeer\Analyse_mainexperiment\Data\';
datapath=[path,'matfiles\',season,'\',reindeer,'\',condition,'\'];
vispath=[path,'visfiles\',season,'\',reindeer,'\',condition,'\'];
savepath=[path,'Mat_power_artcorr_scored_cut\',condition];


%% load EEG

cd(datapath)
filenames=dir('*.mat');

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
fs=128;

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

%% load visfiles (.STD)

cd(vispath)

visnames=dir('*.STD');
nfiles=length(visnames);


for i=1:nfiles
    [vistrack,visfiles(i).vissymb,status]= rdf_AOski_ReadScore(visnames(i).name);   
end    
vissymb=horzcat(visfiles.vissymb);


%% spectral analysis EEG

%%%%spectral analysis, 4s mean, all EEG-channels, all files 

for i=1:nfiles
data=dataEEG(i).EEG';
nch=size(data,2);
newnewsamp=size(data,1);
numepo=floor(newnewsamp/fs/4);
numepo4s=numepo*5;
restsamp=newnewsamp-numepo*4*fs;


ffttot=zeros(nch,161,numepo);  

     for ch=1:datr.nbchan-2
         
     datax=data(:,ch);    
     fft=zeros(161,1);
       
     for ep=1:numepo
        
           
                start=(ep-1)*4*fs+1;
                ending=ep*4*fs;
                ffte=pwelch(datax(start:ending),hanning(4*fs),0,4*fs,fs);
                fft=ffte(1:161);
            
            
            ffttot(ch,:,ep)=fft;
        end
        
     end
    
powerEEG(i).ffttot=ffttot;

end

%%%%spectral analysis, bipolar referencing


for i=1:nfiles
    
data=dataEEG(i).BP';
newnewsamp=size(data,1);
numepo=floor(newnewsamp/fs/4);
numepo4s=numepo*5;
restsamp=newnewsamp-numepo*4*fs;


ffttot_BP=zeros(1,161,numepo);  

         
     datax=data;    
     fft=zeros(161,1);
       
     for ep=1:numepo
        
                start=(ep-1)*4*fs+1;
                ending=ep*4*fs;
                ffte=pwelch(datax(start:ending),hanning(4*fs),0,4*fs,fs);
                fft=ffte(1:161);
   
            ffttot_BP(1,:,ep)=fft;

     end
    
powerBP(i).ffttot=ffttot_BP;

end

%% artefact rejection


for f=1:nfiles
  
    Index_s=find(char(visfiles(f).vissymb)=='n')';
    maxep=length(char(visfiles(f).vissymb));
    VisNum=numvisRD4s(char(visfiles(f).vissymb),0);
    
    filestr=num2str(f);
    fft1=squeeze(powerEEG(f).ffttot(1,:,:));
    fft2=squeeze(powerEEG(f).ffttot(2,:,:)); 
    [Index1,Aborted,Upper1,Factor1,NBins1]=exclude(0.75,4.5,fft1,Index_s,12,15,maxep,VisNum,'SWA_ch1',0);   %0:plot/prompting, 2:nothing
    [Index2,Aborted,Upper2,Factor2,NBins2]=exclude(20,30,fft1,Index_s,5,25,maxep,VisNum,'Muscle_ch1',0);
    [Index3,Aborted,Upper3,Factor3,NBins3]=exclude(0.75,4.5,fft2,Index_s,12,15,maxep,VisNum,'SWA_ch1',0);   %0:plot/prompting, 2:nothing
    [Index4,Aborted,Upper4,Factor4,NBins4]=exclude(20,30,fft2,Index_s,5,25,maxep,VisNum,'Muscle_ch1',0);
    index=intersect(intersect(Index1,Index2),intersect(Index3,Index4));
    artefact(f).artndxn(1:size(fft1,2))=0;
    artefact(f).artndxn(index)=1;

end


%% put together all EEG and artndx and cut

artndxn_all=horzcat(artefact.artndxn);
artndxn_cut=artndxn_all(cutbeg+1:cutend);

vissymb_cut=vissymb(cutbeg+1:cutend);
vissymbplot=transformvisRD4s(vissymb_cut);    

EEG_all=horzcat(dataEEG.EEG);
EEG_dcut=EEG_all(:,cutbeg*4*128+1:cutend*4*128);

BP_all=horzcat(dataEEG.BP);
BP_dcut=BP_all(:,cutbeg*4*128+1:cutend*4*128);

EMG_all=horzcat(dataEEG.EMG);
EMG_dcut=EMG_all(:,cutbeg*4*128+1:cutend*4*128);

% EMGBP_all=horzcat(dataEEG.EMGBP);
% EMGBP_dcut=EMGBP_all(:,cutbeg*4*128+1:cutend*4*128);
% 
% EMGBPf_all=horzcat(dataEEG.EMGBPf);
% EMGBPf_dcut=EMGBPf_all(:,cutbeg*4*128+1:cutend*4*128);

powerEEG_all=cat(3,powerEEG.ffttot);
powerEEG_pcut=powerEEG_all(:,:,cutbeg+1:cutend);

powerBP_all=cat(3,powerBP.ffttot);
powerBP_pcut=powerBP_all(:,:,cutbeg+1:cutend);


%% save 1x mat with power, artndxn, STD and 1x filtered/cut... EEG with power, artndxn

cd(savepath)

save([reindeer,'_',season,'_',condition,'_dataEEG_filt_STD_art_aligned.mat'],'*_cut','*_dcut','*plot','fs');
save([reindeer,'_',season,'_',condition,'_power_filt_STD_art_aligned.mat'],'*_cut','*_pcut','*plot','fs');
