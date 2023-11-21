clear
close all

path='D:\Work\reindeer\Analyse_mainexperiment\Data\';
datapath0=[path,'Mat_power_artcorr_scored_cut\Adapt'];
datapath1=[path,'Mat_power_artcorr_scored_cut\BL1'];
datapath2=[path,'Mat_power_artcorr_scored_cut\SR_BL2'];
savepath='D:\Work\reindeer\Analyse_mainexperiment\Data\matfiles_swa_std_processS\11082022\';


cd(datapath2)
filenames2=dir('*power*.mat');
nfiles=length(filenames2)

for i=1:nfiles

    if i==1  
        
       %adapt (only first 12 hours there), shift data according to starttime 14h
        cd(datapath0)
        filenames0=dir('*power*.mat')
        filename=filenames0(i).name;
        load(filename);       
        powerEEG_pcut_0=powerEEG_pcut;
        artndxn_cut_0=artndxn_cut;
        artefactfreenr=find(artndxn_cut_0);
        SWA=squeeze(mean(powerEEG_pcut_0(1,5:19,artefactfreenr),2));   
        
        SWA_filled_0=nan(1,18900);
        SWA_filled_0(artefactfreenr)=SWA;
        STD_0=vissymb_cut;
        STD_0(end+1:18900)='m';
            
        % BL1 missing      
        SWA_filled_1=nan(1,24300); %27 h
        STD_1=repelem('m',24300); %27 h
        
    else
        
        cd(datapath0)
        filenames0=dir('*power*.mat')
        filename=filenames0(i).name;
        load(filename);       
        powerEEG_pcut_0=powerEEG_pcut;
        artndxn_cut_0=artndxn_cut;
        artefactfreenr=find(artndxn_cut_0);
        SWA=squeeze(mean(powerEEG_pcut_0(1,5:19,artefactfreenr),2));       
        
        %shift data according to starttime
        if i==4 || i==7 || i==9 || i==10 %starttime 14h
            SWA_filled_0=nan(1,18900);
            SWA_filled_0(artefactfreenr)=SWA;
            STD_0=vissymb_cut;
            STD_0(end+1:18900)='w';
        elseif i==2 || i==5 %starttime 15.2h
            SWA_filled_0=nan(1,18900);
            SWA_filled_0(artefactfreenr+1080)=SWA;
            STD_0=repelem('m',18900); %21 h
            STD_0(1081:length(vissymb_cut)+1080)=vissymb_cut;
            STD_0(end+1:18900)='w';
        elseif i==3 %starttime 13h
            SWA_filled_00=nan(1,19800);
            SWA_filled_00(artefactfreenr)=SWA;
            SWA_filled_0=SWA_filled_00(901:19800);
            STD_0=vissymb_cut(901:19800);
        elseif i==11 %starttime 12h (only 2 hours recording, rest missing)
            SWA_filled_00=nan(1,20700);
            SWA_filled_00(artefactfreenr)=SWA;
            SWA_filled_0=SWA_filled_00(1801:20700);
            STD_0=vissymb_cut(1801:end);
            STD_0(end+1:18900)='m';
        elseif i==6 || i==8 %starttime 14.5h
            SWA_filled_0=nan(1,18900);
            SWA_filled_0(artefactfreenr+450)=SWA;
            STD_0=repelem('m',18900); %21 h
            STD_0(451:length(vissymb_cut)+450)=vissymb_cut;
            STD_0(end+1:18900)='w';
            if i==6
            STD_0(11028:11089)='m';
            else
            end
        end
        
      % Baseline 1        
        cd(datapath1)
        filenames1=dir('*power*.mat')
        filename=filenames1(i-1).name;
        load(filename);       
        powerEEG_pcut_1=powerEEG_pcut;
        artndxn_cut_1=artndxn_cut;
        artefactfreenr=find(artndxn_cut_1);
        SWA=squeeze(mean(powerEEG_pcut_1(1,5:19,artefactfreenr),2));       
        SWA_filled_1=nan(1,24300);
        SWA_filled_1(artefactfreenr)=SWA;
        STD_1=vissymb_cut;
        STD_1(end+1:24300)='w';
    end
      % Sleep Restriction and Baseline 2     
        cd(datapath2)
        filename=filenames2(i).name;
        load(filename);
        powerEEG_pcut_2=powerEEG_pcut;
        artndxn_cut_2=artndxn_cut;
        artefactfreenr=find(artndxn_cut_2);
        SWA=squeeze(mean(powerEEG_pcut_2(1,5:19,artefactfreenr),2));       
        SWA_filled_2=nan(1,38700); %43 h
        SWA_filled_2(artefactfreenr)=SWA;
        STD_2=vissymb_cut;
        STD_2(end+1:38700)='w';
        
      % Put together and normalize with Baseline (5:00 - 5:00)
        SWA_filled_012=cat(2,SWA_filled_0,SWA_filled_1,SWA_filled_2);
        SWA_BL = SWA_filled_2(15*60*15+1:39*60*15); % SWA of baseline (5:00 - 5:00, starting 15 hours after start of 2nd recording)
        SWA_filled_normalized=SWA_filled_012/nanmean(SWA_BL);  % normalize with BL 2 (5:00 - 5:00)
        STD=horzcat(STD_0,STD_1,STD_2);

        SWA_absolute(i,:) = SWA_filled_012;
        SWA_normalized(i,:) = SWA_filled_normalized;
        STD_all(i,:)=STD;
        filenames{i}=filenames2(i).name(1:8);
        SWA_BL_abs(i,:) = SWA_BL;
        SWA_all_abs(i,:) = SWA_filled_012;
        
        clear powerEEG_pcut* artndxn_cut* artefactfreenr SWA SWA_filled* STD_0 STD_1 STD_2
        
end

% add known wake epochs to scoring(first sleep restriction RD2-Dec (ID1), feeding
% times RD-2 July (ID2) and RD-3-July (ID5)
scoring=STD_all;
scoring(1,46*60*15+1:49*60*15) = 'w'; % 12:00 - 14:00 (first sleep restriction)
scoring(2,19*60*15+151:21*60*15+75) = 'w'; % 9:10 - 11:05 (according to protocol)
scoring(5,19*60*15+151:21*60*15+75) = 'w'; % 9:10 - 11:05 (according to protocol)


%episodes

cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\episodes\all')
load('episodes.mat')

  %% save
  
cd(savepath)
save('SWA_scoring_episodes','SWA_normalized','SWA_absolute','scoring','filenames','episodes')
close all  
clear


%% plot to check if everything is fine
h1=figure



for i = 1:11
    
    subplot(11,1,i);
    plot(SWA_normalized(i,:),'Color','black');
    xlim([0 82000]);
    ylim([-0 6]);
   
%     
%         hold on
%     
%     nrem(1:81900)=-0.5;
%     nrem(scoring(i,:)=='4' | scoring(i,:)=='t')=0.4;
%     plot(nrem,'LineWidth',2,'Color','green')
%     
        hold on
    
    nrem(1:81900)=-0.5;
    nrem(scoring(i,:)=='n')=0.4;
    plot(nrem,'LineWidth',2,'Color','blue')
    
    
    
    hold on
    
    nrem(1:81900)=-0.5;
    nrem(scoring(i,:)=='m')=0.4;
    plot(nrem,'LineWidth',2,'Color','red')
    
    
end

       


    
    
    