 % Initial housekeeping
clear; close all; clc
addpath('C:\jinwork\BE\matlab\logDataProcess')
addpath('C:\jinwork\BE\matlab\addaxis5')
addpath('C:\jinwork\BE\matlab\altmany-export_fig-5be2ca4')
home = [getenv('HOMEDRIVE') getenv('HOMEPATH')];
if contains(home,'admin')
  dataPath = 'C:\Users\admin\Dropbox (BEC)\';
else
  dataPath = 'D:\DropBox\Dropbox (BEC)\';
end  
%dataPath = 'D:\DropBox\Dropbox (BEC)\';
outputPath ='C:\jinwork\BEC\tmp\';
googleModelPath = 'C:\jinwork\BE\matlab\df-google\matfiles\';
%Control parameters
tsPlot = true; googleCopPlot = true; debugPlot = false; tsMultiPlot = false; tempExpFit = false; hpExpFit = true;  %has to set true TODO JLIU
postProcess = true; writeOutput = true; plotOutput = true; detailPlot = true;findDuplicates = false;
%plot bounds setting
startOffset = 0;endOffset = 0;hp1 = 0;hp2 = 50; qp1 = 5;qp2 = 55;cqp1 = 0;cqp2 = 18; temp1 = 250; temp2 = 350;
colors = setColors();
%read cases
readCase;

figname = strcat(outputPath,aSetdesc,'.pdf');
delete(figname);
filen1 = strcat(outputPath,aSetdesc,'detail.csv');
filen2 = strcat(outputPath,aSetdesc,'.csv');
T1=cell2table(cell(0,24),...
'VariableName',{'coreT','inT','outT','QL','QF','HP','CoreQPower','v1','v2','v3','qPow','qSP','qSV','h2','termP','pcbP',...
'p1','p2','p3','p4','hp_','seq','steps','date'});
T2 = cell2table(cell(0,14),'VariableNames',{'coreT','icT','icTsse','R','Rsse','C','M','Msse','Ra','Rb','Ca','Cb','Ma','Mb'});
pos = [10 10 1000 800];
fsummary=figure('Position',pos);
if tsMultiPlot
  ftsMulitplot = figure('Position',pos);
end
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
  coreL = aSet.coreL(ai);
  isDC = aSet.isDC(ai);
  efficiency = aSet.efficiency(ai);
  termRes = aSet.termRes(ai);
  version = aSet.version(ai);
  googleModel = aSet.googleModel(ai);
  desc = char(aSet.desc(ai));
  switch (reactor)
    case {'ipb1-29'; 'ipb1-30';'ipb1-13';'ipb1-40';'ipb1-41'}
      rtFolder='ISOPERIBOLIC_DATA'; 
    case {'sri-ipb1-41'}
      rtFolder='SRI-IPB1';  
    case {'sri-ipb2-27';'sri-ipb2-33'}
      rtFolder='SRI-IPB2';  
    case {'ipb3-32';'ipb3-37';'ipb3-42';'ipb3-43'}
      rtFolder='IPB3_DATA';   
    case {'ipb4-37';'ipb4-44'}
      rtFolder='IPB4_DATA';       
    case 'sri-conflat'
      rtFolder='SRIdata';
  end %switch
  Directory=char(strcat(dataPath,rtFolder,'\',folder));
  tmpDir = extractAfter(Directory,dataPath);

  AllFiles = getall(Directory); 
  Experiment= AllFiles(file1:file2); 
  Experiment'
  loadCSVFile; 
  dateN=datenum(DateTime,'mm/dd/yyyy HH:MM:SS');
  if contains(rtFolder,'SRIdata')
   %conflat
    loadConflat;
  else   
   %IPB
    loadIPB;
  end
  if findDuplicates
   numberOfAppearancesOfRepeatedValues =duplicates(CoreQV1Rms);
  end

  if ~postProcess
    continue;
  else   
    %tStr = strcat(reactor,'-',runDate,'-',gas,'-',power);    
    tStr = strcat(reactor,'-',runDate,'-',desc);    
    %ff(ai) = figure('Position',pos);
    ff(ai) = 0;
    [T1,pdata] = writeOut(rawDataN,T1,hpExpFit,tempExpFit,writeOutput,figname,tStr,ff(ai));
    %comment out , too many plots
    %export_fig(ff(ai),figname,'-append');
    if true
       
      [tt,icT,hpdrop,v12,dqp,v122,hv,res,hva,hvb,hqpa,hqpb,resa,resb,hv0,hqp0,res0,ql,...
       hqp0sse,res0sse,icTsse] = plotSummary(pdata,isDC,efficiency,temp1,temp2);
    if detailPlot
      %plot for all temperatures each q-pulse  
      for qi = 1:size(ql,1)   
        f(qi)=figure('Position',pos);
        grid on;
        grid minor;
        hold on
        for i = 1:size(tt,2) 
          %tqStr = strcat(tStr,'-',num2str(ql(qi)),'-ns');
          tqStr = strcat(tStr);
          ylabel('V^2');
          xlabel('P[w]'); 
          title(tqStr);  
          x=[0,max(dqp(:,qi,i))];
          y=[0,res0(qi,i)*x(2)];
          x1 = [0 dqp(:,qi,i)'];
          y1 = [resb(qi,i) v122(:,qi,i)'];
          %plot(dqp(:,qi,i),v122(:,qi,i),'-x','Color',colors(i,:));
          plot(x1,y1,'-x','Color',colors(i,:));
          %ylim([0 7]);
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
        %tqStr = strcat(tStr,'-',num2str(ql(qi)),'-ns');
        tqStr = strcat(tStr);
        ylabel('HpDrop[w]');
        xlabel('P[w]'); 
        title(tqStr);  
        x=[0,max(dqp(:,qi,i))];
        y=[0,hqp0(qi,i)*x(2)];
        %add one more point
        x1 = [0 dqp(:,qi,i)'];
        y1 = [hqpb(qi,i) hpdrop(:,qi,i)'];
        %plot(dqp(:,qi,i),hpdrop(:,qi,i),'-x','Color',colors(i,:));
        plot(x1,y1,'-x','Color',colors(i,:));
        %ylim([0 7]);
        plot(x,y,'--','Color',colors(i,:));     
        l2{2*(i-1)+1}=strcat(power,'-',gas,'-CoreTemp=',num2str(tt(i))); 
        l2{2*i}=strcat(power,'-',gas,'-CoreTemp=',num2str(tt(i))); 
      end
      legend(l2,'Location','northwest');
      export_fig(f(qi),figname,'-append');
    end  
  end  
  figure(fsummary);
  for qi = 1:size(ql,1) 
    fcount = fcount + 1; 
   % tqStr = strcat(tStr,'-',num2str(ql(qi)),'-ns');
    tqStr = strcat(tStr);
    subplot(1,3,1);
    grid on;
    grid minor;
    hold on;
    
    %errorbar(dt1,OutT1,OutT1Error,'green','linewidth',1.5);
    errorbar(tt(:),res0(qi,:),res0sse(qi,:),'Color',colors(ai,:));
    %h1=plot(tt(:),res0(qi,:),'-o','Color',Col);
    xlim([temp1 temp2]);
    ytemp = strcat('V^2 / P');
    ylabel(ytemp); 
    subplot(1,3,2);
    grid on;
    grid minor;
    hold on;
    errorbar(tt(:),hqp0(qi,:),hqp0sse(qi,:),'Color',colors(ai,:));
    %h3=plot(tt(:),hqp0(qi,:),'-o','Color',Col);
    xlim([temp1 temp2]);
    ytemp = strcat('HpDrop / P');
    ylabel(ytemp);
    subplot(1,3,3);
    grid on;
    grid minor;
    hold on;
    %h4=plot(tt(:),icT(qi,:),'-o','Color',Col);
    errorbar(tt(:),icT(qi,:),icTsse(qi,:),'Color',colors(ai,:));
    xlim([temp1 temp2]);
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
if tsMultiPlot
  export_fig(ftsMulitplot,figname,'-append');
end
if postProcess
  legend(l1,'Location','SouthOutside');
  %legend(l1,'Location','NorthOutside','Orientation','horizontal');
  export_fig(fsummary,figname,'-append');
  writetable(T1,filen1);
  writetable(T2,filen2);
end


