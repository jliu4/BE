clear all;close all
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
dailyPlot = 0;
detailPlot = 0;
processYes = 1;

temp=[150 200 250 300 350 400];
qL = [300 150 100 150 300 100];
qN = size(qL,2) -1;
%input reactor
reactor ='ipb2-0907-165-28b' % 'ipb2-0907-165-28b' %'ipb1-0915' %'ipb2-0909-167-27b'  %'ipb1-0915','ipb1-0820''ipb2-08','ipb2-0905' 'ipb2-0907','ipb2-0909-165'
switch (reactor)
case 'ipb1-0915'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\2016-09-15-CRIO-v167_CORE_26b'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '09222016-09232016'; 
   switch (whichDate)
   case '09162016-09182016' 
     seqFile ='IPB1_Core\_26b-H2-CRIO\_v167\_150C-400C\_Run1\_day-01.csv : 04.csv'
     startTime = 1; 
     endTime = 20;  
     Experiment = AllFiles(1:4);
     qL = [150 100 150];
     qN = size(qL,2) -1;
   case '09182016-09192016' 
     seqFile ='IPB1\_Core\_26b-H2-650C-300C\_Run1\_day-01.csv : 02.csv'
     startTime = 0; 
     endTime = 0;  
     Experiment = AllFiles(6:7);
     temp=[600 300];
     qL = [300 150 100 150 300 100];
     qN = size(qL,2) -1;  
   case '09212016-09222016' 
     seqFile ='\ISOPERIBOLIC_DATA\2016-09-15-CRIO-v167_CORE_26b\IPB1_Core_26b-H2-250C-400C_Run2_day-01.csv : 02.csv'
     startTime = 0; 
     endTime = 9;  
     Experiment = AllFiles(12:13);
     temp=[250 275 300 325 400];
     qL = [150 100 150 100];
     qN = size(qL,2) -1;  
  case '09222016-09232016' 
     seqFile ='\ISOPERIBOLIC_DATA\2016-09-15-CRIO-v167_CORE_26b\IPB1_Core_26b-H2-250C-400C_Run2_day-03.csv'
     startTime = 0; 
     endTime = 9;  
     Experiment = AllFiles(15:15);
     temp=[250 275 300 325 400];
     qL = [150 100 150 100];
     qN = size(qL,2) -1;  

   end  
case 'ipb2-0907-165-28b'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-07_Crio_V165_core28b'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '09072016-09082016-250'; 
   switch (whichDate)
   case '09072016-09082016-150' 
     seqFile ='ISOPERIBOLIC2_DATA\2016-09-07_Crio_V165_core28b\IPB2-Core-28b--H2-150C-400C-Run1-day-01 : 02.csv'
     startTime = 1; 
     endTime = 0;  
     Experiment = AllFiles(1:2);
     temp=[150 200 250 300];
     qL = [300 150 100 150 100 300];
     qN = size(qL,2) -1;  
   case '09072016-09082016-200' 
     seqFile ='ISOPERIBOLIC2_DATA\2016-09-07_Crio_V165_core28b\IPB2-Core-28b--H2-150C-400C-Run1-day-01 : 02.csv'
     startTime = 1; 
     endTime = 0;  
     Experiment = AllFiles(1:2);
     temp=[200];
     qL = [300 150 100 150 100 150];
     qN = size(qL,2) -1;  
   case '09072016-09082016-250' 
     seqFile ='ISOPERIBOLIC2_DATA\2016-09-07_Crio_V165_core28b\2016-09-07-Crio-V165-core28b-IPB2-Core-28b--H2-150C-400C-Run1-day-01 : 02.csv'
     startTime = 1; 
     endTime = 0;  
     Experiment = AllFiles(2:2);
     temp=[250];
     qL = [100 150 100 150 100];
     qN = size(qL,2) -1;  

   end  
case 'ipb2-0909-167-27b'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-09_CRIO_v167-core27b'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '09232016';   
   switch (whichDate)
   case '09121016' 
     seqFile ='2016-09-09-CRIO-v167-core27b'
     startTime = 0; 
     endTime = 0;  
     Experiment = AllFiles(2:3);
   case '09142016-09152016' 
     seqFile ='2016-09-09-CRIO-v167-core27b'
     startTime = 0; 
     endTime = 10;  
     Experiment = AllFiles(7:9);    
   case '09162016-09182016' 
     seqFile ='2016-09-09-CRIO-v167-core27b'
     startTime = 0; 
     endTime = 15;  
     Experiment = AllFiles(11:13);    
   case '09192016-09202016' 
     seqFile ='2016-09-09-CRIO-v167-core27b'
     startTime = 0; 
     endTime = 0;  
     Experiment = AllFiles(16:17);    
   case '09212016' 
     seqFile ='2016-09-09-CRIO-v167-core27b data file IPB2_Core\_27b-\_H2-250-400C\_RUN1\_9-20-16\_day-01.csv'
     startTime = 0; 
     endTime = 0;  
     Experiment = AllFiles(18:18);    
   case '09222016' 
     seqFile ='2016-09-09-CRIO-v167-core27b data file: IPB2\_Core\_27b-\_H2-250-400C\_RUN1\_9-21-16\_day-01csv.csv'
     startTime = 0; 
     endTime = 0;  
     Experiment = AllFiles(20:20); 
     temp=[250 275];
     qL = [300 150 100 150 300 100];
     qN = size(qL,2) -1;  
   case '09232016' 
     seqFile ='2016-09-09-CRIO-v167-core27b data file: IPB2\_Core\_27b-\_H2-250-400C\_RUN1\_9-21-16\_day-02csv.csv'
     startTime = 0; 
     endTime = 0;  
     Experiment = AllFiles(21:21); 
     temp=[250 275];
     qL = [300 150 100 150 100 300 150 100];
     qN = size(qL,2) -1;  
   
   end  
case 'ipb2-0909-166'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-09_CRIO_v166-core27b'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '09112016-09122016';
   switch (whichDate)
   case '09112016-09122016' 
     seqFile ='2016-09-09-CRIO-v166-core27b-IPB2\_Core\_27b-\_H2\_600C-300C\_\_Run1_day-01.csv : 02.csv'
     startTime = 0; 
     endTime = 15;  
     Experiment = AllFiles(1:2);
     temp=[600 300];
     qL = [300 150 100 150 300 100];
     qN = size(qL,2) -1;  
   case '09122016' 
     seqFile ='IPB2\_Core\_27b-\_H2_600c-300C\_2probetest1\_EDITED.csv'
     startTime = 0; 
     endTime = 10;  
     Experiment = AllFiles(6:6);
     temp=[600 300];
     qL = [300 150 100 150 300 100];
     qN = size(qL,2) -1;  
   end  
case 'ipb2-0909-165'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-09_CRIO_v165-core27b'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '1';
   switch (whichDate)
   case '1' 
     seqFile ='2016-09-09-CRIO-v165-core27b'
     startTime = 0; 
     endTime = 0;  
     Experiment = AllFiles(1:1);  
   end     
case 'ipb2-sep0'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-05_Crio_V164_core28b'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '3';
   detailPlot = 1;
   switch (whichDate)
   case '1' 
     seqFile ='All'
     startTime = 0; %9/5/2016 
     endTime = 0;  
     Experiment = AllFiles(5:6);
   case '2'
     seqFile ='IPB2-Core-28b-H2-600c-300c-CRIO-V164'       
     startTime = 0; 
     endTime = 0; 
     Experiment = AllFiles(1:2);     
   case '3'
     seqFile ='IPB2-Core-28b-H2-150c-400c-CRIO-V164'       
     startTime = 0; 
     endTime = 0; 
     Experiment = AllFiles(5:6);     
   end
case 'ipb2-0907'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-07_Crio_V165_core28b'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '1';
   detailPlot = 1;
   switch (whichDate)
   case '1'
     seqFile ='IPB2-Core-28b-H2-150c-400c-run1-09072016'       
     startTime = 0; 
     endTime = 0; 
     Experiment = AllFiles(1:2);
   end
 case 'ipb2-08'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-08-20-CORE_28_DC_Heater'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate ='2';
   detailPlot = 1;
   switch (whichDate)
   case '1' 
     seqFile ='IPB2-core-28b-he'   
     startTime = 0; %11 hours after 6:00
     endTime = 14;   %8/21/2016 20:33
     Experiment = AllFiles(1:3);
   case '2' 
     seqFile ='IPB2-core-28b-h2'   
     startTime = 2; %11 hours after 6:00
     endTime = 7;   %8/21/2016 20:33
     Experiment = AllFiles(4:6);
   case '3'  
     seqFile ='H2-150C-400C-DEUG-NEW-SW'   
     startTime = 0.5; %11 hours after 6:00
     endTime = 32;   %8/21/2016 20:33
     Experiment = AllFiles(13:16);
   otherwise
     exit
   end
 case 'ipb1-0820'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\2016-08-20-CORE_26b'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '08022016-08212016';
   switch (whichDate)
   case '1' 
     seqFile ='ALL'   
     startTime = 1.0;
     endTime = 11; 
     Experiment = AllFiles(1:20);
   case '08022016-08212016'
     seqFile ='IPB1-Core-26b-New-core-He'   
     startTime = 1.0; 
     endTime = 13.5; 
     Experiment = AllFiles(1:3);
   case '3'
     seqFile ='IPB1-Core-26b-New-core-H2'   
     startTime = 1.0;
     endTime = 9;
     Experiment = AllFiles(4:6);
   case '4'
     seqFile ='IPB1-Core-26b-New-core-1st-condition'   
     startTime = 1.0; 
     endTime = 0; 
     temp = [600 300];
     Experiment = AllFiles(7:8);    
   case '5'
     seqFile ='IPB1-Core-26b-New-core-2nd-condition'  
     startTime = 1.5;
     endTime = 19; 
     Experiment = AllFiles(9:10);
     temp = [600 300];
   case '6'
     seqFile ='IPB1-Core-26b-New-core-3rd-condition'  
     startTime = 1.5;
     endTime = 0; 
     Experiment = AllFiles(11:12)
     temp = [600 300];
   case '7'
     seqFile ='IPB1-Core-26b-New-core-H2-D2'  
     startTime = 1.5; 
     endTime = 16; 
     Experiment = AllFiles(16:18);
   case '8'
     seqFile ='IPB1-Core-26b-New-core-H2-D2-Run2'  
     startTime = 3.5; 
     endTime = 12; 
     Experiment = AllFiles(19:21);
   case '9'
     seqFile ='IPB1-Core-26b-New-core-H2-D2-Run3'  
     startTime = 0; 
     endTime = 15; 
     Experiment = AllFiles(22:24);
   case '10'
     seqFile ='IPB1-Core-26b-New-core-H2-D2-Run5'  
     startTime = 0; 
     endTime = 0; 
     Experiment = AllFiles(25:26);
   case '11'
     seqFile ='IPB1-Core-26b-New-core-H2-D2-Run5'  
     startTime = 0; 
     endTime = 0; 
     Experiment = AllFiles(27:27);
   case '12'
     seqFile ='IPB1-Temp-sequence-150-100-150ns-50W-150C-400C-H2.csv'   
     %IPB1_Core_26b-New-core_He_150C-400C_day-01(02)(03).csv (8/20/2016 11:00 - 8/22/2016 10:28)
     startTime = 0; 
     endTime = 15;    
     Experiment = AllFiles(19:21);   
   case '13'
     seqFile ='IPB1-Temp-sequence-150-100-150ns-50W-150C-400C-H2.csv'   
     %IPB1_Core_26b-New-core_He_150C-400C_day-01(02)(03).csv (8/20/2016 11:00 - 8/22/2016 10:28)
     startTime = 0; 
     endTime = 0;   
     Experiment = AllFiles(22:22);
   otherwise
     exit
  end;
end    
Experiment'
loadHHT 
%change a few messy variable names
QOccurred = QOccurred0x3F; clear QPulseOccurred0x3F
QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29
QPulseDelays = QPulseDelay0x28s0x29; clear QPulseDelay0x28s0x29
QkHz = QKHz; clear QKHz;
%change datetime to number
dateN=datenum(DateTime,'mm/dd/yyyy HH:MM:SS');
DateTime(1+startTime*360)
DateTime(end - endTime*360)
            %1     2           3        4              5    6    7                        8                 9                      10        
j1 = horzcat(dateN,HeaterPower,CoreTemp,QPulseLengthns,QkHz,QPow,TerminationHeatsinkPower,PressureSensorPSI,QPulsePCBHeatsinkPower,QEnable,CoreQPower,SeqStep);
j1=j1(1+startTime*360:end-endTime*360,:);
j1(isnan(j1))=0;
dt = datetime(j1(:,1), 'ConvertFrom', 'datenum') ; 
if (dailyPlot == 1)
figure(1)
hold on
aa_splot(dt,j1(:,2),'black','linewidth',1.5)
ylim([0 40])
addaxis(dt,j1(:,3),'linewidth',1.5);
addaxis(dt,j1(:,4))
addaxis(dt,j1(:,5))
addaxis(dt,smooth(j1(:,6),11))
%addaxis(dt,smooth(j1(:,7),11))
%addaxis(dt,smooth(j1(:,9),19))
addaxis(dt,smooth(j1(:,11),11))    
title(seqFile,'fontsize',11)
addaxislabel(1,'HeaterPower');
addaxislabel(2,'CoreTemp');
addaxislabel(3,'QPulseLen');
addaxislabel(4,'QkHz');
addaxislabel(5,'QPow');
%addaxislabel(6,'TerminationHeatSinkPower');
%addaxislabel(6,'QPulsePCBHeatsinkPower');
addaxislabel(6,'CoreQPow'); 
end
if (processYes == 1) 
heatPower = []; 
heatPower0 = 0;
dt0 = 0;
coreQPow = [];
coreQPowCV = [];
qPCB = [];
qPCBCV=[];
qTerm=[];
qTermCV=[];
qPow=[];
qPowCV=[];
t2 = [];
tp = [];
dt2=[];
dt1=[];
j5 =[];
i=0;
nj1 = 1;
ki=1;
deltaTemp = 3;
for ti = temp
   %pick up data with the particular tempareture   
  i = i+1;
  j2= j1(nj1:end,:); %continue
  j2 = j2((abs(j2(:,3)-ti) < deltaTemp),:);
  nj2 = size(j2(:,1),1);
  if nj2 > 100 
    nj1 = 1;
    nq = 1;
    for ki = 1:1:qN  
      heatpower(ki) = 0;
      qPCB(ki)=0;
      qTerm(ki)=0;
      qPow(ki) = 0;
      coreQPow(ki) = 0;
      heatpowerCV(ki) = 0;
      qPCBCV(ki)=0;
      qTermCV(ki)=0;
      qPowCV(ki) = 0;
      coreQPowCV(ki) = 0;
      %j5(ki)=0;
      dt1(ki) = j2(1,1);
      for ni = nj1:1:nj2-1
        if (j2(ni+1,10)-j2(ni,10))==1 %noQ
          j3 = j2(nj1:ni,:);
          fn = ['C:\jinwork\BEC\tmp\' reactor '-' whichDate num2str(ti) num2str(qL(ki)) num2str(ki) 'nq.csv'];          
          dt = datetime(j3(:,1), 'ConvertFrom', 'datenum') ;                  
          T = table(dt,j3(:,2),j3(:,3),j3(:,4),j3(:,5), 'VariableName',{'DateTime','HeatPower','Temp','QLen','QkHz'});
          writetable(T,fn);
          heatPower0 = j2(ni,2);
          dt0=j2(ni,1);
          nj1 = ni+1;  
          continue
        end  
        if ((j2(ni,4)==qL(ki) & j2(ni+1,4)==qL(ki+1) & j2(ni,10) == 1) || (j2(ni,10)-j2(ni+1,10))==1 ) 
           j3 = j2(nj1:ni,:);
           fn = ['C:\jinwork\BEC\tmp\' reactor '-' whichDate num2str(ti) num2str(qL(ki)) num2str(ki) '.csv'];          
           dt = datetime(j3(:,1), 'ConvertFrom', 'datenum') ;               
           T = table(dt,j3(:,2),j3(:,3),j3(:,6),j3(:,7), j3(:,9),j3(:,11),'VariableName',{'DateTime','HeatPower','Temp','qPow','Term','PCB','coreQPow'});
           writetable(T,fn);
           heatPower(ki) = trimmean(j2(nj1:ni,2),25); %j2(ni,2);
           %heatPower(ki)=mean(j2(ni-20:ni,2));
           qPow(ki) = trimmean(j2(nj1:ni,6),25);
           qTerm(ki) = trimmean(j2(nj1:ni,7),25);
           qPCB(ki) = trimmean(j2(nj1:ni,9),25);
           coreQPow(ki)=trimmean(j2(nj1:ni,11),25);
           j6 =mean(j2(nj1:ni,6)); 
           j7 = mean(j2(nj1:ni,7));
           j9 =mean(j2(nj1:ni,9)); 
           j11 = mean(j2(nj1:ni,11));   
           qPowCV(ki) = std(j2(nj1:ni,6));
           if j6 > 0
             qPowCV(ki)= qPowCV(ki)/j6;
           end   
           qTermCV(ki) = std(j2(nj1:ni,7));
           if j7 > 0
             qTermCV(ki)=qTermCV(ki)/j7;
           end  
           qPCBCV(ki) = std(j2(nj1:ni,9))/j9;
           if j11 > 0 
            coreQPowCV(ki)=coreQPowCV(ki)/j11;
           end
           dt1(ki) = j2(ni,1);
           j5(ki) = ni-nj1;
           nj1 = ni+1;     
           break
          end                
       end    
     end 
     tpi = [ti heatPower0 heatPower coreQPow qPow qPCB qTerm  coreQPowCV qPowCV ];
     tp = vertcat(tp,tpi);
     dti=[dt0 dt1];
     dt2 = vertcat(dt2,dti); 
    end   
end    
fn = ['C:\jinwork\BEC\tmp\' reactor '-' whichDate '.csv'];            
dt3 = datetime(dt2, 'ConvertFrom', 'datenum') ;
delete(fn);
%T = table(tp(:,1:19),dt3(:,1:7),'VariableName',{'Qvolts','QkHz','x2','x','c','100','200','275','300','400','500','600','100','200','275','300','400','500','600','100','200','275','300','400','500','600'});
%T = table(j4(:,1:end),dt3(:,1:end))
T = table(tp(:,1:end),dt3(:,1:end));
writetable(T,fn);

%fn = ['C:\jinwork\BEC\tmp\tp' whichDate '.csv']
%dlmwrite(fn,tp(:,1:end),',');
end
