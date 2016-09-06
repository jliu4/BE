clear all;close all
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')

%looking at Berkeley HHT
SYS = 'BEC Core B37';
Directory='C:\jinwork\BEC\data\ConF00_copy\2016-07-21';
AllFiles = getall(Directory);  %SORTED BY DATE....
Experiment = AllFiles(1:2);
Experiment'

loadHHT 
%startTime 8/12/2016 17:30 assume 11.5*360
%endTime 8/15/2016 17 assume (8/12-8/15) 24*4 - 16

%change a few messy variable names
QOccurred = QOccurred0x3F; clear QPulseOccurred0x3F
QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29
QPulseDelays = QPulseDelay0x28s0x29; clear QPulseDelay0x28s0x29
QkHz = QKHz; clear QKHz;
dateN=datenum(DateTime,'mm/dd/yyyy HH:MM:SS');
reltime=24*(dateN-dateN(1)); %in days*24 = hours
titletxt=strcat('BEC HHT test from ',DateTime(1),' through ',DateTime(end)); %how to keep trailing spaces?
qi=find(QOccurred == 1);


%check for alarms!
ALARM = find(ActiveAlarmBits ~= 0);
if length(ALARM) > 0
    AS = {'ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM'};
    disp(AS)
    
    figure
    plot(dateN,ActiveAlarmBits,'.-')
    grid
   title('ActiveAlarmBits')
    datetick('x','keeplimits')
else
end

figure
%figure 1
plot(dateN,x61602FreqHz,'.-') %put this in because SRI system changed
hold
plot(dateN, 250*(ActiveAlarmBits/1.0000e+09),'r.-')
grid
ylim([0 250])
title('Chroma Frequency')
legend('Chroma frequency','Active alarm bits (scaled)')
ylabel('Frequency (Hz)')
datetick('x','mm/dd','keeplimits')


%calc of Q power
Qcalc = QPulseVolt.*QCur;
QPow_orig = QPow;

figure
%figure 2
plot(dateN,Qcalc,'r')
hold on
plot(dateN,QPow_orig)
plot(dateN(qi),QPow(qi),'k.')
grid
legend('QPow (Calc)','QPow','Qon')
datetick('x','mm/dd','keeplimits')
ylabel('Q Power (W)')
title('calc of Q Pow')


figure
%figure 3
plot(dateN,QPow)
hold on
plot(dateN,TerminationThermPow,'r')
grid
title('Q Power before and after core')
legend('Q Power at pi filter','Termination Therm Pow')
ylabel('Power (W)')
datetick('x','mm/dd','keeplimits')

figure
hold all
plot(dateN,CoreOutH2,'r','linewidth',2)
plot(dateN,CoreOutHe,'b','linewidth',2)
plot(dateN,CoreOutAr,'g','linewidth',2)
plot(dateN,CoreOutH2O,'c','linewidth',2)
plot(dateN,CoreOutO2,'m','linewidth',2)
plot(dateN,CoreOutN,'k','linewidth',2)
grid
legend('H2','He','Ar','H2O','O2','N')
title([SYS,' HHT ',DateTime{1},' through ',DateTime{end}],'fontsize',11)
ylabel('Core Out Gas')
datetick('x','mm/dd','keeplimits')

figure
%figure 4
plot(dateN,CoreOutPress,'linewidth',2)
grid
datetick('x','mm/dd','keeplimits')
ylabel('Core Out Pressure')
title([SYS,' HHT ',DateTime{1},' through ',DateTime{end}],'fontsize',11)


figure
%figure 6
plot(dateN,InnerCoreTemp,'r','linewidth',2)
grid
hold on
plot(dateN,CoreReactorTemp,'b','linewidth',2)
ylabel('Core Temp (degC)')
datetick('x','mm/dd','keeplimits')
title([SYS,' HHT ',DateTime{1},' through ',DateTime{end}],'fontsize',11)
legend('Inner Core Temp','Core Reactor Temp')

figure
hold on
aa_splot(dateN,InnerCoreTemp-CoreReactorTemp,'linewidth',2)
addaxis(dateN,CoreReactorTemp,'linewidth',2)
addaxis(dateN,CoreOutAr,[0 1200],'linewidth',2)
addaxis(dateN,CoreOutHe,[0 1200],'linewidth',2)
addaxis(dateN,CoreOutH2,[0 1200],'linewidth',2)
addaxis(dateN,QOccurred,[0.5 1],'*')
legend('Inner-Core Temp','Core Temperature)','Core Ar','Core He','Core H2','Q Occurred')
grid on
datetick('x','mm/dd','keeplimits')
%set(gca,'XTick',[0:hpt:round(reltime(end))])
title([SYS,' Q Parameters, ',DateTime{1},' through ',DateTime{end}],'fontsize',11)
addaxislabel(1,'Inner-Core Temp (degC)');
addaxislabel(2,'Core Temp (degC)');
addaxislabel(3,'Core Gas');

figure
hold on
aa_splot(dateN,QPow,'linewidth',2)
yi=ylim;
addaxis(dateN,InnerCoreTemp,'linewidth',2)
addaxis(dateN(qi),QPow(qi),yi,'.')
addaxis(dateN,CoreReactorTemp,'linewidth',2)
addaxis(dateN,CoreHtrPow,'linewidth',2)
addaxis(dateN,CoreGasOut,'linewidth',2)
legend('QPow','InnerCoreTemp','QPow (only with Q on)','CoreReactorTemp','Heater Power','CoreGasOut')
grid on
datetick('x','mm/dd','keeplimits')
title([SYS,' HHT Parameters, ',DateTime{1},' through ',DateTime{end}],'fontsize',11)
addaxislabel(1,'QPow(W)');
addaxislabel(2,'Inner Core Temp (degC)');
addaxislabel(3,'Q on)');
addaxislabel(4,'Core Reactor Temp (degC)');
addaxislabel(5,'Core Heater Power (W)');
addaxislabel(6,'Core Gas Out');


DTjacketgas = JacketGasOut-JacketGasIn;
DTjckXCH = JCKTXCH2OOUT - JCKTXCH2OIN;
DTcoreRm = CoreGasOut - RoomTemp;

figure
plot(dateN,DTjacketgas,'linewidth',2)
hold on
plot(dateN,DTjckXCH,'g','linewidth',2)
plot(dateN,DTcoreRm,'r','linewidth',2)
title([SYS,' HHT ',DateTime{1},' through ',DateTime{end}],'fontsize',11)
grid on
legend('Jacket Gas (out-in)','Jacket XCH (out-in)','CoreGas-Room Temp')
ylabel('Temp difference (degC)')
datetick('x','mm/dd','keeplimits')

figure
hold on
aa_splot(dateN,QkHz,'linewidth',2)
ylim([0 120])
addaxis(dateN,CoreReactorTemp,'linewidth',2)
%addaxis(dateN,QPulseDelays,'linewidth',2)
addaxis(dateN,QPulseLengthns,'linewidth',2)
addaxis(dateN,QNPulses,'linewidth',2)
addaxis(dateN,QPulseVolt,'linewidth',2)
addaxis(dateN,QOccurred,[0 1],'*')
legend('Q freq (kHz)','Core Reactor Temp','Pulse length (ns)','N Pulses','QPulseVolt (V)','Q Occurred')
grid on
datetick('x','mm/dd','keeplimits')
title([SYS,' Q Parameters, ',DateTime{1},' through ',DateTime{end}],'fontsize',11)
addaxislabel(1,'Q frequency (kHz)');
%addaxislabel(2,'Q pulse delay (sec)');
addaxislabel(2,'Core Temp (degC)');
addaxislabel(3,'Q pulse length (ns)');
addaxislabel(4,'# Q pulses');
addaxislabel(5,'Q Pulse Volt (V)');


