%BEC HHT core B13
%
% 2016-05-04
% 8:15 starting last part of disrupted sweep Sequence001D240—VAC.csv again but with Q supply enabled!
% 13:00 starting last part of disrupted sweep Sequence001D240—VAC.csv again but with Q supply enabled and set to 1/2H so we actually get a Q pulse!!!!!
% 
% 2016-05-04
% 10:41 started sequence file Sequence001D260--VAC@650C.csv.

clear all;close all
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')

% note: changed on 3/4/16 to replace TerminationThermPow and QPow with calculations
% of those parameters. 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%looking at Berkeley HHT
SYS = 'BEC Core B37';
hpt = 24 %how many hours per tick mark in graphs...
Directory='C:\jinwork\BEC\data\ConF00_copy\2016-07-21';
AllFiles = getall(Directory);  %SORTED BY DATE....
Experiment = AllFiles([4:7]);%(9:22);
Experiment'

loadHHT 
%change a few messy variable names
QOccurred = QOccurred0x3F; clear QPulseOccurred0x3F
QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29
QPulseDelays = QPulseDelay0x28s0x29; clear QPulseDelay0x28s0x29
QkHz = QKHz; clear QKHz;
dateN=datenum(DateTime,'mm/dd/yyyy HH:MM:SS');
%startTime 8/12/2016 17:30 assume 11*360
%endTime 8/15/2016 17 assume (8/12-8/15) 24*4 - 12
DateTime(11*360)
DateTime(end - 12*360)

reltime=24*(dateN-dateN(1)); %in days*24 = hours
%titletxt=strcat('BEC HHT test from ',DateTime(11*360),' through ',DateTime(end - 12*360)); %how to keep trailing spaces?
titletxt=strcat('BEC HHT test from ',DateTime(1),' through ',DateTime(end)); %how to keep trailing spaces?
qi=find(QOccurred == 1);
cd('C:\jinwork\BEC\Data\MatlabTempData')
save BEC_081616 %used to be BEC_051016
%%
clear all;close all;
cd('C:\jinwork\BEC\Data\MatlabTempData')
load BEC_081616

%note that everthing before index ~5000 (starting at file 8) is before
%sequence we want was actually started.


%copied from "biasSteps.m"
%use bias voltage to get steps, then take last 15 min of step and average
%since 7/21/2016 CoreGasHtrVolt changed to BiasVolt
%BiasV = CoreGasHtrVolt;
BiasV = BiasVolt;
%take each step and find avg, the delay from term them pow is distracting
dQBV = abs(diff(BiasV));
% [peakLoc] = peakfinder(x0,sel,thresh) returns the indicies of local 
%         maxima that are at least sel above surrounding data and larger
%         (smaller) than thresh if you are finding maxima (minima).
clear peaki legstr Expstart Expend peakqi peakqdi
[peaki] = peakfinder(dQBV,4,2);

qdi = abs(QOccurred(2:end)-QOccurred(1:end-1));
[peakqi] = find(qdi ~=0);
%peakqi = qi(peakqdi);

figure
plot(100*qdi)
hold
plot(peakqi,100*qdi(peakqi),'c*')
grid
plot(dQBV,'r')
plot(peaki,dQBV(peaki),'m*')

%what if we used q and not peaki
peaki = [peakqi;(length(BiasV)-1)]; %make sure end point is the last "peak"

figure
plot(reltime,BiasV)
hold
plot(reltime(qi),BiasV(qi),'k.')
plot(reltime(peakqi),BiasV(peakqi),'m*')
grid
title('BiasV')

figure
subplot(2,1,1)
plot([1:length(BiasV)],BiasV)
grid
hold on
plot(peaki,BiasV(peaki),'m*')
title('BiasV - starting points') %...used to find data ranges
subplot(2,1,2)
plot(dQBV)
hold on
plot(peaki,dQBV(peaki),'ro')
grid on

%Qon/Qoff on each bias voltage...use qi to get peaki??
% Expend=zeros(1,2*length(peaki));
% Expstart=zeros(1,2*length(peaki));
% StepLength = [peaki(2:end) - peaki(1:end-1);peaki(end)-peaki(end-1)]; %guesstimate the last one? or add peaki(end) ...
% 
% Expend(2:2:end) = peaki-10; %end just before the next voltage step
% explength = (0.3*StepLength); %take ? hours of data.
% Expstart(2:2:end) = round(Expend(2:2:end)-(explength'));%*60*60/10)]; %"explength" hours each region
peaki(find(peaki < 5000)) = []; %get rid of triggers for bad sequence
Expend = peaki - 5; %using Q as indicator
StepLength = [peaki(2:end) - peaki(1:end-1);peaki(end)-peaki(end-1)];
explength = (0.3*StepLength); 
Expstart = round(Expend - explength);
% 
% for ee=[1:length(peaki(1:end-1))]
%    if intersect(peaki(ee)+20,qi) == 1 %started with Q on
%         midi(ee) = qi(max(find(qi > peaki(ee+50) & qi < peaki(ee+1)))); %find when Q turns off
%         ee
%    else 
%        midi(ee) = qi(min(find(qi > peaki(ee)+50 & qi < peaki(ee+1)))); %find when Q turns on
%    end
% end
% midi(length(peaki)) = qi(min(find(qi > peaki(end)))); %first qi after last peak....may not exist :(
% Expend(1:2:end) = midi - 10;
% Expstart(1:2:end) = round(Expend(1:2:end) - (explength')); %first half is zero Q
% Expstart(1) = [];
% Expend(1) = [];

figure
plot([1:length(BiasV)],BiasV)
hold on
plot(qi,BiasV(qi),'k.')
grid
plot(peaki,BiasV(peaki),'m*')
title('BiasV - starting points') %...used to find data ranges
plot(Expstart,BiasV(Expstart),'go')
plot(Expend,BiasV(Expend),'ro')

QCP = QPow-TerminationThermPow;
%changed the name from CoreGasHtrPow to BiasPow 2016-7-21 from 2016-4-20
%BiasP = CoreGasHtrPow - 0.00063*BiasV;
BiasP = BiasPow - 0.00063*BiasV;
QPcore = QCP + BiasP;

figure
plot(reltime,QPcore)
hold
plot(reltime,BiasV,'r')

figure
plot(reltime,QPow)
hold all
for pp=1:length(Expstart)
    ExpRange = [Expstart(pp):Expend(pp)];
    dateS(pp) = dateN(Expstart(pp));
    relT(pp) = reltime(Expstart(pp));
    mCRT(pp) = mean(CoreReactorTemp(ExpRange));
    mQBV(pp) = mean(BiasV(ExpRange));
    stdQBV(pp) = std(BiasV(ExpRange));
      mQBP(pp) = mean(BiasP(ExpRange));
    stdQBP(pp) = std(BiasP(ExpRange));
    mCHP(pp) = mean(CoreHtrPow(ExpRange));
    stdCHP(pp) = std(CoreHtrPow(ExpRange));
        mQPow(pp) = mean(QPow(ExpRange));
        stdQPow(pp) = std(QPow(ExpRange));
        mQPV(pp) = mean(QPulseVolt(ExpRange));
        stdQPV(pp) = std(QPulseVolt(ExpRange));
         mQkHz(pp) = mean(QkHz(ExpRange));
        stdQkHz(pp) = std(QkHz(ExpRange));
        mTTPow(pp) = mean(TerminationThermPow(ExpRange));
         stdTTPow(pp) = std(TerminationThermPow(ExpRange));
        mQCPow(pp) = mean(QCP(ExpRange));
        stdQCPow(pp) = std(QCP(ExpRange));
          mQPcore(pp) = mean(QPcore(ExpRange));
        stdQPcore(pp) = std(QPcore(ExpRange));
    plot(reltime(ExpRange),QPow(ExpRange),'.')
    legstr(pp) = {[num2str(Expstart(pp),'%8.0f'),' : ',num2str(Expend(pp),'%8.0f')]};
end
grid
xlabel('Relative Time (hours)')
ylabel('Q Power (W)')
legend(['Q Power',legstr])
title(['HHT ',DateTime{1},' through ',DateTime{end}],'fontsize',11)
legstr'
size(relT)
size(mQPow)

plot([relT(1:2:end);relT(2:2:end)],[mQPow(1:2:end);mQPow(2:2:end)],'s-')

Adj_QP = mQPow(2:2:end) - mQPow(1:2:end);
Adj_BP = mQBP(2:2:end) - 0.00063*mQBV(2:2:end);% 
Adj_TP = mTTPow(2:2:end) - mTTPow(1:2:end);
Adj_HP = mCHP(2:2:end);% 

Adj_TotalPower = Adj_HP + Adj_BP + Adj_QP - Adj_TP;

figure
plot(mQPow,'.-')
hold all
plot(mQBP,'.-')
plot(mTTPow,'.-')
plot(mCHP/10,'.-')
grid
legend('Q Pow','Bias Pow','Term Therm Pow','Heater Pow / 10')

figure
plot(mQBV(2:2:end), Adj_BP + Adj_QP - Adj_TP,'*')
hold on
plot(mQBV(2:2:end), mCHP(2:2:end),'c*')
grid
title('BEC HHT, Power to the core (corrected) as a function of Bias V')
ylabel('Bias Power + Q Power -TermTherm Power')
xlabel('mean Bias voltage')

figure
LT = find(mCRT(2:2:end) < 625);
HT = find(mCRT(2:2:end) >= 625);
QBV2 = mQBV(2:2:end);
plot(QBV2(LT),Adj_TotalPower(LT),'b*')
hold on
plot(QBV2(HT),Adj_TotalPower(HT),'r*')
grid
title('BEC HHT, Total system power as a function of Bias V, Q and TermPow corrected each point')
ylabel('Power(heater) + Power(Bias+Qpulse) - TermLoss')
xlabel('mean Bias voltage')
legend('Core Temp = 600','Core Temp = 650')

figure
QPV2 = mQPV(2:2:end);
plot(QPV2(LT),Adj_TotalPower(LT),'b*')
hold on
plot(QPV2(HT),Adj_TotalPower(HT),'r*')
grid
title('BEC HHT, Total system power as a function of Pulse Voltage (Q and TermPow corrected)')
ylabel('Power(heater) + Power(Bias+Qpulse) - TermLoss')
xlabel('mean Q Pulse voltage')
legend('Core Temp = 600','Core Temp = 650')

figure
plot3(QBV2(LT),QPV2(LT),Adj_TotalPower(LT),'b*')
hold on
plot3(QBV2(HT),QPV2(HT),Adj_TotalPower(HT),'r*')
grid

figure
QkHz2 = mQkHz(2:2:end);
plot(QkHz2(LT),Adj_TotalPower(LT),'b*')
hold on
plot(QkHz2(HT),Adj_TotalPower(HT),'r*')
grid
title('BEC HHT, Total system power as a function of Q Frequency, Q and TermPow corrected each point')
ylabel('Power(heater) + Power(Bias+Qpulse) - TermLoss')
xlabel('Q Frequency')
legend('Core Temp = 600','Core Temp = 650')



figure
subplot(2,1,1)
plot(QBV2(LT),Adj_QP(LT),'b*')
hold on
plot(QBV2(HT),Adj_QP(HT),'r*')
grid
title('BEC HHT, Q power (corrected) as a function of Bias V')
ylabel('Q Power only')
xlabel('mean Bias voltage')
subplot(2,1,2)
plot(QBV2(LT),Adj_HP(LT),'b*')
hold on
plot(QBV2(HT),Adj_HP(HT),'r*')
grid
title('BEC HHT, Core Heater Power as a function of Bias V')
ylabel('Heater Power (W)')
xlabel('mean Bias voltage')

