% Initial housekeeping
clear; close all; clc
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
%Control parameters
qPlot = false;
dcPlot = false;
tempExpFit = false;
hpExpFit = false;
postProcess = true;
writeOutput = false;
plotOutput = true;
errorBarPlot = false;
findDuplicates = false;
%plot bounds setting
coreRes = 0.5;
startOffset = 0;
endOffset = 0;
hp1 = 0;
hp2 = 40; 
qp1 = 5;
qp2 = 55;
cqp1 = 0;
cqp2 = 12;
%ipb1_29 = readtable('ipb1-29.csv');
%ipb1_30 = readtable('ipb1-30.csv','ReadRowNames',true,'format','%s%s%s%s%d%d%d%d%d%d%s');
ipb1_30 = readtable('ipb1-30.xlsx');
ipb3_32 = readtable('ipb3-32.xlsx');
sri_ipb2_27 = readtable('sri-ipb2-27.xlsx');
ipb3_37 = readtable('ipb3-37.xlsx');
aSet=[ipb1_30(1,:)]
aSet=ipb3_32 
aSet=ipb1_30
aSet=[sri_ipb2_27(3,:);ipb3_37]
aSet=[sri_ipb2_27(5,:)]
for ai = [1]
 reactor  = char(aSet.reactor(ai));
 folder  = char(aSet.folder(ai));
 runDate = num2str(aSet.runDate(ai));
 file1 = int8(aSet.file1(ai));
 file2 = int8(aSet.file2(ai));
 startOffset = aSet.startOffset(ai);
 endOffset = aSet.endOffset(ai);
 isHe = aSet.isHe(ai);
 isDC = aSet.isDC(ai);
switch (reactor)
case 'ipb1-29'  
  rtFolder='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\';    
  SeqStepNum = SeqStep0x23; clear SeqStep0x23         
case 'ipb1-30'
  rtFolder='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\';      
case 'sri-ipb2-27'
  rtFolder='C:\Users\Owner\Dropbox (BEC)\SRI-IPB2\';
  %SeqStepNum = SeqStep0x23; clear SeqStep0x23       
case 'ipb3-32'
  rtFolder='C:\Users\Owner\Dropbox (BEC)\IPB3_DATA\';     
case 'ipb3-37'
  rtFolder='C:\Users\Owner\Dropbox (BEC)\IPB3_DATA\';       
case 'google'
  rtFolder='C:\Users\Owner\Dropbox (BEC)\BECteam\Jin\google\';
end %switch
Directory=char(strcat(rtFolder,folder));
AllFiles = getall(Directory); 
Experiment= AllFiles(file1:file2); 
Experiment'
loadHHT 
QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29
plotTitle =strcat(Directory,'-',runDate); 
%change datetime to number
dateN=datenum(DateTime,'mm/dd/yyyy HH:MM:SS');
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
     QKHz,...
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
     %HydrogenValves);
%filter rawData out 
dataSize = size(rawData,1);
%find duplicated
if findDuplicates
  duplicates(coreTemp);
end
%show startOffset and endOffset
DateTime(1+int16(startOffset*360))
DateTime(end - int16(endOffset*360))
rawData = rawData(1+int16(startOffset*360):end-int16(endOffset*360),:);
%rawData(any(isnan(rawData)),:)=[]; %take out rows with NaN
%(isnan(j1)) = -2 ;
rawData = rawData(rawData(:,2) > 0,:); %only process data with seq
dataSize = size(rawData,1)
%asignColumn name 
rawDataN = dataset({rawData,'dateN',...
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
     'QKHz',...
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
     %'HydrogenValves'}); 
dt = datetime(dateN, 'ConvertFrom', 'datenum') ;
if dcPlot
  plotDC(dt,hp1,hp2,rawDataN,plotTitle);   
end 
if qPlot
  plotQ(dt,hp1,hp2,qp1,qp2,cqp1,cqp2,coreRes,rawDataN,plotTitle);  
end 
if postProcess
 fn = char(strcat('C:\jinwork\BEC\tmp\', reactor, '-', runDate, '.csv') );        
 writeOut(rawDataN,isDC,isHe,fn,hpExpFit,tempExpFit,writeOutput,plotOutput);
end 
end
