% Initial housekeeping
clear; close all; clc
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
addpath('C:\jinwork\BE\matlab\export_fig\altmany-export_fig-2763b78')
dataPath = 'C:\Users\Owner\Dropbox (BEC)\';
outputPath ='C:\jinwork\BEC\tmp\';
%[1 1 0]	Yellow
%[0 0 0]	Black
%[0 0 1]	Blue
%[0 1 0]	Bright green
%[0 1 1]	Cyan
%[1 0 0]	Bright red
%[1 0 1]	Pink
%[1 1 1]	White
%[0.9412 0.4706 0]	Orange
%[0.251 0 0.502]	Purple
%[0.502 0.251 0]	Brown
%[0 0.251 0]	Dark green
%[0.502 0.502 0.502]	Gray
%[0.502 0.502 1]	Light purple
%[0 0.502 0.502]	Turquoise
%[0.502 0 0]	Burgundy 
%[1 0.502 0.502]	Peach
colors=[0 0 0
    0 0 1
    0 1 0
    0 1 1
    1 0 0
    1 0 1
    240/255 120/255 0
    64/255 0 128/255
    128/255 64/255 0
    0 64/255 0
    128/255 128/255 128/255
    128/255 128/255 1
    0 128/255 128/255
    128/255 0 0
    1 128/255 128/255
    128/255 1 128/255
    0 240/255 120/255
    128/255 64/255 128/255
    rand rand rand
    rand rand rand
    rand rand rand];
%Control parameters
qPlot = true; dcPlot = true; debugPlot = false; tempExpFit = false; hpExpFit = true; %has to set true TODO JLIU
postProcess = true; writeOutput = true; plotOutput = true; detailPlot = true;findDuplicates = false;
%plot bounds setting
startOffset = 0;endOffset = 0;hp1 = 0;hp2 = 60; qp1 = 5;qp2 = 55;cqp1 = 0;cqp2 = 12;
%read data in
ipb1_13 = readtable('ipb1-13.xlsx');
ipb1_29 = readtable('ipb1-29.xlsx');
ipb1_30 = readtable('ipb1-30.xlsx');
ipb3_32 = readtable('ipb3-32.xlsx');
sri_ipb2_27 = readtable('sri-ipb2-27.xlsx');
sri_ipb2_33 = readtable('sri-ipb2-33.xlsx');
ipb3_37 = readtable('ipb3-37.xlsx');
%analysis set
%[ipb1_30(4:5,:);ipb1_30(17:18,:);ipb1_30(22,:);ipb1_30(10,:);ipb1_30(14,:)],...
%[sri_ipb2_27(4:6,:);sri_ipb2_27(9:11,:)],...
%[ipb1_30(4:5,:);ipb1_30(17,:);ipb1_30(22,:);ipb3_32(2,:);ipb3_32(5:6,:);ipb3_37(3,:);ipb3_37(8:9,:);sri_ipb2_27(4:5,:);sri_ipb2_33(1,:)],...
%[ipb3_37(3,:);ipb3_37(8:10,:);ipb3_37(4:6,:);ipb3_37(11,:)],...
aSetMap = containers.Map(...
{'10-ipb1-30b-he-h2-dc-q-5',...
 '11-ipb1-30b-h2-dc-q-2',...
 '12-ipb1-13-h2-q',...
 '20-sri-ipb2-27b-h2-dc-q',...
 '21-sri-ipb2-33b-h2-dc-q',...
 '30-ipb3-32b-he-h2-dc-q',...
 '31-ipb3-37b-he-dc-q',...
 '5-all-dcs',...
 '7-ipb1-30b-sri-ipb2-he-h2-dc-q',...
 '8-dc-ipb1-2',...
 '9-ipb1',...
 '91-ipb1-29',...
 '92-ipb3-37',...
  },...
 {[ipb1_30(5,:);ipb1_30(22,:);ipb1_30(14,:);ipb1_30(26:27,:)],...
  [ipb1_30(22,:);ipb1_30(26,:)],...
  ipb1_13(1:2,:),...
  [sri_ipb2_27(4,:);sri_ipb2_27(10,:)],...
  [sri_ipb2_33(1:3,:)],...
  [ipb3_32(2,:);ipb3_32(5:6,:);ipb3_32(9:10,:)],...
  [ipb3_37(8,:);ipb3_37(10,:);ipb3_37(6,:);ipb3_37(15,:)],...
  [ipb1_30(5,:);ipb1_30(22,:);ipb3_37(8,:);ipb3_37(10,:);sri_ipb2_33(1,:);sri_ipb2_27(4,:);ipb1_13(1,:)],...
  [ipb1_30(4,:);ipb1_30(22,:);sri_ipb2_27(4,:);ipb1_30(10,:);ipb1_30(14,:);sri_ipb2_27(9,:);sri_ipb2_27(10,:)],...
  [ipb1_30(4:5,:);sri_ipb2_27(4:5,:)],...
  [ipb1_30(5,:);ipb1_30(22,:);ipb1_30(14,:);ipb1_30(26,:)],...
  ipb1_29(3:4,:),...
  ipb3_37(13,:)
  });
%perferred order dc-he,dc-h2,q-he,q-h2
descSet = keys(aSetMap);
aSetdesc = char(descSet(5));
aSet = aSetMap(aSetdesc);
figname = strcat(outputPath,aSetdesc,'.pdf');
delete(figname);
filen1 = strcat(outputPath,aSetdesc,'detail.csv');
filen2 = strcat(outputPath,aSetdesc,'.csv');
T1=cell2table(cell(0,24),...
'VariableName',{'coreT','inT','outT','QL','QF','HP','CoreQPower','v1','v2','v3','qPow','qSP','qSV','h2','termP','pcbP',...
'p1','p2','p3','p4','hp_','seq','steps','date'});
T2 = cell2table(cell(0,14),'VariableNames',{'coreT','icT','icTsse','R','Rsse','C','M','Msse','Ra','Rb','Ca','Cb','Ma','Mb'});
pos = [10 10 1000 800];
f1=figure('Position',pos);
%the summary plot count number
fcount = 0;
for ai = 1:size(aSet,1)
 reactor  = char(aSet.reactor(ai));
 folder  = char(aSet.folder(ai));
 runDate = char(aSet.runDate(ai));
 file1 = int8(aSet.file1(ai));
 file2 = int8(aSet.file2(ai)); 
 startOffset = aSet.startOffset(ai);
 endOffset = aSet.endOffset(ai);
 gas = char(aSet.gas(ai));
 isDC = aSet.isDC(ai);
 efficiency = aSet.efficiency(ai);
 termRes = aSet.termRes(ai);
 version = aSet.version(ai);
switch (reactor)
case 'ipb1-29'  
  rtFolder='ISOPERIBOLIC_DATA';   
case {'ipb1-30';'ipb1-13'}
  rtFolder='ISOPERIBOLIC_DATA';      
case {'sri-ipb2-27';'sri-ipb2-33'}
  rtFolder='SRI-IPB2';  
case {'ipb3-32';'ipb3-37'}
  rtFolder='IPB3_DATA';     
case 'google'
  rtFolder='\BECteam\Jin\google';
end %switch
Directory=char(strcat(dataPath,rtFolder,'\',folder));
AllFiles = getall(Directory); 
Experiment= AllFiles(file1:file2); 
Experiment'
loadHHT 
%clean
QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29
%SeqStepNum = SeqStep0x23; clear SeqStep0x23    
power = 'q';
if isDC
  power = 'dc';
end  
tmpDir = extractAfter(Directory,dataPath);
plotTitle =strcat(tmpDir,'-',runDate,'-',power,'-',gas); 
%change datetime to number
dateN=datenum(DateTime,'mm/dd/yyyy HH:MM:SS');
%if version < 173  
 % SeqStepNum = SeqStep0x23; clear SeqStep0x23  
%end    
if strcmp(folder,'2016-09-30_SRI_v171-core27b') % we did not have V1 and V2 columns
    SeqStepNum = SeqStep0x23; clear SeqStep0x23  
    rawData = horzcat(dateN,...
     SeqStepNum,...
     HeaterPower,...
     CoreTemp,...
     InnerBlockTemp1,...
     OuterBlockTemp1,...
     OuterBlockTemp2,...
     QPulseLengthns,...
     CoreQPower,...
     CoreQPower,...
     CoreQPower,...
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
     PressureSensorPSI,...
     RoomTemperature);
     %HydrogenValves);
elseif version < 186 %no V3    
rawData = horzcat(dateN,...
     SeqStepNum,...
     HeaterPower,...
     CoreTemp,...
     InnerBlockTemp1,...
     OuterBlockTemp1,...
     OuterBlockTemp2,...
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
     PressureSensorPSI,...
     RoomTemperature);
else %we added v3
    rawData = horzcat(dateN,...
     SeqStepNum,...
     HeaterPower,...
     CoreTemp,...
     InnerBlockTemp1,...
     OuterBlockTemp1,...
     OuterBlockTemp2,...
     QPulseLengthns,...
     CoreQPower,...
     CoreQV1Rms,...
     CoreQV2Rms,...
     QSupplyPower,...
     QCur,...
     QSupplyVolt,...
     CoreQV3Rms,...
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
     PressureSensorPSI,...
     RoomTemperature);
end
%find duplicated
if findDuplicates
  duplicates(coreTemp);
end
%show startOffset and endOffset
DateTime(1+int16(startOffset*360))
DateTime(end - int16(endOffset*360))
rawData = rawData(1+int16(startOffset*360):end-int16(endOffset*360),:);
%(isnan(j1)) = -2 ;
rawData = rawData(rawData(:,2) > 0,:); %only process data with seq
%rawData(any(isnan(rawData)),:)=[]; %take out rows with NaN but not a good code
%rawData(any(isnan(rawData),2),:)=[];
%asignColumn name 
rawDataN = dataset({rawData,'dateN',...
     'SeqStepNum',...
     'HeaterPower',...
     'CoreTemp',...
     'InnerBlockTemp1',...
     'OuterBlockTemp1',...
     'OuterBlockTemp2',...
     'QPulseLengthns',...
     'CoreQPower',...
     'CoreQV1Rms',...
     'CoreQV2Rms',...
     'QSupplyPower',...
     'QCur',...
     'QSupplyVolt',...
     'CoreQV3Rms',...
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
     'PressureSensorPSI',...
     'RoomTemperature'});
     %'HydrogenValves'}); 
dt = datetime(rawDataN.dateN, 'ConvertFrom', 'datenum') ;
if isDC
  if dcPlot
    plotDC(dt,hp1,hp2,rawDataN,plotTitle,pos,figname);   
  end
else  
  if qPlot
    plotQ(dt,hp1,hp2,qp1,qp2,cqp1,cqp2,rawDataN,plotTitle,pos,figname);  
  end
  if debugPlot
    plotQdebug(dt,rawDataN,plotTitle,pos,figname);  
  end    
end    
if ~postProcess
    continue;
else   

  tStr = strcat(reactor,'-',runDate,'-',gas,'-',power);    
  %ff(ai) = figure('Position',pos);
  ff(ai) = 0;
  [T1,pdata] = writeOut(rawDataN,T1,hpExpFit,tempExpFit,writeOutput,figname,tStr,ff(ai));
  %comment out , too many plots
  %export_fig(ff(ai),figname,'-append');
  if true
  [tt,icT,hpdrop,v12,dqp,v122,hv,res,hva,hvb,hqpa,hqpb,resa,resb,hv0,hqp0,res0,ql,...
     hqp0sse,res0sse,icTsse] = plotSummary(pdata,isDC,efficiency);
  if detailPlot
    %plot for all temperatures each q-pulse  
    for qi = 1:size(ql,1)   
      f(qi)=figure('Position',pos);
      grid on;
      grid minor;
      hold on
      for i = 1:size(tt,2) 
        tqStr = strcat(tStr,'-',num2str(ql(qi)),'-ns');
        ylabel('V^2');
        xlabel('P[w]'); 
        title(tqStr);  
        x=[0,max(dqp(:,qi,i))];
        y=[0,res0(qi,i)*x(2)]; 
        plot(dqp(:,qi,i),v122(:,qi,i),'-x','Color',colors(i,:));
        plot(x,y,'--','Color',colors(i,:));       
        l2{2*(i-1)+1}=strcat(power,'-',gas,'-CoreTemp=',num2str(tt(i))); 
        l2{2*i}=strcat(power,'-',gas,'-CoreTemp=',num2str(tt(i))); 
      end
      legend(l2,'Location','northwest');
      export_fig(f(qi),figname,'-append');
    end  
    for qi = 1:size(ql,1)   
      f(qi)=figure('Position',pos);
      grid on;
      grid minor;
      hold on
      for i = 1:size(tt,2) 
        tqStr = strcat(tStr,'-',num2str(ql(qi)),'-ns');
        ylabel('HpDrop[w]');
        xlabel('P[w]'); 
        title(tqStr);  
        x=[0,max(dqp(:,qi,i))];
        y=[0,hqp0(qi,i)*x(2)];
        plot(dqp(:,qi,i),hpdrop(:,qi,i),'-x','Color',colors(i,:));
        plot(x,y,'--','Color',colors(i,:));     
        l2{2*(i-1)+1}=strcat(power,'-',gas,'-CoreTemp=',num2str(tt(i))); 
        l2{2*i}=strcat(power,'-',gas,'-CoreTemp=',num2str(tt(i))); 
      end
      legend(l2,'Location','northwest');
      export_fig(f(qi),figname,'-append');
    end  
  end  
  figure(f1);
  for qi = 1:size(ql,1) 
    fcount = fcount + 1; 
    tqStr = strcat(tStr,'-',num2str(ql(qi)),'-ns');
    subplot(1,3,1);
    grid on;
    grid minor;
    hold on;
    
    %errorbar(dt1,OutT1,OutT1Error,'green','linewidth',1.5);
    errorbar(tt(:),res0(qi,:),res0sse(qi,:),'Color',colors(ai,:));
    %h1=plot(tt(:),res0(qi,:),'-o','Color',Col);
    xlim([200 400]);
    ytemp = strcat('V^2 / P');
    ylabel(ytemp); 
    subplot(1,3,2);
    grid on;
    grid minor;
    hold on;
    errorbar(tt(:),hqp0(qi,:),hqp0sse(qi,:),'Color',colors(ai,:));
    %h3=plot(tt(:),hqp0(qi,:),'-o','Color',Col);
    xlim([200 400]);
    ytemp = strcat('HpDrop / P');
    ylabel(ytemp);
    subplot(1,3,3);
    grid on;
    grid minor;
    hold on;
    %h4=plot(tt(:),icT(qi,:),'-o','Color',Col);
    errorbar(tt(:),icT(qi,:),icTsse(qi,:),'Color',colors(ai,:));
    xlim([200 400]);
    ytemp = strcat('Inner / core Temp');
    ylabel(ytemp);
    l1{fcount}=tStr; 
    T2 =[T2;table(tt(:),icT(qi,:)',icTsse(qi,:)',res0(qi,:)',res0sse(qi,:)',hv0(qi,:)',hqp0(qi,:)',hqp0sse(qi,:)',...
    resa(qi,:)',resb(qi,:)',...   
    hva(qi,:)',hvb(qi,:)',...
    hqpa(qi,:)',hqpb(qi,:)',...
    'VariableNames',{'coreT','icT','icTsse','R','Rsse','C','M','Msse','Ra','Rb','Ca','Cb','Ma','Mb'})];
  end
 end
end
end
if postProcess
  legend(l1,'Location','SouthOutside');
  %legend(l1,'Location','NorthOutside','Orientation','horizontal');
  export_fig(f1,figname,'-append');
  writetable(T1,filen1);
  writetable(T2,filen2);
end

