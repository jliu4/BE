clear all;close all

addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
%define constants
tempChange = 3
qkHzChange = 13

%looking at Berkeley IPB1
SYS = 'Core #26b-1000A PD with Ni Spray - ';
%sequence file: IPB1_Temp_sequence_300-100-300ns_50W_150C-400C
whichEx = 4;
qpulse = 1;
switch (whichEx)
    case 1 
        Directory='C:\jinwork\BEC\Data\isoperibolic_data\2016-08-20-CORE_26b\He'
        %IPB1_Core_26b-New-core_He_150C-400C_day-01(02)(03).csv (8/20/2016 11:00 - 8/22/2016 10:28)
        startTime = 2; %11 hours after 6:00
        endTime = 14;   %8/21/2016 20:33
        %Experiment = AllFiles(1:3);
        rowPerFigure = 1;
        columnPerFigure = 1;
        SYS = [SYS 'He'];
    case 2
        Directory='C:\jinwork\BEC\Data\isoperibolic_data\2016-08-20-CORE_26b\H2';
        startTime = 1.5; %8/22/2016 15:01
        endTime = 9; %8/24/2016 1:05 from end of file 8/24/2016 10:21
        %Experiment = AllFiles(1:3);
        rowPerFigure = 1;
        columnPerFigure = 1;
        SYS = [SYS 'H'];
    case 3
        Directory='C:\jinwork\BEC\Data\isoperibolic_data\2016-08-20-CORE_26b\firstC';
        startTime = 0; %8/22/2016 15:01
        endTime = 0; %8/24/2016 1:05 from end of file 8/24/2016 10:21
        %Experiment = AllFiles(1:3);
        rowPerFigure = 1;
        columnPerFigure = 1;
        SYS = [SYS 'First Condition H'];
   case 4
        Directory='C:\jinwork\BEC\Data\isoperibolic_data\2016-08-20-CORE_26b\secondC';
        startTime = 1.5; %8/22/2016 15:01
        endTime = 9; %8/24/2016 1:05 from end of file 8/24/2016 10:21
        %Experiment = AllFiles(1:3);
        rowPerFigure = 1;
        columnPerFigure = 1;
        SYS = [SYS 'Second Condition H'];
   case 5
        Directory='C:\jinwork\BEC\Data\isoperibolic_data\2016-08-20-CORE_26b\thirdC';
        startTime = 0; %8/22/2016 15:01
        endTime = 0; %8/24/2016 1:05 from end of file 8/24/2016 10:21
        %Experiment = AllFiles(1:3);
        rowPerFigure = 1;
        columnPerFigure = 1;
        SYS = [SYS 'Third Condition H'];

   case 6
        Directory='C:\jinwork\BEC\Data\isoperibolic_data\2016-08-20-CORE_26b\h2-d2';
        startTime = 1.5; %8/30/2016 13:45 from 12:00
        endTime = 16; %9/1/2016 8/31/2016 20:55 from end of file 9/1/2016 14:27
        %Experiment = AllFiles(1:3);
        rowPerFigure = 1;
        columnPerFigure = 1;
        SYS = [SYS 'H2-D2'];
   case 7
        Directory='C:\jinwork\BEC\Data\isoperibolic_data\2016-08-20-CORE_26b\h2-d2-run2';
        startTime = 3.5; %8/30/2016 13:45 from 12:00
        endTime = 12; %9/1/2016 8/31/2016 20:55 from end of file 9/1/2016 14:27
        %Experiment = AllFiles(1:3);
        rowPerFigure = 1;
        columnPerFigure = 1;
        SYS = [SYS 'H2-D2-run2'];

    otherwise
        exit
end;
AllFiles = getall(Directory);  %SORTED BY DATE....
Experiment = AllFiles(3:3);
Experiment'

loadIPB 
%change a few messy variable names
QOccurred = QOccurred0x3F; clear QPulseOccurred0x3F
QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29
QPulseDelays = QPulseDelay0x28s0x29; clear QPulseDelay0x28s0x29
QkHz = QKHz; clear QKHz;
dateN=datenum(DateTime,'mm/dd/yyyy HH:MM:SS');
DateTime(1+floor(startTime*360))
DateTime(end - floor(endTime*360))
reltime=24*(dateN-dateN(1)); %in days*24 = hours
%titletxt=strcat('BEC HHT test from ',DateTime(startTime*360),' through ',DateTime(end - endTime*360)); %how to keep trailing spaces?
j1 = horzcat(dateN,CoreTemp,QkHz,QPulseVolt,IsoperibolicCalorimetryPower,HeaterPower,QPulseLengthns,QPow,QPulsePCBHeatsinkPower);
%j1 = horzcat(dateN,CoreTemp,QkHz,QPulseVolt,QPulsePCBHeatsinkPower,HeaterPower,QPulseLengthns,QPow);
%start only when runs started
size(j1)
DateTime(1)
j1=j1(1+floor(startTime*360):end-floor(endTime*360),:);
size(j1)
dt = datetime(j1(:,1), 'ConvertFrom', 'datenum') ; 
dt(1)
if (1 ==1)
figure(1)
hold on
aa_splot(dt,j1(:,2),'black')
%yi=ylim;
addaxis(dt,j1(:,3))
addaxis(dt,j1(:,5))
addaxis(dt,j1(:,6))
addaxis(dt,j1(:,7))
addaxis(dt,j1(:,8))

%legend('CoreTemp','QkHz','ISPower','HeaterPower','QPulseLength','QPower')
%grid on
%datetick('x','mm/dd','keeplimits')
title(SYS,'fontsize',11)
addaxislabel(1,'CoreTemp');
addaxislabel(2,'qkHz');
%addaxislabel(3,'MeasuredQPower'); %TODO
addaxislabel(3,'IPBPower');
addaxislabel(4,'HeaterPower');
addaxislabel(5,'QPulseLength');
addaxislabel(6,'QPower');
end

j4 = [];
t2 = [];
tp = [];
dt2=[];
dt1=[];
j5 =[];
qw = [300 150 100 150 300 100];
%for temp = 150:50:400
for temp = [600 300]
   %pick up data with the particular tempareture   
   i = i+1;
   j2 = j1((abs(j1(:,2)-temp) < tempChange),:);
   nj2 = size(j2(:,1),1);
   
   if nj2 > 10 % minimum requirement is 40 minutes for power watt change < 0.3  
      nj1 = 1;
      kii = 1
      for ki = 1:1:5  
         j4(ki) = 0; 
         dt1(ki) = j2(1,1);
         for ni = nj1:1:nj2-1
             if (abs(j2(ni,3)-j2(ni+1,3))>qkHzChange)
                j3 = j2(nj1:ni,:);
                fn = ['C:\jinwork\BEC\tmp\ipb1-' num2str(whichEx) num2str(temp) num2str(qw(ki)) num2str(ki) num2str(kii) '.csv'];          
                dt = datetime(j3(:,1), 'ConvertFrom', 'datenum') ;        
                  
                T = table(dt,j3(:,2),j3(:,3),j3(:,5),j3(:,6),j3(:,7),'VariableName',{'DateTime','CoreTemp','QkHz','IsP','HeatPower','qLen'});
                writetable(T,fn);
                j0 = j2(ni,6)
                dt0=j2(ni,1)
                %j4(kii) = j2(ni,6);
                %dt1(kii) = j2(ni,1);
                %j5(kii) = ni-nj1;
                nj1 = ni+1;  
                kii = kii+1
                continue  
             end   
         %TODO bugs 
             if (j2(ni,7)==qw(ki) & j2(ni+1,7)==qw(ki+1))
                
                j3 = j2(nj1:ni,:);
                fn = ['C:\jinwork\BEC\tmp\ipb1-' num2str(whichEx) num2str(temp) num2str(qw(ki)) num2str(ki) '.csv'];          
                dt = datetime(j3(:,1), 'ConvertFrom', 'datenum') ;        
                  
                T = table(dt,j3(:,2),j3(:,3),j3(:,5),j3(:,6),j3(:,7),'VariableName',{'DateTime','CoreTemp','QkHz','IsP','HeatPower','qLen'});
                writetable(T,fn);
                j4(ki) = j2(ni,6);
                dt1(ki) = j2(ni,1);
                j5(ki) = ni-nj1;
                nj1 = ni+1;  
                kii = kii+1
                break
            end      
                
         end 
 
      end   
      size(j4)
      size(j5)
      j0
      tpi = [temp j4 j5 j0];
      tp = vertcat(tp,tpi);
      dti = [dt1 dt0];
      dt2 = vertcat(dt2,dt1); 
   end    
end

fn = ['C:\jinwork\BEC\tmp\ipb1-' num2str(whichEx) '.xlsx'];            
dt3 = datetime(dt2, 'ConvertFrom', 'datenum') ;
delete(fn);
%T = table(tp(:,1:19),dt3(:,1:7),'VariableName',{'Qvolts','QkHz','x2','x','c','100','200','275','300','400','500','600','100','200','275','300','400','500','600','100','200','275','300','400','500','600'});
%T = table(j4(:,1:end),dt3(:,1:end))
T = table(tp(:,1:end),dt3(:,1:end))
writetable(T,fn);

%figure(3);

%plot(t2,j4,'b');
%grid
%ylabel('Heat Power'); 
%xlabel('Core Temp');

fn = ['C:\jinwork\BEC\tmp\tp' num2str(whichEx) '.csv']
dlmwrite(fn,tp(:,1:6),',');
