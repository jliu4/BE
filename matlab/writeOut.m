function [pdata] = writeOut(data, fn, hpExpFit, tempExpFit,writeOutput )
dataSize = size(data,1);
ctFit = [];
itFit = [];
dt1 = [];
coreT =[];inT=[];outT=[];ql=[];qf=[];hp=[];coreQPow=[];v1=[];v2=[];qPow=[];qSP=[];qSV=[];qCur=[];qSetV=[];h2=[];termP=[];pcbP=[];seq1=[];i12=[];dt2=[];
i=0;
%start point of the sequence
i1 = 1;
trim = 10; %10% outliers throw away.
ii = 30; %30*10=300 seconds before to next seq.
if ii > 5
  trim1 = round(200/ii); %k = ii*(trim/100)/2 through away one highset/lowest point trim = 200/ii
else
  trim1 = 0;
end    
seq2 = 0;
while (i < dataSize-1)  
  i = i+1;
  if (abs(data.SeqStepNum(i+1) - data.SeqStepNum(i)) >= 1 || i == dataSize-1 ) %sequence changed or last sequence
    %end point of the sequence
    i2 = i;
    if i2-i1 > 30 %only pick up the sequence has more then half hours runs
    seq2=seq2+1;
    %one point
    seq = data.SeqStepNum(i);
    seq1(seq2)=seq;
    dt1(seq2) = data.dateN(i2); 
    h2(seq2) = 1; %HydrogenValves(i);
    ql(seq2) = data.QPulseLengthns(i);
    %last few points or exponentialFit
    hp(seq2) = trimmean(data.HeaterPower(i2-ii:i2),trim1);
    coreT(seq2)=trimmean(data.CoreTemp(i2-ii:i2),trim1);
    inT(seq2) = trimmean(data.InnerBlockTemp1(i2-ii:i2),trim1);
    outT(seq2) = trimmean(data.OuterBlockTemp1(i2-ii:i2),trim1);
    %all points
    qf(seq2) = trimmean(data.QKHz(ii:i2),trim);
    qPow(seq2) = trimmean(data.QPow(i1:i2),trim);
    coreQPow(seq2)=trimmean(data.CoreQPower(i1:i2),trim);
    v1(seq2)=trimmean(data.CoreQV1Rms(i1:i2),trim);
    v2(seq2)=trimmean(data.CoreQV2Rms(i1:i2),trim);
    qSP(seq2) = trimmean(data.QSupplyPower(i1:i2),trim); 
    qSV(seq2) = trimmean(data.QSupplyVolt(i1:i2),trim);
    qCur(seq2) = trimmean(data.QCur(ii:i2),trim);
    qSetV(seq2) = trimmean(data.QSetV(i1:i2),trim);
    termP(seq2)= trimmean(data.TerminationHeatsinkPower(i1:i2),trim);
    pcbP(seq2)= trimmean(data.QPulsePCBHeatsinkPower(i1:i2),trim);
    if tempExpFit
      ctFit(seq2,1:4) = expFit(data.CoreTemp(i1:i2));
      itFit(seq2,1:4) = expFit(data.InnerBlockTemp1(i1:i2));
    end
    if hpExpFit
      hpFit(seq2,1:4) = expFit(data.HeaterPower(i1:i2));  
    end  
    i12(seq2)=i2-i1;
    i1 = i2+1; 
    end
  end
end  
dt2 = datetime(dt1, 'ConvertFrom', 'datenum');
if (writeOutput)
T=table(coreT(:),inT(:),outT(:),ql(:),qf(:),hp(:),coreQPow(:),v1(:),v2(:),qPow(:),qSP(:),qSV(:),qCur(:),qSetV(:),h2(:),termP(:),pcbP(:),seq1(:),i12(:),dt2(:),...
'VariableName',{'coreT','inT','outT','QL','QF','HP','CoreQPower','v1','v2','qPow','qSP','qSV','qCur','qSetV','h2','termP','pcbP','seq','steps','date'});
writetable(T,fn);
end
pdata = horzcat(coreT', inT', outT', ql', qf', hp', v1', v2', qPow', termP', pcbP', qSP', qSV', h2');

%delete(fn);

end


