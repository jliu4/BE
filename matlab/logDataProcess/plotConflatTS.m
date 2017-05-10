function plotConflatTS(dt,hp1,hp2,data,plotTitle,pos,figname)
fq=figure('Position',pos);
%hold on
aa_splot(dt,data.HeaterPower,'black','linewidth',1.5); 
ylim([hp1, hp2]);
addaxis(dt,data.CoreTemp,'linewidth',1.5);

addaxis(dt,data.QPow);
title(plotTitle,'fontsize',11);
addaxislabel(1,'Heater Power(W)');
addaxislabel(2,'CoreTemp(C)');
addaxislabel(3,'Power(W)');

%addaxislabel(5,'V');
%addaxislabel(3,'IntT/coreT');

%addaxislabel(4,'CoreQPow(W)'); 
%addaxislabel(4,'V1Rms(Volt)');
%addaxislabel(5,'V2Rms(Volt)'); 
%addaxislabel(7,strcat('(V1-V2)^2/',num2str(coreRes))); 
export_fig(fq,figname,'-append');
end
