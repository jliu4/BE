function plotQdebug(dt,data,plotTitle,pos,figname)

fdebug=figure('Position',pos);

%hold on
aa_splot(dt,data.HeaterPower,'black','linewidth',1.5);
addaxis(dt,data.CoreTemp,'linewidth',1.5);
addaxis(dt,smooth(data.OuterBlockTemp1,11));
addaxis(dt,smooth(data.OuterBlockTemp2,11));

%addaxis(dt,smooth(data.TerminationHeatsinkH2OInT,11));
%addaxis(dt,smooth(data.TerminationHeatsinkH2OOutT,11));
addaxis(dt,data.InnerBlockTemp1,'linewidth',1.5);
addaxis(dt,data.QKHz);
addaxis(dt,smooth(data.QCur,11)); 
%addaxis(dt,smooth(data.QSupplyVolt,11));
%addaxis(dt,smooth(data.CalorimeterJacketFlowrateLPM,11));
%addaxis(dt,smooth(data.RoomTemperature,11));
title(plotTitle,'fontsize',11);
addaxislabel(1,'HP');
addaxislabel(2,'CoreT)');
addaxislabel(3,'OuterT1');
addaxislabel(4,'OuterT2');
%addaxislabel(5,'waterInT');
%addaxislabel(6,'waterOutT');
addaxislabel(5,'InnerT');
addaxislabel(6,'QkHz');
addaxislabel(7,'Qcur');
%addaxislabel(8,'QpulseVolt');
%addaxislabel(8,'JacketLPM');
%addaxislabel(6,'RoomT');
export_fig(fdebug,figname,'-append');
end
