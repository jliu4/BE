%GAS = getavg(range, stepsize, StepParam);
% range = point in larger data set to use
% step size (in hours)
% Step Param (like Q PulseLengthns) to use in finding steps
% 8/2/16 updated to include more parameters, including keeping track of gas
%    mData.DN = dateN(Range);
%     mData.H2 = CoreOutH2(Range);  %use to find which gas we are in...then use 1/0 to indicate core gas
%     mData.He = CoreOutHe(Range);
%     mData.Ar = CoreOutAr(Range);
%     mData.CHP = CoreHtrPow(Range);
%     mData.CRT = CoreReactorTemp(Range);
%     mData.QP = QPow(Range);
%     mData.TTP = TerminationThermPow(Range);
%     mData.PI = PowIn(Range);
%     mData.PO = PowOut(Range);
%     mData.coreLPM = H2MakeupLPM(Range);
%     mData.coreTout = CoreGasOut(Range);
%     mData.coreTin = CoreGasIn(Range);
%     mData.Qkhz = QkHz(Range);
%     mData.QPLns = QPulseLengthns(Range);
%     mData.SP = StepParam(Range); %step parameter
%     mData.R = Range;
%     mData.QSV = QSupplyVolt(Range);
function [GAS] = getavg(mData, stepsize);


mData.QCP = mData.QP - mData.TTP;
mData.TP = mData.CHP + mData.QCP;

dQPL = abs(diff(mData.SP));
% [peakLoc] = peakfinder(x0,sel,thresh) returns the indicies of local
%         maxima that are at least sel above surrounding data and larger
%         (smaller) than thresh if you are finding maxima (minima).
clear peaki legstr Expstart Expend
[peaki] = peakfinder(dQPL,4,2);
peaki = [peaki;length(mData.R)-5];

figure
subplot(2,1,1)
plot([1:length(mData.R)],mData.SP)
grid
hold on
plot(peaki,mData.SP(peaki),'m*')
title('StepParam - starting points') %...used to find data ranges
subplot(2,1,2)
plot(dQPL)
hold on
plot(peaki,dQPL(peaki),'ro')
grid on

Expend = peaki-10; %end just before the next voltage step
explength = stepsize; %take ? hours of data.
Expstart = [Expend-(explength*60*60/10)]; %"explength" each region
neg = find(Expstart < 1);
Expstart(neg) = 1;

figure
plot([1:length(mData.R)],mData.SP)
grid
hold on
plot(peaki,mData.SP(peaki),'m*')
title('StepParam - starting points') %...used to find data ranges
plot(Expstart,mData.SP(Expstart),'go')
plot(Expend,mData.SP(Expend),'ro')

figure
plot(mData.DN,mData.CHP)
hold all
Expstart
for pp=1:length(Expstart)
    ExpRange =[Expstart(pp):Expend(pp)];
    Expstart(pp)
    GAS.dateS(pp) = mData.DN(Expstart(pp));
    %find gas
    GAS.H2(pp) = mean(mData.H2(ExpRange));
    GAS.He(pp) = mean(mData.He(ExpRange));
    GAS.Ar(pp) = mean(mData.Ar(ExpRange));
    [y,cG] = sort([GAS.H2(pp) GAS.He(pp) GAS.Ar(pp)]);
    GAS.H2(pp) = 0; %reset to false...then pick true based on largest coreGas
    GAS.He(pp) = 0;
    GAS.Ar(pp) = 0;
    coreGas = cG(end);
    if coreGas == 1
        GAS.H2(pp) = 1;
    else
        if coreGas == 2
        GAS.He(pp) = 1;
        else if coreGas == 3
        GAS.Ar(pp) = 1;
            end
        end
    end
    
        
    %
    GAS.mCHP(pp) = mean(mData.CHP(ExpRange)); %core heater power
    GAS.stdCHP(pp) = std(mData.CHP(ExpRange))
    GAS.mCRT(pp) = mean(mData.CRT(ExpRange)); %core reactor temp
    GAS.mICT(pp) = mean(mData.ICT(ExpRange)); %inner core temp
    GAS.mQPow(pp) = mean(mData.QP(ExpRange)); %q power (measured at pi filter)
    GAS.stdQPow(pp) = std(mData.QP(ExpRange));
    GAS.mTTPow(pp) = mean(mData.TTP(ExpRange)); %termination thermal power
    GAS.stdTTPow(pp) = std(mData.TTP(ExpRange));
    
    GAS.mQCPow(pp) = mean(mData.QCP(ExpRange)); %mData.QCP = mData.QP - mData.TTP;
    GAS.stdQCPow(pp) = std(mData.QCP(ExpRange));
    GAS.mTP(pp) = mean(mData.TP(ExpRange)); %mData.TP = mData.CHP + mData.QCP;
    GAS.stdTP(pp) = std(mData.TP(ExpRange));
    
    GAS.mPL(pp) = mean(mData.QPLns(ExpRange)); %Q pulse length
    GAS.stdPL(pp) = std(mData.QPLns(ExpRange));
    GAS.mQkHz(pp) = mean(mData.Qkhz(ExpRange)); %Q frequency (kHz)
    GAS.mQSV(pp) = mean(mData.QSV(ExpRange));  %Q supply volt
    
    GAS.mPin(pp) = mean(mData.PI(ExpRange)); %Q Power In
    GAS.stdPin(pp) = std(mData.PI(ExpRange));
    GAS.mPout(pp) = mean(mData.PO(ExpRange)); %Q Power Out
    GAS.stdPout(pp) = std(mData.PO(ExpRange));
    GAS.coreLPM(pp) = mean(mData.coreLPM(ExpRange)); %core LPM flow
    GAS.coreTin(pp) = mean(mData.coreTin(ExpRange)); %core Temp in
    GAS.coreTout(pp) = mean(mData.coreTout(ExpRange)); % core Temp out
    plot(mData.DN(ExpRange),mData.CHP(ExpRange),'.') %plot date(start) vs total power (CHP + power to core)
    
end
grid
datetick('x','mmm dd', 'keeplimits')
ylabel('Core Heater Power (W)')

end