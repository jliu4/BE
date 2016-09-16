 Range = [1:length(QPow)];  %can be anything, but in the case I used the entire data set...
   
    stepsize = 0.5; %30 min
    StepParam = QPulseLengthns;  %this is the Q parameter with the most frequent changes 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % first shorten the variables needed in loop
    mData.DN = dateN(Range);
    mData.H2 = CoreOutH2(Range);  %use to find which gas we are in...then use 1/0 to indicate core gas
    mData.He = CoreOutHe(Range);
    mData.Ar = CoreOutAr(Range);
    mData.CHP = CoreHtrPow(Range);
    mData.CRT = CoreReactorTemp(Range);
    mData.QP = QPow(Range);
    mData.TTP = TerminationThermPow(Range);
    mData.PI = PowIn(Range);
    mData.PO = PowOut(Range);
    mData.coreLPM = H2MakeupLPM(Range);
    mData.coreTout = CoreGasOut(Range);
    mData.coreTin = CoreGasIn(Range);
    mData.Qkhz = QkHz(Range);
    mData.QPLns = QPulseLengthns(Range);
    mData.SP = StepParam(Range); %step parameter
    mData.R = Range;
    mData.QSV = QSupplyVolt(Range);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Results = getavg(mData, stepsize);
