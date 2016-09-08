clear all;close all

addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
%control parameters

%input reactor
reactor = 'ipb1' %'sri'; %'ipb1','ipb2-aug','ipb2-sep'conflat'

deltaTemp = 2;
plotYes = 1;
processYes = 0;
qpulse = 1;
switch (reactor)
case 'ipb2-sep'
   Directory='C:\jinwork\BEC\Data\ISOPERIBOLIC2_DATA\2016-09-05_crio_V164_core28b'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichSeq = 3;
   %input which sequence
   switch (whichSeq)
   case 1 
     seqFile ='All'
     startTime = 0; %9/4/2016 6 hours after 6:00
     endTime = 0;   %9/5/2016 20:33
     Experiment = AllFiles(1:4);
     %for temp=[277 302 327 352]
   case 2
     seqFile ='IPB2-Core-28b-H2-600c-300c-CRIO-V164'       
     startTime = 0; 
     endTime = 0; 
     Experiment = AllFiles(1:2);
     %for temp=[602 502 402 302]
   case 3
     seqFile ='IPB2-Core-28b-H2-150c-400c-CRIO-V164'       
     startTime = 0; 
     endTime = 0; 
     Experiment = AllFiles(3:4);
     %for temp=[602 502 402 302]

   end       
case 'sri'
   Directory='C:\jinwork\BEC\Data\SRIdata\2016-08-12'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichSeq = 1;
   %input which sequence
   switch (whichSeq)
   case 1 
     seqFile ='300-100ns steps 275-350C in 25C steps He 30sccm 100psi.csv'
     startTime = 6; %9/4/2016 6 hours after 6:00
     endTime = 7;   %9/5/2016 20:33
     Experiment = AllFiles(24:25);
     %for temp=[277 302 327 352]
   case 2
     seqFile ='300-100ns+steps+600-300C+in+100C+steps+He+30sccm+100psi.csv'       
     startTime = 2; 
     endTime = 9; 
     Experiment = AllFiles(22:23);
     %for temp=[602 502 402 302]
   case 3
     seqFile ='No QPulse'      
     startTime = 1.5; 
     endTime = 9; 
     Experiment = AllFiles(12:21);
     qpulse = 0;
   case 4 %no Qpulse with a sequence file
     seqFile ='Sequence+325-600C+in+25C+steps+H2+30sccm+100psi.csv'     
     startTime = 11; 
     endTime = 21; 
     Experiment = AllFiles(16:20);
     %for temp=350:25:600
     qpulse = 0;
     deltaTemp = 0.05;
   case 5 %ALL
     seqFile ='ALL'       
     startTime = 0; 
     endTime = 0; 
     Experiment = AllFiles(1:end);
   case 6 
     seqFile ='Sequence+300-100ns+alternates+100VAC+33W+H2+275C+30sccm+100psi.csv'       
     startTime = 5; 
     endTime = 19; 
     Experiment = AllFiles(10:11);
   case 7 
     seqFile ='no sequence file found'     
     startTime = 0; %8/22/2016 15:01
     endTime = 0; %8/24/2016 1:05 from end of file 8/24/2016 10:21
     Experiment = AllFiles(1:9);  
   otherwise
     exit
   end;
 case 'ipb2-aug'
   Directory='C:\jinwork\BEC\Data\isoperibolic2_data\2016-08-20-CORE_28_DC_Heater'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichSeq = 1;
   switch (whichSeq)
   case 1 
     seqFile ='H2-150C-400C-DEUG-NEW-SW'   
     startTime = 0.5; %11 hours after 6:00
     endTime = 32;   %8/21/2016 20:33
     Experiment = AllFiles(2:4);
   otherwise
     exit
   end
 case 'ipb1'
   Directory='C:\jinwork\BEC\Data\isoperibolic_data\2016-08-20-CORE_26b'
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichSeq = 5;
   switch (whichSeq)
   case 1
     seqFile ='ALL'   
     startTime = 1.0; %8/22/2016 15:01
     endTime = 11; %8/24/2016 1:05 from end of file 8/24/2016 10:21
     Experiment = AllFiles(1:20);
   case 2
     seqFile ='IPB1-Core-26b-New-core-He'   
     startTime = 1.0; %8/22/2016 15:01
     endTime = 13.5; %8/24/2016 1:05 from end of file 8/24/2016 10:21
     Experiment = AllFiles(1:3);
   case 3
     seqFile ='IPB1-Core-26b-New-core-H2'   
     startTime = 1.0; %8/22/2016 15:01
     endTime = 9; %8/24/2016 1:05 from end of file 8/24/2016 10:21
     Experiment = AllFiles(4:6);
   case 4
     seqFile ='IPB1-Core-26b-New-core-1st-condition'   
     startTime = 1.0; %8/22/2016 15:01
     endTime = 0; %8/24/2016 1:05 from end of file 8/24/2016 10:21
     Experiment = AllFiles(7:8);

   case 5
        seqFile ='IPB1-Core-26b-New-core-2nd-condition'  
        startTime = 1.5; %8/22/2016 15:01
        endTime = 19; %8/24/2016 1:05 from end of file 8/24/2016 10:21
        Experiment = AllFiles(9:10)
        
   case 6
        seqFile ='IPB1-Core-26b-New-core-3rd-condition'  
        startTime = 1.5; %8/22/2016 15:01
        endTime = 0; %8/24/2016 1:05 from end of file 8/24/2016 10:21
        Experiment = AllFiles(11:12)
   case 7
        seqFile ='IPB1-Core-26b-New-core-H2-D2'  
        startTime = 1.5; %8/30/2016 13:45 from 12:00
        endTime = 16; %9/1/2016 8/31/2016 20:55 from end of file 9/1/2016 14:27
        Experiment = AllFiles(13:15);
      
   case 8
        seqFile ='IPB1-Core-26b-New-core-H2-D2-Run2'  
        startTime = 3.5; %8/30/2016 13:45 from 12:00
        endTime = 12; %9/1/2016 8/31/2016 20:55 from end of file 9/1/2016 14:27
        Experiment = AllFiles(16:18);
   case 9
     seqFile ='IPB1-Temp-sequence-150-100-150ns-50W-150C-400C-H2.csv'   
     %IPB1_Core_26b-New-core_He_150C-400C_day-01(02)(03).csv (8/20/2016 11:00 - 8/22/2016 10:28)
     startTime = 0; %11 hours after 6:00
     endTime = 0;   %8/21/2016 20:33
     Experiment = AllFiles(19:20);

   otherwise
        exit
  end;
end    
Experiment'
loadHHT %TODO change name 
%change a few messy variable names
QOccurred = QOccurred0x3F; clear QPulseOccurred0x3F
QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29
QPulseDelays = QPulseDelay0x28s0x29; clear QPulseDelay0x28s0x29
QkHz = QKHz; clear QKHz;
%change datetime to number
dateN=datenum(DateTime,'mm/dd/yyyy HH:MM:SS');

%print out starting and end time in command window to make sure the data
%process window is proper.
DateTime(1+startTime*360)
DateTime(end - endTime*360)

%j1 = horzcat(dateN,CoreTemp,QkHz,QPulseVolt,IsoperibolicCalorimetryPower,HeaterPower,QPulseLengthns,QPow);
%j1 = horzcat(dateN,InnerCoreTemp,CoreHtrPow,QkHz,QPulseVolt);
switch (reactor)
case {'sri','conflat'}
  j1 = horzcat(dateN,CoreHtrPow,CoreReactorTemp,QPulseLengthns,QkHz,TerminationThermPow,HGASSOURCEVALVEVH3);
case {'ipb1', 'ipb2-sep','ipb2-aug'}
  j1 = horzcat(dateN,HeaterPower,CoreTemp,QPulseLengthns,QkHz,QPulsePCBHeatsinkPower,IsoperibolicCalorimetryPower,QPulseVolt,QEnable);
otherwise
  exit
end

%limit to the right time period
j1=j1(1+startTime*360:end-endTime*360,:);
%formating time
dt = datetime(j1(:,1), 'ConvertFrom', 'datenum') ; 

if (plotYes == 1)
figure(1)
hold on
%Power
aa_splot(dt,j1(:,2),'black')
%tempareture
addaxis(dt,j1(:,3));
%qpulselengthns
addaxis(dt,j1(:,4))
if qpulse == 1
  addaxis(dt,j1(:,5))
  addaxis(dt,j1(:,6))
end

title(seqFile,'fontsize',11)
addaxislabel(1,'HeaterPower');
addaxislabel(2,'CoreTemp');


if qpulse == 1
  addaxislabel(3,'QPulseLen');
  addaxislabel(4,'QkHz');
end 
addaxislabel(5,'QPulsePCBHeatsinkPower');
end
if (processYes == 0) 
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
   nj1 = 1;
   if nj2 > 40 % minimum requirement is 40 minutes for power watt change < 0.3 
     nj1 = 1;
     nq = 1;
     if qpulse == 1 
     for ki = 1:1:6
       j4(ki) = 0; 
       dt1(ki) = j2(1,1);
       jttp(ki) =0;
       
       for ni = nj1:1:nj2-1     
          if ( j2(ni,4) == qL(ki) & abs(j2(ni,4)-j2(ni+1,4)) > 190 & j2(ni,5) > 1) % there is a jump in QPulse
            j3 = j2(nj1:ni,:);
            fn = ['C:\jinwork\BEC\tmp\' reactor '-' num2str(whichSeq) num2str(temp) num2str(qL(ki)) num2str(ki) '.csv'];          
            dt = datetime(j3(:,1), 'ConvertFrom', 'datenum') ;        
            T = table(dt,j3(:,2),j3(:,3),j3(:,4),j3(:,5),'VariableName',{'DateTime','CoreTemp','Power','QL','QPower'});      
            writetable(T,fn);
            j4(ki) = j2(ni,3);
            jttp(ki) = trimmean(j2(nj1:ni,5),10);
            dt1(ki) = j2(ni,1);
            j5(ki) = ni-nj1;
            nj1 = ni+1;            
            break
          end                
       end 
       
     end 
     else
       for ni = nj1:1:nj2-39    
          if (abs(j2(ni,3)-j2(ni+39,3)))< 0.4
            j3 = j2(nj1:ni,:);
            fn = ['C:\jinwork\BEC\tmp\sri-' num2str(whichEx) num2str(temp) num2str(qL(ki)) num2str(ki) '.csv'];          
            dt = datetime(j3(:,1), 'ConvertFrom', 'datenum') ;        
            T = table(dt,j3(:,2),j3(:,3),j3(:,4),j3(:,5),'VariableName',{'DateTime','CoreTemp','Power','QL','QPower'});      
            writetable(T,fn);
            j4(ki) = j2(ni,3);
            jttp(ki) = trimmean(j2(nj1:ni,5),10);
            dt1(ki) = j2(ni,1);
            j5(ki) = ni-nj1;
            nj1 = ni+1; 
            break
          end
       end
     end   
    tpi = [temp j4 jttp j5];
    tp = vertcat(tp,tpi);
    dt2 = vertcat(dt2,dt1); 
  end    
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
