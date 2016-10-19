clear all;close all
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
dailyPlot = 1;
processYes = 1;
p1 = 0;
p2 = 40;
%'sri-08' 'sri-09-11' 'sri-09-19; ,'conflat'
%reactor='conf';
reactor = 'sri-09-19'; 
switch (reactor)
case 'conf'
   Directory='C:\jinwork\BEC\Data\CONF00\2016-08-31';
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '10072016';
   switch (whichDate) 
   case '10072016' 
     dataFile ='\2016-08-31\B40_power_stability_test_day-01.csv:-02.csv';
     startTime = 0; %9/4/2016 6 hours after 6:00
     endTime = 0;   %9/5/2016 20:33
     Experiment = AllFiles(1:2);
   end
case 'sri-09-19'
   Directory='C:\jinwork\BEC\Data\SRIdata\2016-09-19';
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '10152016-10172016';
   %input which sequence
   switch (whichDate)
     
   case '09212016-09222016' 
     dataFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psiQV200V-000.csv';
     startTime = 0.5; %9/4/2016 6 hours after 6:00
     endTime = 0;   %9/5/2016 20:33
     Experiment = AllFiles(7:7);
 
   case '09222016-09232016' 
     dataFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psiQV200V-000.csv';
     startTime = 0.5; %9/4/2016 6 hours after 6:00
     endTime = 0;   %9/5/2016 20:33
     Experiment = AllFiles(8:8);
   case '09282016' 
     dataFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psiQV200V-000.csv';
     startTime = 0; %9/4/2016 6 hours after 6:00
     endTime = 0;   %9/5/2016 20:33
     Experiment = AllFiles(10:11);
   case '09272016' 
     dataFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psiQV200V-000.csv';
     startTime = 0; 
     endTime = 0;   
     Experiment = AllFiles(12:12); 
   case '09282016-09292016' %100
     dataFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psiQV200V-004.csv';
     startTime = 4; 
     endTime = 18.5;  
     Experiment = AllFiles(10:11);  
     p1 = 6.5;
     p2 = 8.5;
      case '09292016-09302016' %150
     dataFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psiQV200V-004.csv';
     startTime = 12;
     endTime = 18.5;   
     Experiment = AllFiles(11:12);  
     p1 = 12.5;
     p2 = 14.5;  
   case '09302016-10012016' %200
     dataFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psiQV200V-004.csv';
     startTime = 10;
     endTime = 18;   
     Experiment = AllFiles(12:13);  
     p1 = 19;
     p2 = 21;  
   case '10012016-10022016' %250
     dataFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psiQV200V-004.csv';
     startTime = 10; 
     endTime = 18;   
     Experiment = AllFiles(13:14);  
     p1 = 26.5;
     p2 = 28.5;  
   case '10022016-10032016' %300
     dataFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psiQV200V-004.csv';
     startTime = 10; 
     endTime = 18;   
     Experiment = AllFiles(14:15);  
     p1 = 34.5;
     p2 = 37.0;  
  case '10032016-10042016' %350
     dataFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psiQV200V-004.csv';
     startTime = 10; 
     endTime = 18;   
     Experiment = AllFiles(15:16);  
     p1 = 44;
     p2 = 47;  
  case '10042016-10052016' %400
     dataFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psiQV200V-004.csv';
     startTime = 10; 
     endTime = 18;   
     Experiment = AllFiles(16:17);  
     p1 = 55.5;
     p2 = 58 ; 
  case '10052016-10062016' %450
     dataFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psiQV200V-004.csv';
     startTime = 10; 
     endTime = 18;   
     Experiment = AllFiles(17:18);  
     p1 = 67.5;
     p2 = 70;  
  case '10062016-10072016' %500
     dataFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psiQV200V-004.csv';
     startTime = 10; 
     endTime = 18;   
     Experiment = AllFiles(18:19);  
     p1 = 81.0;
     p2 = 83.5 ; 

  case '10072016-10082016' %550
     dataFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psiQV200V-004.csv';
     startTime = 10; 
     endTime = 18;   
     Experiment = AllFiles(19:20);  
     p1 = 97;
     p2 = 99;  
  case '10082016-10092016' %600
     dataFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psiQV200V-004.csv';
     startTime = 10; 
     endTime = 18;   
     Experiment = AllFiles(20:21);  
     p1 = 115;
     p2 = 117;   
   case '09282016-10092016' 
     dataFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psiQV200V-004.csv';
     startTime = 0; 
     endTime = 12;  
     Experiment = AllFiles(10:21);
   case '10092016-10122016' 
     dataFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psiQV200V-005.csv';
     startTime = 10; 
     endTime = 0;   
     Experiment = AllFiles(21:25);
     p1=5;
     p2=140;
   case '10152016-10172016' 
     dataFile ='100-600C&300-100ns steps in 100C steps He 30sccm 100psiQV200V-005.csv';
     startTime = 0; 
     endTime = 0;   
     Experiment = AllFiles(29:29);
     p1=5;
     p2=10;
     
   end     
end 
Experiment'
loadHHT 
%change a few messy variable names
QOccurred = QOccurred0x3F; clear QPulseOccurred0x3F

QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29
QPulseDelays = QPulseDelay0x28s0x29; clear QPulseDelay0x28s0x29
QkHz = QKHz; clear QKHz;
%change datetime to number
dateN=datenum(DateTime,'mm/dd/yyyy HH:MM:SS');
DateTime(1+startTime*360);
DateTime(end - endTime*360);
%            1     2          3               4              5    6     7     
j1 = horzcat(dateN,CoreHtrPow,CoreReactorTemp,QPulseLengthns,QkHz,QPow, TerminationThermPow,...
CoreInPress,QCur,QPulseVolt,CoreGasIn,CoreGasOut,H2MakeupLPM,PowOut,SeqStepNum,TERMINATIONXCH2OIN,TERMINATIONXCH2OOUT,TerminationHXWaterLPM);

%8          9     10        11        12         13          14     15
j1 = j1(1+startTime*360:end-endTime*360,:);
j1(any(isnan(j1),2),:)=[];
j1 = j1(j1(:,15) > 0,:);
j1Size = size(j1,1);
dt = datetime(j1(:,1), 'ConvertFrom', 'datenum') ; 
if (dailyPlot == 1)
figure(1)
hold on
aa_splot(dt,j1(:,2),'black','linewidth',1.5)
ylim([p1 p2])
addaxis(dt,j1(:,3),'linewidth',1.5);
addaxis(dt,j1(:,4))
%addaxis(dt,smooth(j1(:,5),11))
%addaxis(dt,smooth(j1(:,6),11))
addaxis(dt,smooth(j1(:,7),11))
%addaxis(dt,smooth(j1(:,14),11))
%addaxis(dt,smooth(j1(:,16),11))
%addaxis(dt,smooth(j1(:,17),11))
%addaxis(dt,smooth(j1(:,18),11))
%addaxis(dt,smooth(j1(:,10),11))

title(dataFile,'fontsize',11)
addaxislabel(1,'HeaterPower');
addaxislabel(2,'CoreTemp');
addaxislabel(3,'QPulseLen');
%addaxislabel(4,'QkHz');
%addaxislabel(4,'QPow');
%addaxislabel(7,'CoreInPress');
addaxislabel(4,'Term');
%addaxislabel(5,'PowOut');
%addaxislabel(9,'TermOut');
%addaxislabel(10,'TermLPM');
%addaxislabel(8,'QPulseVolt');

end
if (processYes == 1) 
dt1 = []; 
hp = []; 
temp1=[];
ql = [];
%gf = [];
qPow = [];
qTerm = [];
coreIn = [];
coreOut = [];
H2MakeupLPM = [];
powOut= [];
qPowCV = [];
qTermCV=[];
coreInCV=[];
coreOutCV=[];
powOutCV= [];
i=0;
i1 = 1;
ii = 60; %600 seconds before to next seq.
if ii > 5;
  trim = round(200/ii); %k = ii*(trim/100)/2 through away one highset/lowest point trim = 200/ii
else
  trim = 0;
end    
while (i < j1Size-1)  
  i = i+1;
  if ((j1(i+1,15) - j1(i,15)) == 1 || i+1 == j1Size )
    i2 = i;
    seq = j1(i2,15);
    temp1(seq)=trimmean(j1(i2-ii:i2,3),trim);
    dt1(seq) = j1(i2,1);
    ql(seq) = j1(i2,4);
   % qf(seq) = trimmean(j1(i2-ii:i2,5),trim);
      hp(seq) = trimmean(j1(i2-ii:i2,2),trim); 
      qPow(seq) = trimmean(j1(i2-ii:i2,6),trim);
      qTerm(seq) = trimmean(j1(i2-ii:i2,7),trim); 
      coreIn(seq) = trimmean(j1(i2-ii:i2,11),trim);
      coreOut(seq)=trimmean(j1(i2-ii:i2,12),trim); 
      H2MakeupLPM(seq) = trimmean(j1(i2-ii:i2,13),trim);
      powOut(seq) = trimmean(j1(i2-ii:i2,14),trim);
      tlpm(seq) = trimmean(j1(i2-ii:i2,18),trim);
      j6 =mean(j1(i1:i2,6)); 
      j7 = mean(j1(i1:i2,7));
      j11 =mean(j1(i1:i2,11)); 
      j12 = mean(j1(i1:i2,12));
      j14 = mean(j1(i1:i2,14));
      qPowCV(seq) = std(j1(i1:i2,6));
      qTermCV(seq)=std(j1(i1:i2,7));
      coreInCV(seq) = std(j1(i1:i2,11));
      coreOutCV(seq)=std(j1(i1:i2,12));
      powOutCV(seq)=std(j1(i1:i2,14));
      if j6 > 0
        qPowCV(seq)= qPowCV(seq)/j6;
      end   
      if j7 > 0
        qTermCV(seq)=qTermCV(seq)/j7;
      end  
      if j11 > 0 
        coreInCV(seq)=coreInCV(seq)/j11;
      end  
      if j12 > 0 
        coreOutCV(seq)=coreOutCV(seq)/j12;
      end    
      if j14 > 0 
        powOutCV(seq)=powOutCV(seq)/j14;
      end    

      i1 = i2+1; 
    
  end
end 
dt2 = datetime(dt1, 'ConvertFrom', 'datenum') ;
fn = ['C:\jinwork\BEC\tmp\' reactor '-' whichDate '.csv'];            

T=table(temp1(:),ql(:),hp(:),qTerm(:),qPow(:),coreIn(:),coreOut(:),H2MakeupLPM(:), ...
    powOut(:),qTermCV(:),qPowCV(:),coreInCV(:),coreOutCV(:),powOutCV(:),tlpm(:),dt2(:),...
    'VariableName',{'Temp','QL','HP','Term','qPow','coreIn','coreOut','H2M','powOut','qTermCV','qPowCV','coreInCV','coreOutCV','powOutCV','tlpm','date'});
writetable(T,fn);
end
