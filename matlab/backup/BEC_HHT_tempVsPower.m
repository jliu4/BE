clear all;close all
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')

%looking at Berkeley HHT
SYS = 'BEC Core B37';
Directory='C:\jinwork\BE\data\ConF00_copy\2016-07-21';
AllFiles = getall(Directory);  %SORTED BY DATE....
%Experiment = AllFiles(19:end);
Experiment = AllFiles(1:2);
Experiment'

loadHHT 
%change a few messy variable names
QOccurred = QOccurred0x3F; clear QPulseOccurred0x3F
QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29
QPulseDelays = QPulseDelay0x28s0x29; clear QPulseDelay0x28s0x29
QkHz = QKHz; clear QKHz;
dateN=datenum(DateTime,'mm/dd/yyyy HH:MM:SS');
startingSeqTime = '08/11/2016 14:25:00';
reltime=24*(dateN-dateN(1)); %in days*24 = hours
titletxt=strcat('BEC HHT test from ',DateTime(1),' through ',DateTime(end)); %how to keep trailing spaces?
qi=find(QOccurred == 1);


%check for alarms!
ALARM = find(ActiveAlarmBits ~= 0);
if length(ALARM) > 0
    AS = {'ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM ALARM'};
    disp(AS)
    
    figure
    plot(dateN,ActiveAlarmBits,'.-')
    grid
    title('ActiveAlarmBits')
    datetick('x','keeplimits')
end
%clean data
size(DateTime)
size(CoreReactorTemp)
%dlmwrite('dt.txt',DateTime,'');
j1 = horzcat(reltime,CoreReactorTemp,CoreHtrPow);
%dlmwrite('j1.txt',j1,',');

size(j1)

IC1 = j1(:,2) < 90 ;
tabulate(IC1)
j1(IC1,:)=[];

size(alldata)
IC2 = j1(:,2) > 610;
tabulate(IC2)
j1(IC2,:)=[];

size(j1)
%dlmwrite('j1.txt',j1,',');
figure
%plot(alldata(:,1),CoreHtrPow,'r','linewidth',2)
plot(j1(:,2),j1(:,3),'r','linewidth',2) 
xlabel('Inner Core Temp')
ylabel('Heat Power')
grid
ylim([0 150])
%title('Heater Power vs. InnerCore Temp')
figure
xlabel('hours')
yyaxis left
ylabel('Inner Core Temp')
hold on
grid
plot(j1(:,1),j1(:,2),'linewidth',2)
yyaxis right
ylabel('Heat Power')
ylim([0 120])
grid
plot(j1(:,1),j1(:,3),'linewidth',2)
hold off
figure

p1=j1(7042,:);
p2=j1(9009,:);
p3=j1(10437,:);
p4=j1(12134,:);
p5=j1(13701,:);
p6=j1(end,:);
j2=vertcat(p1,p2,p3,p4,p5,p6);

p=polyfit(j2(:,2),j2(:,3),2);
polyfit_str=['fitting:' num2str(p(1)) '*x^2+' num2str(p(2)) '*x+' num2str(p(3))]

y1 = polyval(p,j2(:,2));

plot(j2(:,2),j2(:,3),'linewidth',2)
hold on
plot(j2(:,2),y1,'linewidth',2)
legend('Heat Power',polyfit_str) 
ylabel('Heat Power')
xlabel('Inner Core Temp')
grid
hold off

