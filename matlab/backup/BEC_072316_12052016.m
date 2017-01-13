% Initial housekeeping
clear; close all
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%looking at Berkeley HHT
SYS = 'SRI-IPB2-27b-H2';
hpt = 2 %how many hours per tick mark in graphs...
%Directory='C:\Users\jen_g\Data\ConF00_copy\2016-07-21';
Directory='C:\Users\Owner\Dropbox (BEC)\SRI-IPB2\2016-11-16_SRI_v174-core27b';
AllFiles = getall(Directory);  %SORTED BY DATE....
%Experiment = AllFiles(2:8);
Experiment = AllFiles(17:18);

loadHHT 
%change a few messy variable names
QOccurred = QOccurred0x3F; clear QPulseOccurred0x3F
QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29

QkHz = QKHz; clear QKHz;
dateN=datenum(DateTime,'mm/dd/yyyy HH:MM:SS');
reltime=24*(dateN-dateN(1)); %in days*24 = hours
titletxt=strcat('BEC HHT test from ',DateTime(1),' through ',DateTime(end)); %how to keep trailing spaces?
qi=find(QOccurred == 1);
Range = [1:length(SeqStepNum>0)];
figure
dt = datetime(dateN(Range), 'ConvertFrom', 'datenum') ;
plot(dt,CoreQPower(Range),'r')
hold on
plot(dt,QPow(Range))
grid
legend('coreQPow','QPow')
%datetick('x','mm/dd/hh','keeplimits')
ylabel('Q Power (W)')
title('Q Pow')
figure
plotyy(reltime,QPow - TerminationHeatsinkPower,reltime, HeaterPower)
grid
legend('QPow-Term','Heater Power')
%check for alarms!
ALARM = find(ActiveAlarmBits ~= 0);
if length(ALARM) > 0
    AS = {'ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM'};
    disp(AS)    
    figure
    plot(dateN,ActiveAlarmBits,'.-')
    grid
    title('AlarmActiveBits')
    axis auto
    datetick('x','keeplimits')
else
end
figure
hold all
plot(dt,CoreTemp,'linewidth',2)
plot(dt,InnerBlockTemp1,'linewidth',2)
%plot(dateN,CoreQV2Rms,'linewidth',2)
%plot(dateN,CoreOutH2O,'linewidth',2)
%plot(dateN,CoreOutO2,'linewidth',2)
grid
legend('Core Temp','Inner Temp')
%datetick('x','mm/dd','keeplimits')
title([SYS,' HHT Core Gas Out ',DateTime{1},' through ',DateTime{end}],'fontsize',11)

figure
hold on
aa_splot(dateN(Range),QPow(Range),'linewidth',2)
addaxis(dateN(Range),QPulseLengthns(Range),'linewidth',2)
addaxis(dateN(Range),QPulseVolt(Range),'linewidth',2)
addaxis(dateN(Range),QSupplyVolt(Range),'linewidth',2)
addaxis(dateN(Range),QkHz(Range),'linewidth',2)
legend('Q Power (W)','Pulse length (ns)','QPulseVolt','QSupplyVolt (Chroma)','Q Frequency')
grid on
xlabel('Date')
datetick('x','mm/dd MM:HH','keeplimits')
title([SYS,' Q Parameters, ',DateTime{1},' through ',DateTime{end}],'fontsize',11)
addaxislabel(1,'Q Power (W)');
addaxislabel(2,'Q pulse length (ns)');
addaxislabel(3,'Q Pulse Volt (V)');
addaxislabel(4,'Q Supply Volt (V)');
addaxislabel(5,'Q Frequency (kHz))');

figure
[gAx,gLine1,gLine2] = plotyy(dateN(Range),QPow(Range),dateN(Range),TerminationHeatsinkPower(Range))
grid
legend('P-pi',' Term')
ylabel(gAx(1),'Q Power (W)') % left y-axis
ylabel(gAx(2),'Term Therm Pow (W)') % right y-axis
title([SYS,DateTime{1},' through ',DateTime{end}],'fontsize',11)
linkaxes(gAx,'x');
set(gAx(2),'XTickLabel',[]);
xlabel(gAx(1),'Date') % left y-axis
datetick('x','mm/dd MM:HH','keeplimits')

figure
hold on
aa_splot(dateN(Range),QPow(Range))
addaxis(dateN(Range),CoreTemp(Range))
addaxis(dateN(Range),TerminationHeatsinkPower(Range),[0 30])
addaxis(dateN(Range),HeaterPower(Range))
grid
legend('P-pi','Inner Core Temp',' Term','e','P-heater')
addaxislabel(1,'Q Power (W)');
addaxislabel(2,'Inner Core Temp (degC)');
addaxislabel(3,'Term Therm Power (W)');
addaxislabel(4,'Core Heater Power (W)');
title([SYS,' HHT,',DateTime{1},' through ',DateTime{end}],'fontsize',11)
datetick('x','mm/dd MM:HH','keeplimits')

%inH2 = find(CoreOutH2 > 10);
%inHe = find(CoreOutHe > 10);
daystart = DateTime(Range(1))
dayend = DateTime(Range(end))
startDate = datenum(daystart);
endDate = datenum(dayend);


stepsize = 0.5; %30 mins
StepParam = SeqStepNum;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% first shorten the variables needed in loop
mData.DN = dateN(Range);

mData.HP = HeaterPower(Range);
mData.CT = CoreTemp(Range);
mData.OBT = OuterBlockTemp1(Range);
mData.IBT = InnerBlockTemp1(Range);
mData.QP = QPow(Range);

mData.CQP = CoreQPower(Range);
mData.Qkhz = QkHz(Range);
mData.QPLns = QPulseLengthns(Range);
mData.SP = StepParam(Range); %step parameter
mData.R = Range;
mData.QSV = QSupplyVolt(Range);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Results = getavgJL(mData, stepsize);
hold on
plot(dateN(inH2),30*ones(1,length(inH2)),'r*')
plot(dateN(inHe),30*ones(1,length(inHe)),'c*')
title([SYS,' - ',DateTime{Range(1)},' through ',DateTime{Range(end)},', Core in H2(red) & He(cyan)'],'fontsize',11)
xData = linspace(startDate,endDate,10);  %can make more this way...
set(gca,'XTick',xData) %set number of ticks to number of points in xData
datetick('x','HHAM','keepticks')
xlabel([datestr(startDate,'mm/dd HHAM'),' through ',datestr(endDate,'mm/dd HHAM')])

coreH2 = find(Results.H2 == 1);
coreHe = find(Results.He == 1);

figure
plot(Results.dateS(coreHe),Results.mPout(coreHe)-Results.mPin(coreHe),'b.-')
hold on
plot(Results.dateS(coreH2),Results.mPout(coreH2)-Results.mPin(coreH2),'r.-')
grid
title('Power OUT-IN for He(blue) and H2(red)')
set(gca,'XTick',xData) %set number of ticks to number of points in xData
datetick('x','HHAM','keepticks')
xlabel([datestr(startDate,'mm/dd HHAM'),' through ',datestr(endDate,'mm/dd HHAM')])

