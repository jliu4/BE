function plotMultiQ(data,plotTitle)
n=size(data,1);
x=[1:1:n];
aa_splot(x,data.HeaterPower,'black','linewidth',1.5); 
ylim([hp1, hp2]);
addaxis(x,data.CoreTemp,[220,350],'linewidth',1.5); 
%addaxis(dt,data.QPow,[qp1,qp2]); 
addaxis(x,data.CoreQPower,[cqp1,cqp2]) ;
addaxis(x,data.CoreQV3Rms,[cqp1,cqp2]); 
%addaxis(dt,data.CoreQV2Rms,[cqp1,cqp2]) ;
%addaxis(dt,(data.CoreQV1Rms-data.CoreQV2Rms).*(data.CoreQV1Rms-data.CoreQV2Rms)/coreRes,[cqp1,cqp2]) ;
title(plotTitle,'fontsize',11);
addaxislabel(1,'Heater Power(W)');
addaxislabel(2,'CoreTemp(C)');
%addaxislabel(3,'CoreQPow(W)');
addaxislabel(3 ,'V3'); 
%addaxislabel(4,'V1Rms(Volt)');
%addaxislabel(5,'V2Rms(Volt)'); 
%addaxislabel(7,strcat('(V1-V2)^2/',num2str(coreRes))); 

end
