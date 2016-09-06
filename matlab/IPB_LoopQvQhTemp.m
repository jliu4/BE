clear all;close all

addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')

%looking at Berkeley IPB1
SYS = 'Core #26b-1000A PD with Ni Spray - ';
%sequence file: IPB1_Temp_sequence_300-100-300ns_50W_150C-400C
whichEx = 2;
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
        startTime = 1.5; %8/22/2016 15:01
        endTime = 9; %8/24/2016 1:05 from end of file 8/24/2016 10:21
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
        startTime = 9; %
        endTime = 0;
        Experiment = AllFiles(10:14);
        rowPerFigure = 1;
        columnPerFigure = 1;
    otherwise
        exit
end;
AllFiles = getall(Directory);  %SORTED BY DATE....
Experiment = AllFiles(1:3);
Experiment'

loadIPB 
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
j1 = horzcat(dateN,CoreTemp,QkHz,QPulseVolt,IsoperibolicCalorimetryPower,HeaterPower,QPulseLengthns,QPow);
%start only when runs started
j1=j1(1+startTime*360:end-endTime*360,:);

dt = datetime(j1(:,1), 'ConvertFrom', 'datenum') ;  
if (1 ==0)
figure(1)
hold on
aa_splot(dt,j1(:,2))
yi=ylim;
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
addaxislabel(3,'ISPower');
addaxislabel(4,'HeaterPower');
addaxislabel(5,'QPulseLength');
addaxislabel(6,'QPower');
end
%dt =datestr(j1(:,1));
%# Plot the data:
%figure(2);
 
%yyaxis left
%ylabel('Core Temp') %100-400
%hold on
%plot(dt,j1(:,2),'r');

%yyaxis right
%ylabel('Heat Power')        
%plot(dt,j1(:,7),'m'); %100/150/300   
%hold off
%figure(2);
%plot(dt,j1(:,3),'m'); %10/20/45/75
%grid;
%ylabel('QkHz')

%figure(3);
%plot(dt,j1(:,4),'b');
%grid
%ylabel('QVolts'); %300

%figure(4);
%plot(dt,j1(:,5),'y');
%grid
%ylabel('IS Power')

%figure(5);
%plot(dt,j1(:,6),'c');
%grid
%ylabel('Heat Power')

%figure(6);
%plot(dt,j1(:,3),'c');
%grid
%ylabel('QkHz')
%i=0;
%j1 = horzcat(dateN,CoreTemp,QkHz,QPulseVolt,IsoperibolicCalorimetryPower,HeaterPower,QPulseLengthns);
j4 = [];
t2 = [];
tp = [];
dt2=[];
dt1=[];
j5 =[];
qw = [300 150 100 150 300 100];
for temp = 150:50:400
   %pick up data with the particular tempareture   
   i = i+1;
   j2 = j1((abs(j1(:,2)-temp) < 3),:);
   nj2 = size(j2(:,1),1);
   nj1 = 1;
   if nj2 > 10 % minimum requirement is 40 minutes for power watt change < 0.3  
      for ki = 1:1:5
        
         j4(ki) = 0; 
         dt1(ki) = j2(1,1);
         for ni = nj1:1:nj2
             if (j2(ni,7)==qw(ki) & j2(ni+1,7)==qw(ki+1))
                 
                j3 = j2(nj1:ni,:);
                fn = ['C:\jinwork\BEC\tmp\ipb1-' num2str(whichEx) num2str(temp) num2str(qw(ki)) '.csv'];          
                dt = datetime(j3(:,1), 'ConvertFrom', 'datenum') ;        
                  
                T = table(dt,j3(:,2),j3(:,3),j3(:,5),j3(:,6),j3(:,7),'VariableName',{'DateTime','CoreTemp','QkHz','IsP','HeatPower','qLen'});
                writetable(T,fn);
                j4(ki) = j2(ni,6);
                dt1(ki) = j2(ni,1);
                j5(ki) = ni-nj1;
                nj1 = ni+1;              
                break
            end      
                
         end 
 
      end   
      tpi = [temp j4 j5];
      tp = vertcat(tp,tpi);
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
