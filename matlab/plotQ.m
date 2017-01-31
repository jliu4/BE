function plotQ(dt,hp1,hp2,qp1,qp2,cqp1,cqp2,data,plotTitle,pos,figname)
fq=figure('Position',pos);
%hold on
aa_splot(dt,data.HeaterPower,'black','linewidth',1.5); 
ylim([hp1, hp2]);
addaxis(dt,data.CoreTemp,'linewidth',1.5); 
addaxis(dt,data.QPow,[qp1,qp2]); 
%addaxis(dt,data.CoreQPower,[cqp1,cqp2]) ;
addaxis(dt,data.CoreQV1Rms,[cqp1,cqp2]); 
addaxis(dt,data.CoreQV2Rms,[cqp1,cqp2]) ;
%addaxis(dt,(data.CoreQV1Rms-data.CoreQV2Rms).*(data.CoreQV1Rms-data.CoreQV2Rms)/coreRes,[cqp1,cqp2]) ;
title(plotTitle,'fontsize',11);
addaxislabel(1,'Heater Power(W)');
addaxislabel(2,'CoreTemp(C)');
addaxislabel(3,'QPow(W)');
%addaxislabel(4,'CoreQPow(W)'); 
addaxislabel(4,'V1Rms(Volt)');
addaxislabel(5,'V2Rms(Volt)'); 
%addaxislabel(7,strcat('(V1-V2)^2/',num2str(coreRes))); 
export_fig(fq,figname,'-append');
end
