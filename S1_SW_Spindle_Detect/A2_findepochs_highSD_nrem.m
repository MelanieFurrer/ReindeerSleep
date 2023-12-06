clear 
close all

% dataEpochs_sd15_all=[];

for n = 1:11
    
    fs=128;
% data for cross-freq coupling %
path_cfc = ('D:\Work\reindeer\Analyse_mainexperiment\Data\crossfequcoupling')
%data_cfc = ('EEG_rumination_20s_epochs_4s_overlap_fs256_filter0145_Bipolar_RD3_July_SRBL2.mat')

% results spindle detection %
cd('D:\Work\reindeer\Analyse_mainexperiment\Data\spindle_detection\bipolar_nrem')

        filenames=dir('*_nrem.mat');
        filename=filenames(n).name;
        load(filename);
        spindle_density=nan(1,38700);
        
        for ii=1:length(goodepochs)

            if ii==1
                spindle_density(goodepochs(ii))=sum(ismember(spindle_t5.spistart+4*fs,1:ii*fs*4));
            else    
                spindle_density(goodepochs(ii))=sum(ismember(spindle_t5.spistart+4*fs,(ii-1)*fs*4+1:ii*fs*4));
            end
    
        end
        
        spindles_all=spindle_density;
        

% artndxn %
cd('D:\Work\reindeer\Analyse_mainexperiment\Data\Mat_power_artcorr_scored_cut\SR_BL2');
filenames=dir('*power*.mat');
filename=filenames(n).name;
load(filename);


goodepochs = find(artndxn_cut);
epochl = 20;

fep= epochl/4;
spindle_density_20secepochs=NaN(1,floor(length(goodepochs)/fep));

for i=1:length(goodepochs)/fep
    
    
    if goodepochs(i*fep)==goodepochs(i*fep-4)+4 %
        
            nep=goodepochs(i*fep);
            starts(i)=(nep-fep)+1;
            ends(i)=nep;
            spindle_density_20secepochs(:,i)=sum(spindles_all(starts(i):ends(i)))*3;              
    end
    
end
  

  spindle_density_20secepochs(:,find(isnan(spindle_density_20secepochs(1,:))))=[];

% epochs_sd6=find(spindle_density_20secepochs>5);
epochs_sd9=find(spindle_density_20secepochs>8);
epochs_sd12=find(spindle_density_20secepochs>11);
epochs_sd15=find(spindle_density_20secepochs>14);

%data cross-frequency coupling
cd('D:\Work\reindeer\Analyse_mainexperiment\Data\crossfequcoupling\NREM')
filenames=dir('*NREMsleep*.mat');
data_cfc=filenames(n).name;
load(data_cfc);
 clear dataEpochs_sd*

% dataEpochs_sd6=dataEpochs(:,epochs_sd6);
dataEpochs_sd9=dataEpochs(:,epochs_sd9);
dataEpochs_sd12=dataEpochs(:,epochs_sd12);
dataEpochs_sd15=dataEpochs(:,epochs_sd15);


 save(data_cfc,'dataEpochs*','episodeends','epochl','fs','hicutoff','locutoff')

% dataEpochs_sd12_all = [dataEpochs_sd12_all dataEpochs_sd12];
% dataEpochs_sd15_all = [dataEpochs_sd15_all dataEpochs_sd15];

clearvars -except dataEpochs_sd*_all

end

% save('EEG_RUM_20s_epochs_4s_overlap_fs128_filter0540_all_SRBL2','dataEpochs_sd15_all')