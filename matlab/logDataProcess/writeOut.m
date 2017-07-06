function [T1,pdata] = writeOut(data,T1,hpExpFit,tempExpFit,writeOutput,figname,tStr,ff)
dataSize = size(data,1);
ctFit = [];
itFit = [];
ct1 = [];
ct2 = [];
ct3 = [];
ct4 = [];
it1 = [];
it2 = [];
it3 = [];
it4 = [];
p1 = [];
p2 = [];
p3 = [];
p4 = [];
p5 = [];

dt1 = [];
seq1=strings();
coreT =[];inT=[];outT=[];ql=[];qf=[];hp=[];coreQPow=[];v1=[];v2=[];qPow=[];qSP=[];qSV=[];qCur=[];qSetV=[];h2=[];termP=[];pcbP=[];i12=[];dt2=[];
i=0;
%start point of the sequence
i1 = 1;
trim = 25; %10% outliers throw away.
ii = 30; %30*10=300 seconds before to next seq.
if ii > 5
  trim1 = round(200/ii); %k = ii*(trim/100)/2 through away one highset/lowest point trim = 200/ii
else
  trim1 = 0;
end    
seq2 = 0;

while (i < dataSize-1)  
  i = i+1;
  if (abs(data.SeqStepNum(i+1) - data.SeqStepNum(i)) >= 1  || i == dataSize-1 ) %sequence changed or last sequence
    %end point of the sequence
    i2 = i;
    if i2-i1 > 30 %only pick up the sequence has more then half hours runs
    seq2=seq2+1;
    %one point
    seq = data.SeqStepNum(i);
    seq1(seq2)=strcat(tStr,num2str(seq2));
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
    v3(seq2) = trimmean(data.CoreQV3Rms(i1:i2),trim);
    termP(seq2)= trimmean(data.TerminationHeatsinkPower(i1:i2),trim);
    pcbP(seq2)= trimmean(data.QPulsePCBHeatsinkPower(i1:i2),trim);
    if tempExpFit
      ctFit(seq2,1:4) = expFit(data.CoreTemp(i1:i2));
      p1(seq2)=ctFit(seq2,1);
      p2(seq2)=ctFit(seq2,2);
      p3(seq2)=ctFit(seq2,3);
      p4(seq2)=ctFit(seq2,4);
      itFit(seq2,1:4) = expFit(data.InnerBlockTemp1(i1:i2));
      p5(seq2)=itFit(seq2,1);
      it2(seq2)=itFit(seq2,2);
      it3(seq2)=itFit(seq2,3);
      it4(seq2)=itFit(seq2,4);
      
    end
    i12(seq2)=i2-i1;
    if hpExpFit
        %JLIU TODO hard code here
      %take out 15% data set from beginning. 
      i11 = double(int16(0.1*(i2-i1)));
      
      hpFit(seq2,1:4) = expFit(data.HeaterPower(i1+i11:i2),figname,hp(seq2),coreT(seq2),tStr,seq2,ff);      
      p1(seq2)=hpFit(seq2,1);
      p2(seq2)=hpFit(seq2,2);
      p3(seq2)=hpFit(seq2,3);
      p4(seq2)=hpFit(seq2,4);
      %extended double size
      p5(seq2)=p1(seq2)*exp(p2(seq2)*2*i12(seq2))+p3(seq2)*exp(p4(seq2)*2*i12(seq2));
    end     
    i1 = i2+1; 
    end
  end
end  
dt2 = datetime(dt1, 'ConvertFrom', 'datenum');
if (writeOutput)
    if tempExpFit
T1=[T1;table(coreT(:),inT(:),outT(:),ql(:),qf(:),hp(:),coreQPow(:),v1(:),v2(:),v3(:),qPow(:),qSP(:),qSV(:),h2(:),termP(:),pcbP(:),...
    p1(:),p2(:),p3(:),p4(:),p5(:),it2(:),it3(:),it4(:),seq1(:),i12(:),dt2(:),...
'VariableName',{'coreT','inT','outT','QL','QF','HP','CoreQPower','v1','v2','v3','qPow','qSP','qSV','h2','termP','pcbP',...
'p1','p2','p3','p4','hp_','it2','it3','it4','seq','steps','date'})];
    else
        T1=[T1;table(coreT(:),inT(:),outT(:),ql(:),qf(:),hp(:),coreQPow(:),v1(:),v2(:),v3(:),qPow(:),qSP(:),qSV(:),h2(:),termP(:),pcbP(:),...
    p1(:),p2(:),p3(:),p4(:),p5(:),seq1(:),i12(:),dt2(:),...
'VariableName',{'coreT','inT','outT','QL','QF','HP','CoreQPower','v1','v2','v3','qPow','qSP','qSV','h2','termP','pcbP',...
'p1','p2','p3','p4','hp_','seq','steps','date'})];
    end
end
   
pdata = horzcat(coreT', inT', outT', ql', qf', hp', v1', v2',v3', qPow', termP', pcbP', qSP', qSV', h2',coreQPow');

end


