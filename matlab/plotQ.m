function plotQ(hp1,hp2,qp1,qp2,cqp1,cqp2,coreRes)
figure(1)
hold on
aa_splot(dt,HeaterPower,'black','linewidth',1.5); 
ylim([hp1, hp2]);
addaxis(dt,CoreTemp,'linewidth',1.5); 
addaxis(dt,QPow,[qp1,qp2]); 
addaxis(dt,CoreQPower,[cqp1,cqp2]) ;
addaxis(dt,CoreQV1Rms,[cqp1,cqp2]); 
addaxis(dt,CoreQV2Rms,[cqp1,cqp2]) ;
addaxis(dt,(CoreQV1Rms-CoreQV2Rms).*(CoreQV1Rms-CoreQV2Rms)/coreRes,[cqp1,cqp2]) ;
title(dataFile,'fontsize',11);
addaxislabel(1,'Heater Power(W)');
addaxislabel(2,'CoreTemp(C)');
addaxislabel(3,'QPow(W)');
addaxislabel(4,'CoreQPow(W)'); 
addaxislabel(5,'V1Rms(Volt)');
addaxislabel(6,'V2Rms(Volt)'); 
addaxislabel(7,strcat('(V1-V2)^2/',num2str(coreRes))); 
end
