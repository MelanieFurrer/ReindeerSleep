clear
close all

Folderpath='D:\Work\big-data\Data01\reindeer\data\EEG\Juni\RD-3';

cd(Folderpath)
[file_name] = uigetfile('*.edf', 'Select the .edf file');


% dataFormat='int16';
locutoff=0.1;
hicutoff=45;
fs=256;
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
% EEG.srate=500.64;  %% use the one from previous file in case file is
% shorter than 12h

% filter and downsample
datf=pop_eegfilt(EEG,0,hicutoff);
datf2=pop_eegfilt(datf,locutoff,0);
datr=pop_resample(datf2,fs);


% save matfile with filtered and downsampled data

save([filename(1:end-4),'_0145_256Hz.mat'],'datr','hicutoff','locutoff','fs');


