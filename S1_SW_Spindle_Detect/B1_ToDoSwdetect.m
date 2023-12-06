
clear
close all

Folderpath='D:\Work\reindeer\Analyse_mainexperiment\Data\swdetect\fs128';

cd(Folderpath)
file_names=dir('*1_5Hz.mat');


for s=1:length(file_names) 

load(file_names(s,1).name)

sw_result_rum = swdetect(EEG,'artndxn',artndxn_rum,'epoch_len', 4,'thresh_freq', [0.5, 1.5])

amp(s,1)=mean(sw_result.waves(1). maxnegpkamp);
amp(s,2)=mean(sw_result.waves(2). maxnegpkamp);
amp(s,3)=mean(sw_result.waves(3). maxnegpkamp);
amp_sd(s,1)=std(sw_result.waves(1). maxnegpkamp);
amp_sd(s,2)=std(sw_result.waves(2). maxnegpkamp);
amp_sd(s,3)=std(sw_result.waves(3). maxnegpkamp);

freq(s,1)=mean(sw_result.waves(1).freq);
freq(s,2)=mean(sw_result.waves(2).freq);
freq(s,3)=mean(sw_result.waves(3).freq);
freq_sd(s,1)=std(sw_result.waves(1).freq);
freq_sd(s,2)=std(sw_result.waves(2).freq);
freq_sd(s,3)=std(sw_result.waves(3).freq);


numwaves(s,1)=length(sw_result.waves(1).freq)/length((intersect(sw_result.params.artNdxGood,sw_result.params.artNdxGood)))*3;
numwaves(s,2)=length(sw_result.waves(2).freq)/length((intersect(sw_result.params.artNdxGood,sw_result.params.artNdxGood)))*3;
numwaves(s,3)=length(sw_result.waves(3).freq)/length((intersect(sw_result.params.artNdxGood,sw_result.params.artNdxGood)))*3;

save(file_names(s,1).name,'sw_result_rum','-append')

end

close all