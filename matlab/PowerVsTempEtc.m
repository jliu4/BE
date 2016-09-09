clear all;close all
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
dailyPlot = 1;
detailPlot = 1;
processYes = 1;
qpulse = 1;
%input reactor
reactor = 'ipb1' %'sri'; %'ipb1','ipb2-aug','ipb2-sep05','conflat'
switch (reactor)
case 'ipb2-sep07'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-05_Crio_V164_core28b'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichSeq = 3;
   detailPlot = 1;
   %input which sequence
   switch (whichSeq)
   case 1 
     seqFile ='All'
     startTime = 0; %9/5/2016 
     endTime = 0;  
     Experiment = AllFiles(5:6);
     %for temp=[277 302 327 352]
   case 2
     seqFile ='IPB2-Core-28b-H2-600c-300c-CRIO-V164'       
     startTime = 0; 
     endTime = 0; 
     Experiment = AllFiles(1:2);
     %for temp=[602 502 402 302]
   case 3
     seqFile ='IPB2-Core-28b-H2-150c-400c-CRIO-V164'       
     startTime = 0; 
     endTime = 0; 
     Experiment = AllFiles(5:6);
     %for temp=[602 502 402 302]
   end
case 'ipb2-sep07'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-07_Crio_V165_core28b'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichSeq = 1;
   detailPlot = 1;
   switch (whichSeq)
   case 1
     seqFile ='IPB2-Core-28b-H2-150c-400c-run1-09072016'       
     startTime = 0; 
     endTime = 0; 
     Experiment = AllFiles(1:2);
   end
case 'sri'
   Directory='C:\jinwork\BEC\Data\SRIdata\2016-08-12'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichSeq = 1;
   %input which sequence
   switch (whichSeq)
   case 1 %ALL
     seqFile ='ALL'  %8/12/2016-9/5/2016     
     startTime = 0; 
     endTime = 0; 
     Experiment = AllFiles(1:end);
   case 2 
     seqFile ='no sequence file found'     
     startTime = 0; %8/22/2016 15:01
     endTime = 0; %8/24/2016 1:05 from end of file 8/24/2016 10:21
     Experiment = AllFiles(1:9);  
   case 3 
     seqFile ='Sequence+300-100ns+alternates+100VAC+33W+H2+275C+30sccm+100psi.csv'       
     startTime = 5; 
     endTime = 19; 
     Experiment = AllFiles(10:11);
   case 4
     seqFile ='No QPulse'      
     startTime = 1.5; 
     endTime = 9; 
     Experiment = AllFiles(12:21);
     qpulse = 0;
   case 5 %no Qpulse with a sequence file
     seqFile ='Sequence+325-600C+in+25C+steps+H2+30sccm+100psi.csv'     
     startTime = 11; 
     endTime = 21; 
     Experiment = AllFiles(16:20);
     %for temp=350:25:600
     qpulse = 0;
     deltaTemp = 0.05;
   case 6
     seqFile ='300-100ns+steps+600-300C+in+100C+steps+He+30sccm+100psi.csv'       
     startTime = 2; 
     endTime = 9; 
     Experiment = AllFiles(22:23);
     %for temp=[602 502 402 302]
   case 7 
     seqFile ='300-100ns steps 275-350C in 25C steps He 30sccm 100psi.csv'
     startTime = 6; %9/4/2016 6 hours after 6:00
     endTime = 7;   %9/5/2016 20:33
     Experiment = AllFiles(24:25);
     %for temp=[277 302 327 352]
   otherwise
     exit
   end;
 case 'ipb2-aug'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-08-20-CORE_28_DC_Heater'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichSeq = 2;
   detailPlot = 1;
   switch (whichSeq)
   case 1 
     seqFile ='IPB2-core-28b-he'   
     startTime = 0; %11 hours after 6:00
     endTime = 14;   %8/21/2016 20:33
     Experiment = AllFiles(1:3);
   case 2 
     seqFile ='IPB2-core-28b-h2'   
     startTime = 2; %11 hours after 6:00
     endTime = 7;   %8/21/2016 20:33
     Experiment = AllFiles(4:6);
   case 3  
     seqFile ='H2-150C-400C-DEUG-NEW-SW'   
     startTime = 0.5; %11 hours after 6:00
     endTime = 32;   %8/21/2016 20:33
     Experiment = AllFiles(13:16);
   otherwise
     exit
   end
 case 'ipb1'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\2016-08-20-CORE_26b'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichSeq = 9;
   switch (whichSeq)
   case 1 
     seqFile ='ALL'   
     startTime = 1.0; %8/22/2016 15:01
     endTime = 11; %8/24/2016 1:05 from end of file 8/24/2016 10:21
     Experiment = AllFiles(1:20);
   case 2
     seqFile ='IPB1-Core-26b-New-core-He'   
     startTime = 1.0; %8/22/2016 15:01
     endTime = 13.5; %8/24/2016 1:05 from end of file 8/24/2016 10:21
     Experiment = AllFiles(1:3);
   case 3
     seqFile ='IPB1-Core-26b-New-core-H2'   
     startTime = 1.0; %8/22/2016 15:01
     endTime = 9; %8/24/2016 1:05 from end of file 8/24/2016 10:21
     Experiment = AllFiles(4:6);
   case 4
     seqFile ='IPB1-Core-26b-New-core-1st-condition'   
     startTime = 1.0; %8/22/2016 15:01
     endTime = 0; %8/24/2016 1:05 from end of file 8/24/2016 10:21
     Experiment = AllFiles(7:8);    
   case 5
     seqFile ='IPB1-Core-26b-New-core-2nd-condition'  
     startTime = 1.5; %8/22/2016 15:01
     endTime = 19; %8/24/2016 1:05 from end of file 8/24/2016 10:21
     Experiment = AllFiles(9:10);
     detailPlot = 1;        
   case 6
     seqFile ='IPB1-Core-26b-New-core-3rd-condition'  
     startTime = 1.5; %8/22/2016 15:01
     endTime = 0; %8/24/2016 1:05 from end of file 8/24/2016 10:21
     Experiment = AllFiles(11:12)
   case 7
     seqFile ='IPB1-Core-26b-New-core-H2-D2'  
     startTime = 1.5; %8/30/2016 13:45 from 12:00
     endTime = 16; %9/1/2016 8/31/2016 20:55 from end of file 9/1/2016 14:27
     Experiment = AllFiles(16:18);
   case 8
     seqFile ='IPB1-Core-26b-New-core-H2-D2-Run2'  
     startTime = 3.5; %8/30/2016 13:45 from 12:00
     endTime = 12; %9/1/2016 8/31/2016 20:55 from end of file 9/1/2016 14:27
     Experiment = AllFiles(19:21);
   case 9
     seqFile ='IPB1-Core-26b-New-core-H2-D2-Run3'  
     startTime = 0; %8/30/2016 13:45 from 12:00
     endTime = 15; %9/1/2016 8/31/2016 20:55 from end of file 9/1/2016 14:27
     Experiment = AllFiles(22:24);

   case 10
     seqFile ='IPB1-Temp-sequence-150-100-150ns-50W-150C-400C-H2.csv'   
     %IPB1_Core_26b-New-core_He_150C-400C_day-01(02)(03).csv (8/20/2016 11:00 - 8/22/2016 10:28)
     startTime = 0; 
     endTime = 15;    
     Experiment = AllFiles(19:21);
   case 11
     seqFile ='IPB1-Temp-sequence-150-100-150ns-50W-150C-400C-H2.csv'   
     %IPB1_Core_26b-New-core_He_150C-400C_day-01(02)(03).csv (8/20/2016 11:00 - 8/22/2016 10:28)
     startTime = 0; %11 hours after 6:00
     endTime = 0;   %8/21/2016 20:33
     Experiment = AllFiles(22:22);
   otherwise
     exit
  end;
end    
Experiment'
loadHHT %TODO change name 
%change a few messy variable names
QOccurred = QOccurred0x3F; clear QPulseOccurred0x3F
QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29
QPulseDelays = QPulseDelay0x28s0x29; clear QPulseDelay0x28s0x29
QkHz = QKHz; clear QKHz;
%change datetime to number
dateN=datenum(DateTime,'mm/dd/yyyy HH:MM:SS');
DateTime(1+startTime*360)
DateTime(end - endTime*360)
switch (reactor)
case {'sri','conflat'}
  j1 = horzcat(dateN,CoreHtrPow,CoreReactorTemp,QPulseLengthns,QkHz,TerminationThermPow,HGASSOURCEVALVEVH3);
case {'ipb1', 'ipb2-sep05','ipb2-sep07','ipb2-aug'}
              %1     2           3        4              5    6                      7                        8    9                 10        
  j1 = horzcat(dateN,HeaterPower,CoreTemp,QPulseLengthns,QkHz,QPulsePCBHeatsinkPower,TerminationHeatsinkPower,QPow,PressureSensorPSI,QEnable);
otherwise
  exit
end
j1=j1(1+startTime*360:end-endTime*360,:);
dt = datetime(j1(:,1), 'ConvertFrom', 'datenum') ; 
if (dailyPlot == 1)
figure(1)
hold on
aa_splot(dt,j1(:,2),'black')
addaxis(dt,j1(:,3));
addaxis(dt,j1(:,4))
addaxis(dt,j1(:,5))
if detailPlot == 1
  %addaxis(dt,smooth(j1(:,1),j1(:,6),0.1,'loess'))
  %addaxis(dt,smooth(j1(:,1),j1(:,7),0.1,'loess'))
  addaxis(dt,j1(:,6))
  addaxis(dt,j1(:,7))
  addaxis(dt,j1(:,8))
  %addaxis(dt,j1(:,10))
end    
title(seqFile,'fontsize',11)
addaxislabel(1,'HeaterPower');
addaxislabel(2,'CoreTemp');
addaxislabel(3,'QPulseLen');
addaxislabel(4,'QkHz');
if detailPlot == 1
  addaxislabel(5,'QPulsePCBHeatsinkPower');
  addaxislabel(7,'QPow');
  addaxislabel(6,'TerminationHeatSinkPower');
  %addaxislabel(8,'BoxOxygenLevel');
end 
end
if (processYes == 1) 
heatPower = []; 
heatPower0 = 0;
dt0 = 0;
qPCB = [];
qTerm=[];
qPow=[];
t2 = [];
tp = [];
dt2=[];
dt1=[];
j5 =[];
%sri
%qL = [300 100 300 100 300 100 300];
qL = [300 150 100 150 300 100];
i=0;
nj1 = 1;
%for temp = [100 200 275 300 400 500 600]
%for temp=[277 302 327 352]
%for temp=[602 502 402 302]
%for temp=350:25:600
ki=1;
deltaTemp = 3;
for temp=150:50:400
   %pick up data with the particular tempareture   
  i = i+1;
  j2= j1(nj1:end,:); %continue
  j2 = j2((abs(j2(:,3)-temp) < deltaTemp),:);
  nj2 = size(j2(:,1),1);
  % nj1 = 1;
  if nj2 > 10 % minimum requirement is 40 minutes for power watt change < 0.3 
    nj1 = 1;
    nq = 1;
    for ki = 1:1:5  
      heatpower(ki) = 0;
      qPCB(ki)=0;
      qTerm(ki)=0;
      qPow(ki) = 0;
      dt1(ki) = j2(1,1);
      for ni = nj1:1:nj2-1
        if (j2(ni+1,10)-j2(ni,10))==1 %noQ
          j3 = j2(nj1:ni,:);
          fn = ['C:\jinwork\BEC\tmp\' reactor num2str(whichSeq) num2str(temp) num2str(qL(ki)) num2str(ki) '.csv'];          
          dt = datetime(j3(:,1), 'ConvertFrom', 'datenum') ;                  
          T = table(dt,j3(:,2),j3(:,3),j3(:,4),j3(:,5), 'VariableName',{'DateTime','HeatPower','Temp','QLen','QkHz'});
          writetable(T,fn);
          heatPower0 = j2(ni,2);
          dt0=j2(ni,1);
          nj1 = ni+1;  
          continue
        end  
               %1     2           3        4              5    6                      7                        8    9                 10        
  %j1 = horzcat(dateN,HeaterPower,CoreTemp,QPulseLengthns,QkHz,QPulsePCBHeatsinkPower,TerminationHeatsinkPower,QPow,PressureSensorPSI,QEnable);
        if (j2(ni,4)==qL(ki) & j2(ni+1,4)==qL(ki+1) & j2(ni,10) == 1)   
           j3 = j2(nj1:ni,:);
           fn = ['C:\jinwork\BEC\tmp\' reactor num2str(whichSeq) num2str(temp) num2str(qL(ki)) num2str(ki) '.csv'];          
           dt = datetime(j3(:,1), 'ConvertFrom', 'datenum') ;               
           T = table(dt,j3(:,2),j3(:,3),j3(:,6),j3(:,7), 'VariableName',{'DateTime','HeatPower','Temp','PCB','Term'});
           writetable(T,fn);
           heatPower(ki) = j2(ni,2);
           qPCB(ki) = trimmean(j2(nj1:ni,6),10);
           qTerm(ki) = trimmean(j2(nj1:ni,7),10);
           qPow(ki) = trimmean(j2(nj1:ni,8),10);
           qPCB1(ki) = trimmean(j2(nj1:ni,6),25);
           qTerm1(ki) = trimmean(j2(nj1:ni,7),25);
           qPow1(ki) = trimmean(j2(nj1:ni,8),25);
           dt1(ki) = j2(ni,1);
           j5(ki) = ni-nj1;
           nj1 = ni+1;     
           break
          end                
       end 
       
     end 
 
    end   
    tpi = [temp heatPower0 heatPower qPCB qTerm qPow qPCB1 qTerm1 qPow1 j5];
    tp = vertcat(tp,tpi);
    dti=[dt0 dt1];
    dt2 = vertcat(dt2,dti); 
  end    
fn = ['C:\jinwork\BEC\tmp\' reactor num2str(whichSeq) '.xlsx'];            
dt3 = datetime(dt2, 'ConvertFrom', 'datenum') ;
delete(fn);
%T = table(tp(:,1:19),dt3(:,1:7),'VariableName',{'Qvolts','QkHz','x2','x','c','100','200','275','300','400','500','600','100','200','275','300','400','500','600','100','200','275','300','400','500','600'});
%T = table(j4(:,1:end),dt3(:,1:end))
T = table(tp(:,1:end),dt3(:,1:end));
writetable(T,fn);

fn = ['C:\jinwork\BEC\tmp\tp' num2str(whichSeq) '.csv']
dlmwrite(fn,tp(:,1:end),',');
end
