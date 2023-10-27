clear
close all

%%

path='D:\Work\reindeer\Analyse_mainexperiment\Data\';
datapath0=[path,'Mat_power_artcorr_scored_cut\Adapt'];
datapath1=[path,'Mat_power_artcorr_scored_cut\BL1'];
datapath2=[path,'Mat_power_artcorr_scored_cut\SR_BL2'];
savepath='C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\episodes\all';

cd(datapath2)
filenames2=dir('*power*.mat');

nfiles=length(filenames2)


for n=1:nfiles
    
        if n==1
            cd(datapath0)
            filenames0=dir('*power*.mat')
            filename=filenames0(n).name;
            load(filename); 
            
            STD_0=vissymb_cut;
            STD_0(end+1:18900)='m';
            art_0=artndxn_cut;
            art_0(end:18900)=0;
            
            % BL1 missing except for last 2 hours wake
            STD_1=nan(1,24300); %27 h
            art_1=nan(1,24300); %27 h
            STD_1(1,22501:24300)='w'; % sleep deprivation
            
        else
            cd(datapath0)
            filenames0=dir('*power*.mat')
            filename=filenames0(n).name;
            load(filename); 

            
        %shift data according to starttime
        if n==4 || n==7 || n==9 || n==10 %starttime 14h
            STD_0=vissymb_cut;
            STD_0(end+1:18900)='w';
            art_0=artndxn_cut;
            art_0(end:18900)=0;
        elseif n==2 || n==5 %starttime 15.2h
            STD_0=repelem('w',18900); %21 h
            STD_0(1081:length(vissymb_cut)+1080)=vissymb_cut;
            STD_0(end+1:18900)='w';
            art_0(1081:length(artndxn_cut)+1080)=artndxn_cut;
            art_0(end+1:18900)=0;
        elseif n==3 %starttime 13h
            STD_00=vissymb_cut;
            STD_0=vissymb_cut(901:19800);
            art_00=artndxn_cut;
            art_0=artndxn_cut(901:19800);
        elseif n==11 %starttime 12h (only 2 hours recording, rest missing)
            STD_0=vissymb_cut(1801:end);
            STD_0(end+1:18900)='m';
            art_0=artndxn_cut(1801:end);
            art_0(end+1:18900)=0;
        elseif n==6 || n==8 %starttime 14.5h
            STD_0(451:length(vissymb_cut)+450)=vissymb_cut;
            STD_0(end+1:18900)='w';
            art_0(451:length(artndxn_cut)+450)=artndxn_cut;
            art_0(end+1:18900)=0;
        end
                      
            cd(datapath1)
            filenames1=dir('*power*.mat')
            filename=filenames1(n-1).name;
            load(filename); 
            STD_1=vissymb_cut;
            STD_1(end:24300)='w';
            
        end
        
        cd(datapath2)
        filename=filenames2(n).name;
        load(filename);
        STD_2=vissymb_cut;
        STD_2(end:38700)='w';
        art_2=artndxn_cut;
        art_2(end:38700)=0;
        
        STD=horzcat(STD_0,STD_1,STD_2);
        art=horzcat(art_0,art_1,art_2);

        [episodes(n).wakdura,episodes(n).nremdura,episodes(n).remdura,episodes(n).rumdura,episodes(n).baa]=ecountwnrr(STD);
        % [episodes(n).sleepdura, sleeph(n)]=ecountsleepL(STD)
        episodes(n).reindeer=filename(1:8);
        
        STD_all(n).STD=STD;
        art_all(n).art=art;
        
end

cd(savepath)
%save('episodes_sleep.mat','episodes','art_all','STD_all')
save('episodes.mat','episodes','art_all','STD_all')

