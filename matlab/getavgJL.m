%GAS = getavg(range, stepsize, StepParam);
% range = all valid sequences
% step size (in hours)
% Step Param SeqStepNum to use in finding steps
%    mData.DN = dateN(Range);
%     mData.HP = CoreHtrPow(Range);
%     mData.OBT = OuterBlockTemp1(Range);
%     mData.QP = QPow(Range);
%     mData.CQP =CoreQPower(Range);
%     mData.Qkhz = QkHz(Range);
%     mData.QPLns = QPulseLengthns(Range);
%     mData.SP = StepParam(Range); %step parameter
%     mData.R = Range;
%     mData.QSV = QSupplyVolt(Range);
function [GAS] = getavgJL(mData, stepsize);

% [peakLoc] = peakfinder(x0,sel,thresh) returns the indicies of local
%         maxima that are at least sel above surrounding data and larger
%         (smaller) than thresh if you are finding maxima (minima).
clear peaki legstr Expstart Expend
%[peaki] = peakfinder(StepParam(Range),4,2);
%peaki = [peaki;length(mData.R)-5];

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
    
    GAS.CQP(pp) = mean(mData.CQP(ExpRange));
    GAS.HP(pp) = mean(mData.HP(ExpRange));
    GAS.QP(pp) = mean(mData.QP(ExpRange));
    GAS.CT(pp)= mean(mData.CT(ExpRange));
    [y,cG] = sort([GAS.CT(pp) GAS.CQP(pp) GAS.HP(pp) GAS.QP(pp)]);
    GAS.CT(pp) = 0; %reset to false...then pick true based on largest coreGas
    GAS.CQP(pp) = 0;
    GAS.HP(pp) = 0;
    coreParam = cG(end);
    if coreParam == 1
        GAS.CT(pp) = 1;
    else
        if coreParam == 2
        GAS.CQP(pp) = 1;
        else if coreGas == 3
        GAS.QP(pp) = 1;
            end
        end
    end
    
        
    %
    GAS.mHP(pp) = mean(mData.HP(ExpRange)); %core heater power
    GAS.stdHP(pp) = std(mData.HP(ExpRange))
    GAS.mCT(pp) = mean(mData.CT(ExpRange)); %core reactor temp
    GAS.mICT(pp) = mean(mData.ICT(ExpRange)); %inner core temp
    GAS.mQPow(pp) = mean(mData.QP(ExpRange)); %q power (measured at pi filter)
    GAS.stdQPow(pp) = std(mData.QP(ExpRange));
    GAS.mCQPow(pp) = mean(mData.CQP(ExpRange)); %coreQPow
    GAS.stdCQPow(pp) = std(mData.CQP(ExpRange));
    
    
    
    GAS.mPL(pp) = mean(mData.QPLns(ExpRange)); %Q pulse length
    GAS.stdPL(pp) = std(mData.QPLns(ExpRange));
    GAS.mQkHz(pp) = mean(mData.Qkhz(ExpRange)); %Q frequency (kHz)
    GAS.mQSV(pp) = mean(mData.QSV(ExpRange));  %Q supply volt
    
    
    plot(mData.DN(ExpRange),mData.HP(ExpRange),'.') %plot date(start) vs total power (CHP + power to core)
    
end
grid
datetick('x','mmm dd', 'keeplimits')
ylabel('Core Heater Power (W)')

end