% Initial housekeeping
clear; close all
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
filename='C:\jinwork\BEC\tmp\ipb3-32b-he-h2.csv';
%filenamehe='C:\jinwork\BEC\tmp\ipb3-32b-he-121416-12172016.csv';
M = csvread(filename,1,0);
dataset({M,'coreTemp',...
     'intTemp',...
     'outerTemp',...
     'QPulseLengthns',...
     'QPulseFre',...
     'HeaterPower',...
     'CoreQPower',...
     'CoreQV1Rms',...
     'CoreQV2Rms',...
     'QPow',...
     'QSupplyPower',...
     'QCur',...
     'QSupplyVolt',...
     'QSetV',...
     'SeqStepNum',...
     'steps',...
     'gas'});
     
dataSize = size(M,1)
M(any(isnan(M)),:)=[]; %take out rows with Nan
M = M(M(:,8) > 0,:); %only for nonzero
Mh2 = M(M(:,17)==2,:);
Mhe = M(M(:,17)==4,:);
dataSize = size(M,1)
h2uniql = unique(Mh2(:,4));
h2unitemp = unique(int16(Mh2(:,1)));
heuniql = unique(Mhe(:,4));
heunitemp = unique(int16(Mhe(:,1)));
figure
grid
hold on

for qli = 1:numel(h2uniql)
   qM = Mh2(Mh2(:,4) == h2uniql(qli),:); 
   xlabel('coreTemp(C)');
   ylabel('V1-V2(volt)');
 
   plot(qM(:,1),qM(:,8)-qM(:,9));
   labels{qli}=strcat('H2QPulse=',num2str(h2uniql(qli)));
   
end
for qli = 1:numel(heuniql)
   qM = Mhe(Mhe(:,4) == heuniql(qli),:); 
   xlabel('coreTemp(C)');
   ylabel('V1-V2(volt)');
 
   plot(qM(:,1),qM(:,8)-qM(:,9),'--');
   labels{qli+3}=strcat('HeQPulse=',num2str(heuniql(qli)));
   
end
legend(labels);
figure
grid
hold on
for tli = 1:numel(h2unitemp)
   qM = Mh2(int16(Mh2(:,1)) == h2unitemp(tli),:);
   xlabel('QPulseLength(ns)');
   ylabel('V1-V2(volt)');
  
   plot(qM(:,4),qM(:,8)-qM(:,9));
   labels{tli}=strcat('H2coreTemp=',num2str(h2unitemp(tli)));
  
end
for tli = 1:numel(heunitemp)
   qM = Mhe(int16(Mhe(:,1)) == heunitemp(tli),:);
   xlabel('QPulseLength(ns)');
   ylabel('V1-V2(volt)');
  
   plot(qM(:,4),qM(:,8)-qM(:,9),'--');
   labels{tli+numel(heunitemp)}=strcat('HecoreTemp=',num2str(heunitemp(tli)));
  
end
legend(labels)