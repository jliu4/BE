% Initial housekeeping
clear; close all
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
%Control parameters
qPlot = 1;
dcPlot = 0;
exponentialFit = 0;
qpulseLen = 0;
processYes = 1;
errorBarPlot = 0;
coreRes = 0.5;
%plot bounds setting
hp1 = 10;
hp2 = 25; 
qpow1 = 5;
qpow2 = 55;
coreqpow1 = 0;
coreqpow2 = 12;
% list reactors,cores and directories starting from the most recent ones
%reactor = 'ipb1-29b';
%reactor = 'ipb1-30b';
reactor='sri-ipb2';
%reactor='ipb3-32b';
%reactor='google'; %merge files for google, test before the loading
%reactor='ipb3-36b';
switch (reactor)
case 'google' 
rtFolder='C:\Users\Owner\Dropbox (BEC)\BECteam\Jin\google\';
%list subfolders under google 
subFolder = {'sri-ipb2-27b\2-heaterpow-only'...
             'sri-ipb2-27b\3-qpow8hours'...
             'sri-ipb2-27b\4-qpow-heaterpow-83ns'...
             'sri-ipb2-27b\7-qpow-heaterpow-100ns'...
             'sri-ipb2-27b\qpow-heatpower125w'...
             'sri-ipb2-27b\q-calibration'...
             'sri-ipb2-27b\DC-cali2'...
             'ipb3-32b'...
             'ipb1_30b\6-qpow-only'...
             'ipb1_30b\DC-calibration'...
             'ipb1_30b\5-heaterpower-only'...
             'ipb1_30b\DC-cali2'...
             'ipb1_30b\DC-temp-control'...
             'ipb1_30b\DC-temp-control-12212016'...
             };
Directory=char(strcat(rtFolder,subFolder(6)));
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = 'qpulse-calibration';
switch (whichDate)
case 'qpulse-calibration' 
    dataFile =Directory;
    startTime = 0;
    endTime = 0; 
    hp1 = 0;
    hp2= 60;
    Experiment = AllFiles(1:5);            
end  
case 'ipb3-36b'    
Directory='C:\Users\Owner\Dropbox (BEC)\IPB3_DATA\2016-12-09-16-crio-V181-CORE_B36_FOIL_H2'
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '12132016';
switch (whichDate)
case '12062016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='ipb3-h2-36b';
    startTime = 0;
    endTime = 8; 
    hp1 = 30;
    hp2= 110;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(6:7);        
case '12132016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='ipb3-h2-36b';
    startTime = 0;
    endTime = 8; 
    hp1 = 30;
    hp2= 110;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(8:9);          
end 
case 'ipb3-32b'
rtFolder='C:\Users\Owner\Dropbox (BEC)\IPB3_DATA\';    
subFolder = {'2016-11-28-16-crio-V177-CORE_B31_He',...
 '2016-11-28-16-crio-V179-CORE_B31_He',...
 '2016-12-05-16-crio-V179-CORE_B31_He',...
 '2016-12-05-16-crio-V181-CORE_B31_He',...
 '2016-12-14-16-crio-V181-CORE_B32_He',...
 '2016-12-19-16-crio-V181-CORE_B32_H2'};
folder = 4;
switch folder 
case 6    
Directory=char(strcat(rtFolder,subFolder(folder)));
AllFiles = getall(Directory);  
whichDate = '01022017';
switch (whichDate)
case '12172016'    
    dataFile =strcat(Directory,whichDate); 
    startTime = 0;
    endTime = 0; 
    hp1 = 5; 
    hp2= 40;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(1:3);
case '12302016'    
    dataFile =strcat(Directory,whichDate); 
    startTime = 0;
    endTime = 0; 
    hp1 = 5; 
    hp2= 40;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(21:22);    
case '12312016'    
    dataFile =strcat(Directory,whichDate); 
    startTime = 0;
    endTime = 20; 
    hp1 = 5; 
    hp2= 60;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(23:25);     
case '01022017'    
    dataFile =strcat(Directory,whichDate); 
    startTime = 0;
    endTime = 0; 
    hp1 = 5; 
    hp2= 60;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(27:28);     
    
end    
case 4
Directory=char(strcat(rtFolder,subFolder(folder)));
AllFiles = getall(Directory);     
whichDate = '12092016';
dataFile =strcat(Directory,whichDate); 
switch (whichDate)
case '12092016' 
    startTime = 0;
    endTime = 0; 
    hp1 = 5; 
    hp2= 40;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(4:5);
case '12172016'    
    startTime = 0;
    endTime = 0; 
    hp1 = 5; 
    hp2= 40;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(1:3);
end    
case 6
Directory=char(strcat(rtFolder,subFolder(folder)));
AllFiles = getall(Directory); 
whichDate = '12242016';
dataFile =strcat(Directory,whichDate); 
switch (whichDate)
case '12172016' 
    startTime = 0;
    endTime = 0; 
    hp1 = 5; 
    hp2= 40;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(4:4);         
case '12182016' 
    startTime = 0.0;
    endTime = 0; 
    hp1 = 5;
    hp2= 40;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(5:5);     
case '12192016' 
    startTime = 1;
    endTime = 0; 
    hp1 = 5;
    hp2= 40;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(5:6);        
case '12202016' 
    startTime = 0;
    endTime = 0; 
    hp1 = 5;
    hp2= 40;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(1:2);        
case '12212016' 
    startTime = 0;
    endTime = 0; 
    hp1 = 10;
    hp2= 40;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(7:8);        
case '12242016' 
    startTime = 5;
    endTime = 0; 
    hp1 = 10;
    hp2= 60;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(11:12);        
case '12272016' 
    startTime = 0;
    endTime = 0; 
    hp1 = 10;
    hp2= 60;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(16:17);        
case '12282016' 
    startTime = 0;
    endTime = 0; 
    hp1 = 10;
    hp2= 60;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(18:20);      
end %date
end %folder
case 'ipb1-30b';
rtFolder='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\';    
subFolder = {'2016-11-01-CRIO-v174_CORE_30b_He'...
    '2016-11-01-CRIO-v180_CORE_30b_He'};
folder = 2;
switch folder 
case 2    
Directory=char(strcat(rtFolder,subFolder(folder)));
AllFiles = getall(Directory);
whichDate = '01052017';
dataFile =strcat(Directory,whichDate); 
switch (whichDate)
case '12092016' 
    startTime = 5;
    endTime = 0; 
    hp1 = 0;
    hp2= 15;
    coreqpow1=0;
    coreqpow2=10;
    Experiment = AllFiles(12:13);  
case '12182016' %DC temperature control
    startTime = 5;
    endTime = 0; 
    hp1 = 0;
    hp2= 50;
    coreqpow1=0;
    coreqpow2=12;
    Experiment = AllFiles(21:23);     
case '12242016' %not useful, something went to wrong with excitation, 
    startTime = 5;
    endTime = 0; 
    hp1 = 0;
    hp2= 15;
    coreqpow1=0;
    coreqpow2=10;
    Experiment = AllFiles(24:27); 
case '12262016' %40 hours excitation
    startTime = 5;
    endTime = 0; 
    hp1 = 0;
    hp2= 45;
    coreqpow1=0;
    coreqpow2=12;
    Experiment = AllFiles(28:30);         
case '12302016' %100 hours calibration
    startTime = 5;
    endTime = 0; 
    hp1 = 0;
    hp2= 45;
    coreqpow1=0;
    coreqpow2=12;
    Experiment = AllFiles(31:35);     
case '01012017' 
    startTime = 0;
    endTime = 0; 
    hp1 = 0;
    hp2= 45;
    coreqpow1=0;
    coreqpow2=12;
    Experiment = AllFiles(36:38); 
case '01052017' 
    startTime = 0;
    endTime = 0; 
    hp1 = 0;
    hp2= 45;
    coreqpow1=0;
    coreqpow2=12;
    Experiment = AllFiles(48:49);       
end    
case 1
Directory=char(strcat(rtFolder,subFolder(folder)));
AllFiles = getall(Directory);
whichDate = '11102016';
dataFile =strcat(Directory,whichDate); 
switch (whichDate)
case '11012016' 
    startTime = 0;
    endTime = 0; 
    hp1 = 5;
    hp2= 40;
    Experiment = AllFiles(1:2);        
case '11102016' 
    startTime = 0;
    endTime = 0; 
    hp1 = 5;
    hp2=10;
    Experiment = AllFiles(1:15);
case '11082016' 
    startTime = 0;
    endTime = 0; 
    hp1 = 0;
    hp2=20;
    Experiment = AllFiles(14:17);      
case '11112016' 
    startTime = 0;
    endTime = 0; 
    hp1 = 0;
    hp2=20;
    Experiment = AllFiles(14:17);    
 case '11122016' %250c
    startTime = 17;
    endTime = 0; 
    hp1 = 16;
    hp2 = 20;
    qpow1=15;
    qpow2=55;
    Experiment = AllFiles(15:16);    
case '11152016' 
    startTime = 0;
    endTime = 0; 
    hp1 = 10;
    hp2 = 20;
    Experiment = AllFiles(18:21);
case '11162016' 
    startTime = 0;
    endTime = 0; 
    hp1 = 10;
    hp2 = 20;
    Experiment = AllFiles(23:25);        
case '11172016' 
    startTime = 10.4;
    endTime = 0; 
    hp1 = 10;
    hp2 = 20;
    Experiment = AllFiles(23:25);   
    %Experiment = AllFiles(1:1);   
case '11192016' %250c
    startTime = 9;
    endTime = 0; 
    hp1 = 16;
    hp2 = 30;
    qpow1 = 15;
    qpow2 = 55;
    Experiment = AllFiles(28:28);    
    %Experiment = AllFiles(4:4);    
case '11212016' %300c
    startTime = 16;
    endTime = 0; 
    hp1 = 19;
    hp2 = 26;
    qpow1 = 15;
    qpow2 = 55;
    Experiment = AllFiles(28:29);     
case '11272016' %250-300-400c
    startTime = 0;
    endTime = 0; 
    hp1 = 19;
    hp2 = 40;
    qpow1 = 15;
    qpow2 = 55;
    Experiment = AllFiles(30:33);    
    %Experiment = AllFiles(4:4);  
case '11282016' 
    startTime = 17;
    endTime = 0; 
    hp1 = 5;
    hp2 = 10;
    qpow1 = 15;
    qpow2 = 55;
    Experiment = AllFiles(35:35);    
    %Experiment = AllFiles(4:4);           
case '11292016' 
    startTime = 18;
    endTime = 0; 
    hp1 = 7.5;
    hp2 = 40;
    qpow1 = 15;
    qpow2 = 55;
    coreqpow1 = 1;
    coreqpow2 = 6;
    Experiment = AllFiles(36:39);   
case '12022016' 
    startTime = 0;
    endTime = 0; 
    hp1 = 7.5;
    hp2 = 40;
    qpow1 = 15;
    qpow2 = 55;
    coreqpow1 = 1;
    coreqpow2 = 6;
    Experiment = AllFiles(40:41);       
case '12042016' 
    startTime = 0;
    endTime = 0; 
    hp1 = 7.5;
    hp2 = 40;
    qpow1 = 15;
    qpow2 = 55;
    coreqpow1 = 1;
    coreqpow2 = 6;
    Experiment = AllFiles(43:45);       
case '12062016' 
    startTime = 0;
    endTime = 0; 
    hp1 = 7.5;
    hp2 = 40;
    qpow1 = 15;
    qpow2 = 55;
    coreqpow1 = 1;
    coreqpow2 = 6;
    Experiment = AllFiles(47:48);    
case '12072016' 
    startTime = 0;
    endTime = 0; 
    hp1 = 10;
    hp2 = 21;
    qpow1 = 15;
    qpow2 = 55;
    coreqpow1 = 1;
    coreqpow2 = 6;
    Experiment = AllFiles(50:52);             
case '12092016' 
    startTime = 0;
    endTime = 0; 
    hp1 = 10;
    hp2 = 21;
    qpow1 = 15;
    qpow2 = 55;
    coreqpow1 = 1;
    coreqpow2 = 6;
    Experiment = AllFiles(50:52);             
end %date
end %folder
case 'sri-ipb2'   
rtFolder='C:\Users\Owner\Dropbox (BEC)\SRI-IPB2\';    
subFolder = {'2016-09-24_SRI_v170-core27b'...
    '2016-09-30_SRI_v171-core27b',...
    '2016-11-16_SRI_v174-core27b',...
    '2016-12-16_SRI_v181-core27b'};
folder = 4;
switch folder 
case 2    
Directory=char(strcat(rtFolder,subFolder(folder)));
AllFiles = getall(Directory);
whichDate = '10152016';
dataFile =strcat(Directory,whichDate); 
switch (whichDate)
  case '10152016' 
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(20:22);
end     
case 3    
Directory=char(strcat(rtFolder,subFolder(folder)));
AllFiles = getall(Directory);
whichDate = '12162016';
dataFile =strcat(Directory,whichDate); 
switch (whichDate)
  case '11192016-11212016' 
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(3:5);
  case '11222016' 
    startTime =22;
    endTime = 0; 
    hp1 =5;
    hp2=10;
    Experiment = AllFiles(6:6);  
  case '11272016' 
    startTime =0;
    endTime = 55; 
    hp1 =5;
    hp2=40;
    Experiment = AllFiles(8:8);    
  case '11262016-11292016' %qpowonly 8 hours 
    startTime =70;
    endTime = 0; 
    hp1 =5;
    hp2=40;
    Experiment = AllFiles(8:8);    
  case '11302016-12012016' %heater power at 20w and qpow form 10-50-10, 100ns
    startTime =0;
    endTime = 0; 
    hp1 =15;
    hp2=25;
    Experiment = AllFiles(11:13);   
  case '12032016' 
    startTime =0;
    endTime = 0; 
    hp1 =15;
    hp2=25;
    Experiment = AllFiles(14:15);      
  case '12042016' 
    startTime =0;
    endTime = 0; 
    coreqpow1 =5;
    coreqpow2=10;
    hp1 =15;
    hp2=40;
    Experiment = AllFiles(17:18);      
  case '12062016' 
    startTime =0;
    endTime = 0; 
    coreqpow1 =5;
    coreqpow2=10;
    hp1 =15;
    hp2=40;
    Experiment = AllFiles(19:21);      
  case '12072016' 
    startTime =0;
    endTime = 0; 
    coreqpow1 =0;
    coreqpow2=10;
    hp1 =10;
    hp2=21;
    Experiment = AllFiles(23:25);
  case '12082016' 
    startTime =0;
    endTime = 0; 
    coreqpow1 =0;
    coreqpow2=15;
    hp1 =10;
    hp2=26;
    Experiment = AllFiles(26:29);        
  case '12162016' 
    startTime =0;
    endTime = 0; 
    coreqpow1 =0;
    coreqpow2=10;
    hp1 =0;
    hp2=21;
    Experiment = AllFiles(36:36);      
end
case 4
Directory=char(strcat(rtFolder,subFolder(folder)));
AllFiles = getall(Directory);
whichDate = '01052017';
dataFile =strcat(Directory,whichDate); 
switch (whichDate)
  case '12222016' 
    startTime = 4;
    endTime = 0; 
    Experiment = AllFiles(9:11);
  case '12292016' 
    startTime = 5;
    endTime = 0; 
    Experiment = AllFiles(17:18);  
  case '12312016' 
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(20:21);
    hp1 =0;
    hp2=40;
  case '01032017' 
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(24:25);
    hp1 =0;
    hp2=40;
   
  case '01052017' 
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(27:28);
    hp1 =0;
    hp2=40;
 
end %date
end %folder
end %reactor
Experiment'
loadHHT 
%change a few messy variable names
QOccurred = QOccurred0x3F; clear QPulseOccurred0x3F
%SeqStepNum = SeqStep0x23; clear SeqStep0x23
QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29
QPulseDelays = QPulseDelay0x28s0x29; clear QPulseDelay0x28s0x29
QkHz = QKHz; clear QKHz;
%change datetime to number
dateN=datenum(DateTime,'mm/dd/yyyy HH:MM:SS');
DateTime(1+int16(startTime*360));
DateTime(end - int16(endTime*360));
rawData = horzcat(dateN,...
     SeqStepNum,...
     HeaterPower,...
     CoreTemp,...
     InnerBlockTemp1,...
     OuterBlockTemp1,...
     QPulseLengthns,...
     CoreQPower,...
     CoreQV1Rms,...
     CoreQV2Rms,...
     QSupplyPower,...
     QCur,...
     QSupplyVolt,...
     QSetV,...
     QkHz,...
     QPow,...
     TerminationHeatsinkPower,...
     QPulsePCBHeatsinkPower,...
     CalorimeterJacketFlowrateLPM,...
     QPCBHeatsinkFlowrateLPM,...
     TerminationHeatsinkFlowrateLPM,...
     CalorimeterJacketPower,...
     CalorimeterJacketH2OInT,...
     CalorimeterJacketH2OOutT,...
     QPCBHeatsinkH2OInT,...
     QPCBHeatsinkH2OOutT,...
     TerminationHeatsinkH2OInT,...
     TerminationHeatsinkH2OOutT,...
     QPulseVolt,...
     PressureSensorPSI);
%asignColumn name 

dataset({rawData,'dateN',...
     'SeqStepNum',...
     'HeaterPower',...
     'CoreTemp',...
     'InnerBlockTemp1',...
     'OuterBlockTemp1',...
     'QPulseLengthns',...
     'CoreQPower',...
     'CoreQV1Rms',...
     'CoreQV2Rms',...
     'QSupplyPower',...
     'QCur',...
     'QSupplyVolt',...
     'QSetV',...
     'QkHz',...
     'QPow',...
     'TerminationHeatsinkPower',...
     'QPulsePCBHeatsinkPower',...
     'CalorimeterJacketFlowrateLPM',...
     'QPCBHeatsinkFlowrateLPM',...
     'TerminationHeatsinkFlowrateLPM',...
     'CalorimeterJacketPower',...
     'CalorimeterJacketH2OInT',...
     'CalorimeterJacketH2OOutT',...
     'QPCBHeatsinkH2OInT',...
     'QPCBHeatsinkH2OOutT',...
     'TerminationHeatsinkH2OInT',...
     'TerminationHeatsinkH2OOutT',...
     'QPulseVolt',...
     'PressureSensorPSI'}); 
%filter rawData out 
dataSize = size(rawData,1)
rawData = rawData(1+int16(startTime*360):end-int16(endTime*360),:);
dataSize = size(rawData,1)
%rawData(any(isnan(rawData)),:)=[]; %take out rows with Nan
dataSize = size(rawData,1)
%(isnan(j1)) = -2 ;
rawData = rawData(rawData(:,2) > 0,:); %only process data with seq
dataSize = size(rawData,1)
dt = datetime(dateN, 'ConvertFrom', 'datenum') ;
if (dcPlot == 1)
figure
hold on
aa_splot(dt,HeaterPower,'black','linewidth',1.5);
ylim([hp1, hp2]);
addaxis(dt,CoreTemp,'linewidth',1.5);
addaxis(dt,InnerBlockTemp1);
addaxis(dt,QSupplyVolt);
addaxis(dt,QSupplyPower) ;
addaxis(dt,QSetV);
%addaxis(dt,QCur); 
title(dataFile,'fontsize',11);
addaxislabel(1,'HeaterPower');
addaxislabel(2,'CoreT');
addaxislabel(3,'InnerT');
addaxislabel(4,'QSupply');
addaxislabel(5,'QSupplyVolt'); 
addaxislabel(6,'QSetV'); 
%addaxislabel(7,'QCur');
end 
if (qPlot == 1)
figure(1)
hold on
aa_splot(dt,HeaterPower,'black','linewidth',1.5); 
ylim([hp1, hp2]);
addaxis(dt,CoreTemp,'linewidth',1.5); 
addaxis(dt,QPow,[qpow1,qpow2]); 
addaxis(dt,CoreQPower,[coreqpow1,coreqpow2]) ;
addaxis(dt,CoreQV1Rms,[0,12]); 
addaxis(dt,CoreQV2Rms,[0,12]) ;
addaxis(dt,(CoreQV1Rms-CoreQV2Rms).*(CoreQV1Rms-CoreQV2Rms)/coreRes,[coreqpow1,coreqpow2]) ;
title(dataFile,'fontsize',11);
addaxislabel(1,'Heater Power(W)');
addaxislabel(2,'CoreTemp(C)');
addaxislabel(3,'QPow(W)');
addaxislabel(4,'CoreQPow(W)'); 
addaxislabel(5,'V1Rms(Volt)');
addaxislabel(6,'V2Rms(Volt)'); 
addaxislabel(7,strcat('(V1-V2)^2/',num2str(coreRes))); 
end 
if (processYes == 1) 
ctFit = [];
itFit = [];
i=0;
i1 = 1;
ii = 30; %30*10=300 seconds before to next seq.
if ii > 5;
  trim = round(200/ii); %k = ii*(trim/100)/2 through away one highset/lowest point trim = 200/ii
else
  trim = 0;
end    
seq2 = 0;
while (i < dataSize-1)  
  i = i+1;
  if abs(SeqStepNum(i+1) - SeqStepNum(i)) >= 1  %sequence changed or at least sequence has run more than an half hour
    i2 = i;
    if i2-i1 > 30 %only pick up the sequence has more then half hours runs
    seq2=seq2+1;
    seq = SeqStepNum(i);
    seq1(seq2)=seq;
    dt1(seq2) = dateN(i2); 
    hp(seq2) = trimmean(HeaterPower(i2-ii:i2),trim);
    coreT(seq2)=trimmean(CoreTemp(i2-ii:i2),trim);
    ql(seq2) = QPulseLengthns(i);
    qf(seq2) = trimmean(QkHz(i2-ii:i2),trim);
    qPow(seq2) = trimmean(QPow(i2-ii:i2),trim);
    coreQPow(seq2)=trimmean(CoreQPower(i1:i2),trim);
    v1(seq2)=trimmean(CoreQV1Rms(i1:i2),trim);
    v2(seq2)=trimmean(CoreQV2Rms(i1:i2),trim);
    qSP(seq2) = trimmean(QSupplyPower(i2-ii:i2),trim); 
    inT(seq2) = trimmean(InnerBlockTemp1(i2-ii:i2),trim);
    outT(seq2) = trimmean(OuterBlockTemp1(i2-ii:i2),trim);
    qSV(seq2) = trimmean(QSupplyVolt(i2-ii:i2),trim);
    qCur(seq2) = trimmean(QCur(i2-ii:i2),trim);
    qSetV(seq2) = trimmean(QSetV(i2-ii:i2),trim);
    if exponentialFit 
      size1 = length(CoreTemp(i1:i2));
      x=1:size1;
      x1 = reshape(x,[size1,1]);  
      f1 = fit(x1,CoreTemp(i1:i2),'exp2');
      ctFit(seq2,1:4)= coeffvalues(f1);
      f2 = fit(x1,InnerBlockTemp1(i1:i2),'exp2');
      itFit(seq2,1:4)= coeffvalues(f2);
      %figure
      % plot(f,x1,j1(i1:i2,3));
    end
    i12(seq2)=i2-i1;
    i1 = i2+1; 
    end
  end 
end 
dt2 = datetime(dt1, 'ConvertFrom', 'datenum') ;
fn = ['C:\jinwork\BEC\tmp\' reactor '-' whichDate '.csv'];            
delete(fn);
T=table(coreT(:),inT(:),outT(:),ql(:),qf(:),hp(:),coreQPow(:),v1(:),v2(:),qPow(:),qSP(:),qSV(:),qCur(:),qSetV(:),seq1(:),i12(:),dt2(:),...
'VariableName',{'coreT','inT','outT','QL','QF','HP','CoreQPower','v1','v2','qPow','qSP','qSV','qCur','qSetV','seq','steps','date'});
writetable(T,fn);

if exponentialFit 
  fileID = fopen(['C:\jinwork\BEC\tmp\' reactor '-expFit' whichDate '.csv'],'w');
  %fprintf(fileID,'%4s %12s\n','x','exp(x)');
  fprintf(fileID,'%6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f\n',ctFit,itFit);
  fclose(fileID);
end
end
