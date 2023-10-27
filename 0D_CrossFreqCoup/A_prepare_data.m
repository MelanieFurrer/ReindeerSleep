clear 
close all

%% adapt
path='D:\Work\reindeer\Analyse_mainexperiment\Data\';
datapath=[path,'Mat_power_artcorr_scored_cut\SR_BL2\alternative_filter_fs'];
savepath='C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\excel_overview_data\data_crossfequcoupling\first tries';
savename='EEG_NREMsleep_20s_epochs_4s_overlap_fs256_filter0145_RD3_July_SRBL2.mat'

locutoff=0.1;
hicutoff=45;

state=4; % 4 for rumination, 2 for nonrem-sleep

epochl=20; % epochlength

n=1; % reindeer/season

datatype=1; % 1 for one channel, 2 for bipolar

overlap=2; % e.g. 2 for 2sec overlap on both sides (total length = epochl+4)

%%

cd(datapath)
filenames=dir('*dataEEG*.mat');
filename=filenames(n).name;
load(filename);

if datatype==1
    data=EEG_dcut'; % data: BP_dcut (biploar) or EEG_dcut (one channel)
elseif datatype==2
    data=BP_dcut'; % data: BP_dcut (biploar) or EEG_dcut (one channel)
else
end

datar=double(data(:,1));



%%%%scoring and artefact information
if state==4
    artndxn=artndxn_rum(1:end-1);
elseif state == 2
    artndxn=artndxn_cut(1:end-1);
else
end

goodepochs = find(artndxn); % "artefact free" rumination, artefact-free NREM sleep
% goodepochs = find(vissymb_cut=='t' | vissymb_cut=='4'); %all rumination, all nrem sleep

fep= epochl/4;
dataEpochs=NaN((epochl+overlap*2)*fs,floor(length(goodepochs)/fep));
borders=zeros(1,floor(length(goodepochs)/fep));

for i=1:length(goodepochs)/fep
    
    
    if goodepochs(i*fep)==goodepochs(i*fep-4)+4 %
        
            nep=goodepochs(i*fep);
            starts(i)=(nep-fep)*4*fs+1-overlap*fs;
            ends(i)=nep*4*fs+overlap*fs;
            dataEpochs(:,i)=datar(starts(i):ends(i));    
            
            if goodepochs(i*fep)==goodepochs(i*fep+1)-1 %
            else
                borders(i)=goodepochs(i*fep);
            end
        
    elseif i~=1
        borders(i-1)=goodepochs(i*fep);
    end
    
end
  
  borders(find(isnan(dataEpochs(1,:))))=[];
  dataEpochs(:,find(isnan(dataEpochs(1,:))))=[];
  episodeends(1,:)=find(borders);
  episodeends(2,:)=borders(find(borders));
 
  
  
if state==4
    
     % divide data into rum-episodes
     i=1;
     dataEpochs_perepisode{i,:,:} = dataEpochs(:,1:episodeends(1,i))

     for i = 2:length(episodeends);

        dataEpochs_perepisode{i,:,:} = dataEpochs(:,episodeends(1,i-1)+1:episodeends(1,i));

     end

    % divide longest 3 episodes into 2min-bits %
%      dEpochs_episode1 = cell2mat(dataEpochs_perepisode(1));
%      dEpochs_episode1 = dEpochs_episode1(:,1:102);
%      dataEpochs_episode1_per2min = reshape(dEpochs_episode1,6144,6,17);
% 
%      dEpochs_episode3 = cell2mat(dataEpochs_perepisode(3));
%      dEpochs_episode3 = dEpochs_episode3(:,1:66);
%      dataEpochs_episode3_per2min = reshape(dEpochs_episode3,6144,6,11);
% 
%      dEpochs_episode2 = cell2mat(dataEpochs_perepisode(12));
%      dEpochs_episode2 = dEpochs_episode2(:,1:84);
%      dataEpochs_episode2_per2min = reshape(dEpochs_episode2,6144,6,14);
else
end
  
   cd(savepath)
  save(savename,'dataEpochs*','episodeends','fs','locutoff','hicutoff','epochl')
  
 clear
 
 