function plotDC(dt,hp1,hp2,rawData)
figure
hold on
aa_splot(dt,HeaterPower,'black','linewidth',1.5);
ylim([hp1, hp2]);
addaxis(dt,CoreTemp,'linewidth',1.5);
addaxis(dt,InnerBlockTemp1);
addaxis(dt,QSupplyVolt);
addaxis(dt,QSupplyPower) ;
addaxis(dt,QSetV);
%addaxis(dt,QCur); 
title(dataFile,'fontsize',11);
addaxislabel(1,'HeaterPower');
addaxislabel(2,'CoreT');
addaxislabel(3,'InnerT');
addaxislabel(4,'QSupply');
addaxislabel(5,'QSupplyVolt'); 
addaxislabel(6,'QSetV'); 
%addaxislabel(7,'QCur');
end