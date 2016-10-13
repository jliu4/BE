clear all;close all
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
dailyPlot = 1;
flowratePlot = 0;
tempPlot = 0;
processYes = 1;
%'ipb1-0820','ipb1-0915','ipb1-0924-v169-27b''ipb1-0928-crio-v170_core_26b'2016-09-29-CRIO-v170_CORE_29b
%'ipb2-08''ipb2-0905-164-28b''ipb2-0907-165-28b''ipb2-0909-165-27b''ipb2-0909-166-27b''ipb2-0909-167-27b''ipb2-0909-v169-27b'
%ipb2-09-24_CRIO_v169-core27b
%sri-ipb2-0930
%reactor = '2016-08-20-CORE_28_DC_Heater'
reactor ='ipb1-2016-09-30-CRIO-v171_CORE_29b' 
%reactor='sri-ipb2-0930'
switch (reactor)
case '2016-08-20-CORE_28_DC_Heater' 
Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-08-20-CORE_28_DC_Heater'
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '10022016';
switch (whichDate)
  case '10022016' 
    dataFile ='\ISOPERIBOLIC2_DATA/2016-08-20-CORE_28_DC_Heater\IPB2_Core_28b-DC_Qk_CAL_H2_200C-600C_day-01.csv : 02.csv'   
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(8:9);
end     
case 'sri-ipb2-0930' 
Directory='C:\Users\Owner\Dropbox (BEC)\SRI-IPB2\2016-09-30_SRI_v171-core27b'
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '10022016';
switch (whichDate)
  case '10022016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\SRI-IPB2_H2-250-400C_9-30-16_day-01.csv : 03.csv'   
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(6:7);
end 
case 'ipb1-2016-09-30-CRIO-v171_CORE_29b' 
Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\2016-09-30-CRIO-v171_CORE_29b'
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '10122016';
switch (whichDate)
  case '10122016' 
    dataFile ='\ISOPERIBOLIC_DATA\2016-09-30-CRIO-v171_CORE_29b\IPB1_Core_29b-He-DC_QFLOW_CAL-9-30_16_day-01.csv : 02.csv'   
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(19:19);
end
case 'ipb1-0928-crio-v170_core_26b' 
Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\2016-09-28-CRIO-v170_CORE_26b'
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '09282016';
switch (whichDate)
  case '09282016' 
    dataFile ='\ISOPERIBOLIC_DATA\2016-09-28-CRIO-v170_CORE_26b\IPB1_Core_26b-H2-DC_QFLOW_CAL-9-28_16_day-01.csv : 02.csv'   
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(1:2);
end
case 'sri-ipb2'
Directory='C:\Users\Owner\Dropbox (BEC)\SRI-IPB2\2016-09-24_SRI_v170-core27b'
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '09282016';
switch (whichDate)
  case '09282016' 
    dataFile ='SRI-IPB2\_H2-250-400C\_9-28-16\_day-01.csv'   
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(2:3);
   case '09262016' 
    dataFile ='IPB1_Core_27b-_H2-250-400C__9-24-16_day-01.csv:02.csv'   
    startTime = 9;
    endTime = 0; 
    Experiment = AllFiles(2:3);   
end
case 'ipb1-0924-v169-27b'
Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\2016-09-24-CRIO-v169_CORE_26b'
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '09252016-09262016';
switch (whichDate)
  case '09025016-09262016' 
    dataFile ='IPB1_Core_27b-_H2-250-400C__9-24-16_day-01.csv:02.csv'   
    startTime = 3;
    endTime = 10; 
    Experiment = AllFiles(1:2);
   case '09262016' 
    dataFile ='IPB1_Core_27b-_H2-250-400C__9-24-16_day-01.csv:02.csv'   
    startTime = 9;
    endTime = 0; 
    Experiment = AllFiles(2:3);  
end
case 'ipb2-0909-v169-27b' %coreqpow =0
Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-09_CRIO_v169-core27b'
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '09024016';
switch (whichDate)
  case '09024016' 
    dataFile ='IPB2_Core_27b-_H2-250-400C__9-24-16_day-01.csv'   
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(1:1);
end
case 'ipb2-09-24_CRIO_v169-core27b'
Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-24_CRIO_v169-core27b'
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '09024016-09252016';
switch (whichDate)
  case '09024016-09252016' 
    dataFile ='IPB2_Core_27b-_H2-250-400C__9-24-16_day-03.csv'   
    startTime = 2;
    endTime = 0; 
    Experiment = AllFiles(1:2);
  case '09262016' 
    dataFile ='IPB2_Core_27b-_H2-250-400C__9-24-16_day-03.csv'   
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(3:3);   
end
case 'ipb1-0820'
  Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\2016-08-20-CORE_26b'
  AllFiles = getall(Directory);  %SORTED BY DATE....
  whichDate = '08022016-08212016';
  switch (whichDate)
  case '1' 
    dataFile ='ALL'   
    startTime = 1.0;
    endTime = 11; 
    Experiment = AllFiles(1:20);
  case '08022016-08212016'
    dataFile ='IPB1-Core-26b-New-core-He'   
    startTime = 1.0; 
    endTime = 13.5; 
    Experiment = AllFiles(1:3);
  case '3'
    dataFile ='IPB1-Core-26b-New-core-H2'   
    startTime = 1.0;
    endTime = 9;
    Experiment = AllFiles(4:6);
  case '4'
    dataFile ='IPB1-Core-26b-New-core-1st-condition'   
    startTime = 1.0; 
    endTime = 0; 
    Experiment = AllFiles(7:8);    
  case '5'
    dataFile ='IPB1-Core-26b-New-core-2nd-condition'  
    startTime = 1.5;
    endTime = 19; 
    Experiment = AllFiles(9:10);
  case '6'
    dataFile ='IPB1-Core-26b-New-core-3rd-condition'  
    startTime = 1.5;
    endTime = 0; 
    Experiment = AllFiles(11:12)
  case '7'
    dataFile ='IPB1-Core-26b-New-core-H2-D2'  
    startTime = 1.5; 
    endTime = 16; 
    Experiment = AllFiles(16:18);
  case '8'
    dataFile ='IPB1-Core-26b-New-core-H2-D2-Run2'  
    startTime = 3.5; 
    endTime = 12; 
    Experiment = AllFiles(19:21);
  case '9'
    dataFile ='IPB1-Core-26b-New-core-H2-D2-Run3'  
    startTime = 0; 
    endTime = 15; 
    Experiment = AllFiles(22:24);
  case '10'
    dataFile ='IPB1-Core-26b-New-core-H2-D2-Run5'  
    startTime = 0; 
    endTime = 0; 
    Experiment = AllFiles(25:26);
  case '11'
    dataFile ='IPB1-Core-26b-New-core-H2-D2-Run5'  
    startTime = 0; 
    endTime = 0; 
    Experiment = AllFiles(27:27);
  case '12'
    dataFile ='IPB1-Temp-sequence-150-100-150ns-50W-150C-400C-H2.csv'   
    %IPB1_Core_26b-New-core_He_150C-400C_day-01(02)(03).csv (8/20/2016 11:00 - 8/22/2016 10:28)
    startTime = 0; 
    endTime = 15;    
    Experiment = AllFiles(19:21);   
  case '13'
    dataFile ='IPB1-Temp-sequence-150-100-150ns-50W-150C-400C-H2.csv'   
    %IPB1_Core_26b-New-core_He_150C-400C_day-01(02)(03).csv (8/20/2016 11:00 - 8/22/2016 10:28)
    startTime = 0; 
    endTime = 0;   
    Experiment = AllFiles(22:22);
  otherwise
    exit
  end;    
case 'ipb1-0915'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\2016-09-15-CRIO-v167_CORE_26b'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '09222016-09232016'; 
   switch (whichDate)
   case '09162016-09182016' 
     dataFile ='IPB1_Core\_26b-H2-CRIO\_v167\_150C-400C\_Run1\_day-01.csv : 04.csv'
     startTime = 1; 
     endTime = 20;  
     Experiment = AllFiles(1:4);
   case '09182016-09192016' 
     dataFile ='IPB1\_Core\_26b-H2-650C-300C\_Run1\_day-01.csv : 02.csv'
     startTime = 0; 
     endTime = 0;  
     Experiment = AllFiles(6:7);
   case '09212016-09222016' 
     dataFile ='\ISOPERIBOLIC_DATA\2016-09-15-CRIO-v167_CORE_26b\IPB1_Core_26b-H2-250C-400C_Run2_day-01.csv : 02.csv'
     startTime = 0; 
     endTime = 9;  
     Experiment = AllFiles(12:13);
  case '09222016-09232016' 
     dataFile ='\ISOPERIBOLIC_DATA\2016-09-15-CRIO-v167_CORE_26b\IPB1_Core_26b-H2-250C-400C_Run2_day-03.csv'
     startTime = 0; 
     endTime = 9;  
     Experiment = AllFiles(15:15);
   end      
case 'ipb2-08'
  Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-08-20-CORE_28_DC_Heater'
  AllFiles = getall(Directory);  %SORTED BY DATE....
  whichDate ='2';
  detailPlot = 1;
  switch (whichDate)
  case '1' 
    dataFile ='IPB2-core-28b-he'   
    startTime = 0; %11 hours after 6:00
    endTime = 14;   %8/21/2016 20:33
    Experiment = AllFiles(1:3);
  case '2' 
    dataFile ='IPB2-core-28b-h2'   
    startTime = 2; %11 hours after 6:00
    endTime = 7;   %8/21/2016 20:33
    Experiment = AllFiles(4:6);
  case '3'  
    dataFile ='H2-150C-400C-DEUG-NEW-SW'   
    startTime = 0.5; %11 hours after 6:00
    endTime = 32;   %8/21/2016 20:33
    Experiment = AllFiles(13:16);
  otherwise
    exit
  end    
case 'ipb2-0905-164-28b'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-05_Crio_V164_core28b'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '09052016'; 
   switch (whichDate)
   case '09062016-09072016' 
   dataFile ='\ISOPERIBOLIC2_DATA\2016-09-05_Crio_V164_core28b\IPB2_Core_28b-_H2_600C-300C_CRIO_V164_day-01.csv : 02.csv'
   startTime = 7.5; 
   endTime = 5;  
   Experiment = AllFiles(6:6);
   case '09052016' 
   dataFile ='\ISOPERIBOLIC2_DATA\2016-09-05_Crio_V164_core28b\IPB2_Core_28b-_H2_600C-300C_CRIO_V164_Edited.csv'
   startTime = 0; 
   endTime = 0;  
   Experiment = AllFiles(4:4);
   end    
case 'ipb2-0907-165-28b'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-07_Crio_V165_core28b'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '09072016-09082016'; 
   switch (whichDate)
   case '09072016-09082016' 
     dataFile ='ISOPERIBOLIC2_DATA\2016-09-07_Crio_V165_core28b\IPB2-Core-28b--H2-150C-400C-Run1-day-01 : 02.csv'
     startTime = 1; 
     endTime = 0;  
     Experiment = AllFiles(1:2);
   case '09072016-09082016-200' 
     dataFile ='ISOPERIBOLIC2_DATA\2016-09-07_Crio_V165_core28b\IPB2-Core-28b--H2-150C-400C-Run1-day-01 : 02.csv'
     startTime = 1; 
     endTime = 0;  
     Experiment = AllFiles(1:2);
   case '09072016-09082016-250' 
     dataFile ='ISOPERIBOLIC2_DATA\2016-09-07_Crio_V165_core28b\2016-09-07-Crio-V165-core28b-IPB2-Core-28b--H2-150C-400C-Run1-day-01 : 02.csv'
     startTime = 1; 
     endTime = 0;  
     Experiment = AllFiles(2:2);
   end
case 'ipb2-0909-165-27b'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-09_CRIO_v165-core27b'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '1';
   switch (whichDate)
   case '1' 
     dataFile ='2016-09-09-CRIO-v165-core27b'
     startTime = 0; 
     endTime = 0;  
     Experiment = AllFiles(1:1);  
   end        
case 'ipb2-0909-166-27b'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-09_CRIO_v166-core27b'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '09112016-09122016';
   switch (whichDate)
   case '09112016-09122016' 
     dataFile ='2016-09-09-CRIO-v166-core27b-IPB2\_Core\_27b-\_H2\_600C-300C\_\_Run1_day-01.csv : 02.csv'
     startTime = 0; 
     endTime = 15;  
     Experiment = AllFiles(1:2);
   case '09122016' 
     dataFile ='IPB2\_Core\_27b-\_H2_600c-300C\_2probetest1\_EDITED.csv'
     startTime = 0; 
     endTime = 10;  
     Experiment = AllFiles(6:6);
   end    
case 'ipb2-0909-167-27b'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-09_CRIO_v167-core27b'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '09122016';   
   switch (whichDate)
   case '09122016' 
     dataFile ='2016-09-09-CRIO-v167-core27b'
     startTime = 0.5; 
     endTime = 9.5;  
     Experiment = AllFiles(3:3);
   case '09142016-09152016' 
     dataFile ='2016-09-09-CRIO-v167-core27b'
     startTime = 0; 
     endTime = 10;  
     Experiment = AllFiles(7:9);    
   case '09162016-09182016' 
     dataFile ='2016-09-09-CRIO-v167-core27b'
     startTime = 5.5; 
     endTime =7.5 ;  
     Experiment = AllFiles(12:12);    
   case '09162016' 
     dataFile ='2016-09-09-CRIO-v167-core27b'
     startTime = 6; 
     endTime =13 ;  
     Experiment = AllFiles(12:12);    
   case '09192016-09202016' 
     dataFile ='2016-09-09-CRIO-v167-core27b'
     startTime = 0; 
     endTime = 0;  
     Experiment = AllFiles(16:17);    
   case '09212016' 
     dataFile ='2016-09-09-CRIO-v167-core27b data file IPB2_Core\_27b-\_H2-250-400C\_RUN1\_9-20-16\_day-01.csv'
     startTime = 0; 
     endTime = 0;  
     Experiment = AllFiles(18:18);    
   case '09222016' 
     dataFile ='2016-09-09-CRIO-v167-core27b data file: IPB2\_Core\_27b-\_H2-250-400C\_RUN1\_9-21-16\_day-01csv.csv'
     startTime = 0; 
     endTime = 0;  
     Experiment = AllFiles(20:20); 
   case '09232016' 
     dataFile ='2016-09-09-CRIO-v167-core27b data file: IPB2\_Core\_27b-\_H2-250-400C\_RUN1\_9-21-16\_day-02csv.csv'
     startTime = 0; 
     endTime = 0;  
     Experiment = AllFiles(21:21); 
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
aa_splot(dt,smooth(j1(:,2),11),'black','linewidth',1.5);
ylim([5 40])
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

title(dataFile,'fontsize',20)
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
ii = 5; %10 mins from the sequence end.
trim = 2;
while (i < j1Size-1)  
  i = i+1;
  if (j1(i+1,7) - j1(i,7)) == 1 %sequence changed
    i2 = i;
    seq = j1(i2,7);
    dt1(seq) = j1(i2,1); 
    hp(seq) = j1(i2,2); 
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
    coreQPowCV(:),qPowCV(:),qPCBCV(:),qTermCV(:),cjpCV(:),qSupplyP(:),dt2(:),...
'VariableName',{'Temp','QL','QF','HP','CoreQPower','qPow','qPCB','qTerm','CJP','roomT','jLPM','jInT','jOutT',...
'PCBLPM','PCBInT','PCBOutT','termLPM','termInT','termOutT','coreQPowCV','qPowCV','qPCBCV','qTermCV','cjpCV','qSupply','date'});
writetable(T,fn);
end
