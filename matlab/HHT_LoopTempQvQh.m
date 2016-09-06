clear all;close all

addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
deltaTemp = 5;

%looking at Berkeley HHT
SYS = 'HHT Core - ';
%sequence file: IPB1_Temp_sequence_300-100-300ns_50W_150C-400C
whichEx = 1;
qpulse = 1;
switch (whichEx)
    case 1 
        Directory='C:\jinwork\BEC\Data\SRIdata\2016-08-12'
        %IPB1_Core_26b-New-core_He_150C-400C_day-01(02)(03).csv (8/20/2016 11:00 - 8/22/2016 10:28)
        startTime = 5; %11 hours after 6:00
        endTime = 7;   %8/21/2016 20:33
        %Experiment = AllFiles(1:3);
        rowPerFigure = 1;
        columnPerFigure = 1;
        SYS = [SYS 'H'];
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
Experiment = AllFiles(24:25);
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
j1 = horzcat(dateN,CoreReactorTemp,CoreHtrPow,QkHz,QPulseVolt,TerminationThermPow);
%start only when runs started
j1=j1(1+startTime*360:end-endTime*360,:);

dt = datetime(j1(:,1), 'ConvertFrom', 'datenum') ;  
if (1 ==1)
figure(1)
hold on
aa_splot(dt,j1(:,2),'black')
yi=ylim;
addaxis(dt,j1(:,3))
addaxis(dt,j1(:,4))
%addaxis(dt,j1(:,5))
addaxis(dt,j1(:,6))
%legend('CoreTemp','QkHz','ISPower','HeaterPower','QPulseLength','QPower')
%grid on
%datetick('x','mm/dd','keeplimits')
title(SYS,'fontsize',11)
addaxislabel(1,'CoreReactorTemp');
addaxislabel(2,'HeaterPower');
addaxislabel(3,'QkHz');
addaxislabel(4,'TerminationThermPow');
end
if (1==0) 
j4 = [];
t2 = [];
tp = [];
dt2=[];
dt1=[];
j5 =[];
qw = [300 150 100 150 300 100];
qkHz = [30 90 30 90 30 90]
%for temp = [100 200 275 300 400 500 600]
for temp=[277 302 327 352]
   %pick up data with the particular tempareture   
   i = i+1;
   j2 = j1((abs(j1(:,2)-temp) < deltaTemp),:);
   nj2 = size(j2(:,1),1)
   nj1 = 1;
   if nj2 > 100 % minimum requirement is 40 minutes for power watt change < 0.3  
     for qV = 50:50:250
        %qVC = qV*sqrt(2)- 5; % some radiation lost volts
       for ki = 1:1:3    
          j4(ki) = 0; 
          dt1(ki) = j2(1,1);
          for ni = nj1:1:nj2-1
             %if (abs(j2(ni,5)-qVC)<6 & j2(ni,4)==qkHz(ki) & j2(ni+1,4)==qkHz(ki+1))
             if ( j2(ni,4)==qkHz(ki) & j2(ni+1,4)==qkHz(ki+1))
                j3 = j2(nj1:ni,:);
                fn = ['C:\jinwork\BEC\tmp\hht-' num2str(whichEx) num2str(temp) num2str(qV) num2str(qkHz(ki)) '.csv'];          
                dt = datetime(j3(:,1), 'ConvertFrom', 'datenum') ;        
                T = table(dt,j3(:,2),j3(:,3),j3(:,4),j3(:,5),'VariableName',{'DateTime','CoreTemp','Power','QkHz','Qvolts'});  
                
                writetable(T,fn);
                j4(ki) = j2(ni,3);
                dt1(ki) = j2(ni,1);
                j5(ki) = ni-nj1;
                nj1 = ni+1             
                break
             end                
            end   
          end   
        tpi = [temp qV j4 j5];
        tp = vertcat(tp,tpi);
        dt2 = vertcat(dt2,dt1); 
     end    
   end
end

fn = ['C:\jinwork\BEC\tmp\hht-' num2str(whichEx) '.xlsx'];            
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
dlmwrite(fn,tp(:,1:end),',');
end
