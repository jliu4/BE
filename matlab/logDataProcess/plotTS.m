function plotTS(dt,hp1,hp2,cqp1,cqp2,data,plotTitle,pos,figname,cop,isDC)
fq=figure('Position',pos);
%hold on
aa_splot(dt,data.HeaterPower,'black','linewidth',1.5); 
ylim([hp1, hp2]);
addaxis(dt,data.CoreTemp,[150,420],'linewidth',1.5);

if isDC
  v2=data.QSupplyVolt.*data.QSupplyVolt;
  q = data.QSupplyPower;
  q(q<0.5)=-1;
  r=  v2./q;
  
  addaxis(dt,data.QSupplyPower) ;
  addaxis(dt,r,[0,0.7]);
  %addaxis(dt,data.QSupplyVolt,[0, 2]) ;
else 
   v2 = (data.CoreQV1Rms-data.CoreQV2Rms).*(data.CoreQV1Rms-data.CoreQV2Rms);
   q = data.CoreQPower;
   q(q<0.5)=-1;
   r=v2./q;
    
  addaxis(dt,data.CoreQPower,[cqp1,cqp2]);
  addaxis(dt,r,[0,0.7]);
  %addaxis(dt,data.CoreQV1Rms-data.CoreQV2Rms,[0, 4]) ;
end  
%addaxis(dt,data.InnerBlockTemp1./data.CoreTemp,[0.5,1]); 
if size(cop) == size(dt)
  addaxis(dt,cop,[0.8,1.5]) ;  
end  
%addaxis(dt,data.CoreQV1Rms,[cqp1,cqp2]); 
%addaxis(dt,data.CoreQV2Rms,[cqp1,cqp2]) ;
%addaxis(dt,(data.CoreQV1Rms-data.CoreQV2Rms).*(data.CoreQV1Rms-data.CoreQV2Rms)/coreRes,[cqp1,cqp2]) ;
title(plotTitle,'fontsize',11);
addaxislabel(1,'Heater Power(W)');
addaxislabel(2,'CoreTemp(C)');
addaxislabel(3,'Power(W)');
addaxislabel(4,'R');
%addaxislabel(5,'V');
%addaxislabel(3,'IntT/coreT');
if size(cop) == size(dt)
 addaxislabel(5,'COP'); 
end  
%addaxislabel(4,'CoreQPow(W)'); 
%addaxislabel(4,'V1Rms(Volt)');
%addaxislabel(5,'V2Rms(Volt)'); 
%addaxislabel(7,strcat('(V1-V2)^2/',num2str(coreRes))); 
export_fig(fq,figname,'-append');
end
