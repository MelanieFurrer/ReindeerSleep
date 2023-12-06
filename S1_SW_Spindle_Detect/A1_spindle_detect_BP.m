clear 
close all

path='D:\Work\reindeer\Analyse_mainexperiment\Data\';
datapath=[path,'Mat_power_artcorr_scored_cut\SR_BL2'];
savepath='D:\Work\reindeer\Analyse_mainexperiment\Data\spindle_detection\bipolar_rum';

cd(datapath)
filenames=dir('*dataEEG*.mat');

epochl=4;


 for u=2

cd(datapath)
filename=filenames(u).name;
load(filename);


%%%%scoring and artefact information

goodepochs = find(artndxn_rum); %artefact free nrem sleep
%  goodepochs = find(vissymb_cut=='n' | vissymb_cut=='2'); %all nrem sleep
% goodepochs = find(vissymb_cut=='t' | vissymb_cut=='4'); %all rumination
% 
%     
newepo=length(goodepochs); 

 
% bp-filter für spindeln (-3 dB bei 12 und 15 Hz)
Wp=[12 15]/64;
Ws=[6 30]/64;
Rp=3;
Rs=40;    %geändert von 80
[n, Wn]=cheb2ord(Wp,Ws,Rp,Rs);
[bbp, abp]=cheby2(n,Rs,Wn);
%freqz(bbp,abp,512,128)hout artefact, only stage 2

channel=1
         
for thres=[5,6,7,8]
    
            
           
eval(['spindle_t',num2str(thres),'(channel).duration_mn=NaN;'])
eval(['spindle_t',num2str(thres),'(channel).maxamp_mn=NaN;'])
eval(['spindle_t',num2str(thres),'(channel).spifrq_mn=NaN;'])
eval(['spindle_t',num2str(thres),'(channel).spipow_mn=NaN;'])
eval(['spindle_t',num2str(thres),'(channel).duration_sd=NaN;'])
eval(['spindle_t',num2str(thres),'(channel).maxamp_sd=NaN;'])
eval(['spindle_t',num2str(thres),'(channel).spifrq_sd=NaN;'])
eval(['spindle_t',num2str(thres),'(channel).spipow_sd=NaN;'])
eval(['spindle_t',num2str(thres),'(channel).number_all=NaN;'])
eval(['spindle_t',num2str(thres),'(channel).density_all=NaN;'])
eval(['spindle_t',num2str(thres),'(channel).duration_all=NaN;'])
eval(['spindle_t',num2str(thres),'(channel).maxamp_all=NaN;'])
eval(['spindle_t',num2str(thres),'(channel).spipow_all=NaN;'])
eval(['spindle_t',num2str(thres),'(channel).spifrq_all=NaN;'])
eval(['spindle_t',num2str(thres),'(channel).spistart=NaN;'])
eval(['spindle_t',num2str(thres),'(channel).spiend=NaN;'])
eval(['spindle_t',num2str(thres),'(channel).spistart_ISI_s=NaN;'])
eval(['spindle_t',num2str(thres),'(channel).spistart_ISI_var=NaN;'])
eval(['spindle_t',num2str(thres),'(channel).spistart_ISI=NaN;'])
eval(['spindle_t',num2str(thres),'(channel).spistart_ISI_var_s=NaN;'])
           
       
data=BP_dcut';        
%data=EEG_dcut(1,:)';        
datar=double(data(:,channel));

        ol=32; %overlap

        spa=[];
        data_all=[];
        %analyse
        for ep=2:newepo-1 % ep1=2 wenn loff=0, in case file starts with sleep
            nep=goodepochs(ep);
            starts(ep)=(nep-1)*epochl*fs-ol;
            ends(ep)=nep*epochl*fs+ol;
            signal=datar(starts(ep):ends(ep));
            
            sp=filtfilt(bbp, abp, signal); % spindeln
            sp=sp(ol+1:epochl*fs+ol);  %without overlap
            spa=[spa;sp];
            signal=signal(ol+1:epochl*fs+ol);  %without overlap
            data_all=[data_all;signal];
        end


       
        x=abs(spa);
        p=0; pin=[]; ps=[];
        for i=2:length(x)-1
            if (x(i)>=x(i-1)) & (x(i)>=x(i+1))
                if p>0
                    if (i-1)>pin(p)
                        p=p+1;
                        pin(p)=i;
                        ps(p)=x(i);
                    elseif  x(i)>x(i-1)
                        pin(p)=i;   % peak index
                        ps(p)=x(i); % peak size
                    end;
                else
                    p=p+1;
                    pin(p)=i;   % peak index
                    ps(p)=x(i); % peak size
                end
            end
        end
        np=p;


        %maximum
        xx=ps;
        p=0; pinx=[]; psx=[];
        for i=2:np-1
            if (xx(i)>=xx(i-1)) & (xx(i)>=xx(i+1))
                if p>0
                    if (i-1)>pin(p)
                        p=p+1;
                        pinx(p)=i;
                        psx(p)=xx(i);
                    elseif  xx(i)>xx(i-1)
                        pinx(p)=i;   % peak index
                        psx(p)=xx(i); % peak size
                    end;
                else
                    p=p+1;
                    pinx(p)=i;   % peak index
                    psx(p)=xx(i); % peak size
                end
            end
        end
        pinxndx=pin(pinx);

        [nx nn]=hist(psx,120);


        [nxmax,ndxnxmax]=max(nx);
        maxnn=nn(ndxnxmax);
        
        
        %minimum
        p=0; pinxm=[]; psxm=[];
        for i=2:np-1
            if (xx(i)<=xx(i-1)) & (xx(i)<=xx(i+1))
                if p>0
                    if (i-1)>pin(p)
                        p=p+1;
                        pinxm(p)=i;
                        psxm(p)=xx(i);
                    elseif  xx(i)<xx(i-1)
                        pinxm(p)=i;   % peak index
                        psxm(p)=xx(i); % peak size
                    end;
                else
                    p=p+1;
                    pinxm(p)=i;   % peak index
                    psxm(p)=xx(i); % peak size
                end
            end
        end
        pinxmndx=pin(pinxm);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%determine thresholds
 
        %lower threshold
        ndxpsxm=find(psxm<2*maxnn);
        psxmthresh=psxm(ndxpsxm);

        %upper threshold
        %ndxpsx=find(psx>4*maxnn);
        %ndxpsx=find(psx>10);
        ndxpsx=find(psx>thres*mean(x));
        psxthresh=psx(ndxpsx);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        aspa=abs(spa);

        %maxima mit thresholds bestimmen
        spistart=[];spimax=[];spimaxpow=[];spiend=[];spipowi=[];spifrqi=[];
        nspi=0;
        for i=1:length(ndxpsx)
            if i==1
                ndxmaxbef=1:1:pinxndx(ndxpsx(i));
            else
                ndxmaxbef=pinxndx(ndxpsx(i-1)):1:pinxndx(ndxpsx(i));
            end
            ndxminbef=intersect(ndxmaxbef,pinxmndx(ndxpsxm));
            %ndxminbef=intersect(ndxmaxbef,pinxmndx);

            if i==length(ndxpsx)
                ndxmaxaft=pinxndx(ndxpsx(i)):1:length(aspa);
            else
                ndxmaxaft=pinxndx(ndxpsx(i)):1:pinxndx(ndxpsx(i+1));
            end
            ndxminaft=intersect(ndxmaxaft,pinxmndx(ndxpsxm));
            %ndxminaft=intersect(ndxmaxaft,pinxmndx);

            if length(ndxminbef)>0 & length(ndxminaft)>0       %single peak
                nspi=nspi+1;
                spistart(nspi)=ndxminbef(end);
                spimax(nspi)=pinxndx(ndxpsx(i));
                spimaxpow(nspi)=aspa(pinxndx(ndxpsx(i)));
                spiend(nspi)=ndxminaft(1);
            elseif length(ndxminbef)>0 & isempty(ndxminaft)  %multiple peaks start
                nspi=nspi+1;
                spistart(nspi)=ndxminbef(end);
                spimax(nspi)=pinxndx(ndxpsx(i));
                spimaxpow(nspi)=aspa(pinxndx(ndxpsx(i)));
            elseif isempty(ndxminbef) & length(ndxminaft)>0 & nspi>0  %multiple peaks end
                if spimaxpow(nspi)<aspa(pinxndx(ndxpsx(i)))
                    spimax(nspi)=pinxndx(ndxpsx(i));
                    spimaxpow(nspi)=aspa(pinxndx(ndxpsx(i)));
                end
                spiend(nspi)=ndxminaft(1);
            elseif nspi>0                                                                                   %peaks inbetween
                if spimaxpow(nspi)<aspa(pinxndx(ndxpsx(i)))
                    spimax(nspi)=pinxndx(ndxpsx(i));
                    spimaxpow(nspi)=aspa(pinxndx(ndxpsx(i)));
                end
            end
        end

        if nspi>length(spiend)
            nspi=nspi-1;
            spistart=spistart(1:end-1);
        end

        if nspi>0
            for p=1:nspi
                ndxspi=spistart(p):1:spiend(p);
                spipi=intersect(ndxspi,pin);
                spifrqi(p)=length(spipi)/((spiend(p)-spistart(p))/128)/2;
                   spipowi(p)=sum(aspa(ndxspi));
            end
        else
            spifrqi=NaN;
        end
        
%%%%%%%%%%%plot
            
%           
%             cd('D:\Work\reindeer\Analyse_mainexperiment\Data\spindle_detection\all_ch1\pics')
%        
%             close all
%             
%       for ee=79:81%[5,12,130,140,150,160,200,240,300,380,400,500]           
%             
%             see=ee-1;
%             startspi=1+(see-1)*512;
%             stopspi=see*512;
%             startavr=starts(ee)+65;  %correct for overlap
%             stopavr=ends(ee);
%             intndxspi=startspi:1:stopspi;
% 
%             isspistart=intersect(intndxspi,spistart);
%             [isspiend zz endx]=intersect(intndxspi,spiend);
% 
%             figure('Units','characters','Position',[5 5 50 60]) 
%             subplot(211)
%             plot(intndxspi,aspa(startspi:stopspi))
%             hold on
%             plot(pinxmndx,aspa(pinxmndx),'g')
%             hold on
%             plot(pinxndx,aspa(pinxndx),'r')
%             hold on
%             if isempty(isspistart)
%             else
%                 plot(isspistart,aspa(isspistart),'go')
%             end
%             hold on
%             if isempty(isspiend)
%             else
%                 plot(isspiend,aspa(isspiend),'go')
%                 hold on
%                 plot(spimax(endx),spimaxpow(endx),'ro')
%             end
%             title(['channel  ',num2str(channel),'     epoch=',num2str(ee)])
%             axis([intndxspi(1) intndxspi(length(intndxspi)) 0 12])
%             grid
%             ylabel('uV')
%             subplot(212)
%             plot(intndxspi,datar(startavr:stopavr),'k')
%             axis([intndxspi(1) intndxspi(length(intndxspi)) -100 100])
%             hold on
%             if isempty(isspistart)
%             else
%                 for ii=1:length(isspistart)
%                 line([isspistart(ii) isspistart(ii)],[-100 100])
%                 end
%             end
%             hold on
%             if isempty(isspiend)
%             else
%                 for ii=1:length(isspiend)
%                 line([isspiend(ii) isspiend(ii)],[-100 100])
%                 end
%             end
%             grid
%             xlabel('samples')
%             ylabel('uV')
%            % pause
%            
%   
%             
%         saveas(gcf,['spindle_data_rum',num2str(u),'_epo',num2str(ee),'_thres',num2str(thres)],'jpeg') 
%         close all
%      end


%%%%%end plot%%%%%%

                
spistart_v1=spistart(1:end-1);
spistart_v2=spistart(2:end);
spistart_ISI=spistart_v2-spistart_v1;
spistart_ISI_v1=spistart_ISI(1:end-1);
spistart_ISI_v2=spistart_ISI(2:end);
spistart_ISI_var=spistart_ISI_v2-spistart_ISI_v1;
spistart_ISI_var_s=spistart_ISI_var/128;
spistart_ISI_s=spistart_ISI/128;


%spindle(p,channel).density_all=density;


eval(['spindle_t',num2str(thres),'(channel).duration_mn=mean(spiend-spistart)/128;'])
eval(['spindle_t',num2str(thres),'(channel).maxamp_mn=mean(spimaxpow);'])
eval(['spindle_t',num2str(thres),'(channel).spifrq_mn=mean(spifrqi);'])
eval(['spindle_t',num2str(thres),'(channel).spipow_mn=mean(spipowi);'])
eval(['spindle_t',num2str(thres),'(channel).duration_sd=std(spiend-spistart)/128;'])
eval(['spindle_t',num2str(thres),'(channel).maxamp_sd=std(spimaxpow);'])
eval(['spindle_t',num2str(thres),'(channel).spifrq_sd=std(spifrqi);'])
eval(['spindle_t',num2str(thres),'(channel).spipow_sd=std(spipowi);'])
eval(['spindle_t',num2str(thres),'(channel).number_all=nspi;'])
eval(['spindle_t',num2str(thres),'(channel).density_all=nspi/(newepo*epochl/60);'])
eval(['spindle_t',num2str(thres),'(channel).duration_all=(spiend-spistart)./128;'])
eval(['spindle_t',num2str(thres),'(channel).maxamp_all=spimaxpow;'])
eval(['spindle_t',num2str(thres),'(channel).spipow_all=spipowi;'])
eval(['spindle_t',num2str(thres),'(channel).spifrq_all=spifrqi;'])
eval(['spindle_t',num2str(thres),'(channel).spistart=spistart;'])
eval(['spindle_t',num2str(thres),'(channel).spiend=spiend;'])
eval(['spindle_t',num2str(thres),'(channel).spistart_ISI_s=spistart_ISI_s;'])
eval(['spindle_t',num2str(thres),'(channel).spistart_ISI_var=spistart_ISI_var;'])
eval(['spindle_t',num2str(thres),'(channel).spistart_ISI=spistart_ISI;'])
eval(['spindle_t',num2str(thres),'(channel).spistart_ISI_var_s=spistart_ISI_var_s;'])

clear spimaxpow spifrqi spistart spiend spipowi nspi aspa ndxpsxm ndxpsx
% clear spa

end

  
    cd(savepath)
    save([filenames(u).name(1:25),'spindledata_thresh_frq12_15_rum.mat'],'spindle_*','goodepochs','vissymb_cut','newepo','spa','data_all')    
    clear a* b* dataref nch goodepochs v* ndx109 insidendx spindle* spistart*

    
end

