%% 12h bits (for plot with ratios)

clear all
close

%% define start and end of BL2
sb=15*60*15+1;  %start BL2 (5:00)
eb=39*60*15;

path='D:\Work\reindeer\Analyse_mainexperiment\Data\';
datapath=[path,'Mat_power_artcorr_scored_cut\SR_BL2'];

cd(datapath)
filenames=dir('*power*.mat');

nfiles=length(filenames)


%%

for t=1:24
t1(t)=(t-1)*60*15;

if t < 14
    t2(t)=(t+11)*60*15;
else
    t2(t)=(t-13)*60*15;
end
end


for i=1:nfiles
    
    filename=filenames(i).name;
    load(filename);
    vissymb_all=vissymb_cut(sb:eb); %% from 5 to 5 (BL)
    
for t=1:24

if t < 14
vissymb_dark=vissymb_all(t1(t)+1:t2(t));
vissymb_light=horzcat(vissymb_all(t2(t)+1:end),vissymb_all(1:t1(t)));
else
vissymb_dark=horzcat(vissymb_all(t1(t)+1:end),vissymb_all(1:t2(t)));
vissymb_light=vissymb_all(t2(t)+1:t1(t));
end



        %dark
    nrem = find(vissymb_dark=='n' | vissymb_dark=='2');
    nrem_rum = find(vissymb_dark=='n' | vissymb_dark=='2' | vissymb_dark=='t' | vissymb_dark=='4');
    sleep = find(vissymb_dark=='n' | vissymb_dark=='2' | vissymb_dark=='t' | vissymb_dark=='4' | vissymb_dark=='r' | vissymb_dark=='3');
    rem = find(vissymb_dark=='r' | vissymb_dark=='3');
    rum = find(vissymb_dark=='t' | vissymb_dark=='4');
    length_nrem_dark(t,i)=length(nrem)/15/(length(vissymb_dark)/15/60);
    length_nrem_rum_dark(t,i)=length(nrem_rum)/15/(length(vissymb_dark)/15/60);
    length_sleep_dark(t,i)=length(sleep)/15/(length(vissymb_dark)/15/60);
    length_rem_dark(t,i)=length(rem)/15/(length(vissymb_dark)/15/60);
    length_rum_dark(t,i)=length(rum)/15/(length(vissymb_dark)/15/60);
    
    
        %light
    nrem = find(vissymb_light=='n' | vissymb_light=='2');
    nrem_rum = find(vissymb_light=='n' | vissymb_light=='2' | vissymb_light=='t' | vissymb_light=='4');
    sleep = find(vissymb_light=='n' | vissymb_light=='2' | vissymb_light=='t' | vissymb_light=='4' | vissymb_light=='r' | vissymb_light=='3');
    rem = find(vissymb_light=='r' | vissymb_light=='3');
    rum = find(vissymb_light=='t' | vissymb_light=='4');
    length_nrem_light(t,i)=length(nrem)/15/(length(vissymb_light)/15/60);
    length_nrem_rum_light(t,i)=length(nrem_rum)/15/(length(vissymb_light)/15/60);
    length_sleep_light(t,i)=length(sleep)/15/(length(vissymb_light)/15/60);
    length_rem_light(t,i)=length(rem)/15/(length(vissymb_light)/15/60);
    length_rum_light(t,i)=length(rum)/15/(length(vissymb_light)/15/60);
end

end


ratio_nrem_rum=length_nrem_rum_dark./length_nrem_rum_light;
ratio_rem=length_rem_dark./length_rem_light;
ratio_sleep=length_sleep_dark./length_sleep_light;

ratio_nrem=length_nrem_dark./length_nrem_light;
ratio_rum=length_rum_dark./length_rum_light;


%% plot 12h ratios sleep (NREM, REM and RUM)


h3=figure('DefaultAxesFontSize',18)

subplot(1,3,1)
plot(ratio_sleep(:,1),'-s','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(ratio_sleep(:,4),'-s','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(ratio_sleep(:,9),'-s','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(mean(ratio_sleep(:,[1 4 9]),2),'ks-','MarkerFaceColor','k','MarkerSize',6,'LineWidth',3)
ylim([0.2 2.6])
yticks([0.4:0.4:2.4])
ylabel('12h/12h ratio total sleep duration')
xlim([0 25])
xticks([2 14])
xticklabels({'6-18/18-6','18-6/6-18'})
xlabel('time windows (clock time)')
title('December')


subplot(1,3,2)
plot(ratio_sleep(:,2),'-s','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(ratio_sleep(:,5),'-s','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(ratio_sleep(:,10),'-s','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(ratio_sleep(:,7),'-s','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(mean(ratio_sleep(:,[2 5 7 10]),2),'ks-','MarkerFaceColor','k','MarkerSize',6,'LineWidth',3)
ylim([0.2 2.6])
yticks([0.4:0.4:2.6])
ylabel('12h/12h ratio total sleep duration')
xlim([0 25])
xticks([2 14])
xticklabels({'6-18/18-6','18-6/6-18'})
xlabel('time windows (clock time)')
title('July')


subplot(1,3,3)
plot(ratio_sleep(:,3),'-s','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(ratio_sleep(:,6),'-s','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(ratio_sleep(:,11),'-s','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(ratio_sleep(:,8),'-s','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(mean(ratio_sleep(:,[3 6 8 11]),2),'ks-','MarkerFaceColor','k','MarkerSize',6,'LineWidth',3)
ylim([0.2 2.6])
yticks([0.4:0.4:2.6])
ylabel('12h/12h ratio total sleep duration')
xlim([0 25])
xticks([2 14])
xticklabels({'6-18/18-6','18-6/6-18'})
xlabel('time windows (clock time)')
title('September')


%%%stats%%%

for i=1:24
    
    [h,p_dec(i)] = ttest(length_sleep_dark(i,[1 4 9]),length_sleep_light(i,[1 4 9]));
    [h,p_july(i)] = ttest(length_sleep_dark(i,[2 5 7 10]),length_sleep_light(i,[2 5 7 10]));
    [h,p_sep(i)] = ttest(length_sleep_dark(i,[3 6 8 11]),length_sleep_light(i,[3 6 8 11]));
     
end


%%% correct for multiple testing %%%
pFDR_dec = mafdr(p_dec,'BHFDR',true); 
pFDR_july = mafdr(p_july,'BHFDR',true); 
pFDR_sep = mafdr(p_sep,'BHFDR',true); 

sig_dec_corr=find(pFDR_dec<0.05);
sig_july_corr=find(pFDR_july<0.05);        
sig_sep_corr=find(pFDR_sep<0.05);    

  
  
  
