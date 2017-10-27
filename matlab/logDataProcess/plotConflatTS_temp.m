function plotConflatTS_temp(dt,hp1,hp2,ct1,ct2,data,plotTitle,pos,figname)
fq=figure('Position',pos);
%hold on

aa_splot(dt,data.InnerCoreTemp,'k','linewidth',1.5);
ylim([ct1, ct2]);
addaxisplot(dt,data.CoreTemp,1,'--','color','k');
addaxis(dt,data.HeaterPower,[hp1, hp2],'color','r','linewidth',1.5);
addaxis(dt,data.QPow);
addaxis(dt,data.CoreResistance);

title(plotTitle,'fontsize',11);
addaxislabel(2,'Heater Power(W)');
addaxislabel(1,'CoreTemp-InnerT(C)');
addaxislabel(3,'Power(W)');
addaxislabel(4,'CoreResistance');

%addaxislabel(5,'V');
%addaxislabel(3,'IntT/coreT');

%addaxislabel(4,'CoreQPow(W)'); 
%addaxislabel(4,'V1Rms(Volt)');
%addaxislabel(5,'V2Rms(Volt)'); 
%addaxislabel(7,strcat('(V1-V2)^2/',num2str(coreRes))); 
export_fig(fq,figname,'-append');
end
