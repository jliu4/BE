clear all;close all
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5\addaxis5')

%looking at Berkeley HHT
SYS = 'BEC Core B37';
Directory='C:\jinwork\BE\data\ConF00_copy\2016-07-21';
AllFiles = getall(Directory);  %SORTED BY DATE....
Experiment = AllFiles(19:end);
Experiment'

loadHHT 
%change a few messy variable names
QOccurred = QOccurred0x3F; clear QPulseOccurred0x3F
QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29
QPulseDelays = QPulseDelay0x28s0x29; clear QPulseDelay0x28s0x29
QkHz = QKHz; clear QKHz;
dateN=datenum(DateTime,'mm/dd/yyyy HH:MM:SS');
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
j1 = horzcat(CoreReactorTemp,CoreHtrPow);

r1 = j1(floor(j1(:,1))==100,:);
size(r1)
r11=min(r1,2);

size(r11)
r12 = r11(r11(:,2)==r11,:);
size(r12)
r2 = j1(floor(j1(:,1))==200,:);
r21 = r2(min(r2,2),:);

j2 = vertcat(r11,r21);
r3 = j1(floor(j1(:,1))==300,:);
r4 = j1(floor(j1(:,1))==400,:);
j2 = vertcat(r3,r4);
r5 = j1(j1(:,1)==500,:);
r6 = j1(j1(:,1)==600,:);


figure
plot(j2(:,1),j2(:,2),'r','linewidth',2)
size(j1)


IC1 = j1(:,1) < 90 ;
tabulate(IC1)
j1(IC1,:)=[];

size(alldata)
IC2 = j1(:,1) > 610;
tabulate(IC2)
j1(IC2,:)=[];

size(j1)
figure
%plot(alldata(:,1),CoreHtrPow,'r','linewidth',2)
plot(j1(:,1),j1(:,2),'r','linewidth',2)
grid
ylim([0 250])
title('Heater Power vs. InnerCore Temp')

