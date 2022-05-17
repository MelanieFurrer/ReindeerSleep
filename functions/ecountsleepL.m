function [sleepdura, sleeph]=ecountsleepL(STD)


d=length(STD);

sleeph=length(find(STD=='n' | STD=='2' | STD=='t' | STD=='4' | STD=='r' | STD=='3'))/900;


sleepdura=[];
epoch=0;
 while epoch<d
    epoch=epoch+1;
    if STD(epoch)=='n' | STD(epoch)=='2' | STD(epoch)=='t' | STD(epoch)=='4' | STD(epoch)=='r' | STD(epoch)=='3'
        ncount=1; starte=epoch; stope=epoch; xcount=0;
        abort=0;
        
        for i=1:150
            no_nrem(i)=epoch;
        end
        
        while epoch<d & abort==0
            epoch=epoch+1;

            if STD(epoch)=='n' | STD(epoch)=='2' | STD(epoch)=='t' | STD(epoch)=='4' | STD(epoch)=='r' | STD(epoch)=='3'
                ncount=ncount+1;
                stope=epoch;
            else
                xcount=xcount+1;
                no_nrem(xcount)=epoch;          
            end  

            if xcount>=74 & no_nrem(xcount)-no_nrem(xcount-73)==73 %%%%%changed no_wak into no_nrem
                abort=1;
            elseif xcount>1800
                abort=1;
            end
        end 
        nremdur=(stope+1)-starte;
        if ncount>74
            nreminfo=[nremdur starte stope];
            sleepdura=[sleepdura;nreminfo];
        end
    end   
 end



end