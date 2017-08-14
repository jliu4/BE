function plotTS(dt,hp1,hp2,cqp1,cqp2,ct1,ct2,data,plotTitle,pos,figname,cop,isDC,version,coreL,termRes)
fq=figure('Position',pos);
aa_splot(dt,data.HeaterPower,'black','linewidth',1.5); 
ylim([hp1, hp2]);
if isDC
  v2=data.QSupplyVolt.*data.QSupplyVolt;
  q = data.QSupplyPower;
  q(q<0.5)=-1;
  r=  v2./q; 
  addaxisplot(dt,data.QSupplyPower,1,'--','color',[0.502 0.251 0],'linewidth',1.5);

  addaxis(dt,r,[0,0.5]);
  %addaxis(dt,data.QSupplyVolt,[0, 2]) ;
else 
   
   pUp = data.QPow - data.CoreQV2Rms.*data.CoreQV2Rms/termRes; 
   pUp2 = data.QPow - data.TerminationHeatsinkPower-data.QPulsePCBHeatsinkPower;
   %
   addaxisplot(dt,pUp,1,'color','m');
   addaxisplot(dt,smooth(pUp2,12),1,'--');
   addaxisplot(dt,data.CoreQPower,1,'linewidth',2);
   v2 = (data.CoreQV1Rms-data.CoreQV2Rms).*(data.CoreQV1Rms-data.CoreQV2Rms);
   q = data.CoreQPower;
   q(q<0.5)=-1;
   r=v2./q; 
   addaxis(dt,r,[0,0.5]);

  if version > 188 
    c =(coreL*0.0847253)./data.CoreTOFns;
    addaxisplot(dt,smooth(c,20),2,'--') ;
  end  
end 
addaxis(dt,data.CoreTemp,[ct1,ct2],'color','r','linewidth',1.5);
addaxisplot(dt,data.InnerBlockTemp1,3,'--');
addaxis(dt,data.CoreQV1Rms,[cqp1,cqp2]); %light purple
addaxisplot(dt,data.CoreQV2Rms,4,'--'); %light purple
%addaxisplot(dt,data.CoreQV3Rms,4,':'); %light purple

%addaxis(dt,data.InnerBlockTemp1./data.CoreTemp,[0.5,1]); 
if false size(cop) == size(dt)
 addaxis(dt,cop,[0.8,1.5]) ;  
end  
%addaxis(dt,data.CoreQV1Rms,[cqp1,cqp2]); 
%addaxis(dt,data.CoreQV2Rms,[cqp1,cqp2]) ;
%addaxis(dt,(data.CoreQV1Rms-data.CoreQV2Rms).*(data.CoreQV1Rms-data.CoreQV2Rms)/coreRes,[cqp1,cqp2]) ;
title(plotTitle,'fontsize',11);
addaxislabel(1,'Hp-CoreQPowUpBound-CoreQPow(w)');
%addaxislabel(1,'Hp - CoreQPow[w]');
addaxislabel(2,'R[ohm] - c');
%addaxislabel(5,'coreQPowUpbound');
addaxislabel(3,'coreT - innerT');
addaxislabel(4,'v1 - v2[v]');
%legend('hp','coreQpowUpBound','P-term','coreQPow','R','c','coreT','innerT','v1','v2','v3','Location','northwest');
legend('hp','pi-v2^2/r','pi-term-pcb','coreQPow','R','c','coreT','innerT','v1','v2','Location','northwest');
if false && size(cop) == size(dt)
 addaxislabel(5,'COP'); 
end  
%if isDC==false && version > 188
%  addaxislabel(3,'c');
%end  
%addaxislabel(4,'CoreQPow(W)'); 
%addaxislabel(4,'V1Rms(Volt)');
%addaxislabel(5,'V2Rms(Volt)'); 
%addaxislabel(7,strcat('(V1-V2)^2/',num2str(coreRes))); 
export_fig(fq,figname,'-append');

png2 = strcat(strrep(plotTitle,'\','-'),'.png');
pngfile = strrep(figname, '.pdf', png2);
export_fig(fq,pngfile,'-append'); 
end
