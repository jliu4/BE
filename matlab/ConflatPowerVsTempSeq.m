clear all;close all
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
dailyPlot = 1;
processYes = 1;
%'sri-08' 'sri-09'; ,'conflat'
reactor = 'sri-09' 
switch (reactor)
case 'sri-08'
   Directory='C:\jinwork\BEC\Data\SRIdata\2016-08-12'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '09042016-09052016';
   %input which sequence
   switch (whichDate)
   case 08122016-09052016' %ALL
     seqFile ='ALL'  %8/12/2016-9/5/2016     
     startTime = 0; 
     endTime = 0; 
     Experiment = AllFiles(1:end);
   case '08222016-08242016n'
     seqFile ='no sequence file found'     
     startTime = 0; %8/22/2016 15:01
     endTime = 0; %8/24/2016 1:05 from end of file 8/24/2016 10:21
     Experiment = AllFiles(9:10);  
   case '08222016-08242016' 
     seqFile ='Sequence+300-100ns+alternates+100VAC+33W+H2+275C+30sccm+100psi.csv'       
     startTime = 7; %5 
     endTime = 0; %19; 
     Experiment = AllFiles(10:11);
   case '4'
     seqFile ='No QPulse'      
     startTime =0; % 1.5; 
     endTime = 0; %9; 
     Experiment = AllFiles(12:15);
   case '5' %no Qpulse with a sequence file
     seqFile ='Sequence+325-600C+in+25C+steps+H2+30sccm+100psi.csv'     
     startTime = 11; 
     endTime = 21; 
     Experiment = AllFiles(16:20);
     %for temp=350:25:600
   case '6'
     seqFile ='300-100ns+steps+600-300C+in+100C+steps+He+30sccm+100psi.csv'       
     startTime = 2; 
     endTime = 9; 
     Experiment = AllFiles(22:23);
   case '09042016-09052016' 
     seqFile ='300-100ns steps 275-350C in 25C steps He 30sccm 100psi.csv'
     startTime = 0; %6; %9/4/2016 6 hours after 6:00
     endTime = 0; %7;   %9/5/2016 20:33
     Experiment = AllFiles(24:25);
     qL = [300 100 300 100 300 100 300];
     qN = size(qL,2)-1;
     temp = [277 302 327 352];
   case '8' 
     seqFile ='300-100ns steps 100-300C in 25C steps He 30sccm 100psi.csv'
     startTime = 7; %9/4/2016 6 hours after 6:00
     endTime = 0;   %9/5/2016 20:33
     Experiment = AllFiles(26:26);
     %for temp=[277 302 327 352]  
   case '9' 
     seqFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psi002.csv'
     startTime = 10; %9/4/2016 6 hours after 6:00
     endTime = 0;   %9/5/2016 20:33
     Experiment = AllFiles(2:2);
   end  
     %for temp=[277 302 327 352]  
case 'sri-09'
   Directory='C:\jinwork\BEC\Data\SRIdata\2016-09-11'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '09222016-09232016';
   %input which sequence
   switch (whichDate)
   case '1' 
     seqFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psi002.csv'
     startTime = 0; %9/4/2016 6 hours after 6:00
     endTime = 0;   %9/5/2016 20:33
     Experiment = AllFiles(1:4);
   case '09212016-09222016' 
     seqFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psiQV200V-000.csv'
     startTime = 0.5; %9/4/2016 6 hours after 6:00
     endTime = 0;   %9/5/2016 20:33
     Experiment = AllFiles(7:7);
     qL = [300 100 300 100 300 100 300];
     qN = size(qL,2)-1;
     temp = [100 200 300 400];
   case '09222016-09232016' 
     seqFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psiQV200V-000.csv'
     startTime = 0.5; %9/4/2016 6 hours after 6:00
     endTime = 0;   %9/5/2016 20:33
     Experiment = AllFiles(8:8);
     qL = [300 100 300 100 300 100 300];
     qN = size(qL,2)-1;
     temp = [100 200 300 400];

   end  
   
   otherwise
     exit
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
%            1     2          3               4              5    6     7     
j1 = horzcat(dateN,CoreHtrPow,CoreReactorTemp,QPulseLengthns,QkHz,QPow, TerminationThermPow,...
CoreInPress,HGASSOURCEVALVEVH3,QOccurred,CoreGasIn,CoreGasOut,H2MakeupLPM,PowOut);
%8          9                  10        11        12         13       14j1 = j1(1+startTime*360:end-endTime*360,:);
j1(any(isnan(j1),2),:)=[];
j1 = j1(j1(:,12) > 0,:);
j1Size = size(j1,1);
dt = datetime(j1(:,1), 'ConvertFrom', 'datenum') ; 
if (dailyPlot == 1)
figure(1)
hold on
aa_splot(dt,j1(:,2),'black','linewidth',1.5)
ylim([0 40])
addaxis(dt,j1(:,3),'linewidth',1.5);
addaxis(dt,j1(:,4))
addaxis(dt,smooth(j1(:,5),11))
addaxis(dt,smooth(j1(:,6),11))
title(dataFile,'fontsize',11)
addaxislabel(1,'HeaterPower');
addaxislabel(2,'CoreTemp');
addaxislabel(3,'QPulseLen');
addaxislabel(4,'QkHz');
addaxislabel(5,'QPow');
end
if (processYes == 1) 
hp0 = []; 
hp = []; 
temp1=[];
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
ii = 40; 
trim = 25;
while (i < j1Size-1)  
  i = i+1;
  if (j1(i+1,12) - j1(i,12)) == 1  %'& i-i1 > ii )
    i2 = i;
    seq = j1(i2,12)
    temp1(seq)=trimmean(j1(i2-ii:i2,3),trim);
    dt1(seq) = j1(i2,1);
    ql(seq) = j1(i2,4);
    qf(seq) = trimmean(j1(i2-ii:i2,5),trim);
    hp0(seq) = 0;
    hp(seq) = 0;
    qPow(seq) =0;
    qTerm(seq) = 0;
    qPCB(seq) = 0;
    coreQPow(seq)=0;
    qPowCV(seq) = 0;
    qTermCV(seq)=0;
    qPCBCV(seq) = 0;
    coreQPowCV(seq)=0;
    if j1(i2,10) == 0
      hp0(seq) = j1(i2,2);
    else
      hp(seq) = trimmean(j1(i2-ii:i2,2),trim); %j2(ni,2);
      qPow(seq) = trimmean(j1(i2-ii:i2,6),trim);
      qTerm(seq) = trimmean(j1(i2-ii:i2,7),trim);
      qPCB(seq) = trimmean(j1(i2-ii:i2,9),trim);
      coreQPow(seq)=trimmean(j1(i2-ii:i2,11),trim); 
      j6 =mean(j1(i1:i2,6)); 
      j7 = mean(j1(i1:i2,7));
      j9 =mean(j1(i1:i2,9)); 
      j11 = mean(j1(i1:i2,11));   
      qPowCV(seq) = std(j1(i1:i2,6));
      qTermCV(seq)=std(j1(i1:i2,7));
      qPCBCV(seq) = std(j1(i1:i2,9));
      coreQPowCV(seq)=std(j1(i1:i2,11));
      if j6 > 0
        qPowCV(seq)= qPowCV(seq)/j6;
      end   
        qTermCV(seq) =qTermCV(seq)/j7;
      if j7 > 0
        qTermCV(seq)=qTermCV(seq)/j7;
      end  
        qPCBCV(seq) = qPCBCV(seq)/j9;
      if j11 > 0 
        coreQPowCV(seq)=coreQPowCV(seq)/j11;
      end    
      i1 = i2+1; 
    end  
  end
end 
dt2 = datetime(dt1, 'ConvertFrom', 'datenum') ;
fn = ['C:\jinwork\BEC\tmp\' reactor '-' whichDate '.csv'];            
delete(fn);
T=table(temp1(:),ql(:),qf(:),hp0(:),hp(:),coreQPow(:),qPow(:),qPCB(:),qTerm(:),coreQPowCV(:),qPowCV(:),qPCBCV(:),qTermCV(:),dt2(:),...
    'VariableName',{'Temp','QL','QF','HP0','HP','CoreQPower','qPow','qPCB','qTerm','coreQPowCV','qPowCV','qPCBCV','qTermCV','date'});
writetable(T,fn);
end
