
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
    nrem_rem = find(vissymb_dark=='n' | vissymb_dark=='2' | vissymb_dark=='r' | vissymb_dark=='3');
    sleep = find(vissymb_dark=='n' | vissymb_dark=='2' | vissymb_dark=='t' | vissymb_dark=='4' | vissymb_dark=='r' | vissymb_dark=='3');
    rem = find(vissymb_dark=='r' | vissymb_dark=='3');
    rum = find(vissymb_dark=='t' | vissymb_dark=='4');
    length_nrem_dark(t,i)=length(nrem)/15/(length(vissymb_dark)/15/60);
    length_nrem_rum_dark(t,i)=length(nrem_rum)/15/(length(vissymb_dark)/15/60);
    length_nrem_rem_dark(t,i)=length(nrem_rem)/15/(length(vissymb_dark)/15/60);
    length_sleep_dark(t,i)=(length(sleep)/15)/(length(vissymb_dark)/15/60);
    length_rem_dark(t,i)=length(rem)/15/(length(vissymb_dark)/15/60);
    length_rum_dark(t,i)=length(rum)/15/(length(vissymb_dark)/15/60);
    
    
        %light
    nrem = find(vissymb_light=='n' | vissymb_light=='2');
    nrem_rum = find(vissymb_light=='n' | vissymb_light=='2' | vissymb_light=='t' | vissymb_light=='4');
    nrem_rem = find(vissymb_light=='n' | vissymb_light=='2' | vissymb_light=='r' | vissymb_light=='3');
    sleep = find(vissymb_light=='n' | vissymb_light=='2' | vissymb_light=='t' | vissymb_light=='4' | vissymb_light=='r' | vissymb_light=='3');
    rem = find(vissymb_light=='r' | vissymb_light=='3');
    rum = find(vissymb_light=='t' | vissymb_light=='4');
    length_nrem_light(t,i)=length(nrem)/15/(length(vissymb_light)/15/60);
    length_nrem_rum_light(t,i)=length(nrem_rum)/15/(length(vissymb_light)/15/60);
    length_nrem_rem_light(t,i)=length(nrem_rem)/15/(length(vissymb_light)/15/60);
    length_sleep_light(t,i)=(length(sleep)/15)/(length(vissymb_light)/15/60);
    length_rem_light(t,i)=length(rem)/15/(length(vissymb_light)/15/60);
    length_rum_light(t,i)=length(rum)/15/(length(vissymb_light)/15/60);
end

end


ratio_nrem_rum=length_nrem_rum_dark./length_nrem_rum_light;
ratio_rem=length_rem_dark./length_rem_light;
ratio_sleep=length_sleep_dark./length_sleep_light;

ratio_nrem=length_nrem_dark./length_nrem_light;
ratio_rum=length_rum_dark./length_rum_light;


  
%% plot 12h - 12h diff sleep (NREM, REM and RUM)
%-> shifted so median time of first time window corresponds to 5am (lights on in Fall)


diff_sleep=length_sleep_dark-length_sleep_light;

ratio_sleep2=diff_sleep([19:24 1:18],:);

close all
h3=figure('DefaultAxesFontSize',16,'defaultAxesTickDir', 'out',  'defaultAxesTickDirMode', 'manual')

subplot(1,3,1)
plot(ratio_sleep2(:,1),'-o','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(ratio_sleep2(:,4),'-o','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(ratio_sleep2(:,9),'-o','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(mean(ratio_sleep2(:,[1 4 9]),2),'ko-','MarkerFaceColor','k','MarkerSize',4,'LineWidth',3)
ylim([-25 21])
yticks([-20:10:20])
ylabel('{\Delta} Inactive states (min/h)','FontSize',18)
xlim([0 25])
% xticks([2 8 14 20])
% xticklabels({'12','18','00','6'})
% xlabel('time windows (clock time)','FontSize',18)
xticks([1 7 13 19])
xticklabels({'0','6','12','18'})
xlabel('Time windows','FontSize',18)
%title('December')
box off 
line([0 25],[21 21],'Color','k')
line([25 25],[-25 21],'Color','k')
line([0 25],[0 0],'Color','k')


subplot(1,3,2)
plot(ratio_sleep2(:,2),'-o','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(ratio_sleep2(:,5),'-o','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(ratio_sleep2(:,10),'-o','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(ratio_sleep2(:,7),'-o','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(mean(ratio_sleep2(:,[2 5 7 10]),2),'ko-','MarkerFaceColor','k','MarkerSize',4,'LineWidth',3)
ylim([-25 21])
yticks([-20:10:20])
%ylabel('sleep ratio')
xlim([0 25])
xticks([1 7 13 19])
xticklabels({'0','6','12','18'})
%xlabel('time windows (clock time)','FontSize',18))
%title('July')
box off 
line([0 25],[21 21],'Color','k')
line([25 25],[-25 21],'Color','k')
line([0 25],[0 0],'Color','k')

subplot(1,3,3)
plot(ratio_sleep2(:,3),'-o','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(ratio_sleep2(:,6),'-o','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(ratio_sleep2(:,11),'-o','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(ratio_sleep2(:,8),'-o','color',[0.7 0.7 0.7],'MarkerFaceColor',[0.7 0.7 0.7],'MarkerSize',3,'LineWidth',1)
hold on
plot(mean(ratio_sleep2(:,[3 6 8 11]),2),'ko-','MarkerFaceColor','k','MarkerSize',4,'LineWidth',3)
ylim([-25 21])
yticks([-20:10:20])
%ylabel('sleep ratio')
xlim([0 25])
xticks([1 7 13 19])
xticklabels({'0','6','12','18'})
%xlabel('time windows (clock time)')
%title('September')
box off 
line([0 25],[21 21],'Color','k')
line([25 25],[-25 21],'Color','k')
line([0 25],[0 0],'Color','k')
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


%% save

cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\durationacross24h')
print(h3,'sleepdiff_otherlabel_F1Ba.png','-dpng','-r1000')



