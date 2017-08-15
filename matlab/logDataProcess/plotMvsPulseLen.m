function plotMvsPulseLen(pdata,ai,temp1,temp2,ct,pos,figname,tStr)
%pdata = horzcat(coreT', inT', outT', ql', qf', hp', v1', v2', v3',qPow',
%                1       2     3      4    5    6    7    8    9   10
%               termP', pcbP', qSP', qSV', h2',coreQPow');
%                11     12     13    14    15  16
%asignColumn name 

if ct  %use core t   
 uniqCT = unique(int16(pdata(:,1)));
else %use inner t
 uniqCT = unique(int16(pdata(:,2)));
end 
uniqCT(uniqCT>(temp2+3))=[];
uniqCT(uniqCT<(temp1-2))=[];
%assume for each run all temperatures have the same q-pulse length
f(ai) = figure('Position',pos);
   grid on;
   grid minor;
%hold on;
le = [];
i = 0;
for ti = 1:numel(uniqCT) 
 if ct  %use core t   
  tdata = pdata(int16(pdata(:,1)) == uniqCT(ti),:);
 else
  tdata = pdata(int16(pdata(:,2)) == uniqCT(ti),:);
 end 
 tdata = tdata(tdata(:,6) > 1,:); %pick up all rows where hp > 0
 %first pick up no coreQpow, then find the minimun of the hp without
 %coreqpow
 hps0 = min(tdata(tdata(:,16) < 0.1,:));
 %find hps with coreqpow to calculate the hpdrop
 hps = tdata(tdata(:,16) > 0.1,:);
 M = (hps0 - hps(:,6))./hps(:,16);

 if length(M) > 0 
   [M1,i1] = max(M(:,6));
   [M2,i2] = min(M(:,6));
   i = i + 1;
   semilogx(hps(:,4),M(:,6),'-x');
   txt1 = strcat('max=',num2str(M1,'%.2f'), ' at ', num2str(hps(i1,4)),'(ns) ',num2str(hps(i1,14),'%.0f'),'(v)');
   txt2 = strcat('min=',num2str(M2,'%.2f'), ' at ', num2str(hps(i2,4)),'(ns) ',num2str(hps(i2,14),'%.0f'),'(v)');
   x1 = hps(i1,4);
   y1 = M1;
   
   text(x1,y1,txt1)
   %x2 = log10(hps(i2,4));
    x2 = hps(i2,4);
   y2 = M2;
   
   text(x2,y2,txt2)

   %ylim([0 1])
   le{i}=strcat('Temp=',num2str(uniqCT(ti)));   
   hold on
   grid on;
   grid minor;

 end

end
  hold off
   title(tStr);  
   xlabel('Pulse Length(ns)');
   ylabel('Hpdrop/CoreQPow');
   
 legend(le,'Location','northwest');
 export_fig(f(ai),figname,'-append');
end

  

