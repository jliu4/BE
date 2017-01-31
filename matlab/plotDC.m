function plotDC(dt,hp1,hp2,data,plotTitle,pos,figname)
fdc=figure('Position',pos);
%hold on
aa_splot(dt,data.HeaterPower,'black','linewidth',1.5);
ylim([hp1, hp2]);
addaxis(dt,data.CoreTemp,'linewidth',1.5);
addaxis(dt,data.InnerBlockTemp1);
addaxis(dt,data.QSupplyVolt);
addaxis(dt,data.QSupplyPower) ;
addaxis(dt,data.QSetV);
%addaxis(dt,QCur); 
title(plotTitle,'fontsize',11);
addaxislabel(1,'HeaterPower');
addaxislabel(2,'CoreT');
addaxislabel(3,'InnerT');
addaxislabel(4,'QSupply');
addaxislabel(5,'QSupplyVolt'); 
addaxislabel(6,'QSetV'); 
%addaxislabel(7,'QCur');
export_fig(fdc,figname,'-append');
end