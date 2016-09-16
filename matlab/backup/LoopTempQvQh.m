clear all;close all

addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')

%looking at Berkeley HHT
SYS = 'BEC Core B37';
whichEx = 3;
Directory='C:\jinwork\BEC\data\ConF00_copy\2016-07-21';
AllFiles = getall(Directory);  %SORTED BY DATE....

%1 21 (8/10/2016 6:00 - 8/11/2016 5:59)
%2 22 (8/11/2016 6:00 - 8/12/2016 5:59)
%3 23 (8/12/2016 6:00 - 8/13/2016 5:59)
%4 24 (8/13/2016 6:00 - 8/14/2016 5:59)
%5 25 (8/14/2016 6:00 - 8/15/2016 5:59)
%6 26 (8/15/2016 6:00 - 8/16/2016 5:59)
%7 27 (8/16/2016 6:00 - 8/17/2016 5:59)
%8 28 (8/17/2016 6:00 - 8/18/2016 5:59)
%9 29 (8/18/2016 6:00 - 8/19/2016 5:59)
%e1 8/10/2016 16:35(10 hours) - 8/12/2016 9:35 (20 hours) 
%e2 8/12/2016 17:00(11 hours) - 8/15/2016 17:45 (11 hours)
%e3 8/15/2016 22:00(16 hours) - 8/18/2016 20:00 (
switch (whichEx)
    case 1 
        startTime = 10; %11 hours after 6:00
        endTime = 20;   %20 hours before next day 6:00am
        Experiment = AllFiles(1:3);
        rowPerFigure = 1;
        columnPerFigure = 1;
    case 2
        startTime = 10; %
        endTime = 11.5;
        Experiment = AllFiles(3:6);
        rowPerFigure = 5;
        columnPerFigure = 3;

    case 3
        startTime = 13; %
        endTime = 5;
        Experiment = AllFiles(6:9);
        rowPerFigure = 5;
        columnPerFigure = 3;


    otherwise
        exit
end;

%Experiment = AllFiles(4:7);
Experiment'

loadHHT 
%change a few messy variable names
QOccurred = QOccurred0x3F; clear QPulseOccurred0x3F
QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29
QPulseDelays = QPulseDelay0x28s0x29; clear QPulseDelay0x28s0x29
QkHz = QKHz; clear QKHz;
dateN=datenum(DateTime,'mm/dd/yyyy HH:MM:SS');


DateTime(startTime*360)
DateTime(end - endTime*360)
mldatetime = date;
reltime=24*(dateN-dateN(1)); %in days*24 = hours
%titletxt=strcat('BEC HHT test from ',DateTime(startTime*360),' through ',DateTime(end - endTime*360)); %how to keep trailing spaces?
qi=find(QOccurred == 1);
size(DateTime);
j1 = horzcat(dateN,InnerCoreTemp,CoreHtrPow,QkHz,QPulseVolt);

size(j1);
%start only when runs started
j1=j1(startTime*360:end-endTime*360,:);
ti = 0;
for ict = 100:100:600 %inner core temperature
    ti = ti + 1;
    vi = 0;
    for qV = 50:50:250 %qVolts
        vi = vi + 1;
        ki = 0;
        for qkHz = 50:25:100 
            ki = ki + 1;
            qVC = qV*sqrt(2);
            j2 = j1((abs(j1(:,2)-ict) < 3 & abs(j1(:,4)-qkHz) < 1 & abs(j1(:,5)-qVC) < 19) ,:);
            fn = ['C:\jinwork\BEC\tmp\q' num2str(whichEx) num2str(ict) num2str(qV) num2str(qkHz) '.csv'];
            dt = datetime(j2(:,1), 'ConvertFrom', 'datenum') ;    
            %dt.Format = 'mm/dd/yyyy HH:MM:SS';
            T = table(dt,j2(:,2),j2(:,3),j2(:,4),j2(:,5),'VariableName',{'DateTime','InnerCoreTemp','Power','QkHz','Qvolts'});
            writetable(T,fn);
            nj3 = size(j2(:,1),1)
            j5(ti) = nj3   
            j4(ti) = 0
            t2(ti) = ict
            if nj2 > 240 % minimum requirement is 40 minutes for power watt change < 0.3  
              for ni = nj3:-1:2 
                %search the core hrt power change less than 0.3 W
                if (abs(j2(ni,3)-j2(ni-5,3))<=0.3 & j2(ni,3) > 0 & j2(ni,3) < 150)
                   j4(ti) = j2(ni,3)
                            
                   break;
                end
              end
            end  
        end
    end
end
            
p=polyfit(t2, j4, 2);
polyfit_str = ['fitting:' num2str(p(1)) '*x^2+(' num2str(p(2)) '*x)+(' num2str(p(3)) ')'];
               
y1 = polyval(p,t2);
            figure(2)
            xlim([100 600])
            subplot(rowPerFigure,columnPerFigure,ki + (vi-1)*3)
            plot(t2,j4,'r')
            ylim([0 150])
            title([num2str(qV) num2str(qkHz)],'fontsize', 8)
            %title(['QkHz=' num2str(qkHz) ' QVolts=' num2str(qV)])
            hold on
            plot(t2,y1,'b')
            %legend('Heat Power',polyfit_str) 
            %ylabel('Heat Power')
            %xlabel('Inner Core Temp')
            grid
            xlim([100 600])
            hold off
               
            tpi = [qV qkHz p(1) p(2) p(3) j4 j5];
            tp = vertcat(tp,tpi);
        end
    end
end 
fn = ['C:\jinwork\BEC\tmp\tp' num2str(whichEx) '.csv']
dlmwrite(fn,tp,',');

        end
    end
end    

