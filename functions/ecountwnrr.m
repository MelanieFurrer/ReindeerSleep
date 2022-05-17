function [wakdura,nremdura,remdura,rumdura,ba,baa]=ecountwnrr(STD)

%[wakdura nremdura remdura ba]=ecountwnr(STD);
%    mwakdur=mean(wakdura(:,1))/15;
%    mwaknum=length(wakdura(:,1));
%    mnremdur=mean(nremdura(:,1))/15;
%    mnremnum=length(nremdura(:,1));
%    mremdur=mean(remdura(:,1))/15;
%    mremnum=length(remdura(:,1));
%    ba=brief awakenings

d=length(STD);
% if d<21600
%     STD(d+1:21600)='a';
% end

sleeph=length(find(STD=='n' | STD=='2'))/900;



nremdura=[];
epoch=0;
while epoch<d
    epoch=epoch+1;
    if STD(epoch)=='n' | STD(epoch)=='2'
        ncount=1; starte=epoch; stope=epoch; xcount=0; rcount=0;
        before='n'; after='u';
        abort=0;
        for i=1:60
            no_nrem(i)=epoch;
            rem(i)=epoch;
        end
        while epoch<d & abort==0
            epoch=epoch+1;
            if (before=='n' | before=='2') & (STD(epoch)=='n' | STD(epoch)=='2')
                after=STD(epoch);
            end
            if STD(epoch)=='n' | STD(epoch)=='2'
                ncount=ncount+1;
                stope=epoch;
            else
                xcount=xcount+1;
                no_nrem(xcount)=epoch;
                if STD(epoch)=='r' | STD(epoch)=='3'
                   rcount=rcount+1;
                   rem(rcount)=epoch;
                end
            end  
            before=STD(epoch);
            if xcount>14 & no_nrem(xcount)-no_nrem(xcount-13)==13  % max. 1 min breaks allowed
                abort=1;
            elseif rcount>7 & rem(rcount)-rem(rcount-6)==6 % if there is at least 30 sec rem, episode is also terminated
                abort=1;
            elseif xcount>149  % in total not more than 10 min breaks
                abort=1;
            end
        end 
        nremdur=(stope+1)-starte;
        if ncount>14 & after~='a'  % save only episodes that are at least 1 min long
            nreminfo=[nremdur starte stope];
            nremdura=[nremdura;nreminfo];
        end
    end   
end




rumdura=[];
epoch=0;
clear rem
while epoch<d
    epoch=epoch+1;
    if STD(epoch)=='t' | STD(epoch)=='4'
        rumcount=1; starte=epoch; stope=epoch; xcount=0; rcount=0;
        before='t'; after='u';
        abort=0;
        for i=1:60
            no_rum(i)=epoch;
            rem(i)=epoch;
        end
        while epoch<d & abort==0
            epoch=epoch+1;
            if (before=='t' | before=='4') & (STD(epoch)=='t' | STD(epoch)=='4')
                after=STD(epoch);
            end
            if STD(epoch)=='t' | STD(epoch)=='4'
                rumcount=rumcount+1;
                stope=epoch;
            else
                xcount=xcount+1;
                no_rum(xcount)=epoch;
                if STD(epoch)=='r' | STD(epoch)=='3'
                   rcount=rcount+1;
                   rem(rcount)=epoch;
                end
            end  
            before=STD(epoch);
            if xcount>14 & no_rum(xcount)-no_rum(xcount-13)==13 % max. 1 min breaks allowed
                abort=1;
            elseif rcount>7 & rem(rcount)-rem(rcount-6)==6 % if there is at least 30 sec rem, episode is also terminated
                abort=1;
            elseif xcount>149  % in total not more than 10 min breaks
                abort=1;
            end
        end 
        rumdur=(stope+1)-starte;
        if rumdur>14 & after~='a' % save only episodes that are at least 1 min long
            ruminfo=[rumdur starte stope];
            rumdura=[rumdura;ruminfo];
        end
    end   
end




% max. 20 epochen an Unterbrechungen, max. 4 epochen am Stück Unterbrechung
remdura=[];
epoch=0;
while epoch<d
    epoch=epoch+1;
    if STD(epoch)=='r' | STD(epoch)=='3'
        rcount=1; starte=epoch; stope=epoch; xcount=0;
        abort=0;
        for i=1:20
            norem(i)=epoch;
        end
        while epoch<d & abort==0
            epoch=epoch+1;
            if STD(epoch)=='r' | STD(epoch)=='3'
                rcount=rcount+1;
                stope=epoch;
            else
                xcount=xcount+1;
                norem(xcount)=epoch;
            end  
            if xcount>7 & norem(xcount)-norem(xcount-6)==6 % max. 30 sec breaks allowed
                abort=1;
            elseif xcount>20
                abort=1;
            end
        end 
        remdur=(stope+1)-starte;
        reminfo=[remdur starte stope];
        remdura=[remdura;reminfo];
    end  
end

%%%%%avoid overlap of episodes%%%%%
STDw=STD;
for t=1:length(nremdura)
STDw(nremdura(t,2):nremdura(t,3))='n';
end
for t=1:length(remdura)
STDw(remdura(t,2):remdura(t,3))='r';
end
for t=1:length(rumdura)
STDw(rumdura(t,2):rumdura(t,3))='t';
end
%%%%%%%%%%%%%%%%%%%%%%%%


    wakdura=[];
baa=[];
bacount=0;
epoch=0;
while epoch<d
    epoch=epoch+1;
    if STDw(epoch)=='w' | STDw(epoch)=='1' | STDw(epoch)=='0'
        wcount=1; starte=epoch; stope=epoch; xcount=0; ncount=0; rcount=0;
        abort=0;
        for i=1:60
            no_wak(i)=epoch;
            nrem(i)=epoch;
            rem(i)=epoch;
        end
        while epoch<d & abort==0
            epoch=epoch+1;
            if STDw(epoch)=='w' | STDw(epoch)=='1'
                wcount=wcount+1;
                stope=epoch;
            else
                xcount=xcount+1;
                no_wak(xcount)=epoch;
                    if STDw(epoch)=='n' | STDw(epoch)=='2'
                       ncount=ncount+1;
                       nrem(ncount)=epoch;
                       
                    elseif STD(epoch)=='r' | STD(epoch)=='3'
                       rcount=rcount+1;
                       rem(rcount)=epoch;
                    end
            end  
                if xcount>14 & no_wak(xcount)-no_wak(xcount-13)==13 % max. 1 min breaks allowed
                    abort=1;
                elseif rcount>=1 & rem(rcount)-rem(rcount)==0
                    abort=1;
                elseif xcount>=149
                    abort=1;
                end
        end 
        wakdur=(stope+1)-starte;
        if wakdur>14
            wakinfo=[wakdur starte stope];
            wakdura=[wakdura;wakinfo];
        elseif wakdur<=4
            bacount=bacount+1;
            baa=[baa starte];
        end
    end   
end

ba=bacount/sleeph;
end

