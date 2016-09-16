clear all;close all

addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')

%looking at Berkeley HHT
SYS = 'BEC Core B37';
whichEx = 5;
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
%10 30 (8/19/2016 6:00 - 8/20/2016 5:59)
%11 31 (8/20/2016 6:00 - 8/21/2016 5:59)
%12 32 (8/21/2016 6:00 - 8/22/2016 5:59)
%10 30 (8/18/2016 23:00 - 8/19/2016 13:00)
%e1 8/10/2016 16:35(10 hours) - 8/12/2016 9:35 (20 hours) he no Q
%e2 8/12/2016 17:00(11 hours) - 8/15/2016 17:45 (11 hours) he w Q
%e3 8/15/2016 22:00(16 hours) - 8/18/2016 20:00 (10 hours) h w Q
%e4 8/18/2016 23:00(17 hours) - 8/19/2016 13:00 (17 hours) h no Q
%e5 8/19/2016 16:30(10 hours) -                            h w Q
qpulse = 1;
switch (whichEx)
    case 1 
        startTime = 10; %11 hours after 6:00
        endTime = 20;   %20 hours before next day 6:00am
        Experiment = AllFiles(1:3);
        rowPerFigure = 1;
        columnPerFigure = 1;
        qpulse = 0;
    case 2
        startTime = 10; %
        endTime = 11.5;
        Experiment = AllFiles(3:6);
        rowPerFigure = 1;
        columnPerFigure = 1;
    case 3
        startTime = 13; %
        endTime = 5;
        Experiment = AllFiles(6:9);
        rowPerFigure = 5;
        columnPerFigure = 3;
   case 4
        startTime = 10; %
        endTime = 0;
        Experiment = AllFiles(9:10);
        rowPerFigure = 1;
        columnPerFigure = 1;
        qpulse = 0
   case 5
        startTime = 9; %
        endTime = 0;
        Experiment = AllFiles(10:14);
        rowPerFigure = 1;
        columnPerFigure = 1;
    otherwise
        exit
end;
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
reltime=24*(dateN-dateN(1)); %in days*24 = hours
%titletxt=strcat('BEC HHT test from ',DateTime(startTime*360),' through ',DateTime(end - endTime*360)); %how to keep trailing spaces?
j1 = horzcat(dateN,InnerCoreTemp,CoreHtrPow,QkHz,QPulseVolt);
%start only when runs started
j1=j1(startTime*360:end-endTime*360,:);
tp = [];
dt2=[];
dt1=[];
vi = 0;
for qV = 50:50:250
    vi = vi + 1;
    ki = 0;
    qVC = qV*sqrt(2)- 5; % some radiation lost volts
    for qkHz = 50:25:100
        if qpulse == 0
            qV = 0
            qVC = 0
            qkHz = 0
        end
            
        ki = ki + 1;
        j2 = j1((abs(j1(:,4)-qkHz) < 1 & abs(j1(:,5)-qVC) < 6 ), :);        
        if size(j2(:,1)) > 0
            fn = ['C:\jinwork\BEC\tmp\q' num2str(whichEx) num2str(qV) num2str(qkHz) '.csv'];          
            dt = datetime(j2(:,1), 'ConvertFrom', 'datenum') ;        
            %dt.Format = 'mm/dd/yyyy HH:MM:SS';         
            T = table(dt,j2(:,2),j2(:,3),j2(:,4),j2(:,5),'VariableName',{'DateTime','InnerCoreTemp','Power','QkHz','Qvolts'});
            writetable(T,fn);
            if (1==1)
            figure(ki+(vi-1)*3)
            grid
            subplot(rowPerFigure,columnPerFigure,1 ) %ki + (vi-1)*3)
            %title(['QkHz=' num2str(qkHz) ' QVolts=' num2str(qV)])
            title([num2str(qV) num2str(qkHz)],'fontsize', 8)
            xlabel('Date')
            yyaxis left
            ylim([0 700])
            ylabel('Inner Core Temp')
            hold on
            grid
            %plot(dt,j2(:,2),'linewidth',2)
            plot(dt,j2(:,2))
            yyaxis right
            ylabel('Heat Power')
            ylim([0 150])
            grid
            %plot(dt,j2(:,3),'linewidth',2)
            plot(dt,j2(:,3))
            hold off
            end
            j4 = [];
            t2 = [];
            i = 0;
            for temp = [100 200 275 300 400 500 600]
                i = i+1;
                j3 = j2((abs(j2(:,2)-temp) < 3) ,:);
                nj3 = size(j3(:,1),1);
                t2(i) = temp;
                j4(i)=0;
                j5(i) = nj3;
                dt1(i) = j2(1,1); % it should capture the last point
                %pick up data with the particular tempareture              
                if nj3 > 239 % minimum requirement is 40 minutes for power watt change < 0.3  
 
                    for ni = nj3:-1:2 
                        %search the core hrt power change less than 0.3 W,
                        %it is very accurate so far, but it should be
                        %max(j3(ni-230:ni,3)) - min(j3(ni-230:ni,3))<=0.3
                        if (j3(ni,3) > 0 & j3(ni,3) < 150 & abs(j3(ni,3)-j3(ni-20,3))<=0.3 )
                           j4(i) = j3(ni,3);
                           dt1(i) = j3(ni,1); 
                           break;
                        end
                    end    
                end
            end
            
            p=polyfit(t2, j4, 2);
            if (1 == 0) 
            polyfit_str = ['fitting:' num2str(p(1)) '*x^2+(' num2str(p(2)) '*x)+(' num2str(p(3)) ')'];
               
            y1 = polyval(p,t2);
            %figure(2)
            xlim([100 600])
            %subplot(rowPerFigure,columnPerFigure,1 ) %ki + (vi-1)*3)
            %plot(t2,j4,'r')
            ylim([0 150])
            title([num2str(qV) num2str(qkHz)],'fontsize', 8)
            %title(['QkHz=' num2str(qkHz) ' QVolts=' num2str(qV)])
            hold on
            %plot(t2,y1,'b')
            %legend('Heat Power',polyfit_str) 
            %ylabel('Heat Power')
            %xlabel('Inner Core Temp')
            grid
            xlim([100 600])
            hold off
            end   
            tpi = [qV qkHz p(1) p(2) p(3) j4 j5];
            tp = vertcat(tp,tpi);
            dt2 = vertcat(dt2,dt1);
        end
        if qpulse == 0
            break
        end
    end
    if qpulse ==0  % break q loop
       break 
    end    
end 
fn = ['C:\jinwork\BEC\tmp\tp-' num2str(whichEx) '.xlsx'];            
dt3 = datetime(dt2, 'ConvertFrom', 'datenum') ;
delete(fn);
%T = table(tp(:,1:19),dt3(:,1:7),'VariableName',{'Qvolts','QkHz','x2','x','c','100','200','275','300','400','500','600','100','200','275','300','400','500','600','100','200','275','300','400','500','600'});
T = table(tp(:,1:end),dt3(:,1:end))
writetable(T,fn);

%fn = ['C:\jinwork\BEC\tmp\tp' num2str(whichEx) '.csv']
%dlmwrite(fn,tp,',');
