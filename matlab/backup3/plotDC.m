function plotDC(dt,hp1,hp2,data,plotTitle,pos,figname,cop)
fdc=figure('Position',pos);
%hold on
aa_splot(dt,data.HeaterPower,'black','linewidth',1.5);
ylim([hp1, hp2]);
addaxis(dt,data.CoreTemp,'linewidth',1.5);
%addaxis(dt,data.InnerBlockTemp1);
%addaxis(dt,data.QSupplyVolt);
addaxis(dt,data.QSupplyPower) ;
if size(cop) == size(dt)
   addaxis(dt,cop,[0.8,1.5]) ;
end   
title(plotTitle,'fontsize',11);
addaxislabel(1,'HeaterPower');
addaxislabel(2,'CoreT');
%addaxislabel(3,'InnerT');
addaxislabel(3,'QSupply');
if size(cop) == size(dt)
  addaxislabel(4,'COP');
end  
%addaxislabel(5,'QSupplyVolt'); 
export_fig(fdc,figname,'-append');
end