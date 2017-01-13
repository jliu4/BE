function writeOut(data, reactor, reactors, runDate, hpExpFit, tempExpFit )
dataSize = size(data,1);
ctFit = [];
itFit = [];
dt1 = [];
coreT =[];inT=[];outT=[];ql=[];qf=[];hp=[];coreQPow=[];v1=[];v2=[];qPow=[];qSP=[];qSV=[];qCur=[];qSetV=[];h2=[];termP=[];pcbP=[];seq1=[];i12=[];dt2=[];
i=0;
i1 = 1;
trim = 10; %10% outliers throw away.
ii = 30; %30*10=300 seconds before to next seq.
if ii > 5;
  trim1 = round(200/ii); %k = ii*(trim/100)/2 through away one highset/lowest point trim = 200/ii
else
  trim1 = 0;
end    
seq2 = 0;
while (i < dataSize-1)  
  i = i+1;
  if abs(data.SeqStepNum(i+1) - data.SeqStepNum(i)) >= 1  %sequence changed or at least sequence has run more than an half hour
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
dt2 = datetime(dt1, 'ConvertFrom', 'datenum') ;
if (false)
pdata = horzcat(coreT', inT', outT', ql', qf', hp', v1', v2', qPow', termP', pcbP', qSP', qSV', h2');
dataset({pdata,'coreT','inT','outT','ql','qf','hp','v1','v2','qPow','termP','pcbP','qSP','qSV','h2'});
%get unique ql
uniqQl = unique(ql);
uniqCT = unique(int16(coreT));
%for each ql and temp get hp0
i = 0;
j = 0;
hpdrop = [];
qp = [];
tp = [];
pp = [];
v12 = [];
v122 = [];
figure
grid
hold on
for ti = uniqCT
  i = i + 1;  
  tdata = pdata(int16(pdata(:,1)) == ti,:);
  hp0=tdata(1,6);
  qp0=tdata(1,9);
  termP0=tdata(1,10);
  pcbP0 = tdata(1,11);
  for qi = uniqQl
    %q-pusle length only valid when there is q-pulse  
    j = j + 1;  
    qtdata = tdata((tdata(:,4)) == qi,:);
    qtdata = qtdata(2:end-1,:);
    tq(:,i,j) = [ti,qi];
    hpdrop(:,i,j) = hp0-qtdata(:,6);
    qp(:,i,j) = qtdata(:,9) - qp0;
    tp(:,i,j) = qtdata(:,10) - termP0;
    pp(:,i,j) = qtdata(:,11) - pcbP0;
    v12(:,i,j)= qtdata(:,7)-qtdata(:,8) ;
    v122=v12.*v12;
    vh = v122./hpdrop;
    vh0(i,j) = hpdrop(:,i,j)\v122(:,i,j);
    
  end
  %plot(uniqCT,vh0);
end    
%plot(uniqCT,hpdrop(1,:,:));
%disp(hpdrop);
end
fn = char(strcat('C:\jinwork\BEC\tmp\', reactors(reactor), '-', runDate, '.csv') );          
delete(fn);
T=table(coreT(:),inT(:),outT(:),ql(:),qf(:),hp(:),coreQPow(:),v1(:),v2(:),qPow(:),qSP(:),qSV(:),qCur(:),qSetV(:),h2(:),termP(:),pcbP(:),seq1(:),i12(:),dt2(:),...
'VariableName',{'coreT','inT','outT','QL','QF','HP','CoreQPower','v1','v2','qPow','qSP','qSV','qCur','qSetV','h2','termP','pcbP','seq','steps','date'});
writetable(T,fn);
if hpExpFit 
  fileID = fopen(char(strcat('C:\jinwork\BEC\tmp\', reactors(reactor), '-', runDate, '-hpfit.csv') ),'w');
  %fprintf(fileID,'%4s %12s\n','x','exp(x)');
  fprintf(fileID,'%6.2f %6.2f %6.2f %6.2f\n',hpFit);
  fclose(fileID);
end
if tempExpFit 
  fileID = fopen(char(strcat('C:\jinwork\BEC\tmp\', reactors(reactor), '-', runDate, '-hpfit.csv') ),'w');
  %fprintf(fileID,'%4s %12s\n','x','exp(x)');
  fprintf(fileID,'%6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f\n',ctFit,itFit);
  fclose(fileID);
end
end


