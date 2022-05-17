clear
close all

Folderpath='D:\Work\big-data\Data01\reindeer\data\EEG\Juni\RD-2';


%%
cd(Folderpath)
[file_name] = uigetfile('*.edf', 'Select the .edf file');

visname=input('Type name of vis file as string: ');

vispath=[Folderpath,'\'];
% datapath=[Folderpath,'\'];


% dataFormat='int16';
locutoff=0.5;
hicutoff=40;
fs=128;
% fsedf=500;
    
filename=file_name

%add path
addpath('C:\Users\schlaf\Documents\MATLAB\toolboxen\biosig4octmat-3.3.0\biosig\eeglab')
addpath('C:\Users\schlaf\Documents\MATLAB\toolboxen\biosig4octmat-3.3.0\biosig\t200_FileAccess')
addpath('C:\Users\schlaf\Documents\MATLAB\toolboxen\biosig4octmat-3.3.0\biosig\t250_ArtifactPreProcessingQualityControl')
addpath('C:\Users\schlaf\Documents\MATLAB\toolboxen\eeglab13_5_4b\functions\popfunc')
addpath('C:\Users\schlaf\Documents\MATLAB\toolboxen\eeglab13_5_4b\functions\adminfunc')
addpath('C:\Users\schlaf\Documents\MATLAB\toolboxen\functions\sigprocfunc')
addpath('C:\Users\schlaf\Documents\MATLAB\toolboxen\plugins\firfilt1.6.1')

% load EDF-data
[EEG]  = pop_readedf(filename);
% [hdr, record] = edfread(filename);
EEG.srate=floor((length(EEG.data)/60/60/12)*100)/100;
%EEG.srate=500.87;  %% use the one from previous file in case file is
% shorter than 12h

% filter and downsample
datf=pop_eegfilt(EEG,0,hicutoff);
datf2=pop_eegfilt(datf,locutoff,0);
datr=pop_resample(datf2,fs);

% cut data at the end (for 4s epochs)
EpochNo=(floor(length(datr.data)/fs/4));
NrSamples=EpochNo*fs*4;

% data EEG-channels
 for ch=1:datr.nbchan-2      
     datEEG(ch,:)=datr.data(ch,1:NrSamples);
 end
 
 % data EEG-bipolar
    datBP=datr.data(1,1:NrSamples)-datr.data(2,1:NrSamples); 
 
% data EMG-channels
    datEMG=(datr.data(datr.nbchan-1,1:NrSamples)-datr.data(datr.nbchan,1:NrSamples));
    datEMGf=eegfilt(datEMG,128,20,40);

% put together
    scordat=[datEMGf;datEEG;datBP];

    
%%%%write scoring file
scorlen = size(scordat, 1);
filenamescor=[vispath,visname,'.r0',num2str(scorlen)]
fid = fopen(filenamescor,'w')
fwrite(fid,scordat,'short')
fclose(fid);

%% calculates NREM index (normalized SWA * 2*sigma power) for EEG1(SPA)

addpath 'C:\Users\schlaf\Documents\MATLAB\ascore_waleed'

EMGPerEpoch=reshape(datEMGf,fs*4,[]);
sq=EMGPerEpoch.^2;
ssq=sum(sq);
srssq=sqrt(ssq*900);
VarEMG=srssq;

PSD_Array=rdf_FastPSD(datEEG(1,:),fs,4,4);
SingleAnimalPSDandEMGVarOutput=rdf_ConvertToAOskiSpectrumPlusEMGVarOskiScaled(PSD_Array,VarEMG);

Delta=mean(SingleAnimalPSDandEMGVarOutput(3:8,:))./median(mean(SingleAnimalPSDandEMGVarOutput(3:8,:)));
Sigma=mean(SingleAnimalPSDandEMGVarOutput(17:21,:))./median(mean(SingleAnimalPSDandEMGVarOutput(17:21,:)));
Beta=mean(SingleAnimalPSDandEMGVarOutput(23:30,:))./median(mean(SingleAnimalPSDandEMGVarOutput(23:30,:)));
Delta2=mean(SingleAnimalPSDandEMGVarOutput(2:4,:))./median(mean(SingleAnimalPSDandEMGVarOutput(2:4,:)));
Beta2=mean(SingleAnimalPSDandEMGVarOutput(29:30,:))./median(mean(SingleAnimalPSDandEMGVarOutput(29:30,:)));

NREMindex=(Delta+2*Sigma)./Beta;
for i=1:30
SingleAnimalPSDandEMGVarOutput(i,:)=NREMindex;
end

%%%%write SPA file
filenamespec=[vispath,visname,'.SPA']
fid = fopen(filenamespec,'w')
fwrite(fid,SingleAnimalPSDandEMGVarOutput,'float')
fclose(fid);

%% calculates Rumindex (SPB)



Rumindex=Delta2*2+Sigma;

for i=1:30
SingleAnimalPSDandEMGVarOutput(i,:)=Rumindex;
end


%%%%write SPA file
filenamespec=[vispath,visname,'.SPB']
fid = fopen(filenamespec,'w')
fwrite(fid,SingleAnimalPSDandEMGVarOutput,'float')
fclose(fid);


%% save matfile with filtered and downsampled data

save([filename(1:end-4),'.mat'],'datr','EEG','hicutoff','locutoff','visname');

% %% calculates spectra (SPA) for EEG1
%     data_spec=[datEEG(1,:)'];
% 
%     newnewsamp=size(data_spec,1);
%     numepo4s=floor(newnewsamp/fs/4);
%     restsamp=newnewsamp-numepo4s*4*fs;
% 
%     %%%%spectral analysis, 4s
%     fftblock=zeros(30,numepo4s);
%     datax=double(data_spec);
%     for epoch=1:numepo4s
%         start=1+((epoch-1)*4*fs);
%         ending      = 4*fs+((epoch-1)*4*fs);
%         ffte        = pwelch(datax(start:ending),hanning(4*fs),0,4*fs,fs);
%         ffte=ffte(1:120);
%         fft30=mean(reshape(ffte,4,30));
%         fftblock(:,epoch)=fft30;
%     end
%     ffttot=fftblock;
% 
% 
% %%%%write SPA file
% filenamespec=[vispath,visname,'.SPA']
% fid = fopen(filenamespec,'w')
% fwrite(fid,ffttot,'float')
% fclose(fid);
% 
% 
% %% calculates spectra (vigilance index) for EEG1 (SPB)
%     % calculate modified Vigilance Index based on:
%     %   https://www.ncbi.nlm.nih.gov/pmc/articles/PMC5455770/?fbclid=IwAR22XbpTGq2LsOiQGeNwZujvLiZ_aNGvFPwn65iAClTAn5yUgtMjFYQiPbg
%     %   VI = [delta power norm + 2*spindle power norm]/[alpha power norm + high-beta power norm]
%     %   As frequency ranges  used delta (1?4 Hz),  spindle (11?16Hz), alpha (8?13 Hz) and high-beta (20?40 Hz)
% 
%     % calculate total power for all recording (for normalization) 
%     ONECHAN=[datEEG(1,:)'];
%     [ffte_tot] =  pwelch(ONECHAN(:),hanning(4*fs),0,4*fs,fs);
%     fft_de_tot     = mean(ffte_tot(3:17));  % delta
% %     fft_th_tot     = mean(ffte_tot(17:29)); % theta
%     fft_si_tot     = mean(ffte_tot(45:65));  % sigma (spindles)
%     fft_al_tot     = mean(ffte_tot(33:53));  % alpha
%     fft_be_tot     = mean(ffte_tot(81:161));  % beta-gamma
%     
%     
%     FourSecEpo = numepo4s;
%     fftblock = zeros(30, FourSecEpo);
%     for epoch = 1:FourSecEpo % calculate epoch-by-epoch
%         from     = 1+((epoch-1)*4*fs); 
%         to       = 4*fs+((epoch-1)*4*fs);
%         [ffte] =  pwelch(ONECHAN(from:to),hanning(4*fs),0,4*fs,fs);
%         fft_de     = mean(ffte(3:17));  % delta
% %         fft_th     = mean(ffte(17:29)); 
%         fft_si     = mean(ffte(45:65));   % sigma (spindles)
%         fft_al     = mean(ffte(33:53));  % alpha
%         fft_be     = mean(ffte(81:161)); % beta-gamma
%         
%         fft_VI    = (fft_de/fft_de_tot + 2*(fft_si/fft_si_tot))/...
%             (fft_al/fft_al_tot + fft_be/fft_be_tot);
%         fftblock(1:30,epoch) = fft_VI;
%     end
% 
%      % write .sp2 file
% filenamespec=[vispath,visname,'.SPB']
% fid = fopen(filenamespec,'w')
% fwrite(fid,fftblock,'float')
% fclose(fid);
% save(num2str(visname))
% 
