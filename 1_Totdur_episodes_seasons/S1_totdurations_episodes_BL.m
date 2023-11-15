clear 
close all


%% durations

sb=15*60*15+1;  %start BL2 (5:00)
eb=39*60*15;

path='D:\Work\reindeer\Analyse_mainexperiment\Data\';
datapath=[path,'Mat_power_artcorr_scored_cut\SR_BL2'];

cd(datapath)
filenames=dir('*power*.mat');

nfiles=length(filenames)

for i=1:nfiles
    
    filename=filenames(i).name;
    load(filename);
    
    vissymb_all=vissymb_cut(sb:eb);

    %total
    nrem = find(vissymb_all=='n' | vissymb_all=='2');
    nrem_rum = find(vissymb_all=='n' | vissymb_all=='2' | vissymb_all=='t' | vissymb_all=='4');
    rem = find(vissymb_all=='r' | vissymb_all=='3');
    rum = find(vissymb_all=='t' | vissymb_all=='4');
    sleep = find(vissymb_all=='n' | vissymb_all=='2' | vissymb_all=='t' | vissymb_all=='4' | vissymb_all=='r' | vissymb_all=='3');
    wake = find(vissymb_all=='w' | vissymb_all=='0');
    length_nrem(i)=length(nrem)/15;
    length_nrem_rum(i)=length(nrem_rum)/15;
    length_rem(i)=length(rem)/15;
    length_rum(i)=length(rum)/15;
    length_sleep(i)=length(sleep)/15;
    length_wake(i)=length(wake)/15;
    
end

% mean and sd overall %

durations_all(1,1) = mean(length_nrem)/60;
durations_all(1,2) = std(length_nrem)/60;
durations_all(2,1) = mean(length_rem)/60;
durations_all(2,2) = std(length_rem)/60;
durations_all(3,1) = mean(length_rum)/60;
durations_all(3,2) = std(length_rum)/60;
durations_all(4,1) = mean(length_wake)/60;
durations_all(4,2) = std(length_wake)/60;

% mean and sd per season (Table 1)%

summary(1,1)=mean(length_nrem(1,[1 4 9]));
summary(2,1)=mean(length_nrem(1,[2 5 7 10]));
summary(3,1)=mean(length_nrem(1,[3 6 8 11]));

summary(1,2)=std(length_nrem(1,[1 4 9]));
summary(2,2)=std(length_nrem(1,[2 5 7 10]));
summary(3,2)=std(length_nrem(1,[3 6 8 11]));

summary(1,3)=mean(length_rem(1,[1 4 9]));
summary(2,3)=mean(length_rem(1,[2 5 7 10]));
summary(3,3)=mean(length_rem(1,[3 6 8 11]));

summary(1,4)=std(length_rem(1,[1 4 9]));
summary(2,4)=std(length_rem(1,[2 5 7 10]));
summary(3,4)=std(length_rem(1,[3 6 8 11]));

summary(1,5)=mean(length_rum(1,[1 4 9]));
summary(2,5)=mean(length_rum(1,[2 5 7 10]));
summary(3,5)=mean(length_rum(1,[3 6 8 11]));

summary(1,6)=std(length_rum(1,[1 4 9]));
summary(2,6)=std(length_rum(1,[2 5 7 10]));
summary(3,6)=std(length_rum(1,[3 6 8 11]));

summary(1,7)=mean(length_wake(1,[1 4 9]));
summary(2,7)=mean(length_wake(1,[2 5 7 10]));
summary(3,7)=mean(length_wake(1,[3 6 8 11]));

summary(1,8)=std(length_wake(1,[1 4 9]));
summary(2,8)=std(length_wake(1,[2 5 7 10]));
summary(3,8)=std(length_wake(1,[3 6 8 11]));

% t-test tot. duration NREM summer vs. winter

% [h,p] = ttest(length_nrem(1,[1 4 9]),length_nrem(1,[2 5 10]))
% [h,p] = ttest(length_sleep(1,[1 4 9]),length_sleep(1,[2 5 10]))
% [h,p] = ttest(length_nrem_rum(1,[1 4 9]),length_nrem_rum(1,[2 5 10]))

%%  characteristics episodes
cd('C:\Users\schlaf\Documents\GitHub\ReindeerSleep\data')

load('episodes.mat')

for n= 1:11
nreme(n,1)=length(episodes(n).nremdura(:,1));
nreme(n,2)=mean(episodes(n).nremdura(:,1))./15;
nreme(n,3)=std(episodes(n).nremdura(:,1))./15;

reme(n,1)=length(episodes(n).remdura(:,1));
reme(n,2)=mean(episodes(n).remdura(:,1))./15;
reme(n,3)=std(episodes(n).remdura(:,1))./15;

rume(n,1)=length(episodes(n).rumdura(:,1));
rume(n,2)=mean(episodes(n).rumdura(:,1))./15;
rume(n,3)=std(episodes(n).rumdura(:,1))./15;

wake(n,1)=length(episodes(n).wakdura(:,1));
wake(n,2)=mean(episodes(n).wakdura(:,1))./15;
wake(n,3)=std(episodes(n).wakdura(:,1))./15;

end



% mean and sd per seson %

summary_e1(1,1)=mean(nreme([1 4 9],1));
summary_e1(2,1)=mean(nreme([2 5 7 10],1));
summary_e1(3,1)=mean(nreme([3 6 8 11],1));

summary_e1(1,2)=std(nreme([1 4 9],1));
summary_e1(2,2)=std(nreme([2 5 7 10],1));
summary_e1(3,2)=std(nreme([3 6 8 11],1));

summary_e1(1,3)=mean(reme([1 4 9],1));
summary_e1(2,3)=mean(reme([2 5 7 10],1));
summary_e1(3,3)=mean(reme([3 6 8 11],1));

summary_e1(1,4)=std(reme([1 4 9],1));
summary_e1(2,4)=std(reme([2 5 7 10],1));
summary_e1(3,4)=std(reme([3 6 8 11],1));

summary_e1(1,5)=mean(rume([1 4 9],1));
summary_e1(2,5)=mean(rume([2 5 7 10],1));
summary_e1(3,5)=mean(rume([3 6 8 11],1));

summary_e1(1,6)=std(rume([1 4 9],1));
summary_e1(2,6)=std(rume([2 5 7 10],1));
summary_e1(3,6)=std(rume([3 6 8 11],1));

summary_e1(1,7)=mean(wake([1 4 9],1));
summary_e1(2,7)=mean(wake([2 5 7 10],1));
summary_e1(3,7)=mean(wake([3 6 8 11],1));

summary_e1(1,8)=std(wake([1 4 9],1));
summary_e1(2,8)=std(wake([2 5 7 10],1));
summary_e1(3,8)=std(wake([3 6 8 11],1));



summary_e2(1,1)=mean(nreme([1 4 9],2));
summary_e2(2,1)=mean(nreme([2 5 7 10],2));
summary_e2(3,1)=mean(nreme([3 6 8 11],2));

summary_e2(1,2)=std(nreme([1 4 9],2));
summary_e2(2,2)=std(nreme([2 5 7 10],2));
summary_e2(3,2)=std(nreme([3 6 8 11],2));

summary_e2(1,3)=mean(reme([1 4 9],2));
summary_e2(2,3)=mean(reme([2 5 7 10],2));
summary_e2(3,3)=mean(reme([3 6 8 11],2));

summary_e2(1,4)=std(reme([1 4 9],2));
summary_e2(2,4)=std(reme([2 5 7 10],2));
summary_e2(3,4)=std(reme([3 6 8 11],2));

summary_e2(1,5)=mean(rume([1 4 9],2));
summary_e2(2,5)=mean(rume([2 5 7 10],2));
summary_e2(3,5)=mean(rume([3 6 8 11],2));

summary_e2(1,6)=std(rume([1 4 9],2));
summary_e2(2,6)=std(rume([2 5 7 10],2));
summary_e2(3,6)=std(rume([3 6 8 11],2));

summary_e2(1,7)=mean(wake([1 4 9],2));
summary_e2(2,7)=mean(wake([2 5 7 10],2));
summary_e2(3,7)=mean(wake([3 6 8 11],2));

summary_e2(1,8)=std(wake([1 4 9],2));
summary_e2(2,8)=std(wake([2 5 7 10],2));
summary_e2(3,8)=std(wake([3 6 8 11],2));


%% plot

season=[{'December','July','September','December','July','September','July','September','December','July','September'}]
season2=[1 2 3 1 2 3 2 3 1 2 3]

h1=figure
subplot(3,3,1)
boxplot(length_rum./60,season)
hold on
scatter(season2,length_rum./60)
hold on
plot(length_rum(1:3)./60); plot(length_rum(4:6)./60); plot([NaN,length_rum(7:8)./60]); plot(length_rum(9:11)./60);
title ('total rumination (h)')

subplot(3,3,2)
boxplot(length_nrem./60,season)
hold on
scatter(season2,length_nrem./60)
hold on
plot(length_nrem(1:3)./60); plot(length_nrem(4:6)./60); plot([NaN,length_nrem(7:8)./60]); plot(length_nrem(9:11)./60);
title ('total NREM sleep (h)')

subplot(3,3,3)
boxplot(length_rem./60,season)
hold on
scatter(season2,length_rem./60)
hold on
plot(length_rem(1:3)./60); plot(length_rem(4:6)./60); plot([NaN,length_rem(7:8)./60]); plot(length_rem(9:11)./60);
title ('total REM sleep (h)')

subplot(3,3,4)
boxplot(rume(:,1),season)
hold on
scatter(season2,rume(:,1))
hold on
plot(rume(1:3,1)'); plot(rume(4:6,1)'); plot([NaN,rume(7:8,1)']); plot(rume(9:11,1)');
title('# rumination episodes')

subplot(3,3,5)
boxplot(nreme(:,1),season)
hold on
scatter(season2,nreme(:,1))
hold on
plot(nreme(1:3,1)'); plot(nreme(4:6,1)'); plot([NaN,nreme(7:8,1)']); plot(nreme(9:11,1)');
title('# NREMs episodes')

subplot(3,3,6)
boxplot(reme(:,1),season)
hold on
scatter(season2,reme(:,1))
hold on
plot(reme(1:3,1)'); plot(reme(4:6,1)'); plot([NaN,reme(7:8,1)']); plot(reme(9:11,1)');
title('# REMs episodes')

subplot(3,3,7)
boxplot(rume(:,2),season)
hold on
scatter(season2,rume(:,2))
hold on
plot(rume(1:3,2)'); plot(rume(4:6,2)'); plot([NaN,rume(7:8,2)']); plot(rume(9:11,2)');
title('length rumination episodes')

subplot(3,3,8)
boxplot(nreme(:,2),season)
hold on
scatter(season2,nreme(:,2))
hold on
plot(nreme(1:3,2)'); plot(nreme(4:6,2)'); plot([NaN,nreme(7:8,2)']); plot(nreme(9:11,2)');
title('length NREMs episodes')

subplot(3,3,9)
boxplot(reme(:,2),season)
hold on
scatter(season2,reme(:,2))
hold on
plot(reme(1:3,2)'); plot(reme(4:6,2)'); plot([NaN,reme(7:8,2)']); plot(reme(9:11,2)');
title('length REMs episodes')

cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\overview_plots')
 print(h1,['Boxplot_duration_episodes_overview'],'-dpng','-r500')
close all


%% episodes light_dark
    
for n=1:9
    
episodes(n).nremrumdura = vertcat(episodes(n).nremdura,episodes(n).rumdura);
episodes(n).nremrumdura = sortrows(episodes(n).nremrumdura,2);

nremrumdura_d=episodes(n).nremrumdura(episodes(n).nremrumdura(:,2)>10800,:);
nremrumdura_l=episodes(n).nremrumdura(episodes(n).nremrumdura(:,2)<=10800,:);

nremdura_d=episodes(n).nremdura(episodes(n).nremdura(:,2)>10800,:);
nremdura_l=episodes(n).nremdura(episodes(n).nremdura(:,2)<=10800,:);

remdura_d=episodes(n).remdura(episodes(n).remdura(:,2)>10800,:);
remdura_l=episodes(n).remdura(episodes(n).remdura(:,2)<=10800,:);

rumdura_d=episodes(n).rumdura(episodes(n).rumdura(:,2)>10800,:);
rumdura_l=episodes(n).rumdura(episodes(n).rumdura(:,2)<=10800,:);

wakdura_d=episodes(n).wakdura(episodes(n).wakdura(:,2)>10800,:);
wakdura_l=episodes(n).wakdura(episodes(n).wakdura(:,2)<=10800,:);

nremrume_light(n,1)=length(nremrumdura_l(:,1))
nremrume_light(n,2)=mean(nremrumdura_l(:,1))./15
nremrume_light(n,3)=std(nremrumdura_l(:,1))./15
nremrume_dark(n,1)=length(nremrumdura_d(:,1))
nremrume_dark(n,2)=mean(nremrumdura_d(:,1))./15
nremrume_dark(n,3)=std(nremrumdura_d(:,1))./15

nreme_light(n,1)=length(nremdura_l(:,1))
nreme_light(n,2)=mean(nremdura_l(:,1))./15
nreme_light(n,3)=std(nremdura_l(:,1))./15
nreme_dark(n,1)=length(nremdura_d(:,1))
nreme_dark(n,2)=mean(nremdura_d(:,1))./15
nreme_dark(n,3)=std(nremdura_d(:,1))./15

reme_light(n,1)=length(remdura_l(:,1))
reme_light(n,2)=mean(remdura_l(:,1))./15
reme_light(n,3)=std(remdura_l(:,1))./15
reme_dark(n,1)=length(remdura_d(:,1))
reme_dark(n,2)=mean(remdura_d(:,1))./15
reme_dark(n,3)=std(remdura_d(:,1))./15

rume_light(n,1)=length(rumdura_l(:,1))
rume_light(n,2)=mean(rumdura_l(:,1))./15
rume_light(n,3)=std(rumdura_l(:,1))./15
rume_dark(n,1)=length(rumdura_d(:,1))
rume_dark(n,2)=mean(rumdura_d(:,1))./15
rume_dark(n,3)=std(rumdura_d(:,1))./15

wake_light(n,1)=length(wakdura_l(:,1))
wake_light(n,2)=mean(wakdura_l(:,1))./15
wake_light(n,3)=std(wakdura_l(:,1))./15
wake_dark(n,1)=length(wakdura_d(:,1))
wake_dark(n,2)=mean(wakdura_d(:,1))./15
wake_dark(n,3)=std(wakdura_d(:,1))./15

end



%% plot


%%%%%%%% NREM + RUM %%%%%%%%%%%%%%

h2=figure

subplot(2,3,1)
boxplot([nremrume_light([1 4 7],1),nremrume_dark([1 4 7],1)]); 
hold on
scatter([1 1 1 2 2 2],[nremrume_light([1 4 7],1);nremrume_dark([1 4 7],1)]);
hold on
plot([nremrume_light(1,1);nremrume_dark(1,1)]); plot([nremrume_light(4,1);nremrume_dark(4,1)]); plot([nremrume_light(7,1);nremrume_dark(7,1)]);
title('# rumination plus NREMs episodes December','fontsize',16)


subplot(2,3,2)
boxplot([nremrume_light([2 5 8],1),nremrume_dark([2 5 8],1)]); 
hold on
scatter([1 1 1 2 2 2],[nremrume_light([2 5 8],1);nremrume_dark([2 5 8],1)]);
hold on
plot([nremrume_light(2,1);nremrume_dark(2,1)]); plot([nremrume_light(5,1);nremrume_dark(5,1)]); plot([nremrume_light(8,1);nremrume_dark(8,1)]);
title('# rumination plus NREMs episodes July','fontsize',16)


subplot(2,3,3)
boxplot([nremrume_light([3 6 9],1),nremrume_dark([3 6 9],1)]); 
hold on
scatter([1 1 1 2 2 2],[nremrume_light([3 6 9],1);nremrume_dark([3 6 9],1)]);
hold on
plot([nremrume_light(3,1);nremrume_dark(3,1)]); plot([nremrume_light(6,1);nremrume_dark(6,1)]); plot([nremrume_light(9,1);nremrume_dark(9,1)]);
title('# rumination plus NREMs episodes September','fontsize',16)


subplot(2,3,4)
boxplot([nremrume_light([1 4 7],2),nremrume_dark([1 4 7],2)]); 
hold on
scatter([1 1 1 2 2 2],[nremrume_light([1 4 7],2);nremrume_dark([1 4 7],2)]);
hold on
plot([nremrume_light(1,2);nremrume_dark(1,2)]); plot([nremrume_light(4,2);nremrume_dark(4,2)]); plot([nremrume_light(7,2);nremrume_dark(7,2)]);
title('length rumination plus NREMs episodes December','fontsize',16)


subplot(2,3,5)
boxplot([nremrume_light([2 5 8],2),nremrume_dark([2 5 8],2)]); 
hold on
scatter([1 1 1 2 2 2],[nremrume_light([2 5 8],2);nremrume_dark([2 5 8],2)]);
hold on
plot([nremrume_light(2,2);nremrume_dark(2,2)]); plot([nremrume_light(5,2);nremrume_dark(5,2)]); plot([nremrume_light(8,2);nremrume_dark(8,2)]);
title('length rumination plus NREMs episodes July','fontsize',16)


subplot(2,3,6)
boxplot([nremrume_light([3 6 9],2),nremrume_dark([3 6 9],2)]); 
hold on
scatter([1 1 1 2 2 2],[nremrume_light([3 6 9],2);nremrume_dark([3 6 9],2)]);
hold on
plot([nremrume_light(3,2);nremrume_dark(3,2)]); plot([nremrume_light(6,2);nremrume_dark(6,2)]); plot([nremrume_light(9,2);nremrume_dark(9,2)]);
title('length rumination plus NREMs episodes September','fontsize',16)






%%%%%%%% REM %%%%%%%%%%%%%%

h3=figure

subplot(2,3,1)
boxplot([reme_light([1 4 7],1),reme_dark([1 4 7],1)]); 
hold on
scatter([1 1 1 2 2 2],[reme_light([1 4 7],1);reme_dark([1 4 7],1)]);
hold on
plot([reme_light(1,1);reme_dark(1,1)]); plot([reme_light(4,1);reme_dark(4,1)]); plot([reme_light(7,1);reme_dark(7,1)]);
title('# REM sleep episodes December','fontsize',16)


subplot(2,3,2)
boxplot([reme_light([2 5 8],1),reme_dark([2 5 8],1)]); 
hold on
scatter([1 1 1 2 2 2],[reme_light([2 5 8],1);reme_dark([2 5 8],1)]);
hold on
plot([reme_light(2,1);reme_dark(2,1)]); plot([reme_light(5,1);reme_dark(5,1)]); plot([reme_light(8,1);reme_dark(8,1)]);
title('# REM sleep episodes July','fontsize',16)


subplot(2,3,3)
boxplot([reme_light([3 6 9],1),reme_dark([3 6 9],1)]); 
hold on
scatter([1 1 1 2 2 2],[reme_light([3 6 9],1);reme_dark([3 6 9],1)]);
hold on
plot([reme_light(3,1);reme_dark(3,1)]); plot([reme_light(6,1);reme_dark(6,1)]); plot([reme_light(9,1);reme_dark(9,1)]);
title('# REM sleep episodes September','fontsize',16)


subplot(2,3,4)
boxplot([reme_light([1 4 7],2),reme_dark([1 4 7],2)]); 
hold on
scatter([1 1 1 2 2 2],[reme_light([1 4 7],2);reme_dark([1 4 7],2)]);
hold on
plot([reme_light(1,2);reme_dark(1,2)]); plot([reme_light(4,2);reme_dark(4,2)]); plot([reme_light(7,2);reme_dark(7,2)]);
title('length REM sleep episodes December','fontsize',16)


subplot(2,3,5)
boxplot([reme_light([2 5 8],2),reme_dark([2 5 8],2)]); 
hold on
scatter([1 1 1 2 2 2],[reme_light([2 5 8],2);reme_dark([2 5 8],2)]);
hold on
plot([reme_light(2,2);reme_dark(2,2)]); plot([reme_light(5,2);reme_dark(5,2)]); plot([reme_light(8,2);reme_dark(8,2)]);
title('length REM sleep episodes July','fontsize',16)


subplot(2,3,6)
boxplot([reme_light([3 6 9],2),reme_dark([3 6 9],2)]); 
hold on
scatter([1 1 1 2 2 2],[reme_light([3 6 9],2);reme_dark([3 6 9],2)]);
hold on
plot([reme_light(3,2);reme_dark(3,2)]); plot([reme_light(6,2);reme_dark(6,2)]); plot([reme_light(9,2);reme_dark(9,2)]);
title('length REM sleep episodes September','fontsize',16)





%%%%%%%% RUM %%%%%%%%%%%%%%

h4=figure

subplot(2,3,1)
boxplot([rume_light([1 4 7],1),rume_dark([1 4 7],1)]); 
hold on
scatter([1 1 1 2 2 2],[rume_light([1 4 7],1);rume_dark([1 4 7],1)]);
hold on
plot([rume_light(1,1);rume_dark(1,1)]); plot([rume_light(4,1);rume_dark(4,1)]); plot([rume_light(7,1);rume_dark(7,1)]);
title('# RUM episodes December','fontsize',16)


subplot(2,3,2)
boxplot([rume_light([2 5 8],1),rume_dark([2 5 8],1)]); 
hold on
scatter([1 1 1 2 2 2],[rume_light([2 5 8],1);rume_dark([2 5 8],1)]);
hold on
plot([rume_light(2,1);rume_dark(2,1)]); plot([rume_light(5,1);rume_dark(5,1)]); plot([rume_light(8,1);rume_dark(8,1)]);
title('# RUM episodes July','fontsize',16)


subplot(2,3,3)
boxplot([rume_light([3 6 9],1),rume_dark([3 6 9],1)]); 
hold on
scatter([1 1 1 2 2 2],[rume_light([3 6 9],1);rume_dark([3 6 9],1)]);
hold on
plot([rume_light(3,1);rume_dark(3,1)]); plot([rume_light(6,1);rume_dark(6,1)]); plot([rume_light(9,1);rume_dark(9,1)]);
title('# RUM episodes September','fontsize',16)


subplot(2,3,4)
boxplot([rume_light([1 4 7],2),rume_dark([1 4 7],2)]); 
hold on
scatter([1 1 1 2 2 2],[rume_light([1 4 7],2);rume_dark([1 4 7],2)]);
hold on
plot([rume_light(1,2);rume_dark(1,2)]); plot([rume_light(4,2);rume_dark(4,2)]); plot([rume_light(7,2);rume_dark(7,2)]);
title('length RUM episodes December','fontsize',16)


subplot(2,3,5)
boxplot([rume_light([2 5 8],2),rume_dark([2 5 8],2)]); 
hold on
scatter([1 1 1 2 2 2],[rume_light([2 5 8],2);rume_dark([2 5 8],2)]);
hold on
plot([rume_light(2,2);rume_dark(2,2)]); plot([rume_light(5,2);rume_dark(5,2)]); plot([rume_light(8,2);rume_dark(8,2)]);
title('length RUM episodes July','fontsize',16)


subplot(2,3,6)
boxplot([rume_light([3 6 9],2),rume_dark([3 6 9],2)]); 
hold on
scatter([1 1 1 2 2 2],[rume_light([3 6 9],2);rume_dark([3 6 9],2)]);
hold on
plot([rume_light(3,2);rume_dark(3,2)]); plot([rume_light(6,2);rume_dark(6,2)]); plot([rume_light(9,2);rume_dark(9,2)]);
title('length RUM episodes September','fontsize',16)




%%%%%%%% NREM %%%%%%%%%%%%%%

h5=figure

subplot(2,3,1)
boxplot([nreme_light([1 4 7],1),nreme_dark([1 4 7],1)]); 
hold on
scatter([1 1 1 2 2 2],[nreme_light([1 4 7],1);nreme_dark([1 4 7],1)]);
hold on
plot([nreme_light(1,1);nreme_dark(1,1)]); plot([nreme_light(4,1);nreme_dark(4,1)]); plot([nreme_light(7,1);nreme_dark(7,1)]);
title('# NREM sleep episodes December','fontsize',16)


subplot(2,3,2)
boxplot([nreme_light([2 5 8],1),nreme_dark([2 5 8],1)]); 
hold on
scatter([1 1 1 2 2 2],[nreme_light([2 5 8],1);nreme_dark([2 5 8],1)]);
hold on
plot([nreme_light(2,1);nreme_dark(2,1)]); plot([nreme_light(5,1);nreme_dark(5,1)]); plot([nreme_light(8,1);nreme_dark(8,1)]);
title('# NREM sleep episodes July','fontsize',16)


subplot(2,3,3)
boxplot([nreme_light([3 6 9],1),nreme_dark([3 6 9],1)]); 
hold on
scatter([1 1 1 2 2 2],[nreme_light([3 6 9],1);nreme_dark([3 6 9],1)]);
hold on
plot([nreme_light(3,1);nreme_dark(3,1)]); plot([nreme_light(6,1);nreme_dark(6,1)]); plot([nreme_light(9,1);nreme_dark(9,1)]);
title('# NREM sleep episodes September','fontsize',16)


subplot(2,3,4)
boxplot([nreme_light([1 4 7],2),nreme_dark([1 4 7],2)]); 
hold on
scatter([1 1 1 2 2 2],[nreme_light([1 4 7],2);nreme_dark([1 4 7],2)]);
hold on
plot([nreme_light(1,2);nreme_dark(1,2)]); plot([nreme_light(4,2);nreme_dark(4,2)]); plot([nreme_light(7,2);nreme_dark(7,2)]);
title('length NREM sleep episodes December','fontsize',16)


subplot(2,3,5)
boxplot([nreme_light([2 5 8],2),nreme_dark([2 5 8],2)]); 
hold on
scatter([1 1 1 2 2 2],[nreme_light([2 5 8],2);nreme_dark([2 5 8],2)]);
hold on
plot([nreme_light(2,2);nreme_dark(2,2)]); plot([nreme_light(5,2);nreme_dark(5,2)]); plot([nreme_light(8,2);nreme_dark(8,2)]);
title('length NREM sleep episodes July','fontsize',16)


subplot(2,3,6)
boxplot([nreme_light([3 6 9],2),nreme_dark([3 6 9],2)]); 
hold on
scatter([1 1 1 2 2 2],[nreme_light([3 6 9],2);nreme_dark([3 6 9],2)]);
hold on
plot([nreme_light(3,2);nreme_dark(3,2)]); plot([nreme_light(6,2);nreme_dark(6,2)]); plot([nreme_light(9,2);nreme_dark(9,2)]);
title('length NREM sleep episodes September','fontsize',16)



%% save
cd('C:\Users\schlaf\Documents\reindeer\Data_Analysis_main_experiment\Results\episodes')
print(h2,['Boxplot_episodes_daynight_nremrum'],'-dpng')
print(h3,['Boxplot_episodes_daynight_rem'],'-dpng')
print(h4,['Boxplot_episodes_daynight_rum'],'-dpng')
print(h5,['Boxplot_episodes_daynight_nrem'],'-dpng')
close all