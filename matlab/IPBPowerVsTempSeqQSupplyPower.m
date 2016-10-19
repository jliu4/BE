clear all;close all
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
dailyPlot = 1;
flowratePlot = 0;
tempPlot = 0;
processYes = 1;
p1 =0;
p2 = 40;
reactor = '2016-08-20-CORE_28_DC_Heater';
%reactor ='ipb1-2016-09-30-CRIO-v171_CORE_29b' 
%reactor='sri-ipb2-0930'
switch (reactor)
case '2016-08-20-CORE_28_DC_Heater' 
Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-08-20-CORE_28_DC_Heater';
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '10022016';
switch (whichDate)
  case '10022016' 
    dataFile ='\ISOPERIBOLIC2_DATA/2016-08-20-CORE_28_DC_Heater\IPB2_Core_28b-DC_Qk_CAL_H2_200C-600C_day-01.csv : 02.csv' ;  
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(8:9);
end     
case 'sri-ipb2-0930' 
Directory='C:\Users\Owner\Dropbox (BEC)\SRI-IPB2\2016-09-30_SRI_v171-core27b';
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '10172016';
switch (whichDate)
  case '10172016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\SRI-IPB2_H2-250-400C_9-30-16_day-11.csv : 12.csv' ;  
    startTime = 12.5;
    endTime = 12; 
    Experiment = AllFiles(18:20);  
end 
case 'ipb1-2016-09-30-CRIO-v171_CORE_29b' 
Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\2016-09-30-CRIO-v171_CORE_29b';
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '10122016';
switch (whichDate)
case '10122016' 
  dataFile ='\ISOPERIBOLIC_DATA\2016-09-30-CRIO-v171_CORE_29b\IPB1_CoreQ_DC_cal_10-12-16day-01.csv : 03.csv';  
  startTime = 0;
  endTime = 0; 
  Experiment = AllFiles(19:21);
end
end    
Experiment'
loadHHT 
%change a few messy variable names
QOccurred = QOccurred0x3F; clear QPulseOccurred0x3F
SeqStep = SeqStep0x23; clear SeqStep0x23
QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29
QPulseDelays = QPulseDelay0x28s0x29; clear QPulseDelay0x28s0x29
QkHz = QKHz; clear QKHz;
%change datetime to number
dateN=datenum(DateTime,'mm/dd/yyyy HH:MM:SS');
DateTime(1+startTime*360)
DateTime(end - endTime*360)
            %1     2           3        4              5    6    7       8                        9                      10        
j1 = horzcat(dateN,HeaterPower,CoreTemp,QPulseLengthns,QkHz,QPow,SeqStep,TerminationHeatsinkPower,QPulsePCBHeatsinkPower,CoreQPower,...
    CalorimeterJacketFlowrateLPM,QPCBHeatsinkFlowrateLPM,TerminationHeatsinkFlowrateLPM,CalorimeterJacketPower,...
    CalorimeterJacketH2OInT,CalorimeterJacketH2OOutT,QPCBHeatsinkH2OInT,QPCBHeatsinkH2OOutT,TerminationHeatsinkH2OInT,...
    TerminationHeatsinkH2OOutT,RoomTemperature,QSupplyPower);
%   11                           12                      13                             14                  
j1 = j1(1+startTime*360:end-endTime*360,:);
j1(any(isnan(j1),2),:)=[]; %take out rows with Nan
j1 = j1(j1(:,7) > 0,:); %only process data with seq
j1Size = size(j1,1);
dt = datetime(j1(:,1), 'ConvertFrom', 'datenum') ; 
if (dailyPlot == 1)
figure(1)
hold on
aa_splot(dt,j1(:,2),'black','linewidth',1.5);
ylim([p1 p2]);
addaxis(dt,j1(:,3),'linewidth',1.5);
%addaxis(dt,j1(:,4),'linewidth',1);
%addaxis(dt,j1(:,5),'linewidth',1);
%addaxis(dt,smooth(j1(:,6),11));
%addaxis(dt,smooth(j1(:,22),11)) ;
addaxis(dt,j1(:,22)) ;
%addaxis(dt,smooth(j1(:,13),11)) 
title(dataFile,'fontsize',11);
addaxislabel(1,'HeaterPower');
addaxislabel(2,'CoreTemp');
%addaxislabel(3,'QPulseLen');
%addaxislabel(4,'QkHz');
%addaxislabel(4,'QPow');
%addaxislabel(6,'TerminationHeatSinkPower');
%addaxislabel(7,'QPulsePCBHeatsinkPower');
addaxislabel(3,'QSupplyPower'); 
end 
if (flowratePlot)
figure(2)
hold on
aa_splot(dt,smooth(j1(:,11),20),'black');
%ylim([0 80])
addaxis(dt,smooth(j1(:,12),20));
addaxis(dt,smooth(j1(:,13),20))
title(dataFile,'fontsize',20)
addaxislabel(1,'Jacket LPM');
addaxislabel(2,'PCB LPM');
addaxislabel(3,'Term LPM');
end
if (tempPlot)
figure(3)
hold on
aa_splot(dt,smooth(j1(:,21),20),'black');
%ylim([0 80])
addaxis(dt,smooth(j1(:,16),30));
addaxis(dt,smooth(j1(:,15),30));
addaxis(dt,smooth(j1(:,18),30));
addaxis(dt,smooth(j1(:,17),30));
addaxis(dt,smooth(j1(:,20),30));
addaxis(dt,smooth(j1(:,10),30));

title(dataFile,'fontsize',20);
addaxislabel(1,'Room Temp');
addaxislabel(2,'JacketOutT');
addaxislabel(3,'JacketInT');
addaxislabel(4,'PCBOutT');
addaxislabel(5,'PCBInT');
addaxislabel(7,'TermOutT');
addaxislabel(7,'TermInT');
end
if (processYes == 1) 
hp = []; 
temp=[];
ql = [];
gf=[];
qPow=[];
qTerm=[];
qPCB = [];
coreQPow = [];
coreQPowCV = [];
qPCBCV=[];
qTermCV=[];
qPowCV=[];
i=0;
i1 = 1;
ii = 30; %10 mins from the sequence end.
if ii > 5;
  trim = round(200/ii); %k = ii*(trim/100)/2 through away one highest/lowest point trim = 200/ii
else
  trim = 0;
end    
while (i < j1Size-1)  
  i = i+1;
  if abs(j1(i+1,7) - j1(i,7)) >= 1 %sequence changed
    i2 = i;
    seq = j1(i2,7);
    seqs(seq)=seq;
    dt1(seq) = j1(i2,1); 
    hp(seq) = trimmean(j1(i2-ii,2),trim); 
    temp(seq)=trimmean(j1(i2-ii:i2,3),trim);
    ql(seq) = j1(i2,4);
    qf(seq) = trimmean(j1(i2-ii:i2,5),trim);
    qPow(seq) = trimmean(j1(i2-ii:i2,6),trim);
    qTerm(seq) = trimmean(j1(i2-ii:i2,8),trim);
    qPCB(seq) = trimmean(j1(i2-ii:i2,9),trim);
    coreQPow(seq)=trimmean(j1(i2-ii:i2,10),trim);
    cjp(seq) = trimmean(j1(i2-ii:i2,14),trim);
    jlpm(seq) = trimmean(j1(i2-ii:i2,11),trim);
    PCBlpm(seq) = trimmean(j1(i2-ii:i2,12),trim);
    termlpm(seq) = trimmean(j1(i2-ii:i2,13),trim);
    jInT(seq) = trimmean(j1(i2-ii:i2,15),trim);
    jOutT(seq) = trimmean(j1(i2-ii:i2,16),trim);
    PCBInT(seq) = trimmean(j1(i2-ii:i2,17),trim);
    PCBOutT(seq) = trimmean(j1(i2-ii:i2,18),trim);
    termInT(seq) = trimmean(j1(i2-ii:i2,19),trim);
    termOutT(seq) = trimmean(j1(i2-ii:i2,20),trim);
    roomT(seq) = trimmean(j1(i2-ii:i2,21),trim); 
    qSupplyP(seq) = trimmean(j1(i2-ii:i2,22),trim); 
    hpM =  mean(j1(i1:i2,2)); 
    qPowM =mean(j1(i1:i2,6)); 
    qTermM = mean(j1(i1:i2,8));
    qPCBM =mean(j1(i1:i2,9)); 
    coreQPowM = mean(j1(i1:i2,10));
    cjpM = mean(j1(i1:i2,14));
    qPowCV(seq) = std(j1(i1:i2,6));
    qTermCV(seq)=std(j1(i1:i2,8));
    qPCBCV(seq) = std(j1(i1:i2,9));
    coreQPowCV(seq)=std(j1(i1:i2,10));
    cjpCV(seq)=std(j1(i1:i2,14));
    if qPowM > 0
      qPowCV(seq)= qPowCV(seq)/qPowM;
    end   
    if qTermM > 0
      qTermCV(seq)=qTermCV(seq)/qTermM;
    end 
    if qPCBM > 0
      qPCBCV(seq) = qPCBCV(seq)/qPCBM;
    end   
    if coreQPowM > 0 
      coreQPowCV(seq)=coreQPowCV(seq)/coreQPowM;
    end    
    if cjpM > 0 
      cjpCV(seq)=cjpCV(seq)/cjpM;
    end    
    i1 = i2+1; 
  end
end 
dt2 = datetime(dt1, 'ConvertFrom', 'datenum') ;
fn = ['C:\jinwork\BEC\tmp\' reactor '-' whichDate '.csv'];            
delete(fn);
T=table(temp(:),ql(:),qf(:),hp(:),coreQPow(:),qPow(:),qPCB(:),qTerm(:),cjp(:),...
    roomT(:),jlpm(:),jInT(:),jOutT(:), PCBlpm(:),PCBInT(:),PCBOutT(:),termlpm(:),termInT(:),termOutT(:),...
    coreQPowCV(:),qPowCV(:),qPCBCV(:),qTermCV(:),cjpCV(:),qSupplyP(:),seqs(:),dt2(:),...
'VariableName',{'Temp','QL','QF','HP','CoreQPower','qPow','qPCB','qTerm','CJP','roomT','jLPM','jInT','jOutT',...
'PCBLPM','PCBInT','PCBOutT','termLPM','termInT','termOutT','coreQPowCV','qPowCV','qPCBCV','qTermCV','cjpCV','qSupply','seq','date'});
writetable(T,fn);
end
