clear all;close all

addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
deltaTemp = 2;
plotYes = 1;
processYes = 0;
%looking at Berkeley HHT
SYS = 'HHT Core - ';
%sequence file: IPB1_Temp_sequence_300-100-300ns_50W_150C-400C
whichEx = 4;
qpulse = 1;
switch (whichEx)
    case 1 
        seqFile ='300-100ns steps 275-350C in 25C steps He 30sccm 100psi.csv';
        Directory='C:\jinwork\BEC\Data\SRIdata\2016-08-12'
        %IPB1_Core_26b-New-core_He_150C-400C_day-01(02)(03).csv (8/20/2016 11:00 - 8/22/2016 10:28)
        startTime = 6; %9/4/2016 6 hours after 6:00
        endTime = 7;   %9/5/2016 20:33
        %Experiment = AllFiles(24:25);
        %for temp=[277 302 327 352]
    case 2
        seqFile ='300-100ns+steps+600-300C+in+100C+steps+He+30sccm+100psi.csv'
        Directory='C:\jinwork\BEC\Data\SRIdata\2016-08-12';
        startTime = 2; %8/22/2016 15:01
        endTime = 9; %8/24/2016 1:05 from end of file 8/24/2016 10:21
        %Experiment = AllFiles(22:23);
         %for temp=[602 502 402 302]
    case 3
        seqFile ='No QPulse'
        Directory='C:\jinwork\BEC\Data\SRIdata\2016-08-12';
        startTime = 1.5; %8/22/2016 15:01
        endTime = 9; %8/24/2016 1:05 from end of file 8/24/2016 10:21
        %Experiment = AllFiles(12:21);
        qpulse = 0;
   case 4
        seqFile ='Sequence+325-600C+in+25C+steps+H2+30sccm+100psi.csv'
        Directory='C:\jinwork\BEC\Data\SRIdata\2016-08-12';
        startTime = 11; %8/22/2016 15:01
        endTime = 21; %8/24/2016 1:05 from end of file 8/24/2016 10:21
        %Experiment = AllFiles(16:20);
        %for temp=350:25:600
        qpulse = 0;
        deltaTemp = 0.05;
   case 5
        startTime = 9; %
        endTime = 0;
        Experiment = AllFiles(10:14);
        rowPerFigure = 1;
        columnPerFigure = 1;
    otherwise
        exit
end;
AllFiles = getall(Directory);  %SORTED BY DATE....
Experiment = AllFiles(16:20);
Experiment'

loadHHT 
%change a few messy variable names
QOccurred = QOccurred0x3F; clear QPulseOccurred0x3F
QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29
QPulseDelays = QPulseDelay0x28s0x29; clear QPulseDelay0x28s0x29
QkHz = QKHz; clear QKHz;
dateN=datenum(DateTime,'mm/dd/yyyy HH:MM:SS');
DateTime(1+startTime*360)
DateTime(end - endTime*360)
reltime=24*(dateN-dateN(1)); %in days*24 = hours
%titletxt=strcat('BEC HHT test from ',DateTime(startTime*360),' through ',DateTime(end - endTime*360)); %how to keep trailing spaces?
%j1 = horzcat(dateN,CoreTemp,QkHz,QPulseVolt,IsoperibolicCalorimetryPower,HeaterPower,QPulseLengthns,QPow);
%j1 = horzcat(dateN,InnerCoreTemp,CoreHtrPow,QkHz,QPulseVolt);
j1 = horzcat(dateN,CoreReactorTemp,CoreHtrPow,QPulseLengthns,TerminationThermPow);
%start only when runs started
j1=j1(1+startTime*360:end-endTime*360,:);

dt = datetime(j1(:,1), 'ConvertFrom', 'datenum') ;  
if (plotYes == 1)
figure(1)
hold on
aa_splot(dt,j1(:,3),'black')
yi=ylim;
addaxis(dt,j1(:,2))
if qpulse == 1
  addaxis(dt,j1(:,4))
  addaxis(dt,j1(:,5))
end
%legend('CoreTemp','QkHz','ISPower','HeaterPower','QPulseLength','QPower')
%grid on
%datetick('x','mm/dd','keeplimits')
title(seqFile,'fontsize',11)
addaxislabel(2,'CoreReactorTemp');
addaxislabel(1,'HeaterPower');
if qpulse == 1
  addaxislabel(3,'QPulselen');
  addaxislabel(4,'TerminationThermPow');
end  
end
if (processYes == 1) 
j4 = [];
t2 = [];
tp = [];
dt2=[];
dt1=[];
j5 =[];

qL = [300 100 300 100 300 100 300]
i=0;
nj1 = 1
%for temp = [100 200 275 300 400 500 600]
%for temp=[277 302 327 352]
%for temp=[602 502 402 302]
ki=1
for temp=350:25:600
   %pick up data with the particular tempareture   
   i = i+1;
   j2= j1(nj1:end,:); %continue
   j2 = j2((abs(j2(:,2)-temp) < deltaTemp),:);
   nj2 = size(j2(:,1),1)
   nj1 = 2;
   if nj2 > 239 % minimum requirement is 40 minutes for power watt change < 0.3 
       for ni = nj2:-1:2    
          if (abs(j2(ni,3)-j2(ni-20,3)))<= 0.3
      
            j4(ki) = j2(ni,3);
            
            dt1(ki) = j2(ni,1);
           
            nj1 = ni+1; 
            break
          end
       end
     end   
    tpi = [temp j4];
    tp = vertcat(tp,tpi);
    dt2 = vertcat(dt2,dt1); 
  end    

fn = ['C:\jinwork\BEC\tmp\sri-' num2str(whichEx) '.xlsx'];            
dt3 = datetime(dt2, 'ConvertFrom', 'datenum') ;
delete(fn);
%T = table(tp(:,1:19),dt3(:,1:7),'VariableName',{'Qvolts','QkHz','x2','x','c','100','200','275','300','400','500','600','100','200','275','300','400','500','600','100','200','275','300','400','500','600'});
%T = table(j4(:,1:end),dt3(:,1:end))
T = table(tp(:,1:end),dt3(:,1:end))
writetable(T,fn);

fn = ['C:\jinwork\BEC\tmp\tp' num2str(whichEx) '.csv']
dlmwrite(fn,tp(:,1:end),',');
end
