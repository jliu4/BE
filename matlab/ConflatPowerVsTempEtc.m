clear all;close all
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
dailyPlot = 1;
detailPlot = 1;
processYes = 0;
qpulse = 1;
%input reactor
reactor = 'sri' %'sri' 'sri-09'; ,'conflat'
switch (reactor)

case 'sri'
   Directory='C:\jinwork\BEC\Data\SRIdata\2016-08-12'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichSeq = 8;
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
   case 8 
     seqFile ='300-100ns steps 100-300C in 25C steps He 30sccm 100psi.csv'
     startTime = 7; %9/4/2016 6 hours after 6:00
     endTime = 0;   %9/5/2016 20:33
     Experiment = AllFiles(26:26);
     %for temp=[277 302 327 352]  
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
%            1     2          3               4              5    6                   7    8
j1 = horzcat(dateN,CoreHtrPow,CoreReactorTemp,QPulseLengthns,QkHz,TerminationThermPow,QPow,CoreInPress,HGASSOURCEVALVEVH3);
j1=j1(1+startTime*360:end-endTime*360,:);
dt = datetime(j1(:,1), 'ConvertFrom', 'datenum') ; 
if (dailyPlot == 1)
figure(1)
hold on
aa_splot(dt,j1(:,2),'black')
ylim([0 40])
addaxis(dt,j1(:,3));
addaxis(dt,j1(:,4))
addaxis(dt,j1(:,5))
if detailPlot == 1
  %addaxis(dt,smooth(j1(:,1),j1(:,6),0.1,'loess'))
  %addaxis(dt,smooth(j1(:,1),j1(:,7),0.1,'loess'))
  addaxis(dt,smooth(j1(:,6),11))
  addaxis(dt,smooth(j1(:,7),11))
  addaxis(dt,smooth(j1(:,8),11))
end    
title(seqFile,'fontsize',11)
addaxislabel(1,'HeaterPower');
addaxislabel(2,'CoreTemp');
addaxislabel(3,'QPulseLen');
addaxislabel(4,'QkHz');
if detailPlot == 1 
  addaxislabel(6,'QPow');
  addaxislabel(5,'TerminationTermPower');
  addaxislabel(7,'CoreInPress'); 
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
