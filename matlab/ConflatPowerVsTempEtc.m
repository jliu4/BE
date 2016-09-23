clear all;close all
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
dailyPlot = 1;
detailPlot = 1;
processYes = 1;
qpulse = 1;
temp =[];
qL=[];
%input reactor
reactor = 'sri-09' %'sri-08' 'sri-09'; ,'conflat'
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
     qL = [100 300 100];
     qN = size(qL,2)-1;
     temp = [277];
   case '4'
     seqFile ='No QPulse'      
     startTime =0; % 1.5; 
     endTime = 0; %9; 
     Experiment = AllFiles(12:15);
     qpulse = 0;
   case '5' %no Qpulse with a sequence file
     seqFile ='Sequence+325-600C+in+25C+steps+H2+30sccm+100psi.csv'     
     startTime = 11; 
     endTime = 21; 
     Experiment = AllFiles(16:20);
     %for temp=350:25:600
     qpulse = 0;
     deltaTemp = 0.05;
   case '6'
     seqFile ='300-100ns+steps+600-300C+in+100C+steps+He+30sccm+100psi.csv'       
     startTime = 2; 
     endTime = 9; 
     Experiment = AllFiles(22:23);
     %for temp=[602 502 402 302]
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
%            1     2          3               4              5    6     7     
j1 = horzcat(dateN,CoreHtrPow,CoreReactorTemp,QPulseLengthns,QkHz,QPow, TerminationThermPow,...
CoreInPress,HGASSOURCEVALVEVH3,QOccurred,CoreGasIn,CoreGasOut,H2MakeupLPM,PowOut,JcktGasCircLPM);
%8          9                  10        11        12         13       14
j1=j1(1+startTime*360:end-endTime*360,:);
dt = datetime(j1(:,1), 'ConvertFrom', 'datenum') ; 
if (dailyPlot == 1)
figure(1)
hold on
aa_splot(dt,j1(:,2),'black','linewidth',1.5)
ylim([0 70])
addaxis(dt,j1(:,3),'linewidth',1.5);
addaxis(dt,j1(:,4))
addaxis(dt,smooth(j1(:,5),11))
if detailPlot == 1
  addaxis(dt,smooth(j1(:,6),11))
  addaxis(dt,smooth(j1(:,7),11))
  %addaxis(dt,smooth(j1(:,11),11))
  %addaxis(dt,smooth(j1(:,12),11))
  %addaxis(dt,smooth(j1(:,13),11))
 addaxis(dt,smooth(j1(:,14),11))
end    
title(seqFile,'fontsize',11)
addaxislabel(1,'HeaterPower');
addaxislabel(2,'CoreTemp');
addaxislabel(3,'QPulseLen');
addaxislabel(4,'QkHz');
if detailPlot == 1 
  addaxislabel(5,'QPow'); 
  addaxislabel(6,'TerminationTermPower');
  %addaxislabel(7,'CoreGasIn'); 
  %addaxislabel(8,'CoreGasOut'); 
  %addaxislabel(9,'H2Markup'); 
  addaxislabel(7,'PowOut'); 
end 
end
if (processYes == 1) 
heatPower = []; 
heatPower0 = 0;
dt0 = 0;
qTerm=[];
qPow=[];
coreIn = [];
coreOut = [];
H2MakeupLPM = [];
powOut=[];
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
  if nj2 > 100 % minimum requirement is 40 minutes for power watt change < 0.3 
    nj1 = 1;
    nq = 1;
    for ki = 1:1:qN
      heatpower(ki) = 0;
      qTerm(ki)=0;
      qPow(ki) = 0;
      coreIn(ki)=0;
      coreOut(ki) = 0;
      H2MakeupLPM(ki)=0;
      powOut(ki) = 0;
      qTermStd(ki)=0;
      qPowStd(ki) = 0;
      coreInStd(ki)=0;
      coreOutStd(ki) = 0;
      H2MakeupLPMStd(ki)=0;
      powOutStd(ki) = 0;
      dt1(ki) = j2(1,1);
      for ni = nj1:1:nj2-1
        if (j2(ni+1,10)-j2(ni,10))==1 %noQ
          j3 = j2(nj1:ni,:);
          fn = ['C:\jinwork\BEC\tmp\' reactor num2str(whichDate) num2str(ti) num2str(qL(ki)) num2str(ki) '.csv'];          
          dt = datetime(j3(:,1), 'ConvertFrom', 'datenum') ;                  
          T = table(dt,j3(:,2),j3(:,3),j3(:,4),j3(:,5), 'VariableName',{'DateTime','HeatPower','Temp','QLen','QkHz'});
          writetable(T,fn);
          heatPower0 = j2(ni,2);
          dt0=j2(ni,1);
          nj1 = ni+1;  
          continue
        end  
        if (((j2(ni,4)==qL(ki) & j2(ni+1,4)==qL(ki+1) ) & j2(ni,10) == 1) || (j2(ni,10)-j2(ni+1,10))==1 ) %there is a bug in 2016-08-12_day-09.csv file line 3569 some random number of 308.3333 appears 
        %if (( abs(j2(ni,4)-j2(ni+1,4))>= abs(qL(ki)-qL(ki+1)) || (j2(ni,4)==qL(ki) & j2(ni+1,4)==qL(ki+1) ) & j2(ni,10) == 1) || (j2(ni,10)-j2(ni+1,10))==1 ) 
           j3 = j2(nj1:ni,:);
           fn = ['C:\jinwork\BEC\tmp\' reactor '-' whichDate num2str(ti) num2str(qL(ki)) num2str(ki) '.csv'];          
           dt = datetime(j3(:,1), 'ConvertFrom', 'datenum') ;               
           T = table(dt,j3(:,2),j3(:,3),j3(:,6),j3(:,7), j3(:,11),j3(:,12), j3(:,14),'VariableName',{'DateTime','HeatPower','Temp','QPow','Term','CoreGasIn','CoreGasOut','PowOut'});
           writetable(T,fn);
           heatPower(ki) = j2(ni,2);
           qPow(ki) = trimmean(j2(nj1:ni,6),10);
           qTerm(ki) = trimmean(j2(nj1:ni,7),10);
           coreIn(ki) = trimmean(j2(nj1:ni,11),10);
           coreOut(ki) = trimmean(j2(nj1:ni,12),10);
           H2MakeupLPM(ki) = trimmean(j2(nj1:ni,13),10);
           powOut(ki) = trimmean(j2(nj1:ni,14),10);
           qPowStd(ki) = std(j2(nj1:ni,6));
           qTermStd(ki) = std(j2(nj1:ni,7));       
           coreInStd(ki) = std(j2(nj1:ni,11));
           coreOutStd(ki) = std(j2(nj1:ni,12));
           H2MakeupLPMStd(ki) = std(j2(nj1:ni,13));
           powOutStd(ki) = std(j2(nj1:ni,14));
           dt1(ki) = j2(ni,1);
           j5(ki) = ni-nj1;
           nj1 = ni+1;     
           break
          end                
       end 
   
    end 
    tpi = [ti heatPower0 heatPower qTerm qPow coreIn coreOut H2MakeupLPM powOut qTermStd qPowStd coreInStd coreOutStd H2MakeupLPMStd powOutStd];
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
