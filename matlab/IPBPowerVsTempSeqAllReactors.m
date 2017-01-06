% Initial housekeeping
clear; close all
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
%Control parameters
dailyPlot = 1;
debugQPow = 0;
flowratePlot = 0;
tempPlot = 0;
qPowOnlyPlot = 0;
heaterPowerOnlyPlot = 0;
qPowHeaterPowerPlot = 0;
qpulseLen = 0;
processYes = 1;
errorBarPlot = 1;
hp1 = 0;
hp2 = 40; 
qpow1 = 5;
qpow2 = 55;
coreqpow1 = 0;
coreqpow2 = 8.2;
% list reactors,cores and directories starting from the most recent ones
%reactor='google'; %merge files
%reactor='2016-10-27-CRIO-v174_CORE_30b_He';
%reactor='sri-ipb2-27b-1116';
%reactor='sri-ipb2-27b';
%reactor='2016-10-27-CRIO-v174_CORE_29b_H2';
%reactor='2016-10-24-CRIO-v173_CORE_29b_H2';
%reactor ='ipb1-2016-09-30-CRIO-v171_CORE_29b' ;
%reactor = '2016-09-29-CRIO-v170_CORE_29b';
%reactor = 'ipb2-0907-165-28b';
%reactor = 'ipb2-0905-164-28b';
%reactor = 'ipb1-0924-v169-27b';
%reactor='ipb2-0909-v169-27b';
%reactor = 'ipb2-0909-167-27b';
reactor='ipb2-0909-166-27b';
%reactor = 'ipb2-0909-165-27b';
%reactor = 'ipb1-0928-crio-v170_core_26b'
switch (reactor)
case 'google' 
Directory='C:\jinwork\BEC\google';
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '11222016';
switch (whichDate)
case '11222016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='sri-ipb2-h2-heatpoweronly4hours';
    startTime = 0;
    endTime = 0; 
    hp1 = 5;
    hp2= 40;
    Experiment = AllFiles(4:4);    
case '11292016' %sri-ipb2 qpowonly
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='sri-ipb2-h2-qpowonly8hours';
    startTime = 1;
    endTime = 0; 
    hp1 = 5;
    hp2= 40;
    Experiment = AllFiles(9:9);            
end    
case '2016-10-27-CRIO-v174_CORE_30b_He' 
Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\2016-11-01-CRIO-v174_CORE_30b_He';
%Directory='C:\Users\Owner\Dropbox (BEC)\BECteam\Jen';
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '11152016';
switch (whichDate)
case '11012016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='IPB1_Temp_sequence_150-100-150ns_50W_150C-400C_Helium_Run3_10-07-16_day-01.csv:02.csv';
    startTime = 0;
    endTime = 0; 
    hp1 = 5;
    hp2= 40;
    Experiment = AllFiles(1:2);        
case '11102016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='IPB1_Temp_sequence_150-100-150ns_50W_150C-400C_Helium_Run3_10-07-16_day-01.csv:02.csv';
    startTime = 0;
    endTime = 0; 
    hp1 = 5;
    hp2=10;
    Experiment = AllFiles(1:15);
case '11112016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='IPB1_Temp_sequence_150-100-150ns_50W_150C-400C_Helium_Run3_10-07-16_day-01.csv:02.csv';
    startTime = 0;
    endTime = 0; 
    hp1 = 0;
    hp2=20;
    Experiment = AllFiles(14:17);    
 case '11122016' %250c
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='IPB1_Core_30b-Q_power_calibration_1000ns_Helium_JL__11-11-16_day-02.csv-03.csv';
    startTime = 17;
    endTime = 0; 
    hp1 = 16;
    hp2 = 20;
    qpow1=15;
    qpow2=55;
    Experiment = AllFiles(15:16);    
case '11152016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='IPB1-Q-Power-only-sequence-HeliumDFR-day-01.csv-02.csv';
    startTime = 0;
    endTime = 0; 
    hp1 = 10;
    hp2 = 20;
    Experiment = AllFiles(18:19);
case '11162016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='IPB1-Q-Power-only-sequence-HeliumDFR-day-01.csv-02.csv';
    startTime = 20;
    endTime = 0; 
    hp1 = 10;
    hp2 = 20;
    Experiment = AllFiles(20:20);        
case '11172016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='IPB1-Heater-Power-10W-to-50W-day-01.csv';
    startTime = 10.4;
    endTime = 0; 
    hp1 = 10;
    hp2 = 20;
    Experiment = AllFiles(23:25);   
    %Experiment = AllFiles(1:1);   
case '11192016' %250c
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='Qpow_calibaration_day-03.csv';
    startTime = 9;
    endTime = 0; 
    hp1 = 16;
    hp2 = 30;
    qpow1 = 15;
    qpow2 = 55;
    Experiment = AllFiles(28:28);    
    %Experiment = AllFiles(4:4);    
case '11212016' %300c
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='Qpow_calibaration_day-03.csv';
    startTime = 16;
    endTime = 0; 
    hp1 = 19;
    hp2 = 26;
    qpow1 = 15;
    qpow2 = 55;
    Experiment = AllFiles(28:29);    
    %Experiment = AllFiles(4:4);      
case '11272016' %250-300-400c
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='Qpow-calibaration-day-03.csv';
    startTime = 0;
    endTime = 0; 
    hp1 = 19;
    hp2 = 40;
    qpow1 = 15;
    qpow2 = 55;
    Experiment = AllFiles(30:33);    
    %Experiment = AllFiles(4:4);  
case '11282016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='IPB1-Qpow-calibaration-run2-day-06.csv';
    startTime = 17;
    endTime = 0; 
    hp1 = 5;
    hp2 = 10;
    qpow1 = 15;
    qpow2 = 55;
    Experiment = AllFiles(35:35);    
    %Experiment = AllFiles(4:4);           
case '11292016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='IPB1-Qpow-calibaration-run2-day-07.csv';
    startTime = 18;
    endTime = 0; 
    hp1 = 7.5;
    hp2 = 40;
    qpow1 = 15;
    qpow2 = 55;
    coreqpow1 = 1;
    coreqpow2 = 6;
    Experiment = AllFiles(36:39);    
    %Experiment = AllFiles(4:4);               
end  
case 'sri-ipb2-27b-1116' 
Directory='C:\Users\Owner\Dropbox (BEC)\SRI-IPB2\2016-11-16_SRI_v174-core27b';
%Directory='C:\jinwork\BEC\Data'
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '12012016';
switch (whichDate)
  case '11202016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\HeaterPower_only';   
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(3:5);
  case '11222016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\temperature';   
    startTime =22;
    endTime = 0; 
    hp1 =5;
    hp2=10;
    Experiment = AllFiles(6:6);  
  case '11272016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\temperature';   
    startTime =0;
    endTime = 55; 
    hp1 =5;
    hp2=40;
    Experiment = AllFiles(8:8);    
  case '11282016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\qpowOnly8hours';   
    startTime =70;
    endTime = 0; 
    hp1 =5;
    hp2=40;
    Experiment = AllFiles(8:8);    
   case '12012016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\heatpowerQpow';   
    startTime =2;
    endTime = 0; 
    hp1 =15;
    hp2=25;
    Experiment = AllFiles(11:13);      
end
case '2016-10-27-CRIO-v174_CORE_29b_H2' 
Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2';
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '10292016';
switch (whichDate)
  case '10282016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='IPB1 H2';
    startTime = 0;
    endTime = 0; 
    hp1 = 5;
    hp2 = 40;
    Experiment = AllFiles(1:2);
  case '10292016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-Run2_10-28-16_day-01.csv:03.csv';   
    dataFile='IPB1 H2';
    startTime = 4;
    endTime = 0; 
    hp1 = 5;
    hp2 = 40;
    Experiment = AllFiles(3:5);
end        
case '2016-10-24-CRIO-v173_CORE_29b_H2' 
Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\2016-10-24-CRIO-v173_CORE_29b_H2';
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '10252016';
switch (whichDate)
  case '10252016' 
    dataFile ='\ISOPERIBOLIC_DATA\2016-10-24-CRIO-v173_CORE_29b_H2\PB1_Core_29b_DC_Qkcal_150C-500C_H2_day-01.cs';   
    startTime = 2;
    endTime = 0; 
    Experiment = AllFiles(5:5);
end    
case 'sri-ipb2-27b' 
Directory='C:\Users\Owner\Dropbox (BEC)\SRI-IPB2\2016-09-30_SRI_v171-core27b';
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '11152016';
switch (whichDate)
  case '10042016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\SRI-IPB2_H2-250-400C_10-04-16_day-01.csv - 02.csv';   
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(6:7);
  case '10112016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\SRI-IPB2_H2-250-400C_10-04-16_day-01.csv - 02.csv';   
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(14:15);  
  case '10062016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\SRI-IPB2_H2-250-400C_10-05-16_day-16.csv : 22.csv'; 
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(23:29);
  case '10262016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\SRI-IPB2_H2-250-400C_10-05-16_day-23.csv'; 
    startTime = 12;
    endTime = 3; 
    Experiment = AllFiles(30:32);
  case '10282016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\SRI-IPB2_H2-250-400C_10-05-16_day-23.csv'; 
    startTime = 12;
    endTime = 3; 
    Experiment = AllFiles(32:35);
  case '11012016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\SRI-IPB2_H2-250-400C_10-05-16_day-25.csv-29.csv'; 
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(32:36);
  case '11032016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\SRI-IPB2_H2-250-400C_10-05-16_day-25.csv-29.csv'; 
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(37:37);
  case '11062016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\SRI-IPB2_H2-250-400C_10-05-16_day-25.csv-29.csv'; 
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(43:44);
  case '11112016-11122016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\SRI-IPB2_H2-250-400C_10-05-16_day-38.csv-40.csv'; 
    startTime = 19.5;
    endTime = 0; 
    Experiment = AllFiles(45:50);
    p1 = 5;
    p2=40;
  case '11112016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\SRI-IPB2_H2-250-400C_10-05-16_day-38.csv-40.csv'; 
    startTime = 19.5; %150
    endTime = 2; 
    Experiment = AllFiles(45:46);
    p1 = 5;
    p2=10;  
  case '11122016' %250c
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\SRI-IPB2_H2-250-400C_10-05-16_day-38.csv-40.csv'; 
    startTime = 0;
    endTime = 23; 
    Experiment = AllFiles(47:48);
    p1 = 15;
    p2=20;
  case '11152016' %300c
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\SRI-IPB2_H2-250-400C_10-05-16_day-38.csv-40.csv'; 
    startTime = 2;
    endTime = 18.5; 
    Experiment = AllFiles(48:49);
    hp1 = 19;
    hp2 = 26;
  case '11162016' %400c
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\SRI-IPB2_H2-250-400C_10-05-16_day-38.csv-40.csv'; 
    startTime = 7;
    endTime = 2; 
    Experiment = AllFiles(49:50);
    hp1 = 35;
    hp2 = 40;
  case '11172016'
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\2016-11-16_day-1.csv'; 
    startTime = 7;
    endTime = 0; 
    Experiment = AllFiles(51:51);
    hp1 = 0;
    hp2 = 0;
end 
case 'ipb1-2016-09-30-CRIO-v171_CORE_29b' 
Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\2016-09-30-CRIO-v171_CORE_29b';
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '10212016';
switch (whichDate)
  case '093002016' 
    dataFile ='\ISOPERIBOLIC_DATA\2016-09-30-CRIO-v171_CORE_29b\IPB1_Core_29b-He-DC_QFLOW_CAL-9-30_16_day-01.csv : 02.csv' ;  
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(1:4);
  case '10052016' 
    dataFile ='\ISOPERIBOLIC_DATA\2016-09-30-CRIO-v171_CORE_29b\IPB1_Core_29b-Helium-150C-400C_10-04-16_day-01.csv' ;  
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(10:12);  
  case '10042016' 
    dataFile ='\ISOPERIBOLIC_DATA\2016-09-30-CRIO-v171_CORE_29b\IPB1_Core_29b-Helium-150C-400C_10-04-16_day-01.csv' ;  
    %dataFile ='IPB1 He' ;  
    startTime = 0;
    endTime = 0; 
    hp1 = 5;
    hp2 = 40;
    Experiment = AllFiles(9:10);
  case '10072016' 
    dataFile ='\ISOPERIBOLIC_DATA\2016-09-30-CRIO-v171_CORE_29b\IPB1_CoreQ_Pow_cal_day-01.csv:06.csv' ;  
    startTime = 1;
    endTime = 0; 
    Experiment = AllFiles(13:18);
  case '10152016' 
    dataFile ='\ISOPERIBOLIC_DATA\2016-09-30-CRIO-v171_CORE_29b\IPB1_CoreQ_Cal_2_day-01.csv:05.csv' ;  
    startTime = 1;
    endTime = 0; 
    Experiment = AllFiles(24:28);
  case '10182016' 
    dataFile ='\ISOPERIBOLIC_DATA\2016-09-30-CRIO-v171_CORE_29b\PB1_Core_29b-Helium-150C-400C_10-18-16_Run2_day-01.csv:02.csv'  ; 
    startTime = 0;
    endTime = 0; 
    hp1 = 5;
    hp2 = 40;
    Experiment = AllFiles(29:30);
  case '10212016' 
    dataFile ='\ISOPERIBOLIC_DATA\2016-09-30-CRIO-v171_CORE_29b\PB1_Core_29b_Q_power_calibration_sequence_day-01.csv:04.csv'  ; 
    startTime = 0;
    endTime = 0; 
    hp1 = 5;
    hp2 = 40;
    Experiment = AllFiles(32:35);
end
case 'ipb1-0928-crio-v170_core_26b' 
Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\2016-09-28-CRIO-v170_CORE_26b';
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '09282016';
switch (whichDate)
  case '09282016' 
    dataFile ='\ISOPERIBOLIC_DATA\2016-09-28-CRIO-v170_CORE_26b\IPB1_Core_26b-H2-DC_QFLOW_CAL-9-28_16_day-01.csv : 02.csv' ;  
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(1:2);
end
case 'sri-ipb2'
Directory='C:\Users\Owner\Dropbox (BEC)\SRI-IPB2\2016-09-24_SRI_v170-core27b';
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '09282016';
switch (whichDate)
  case '09282016' 
    dataFile ='SRI-IPB2\_H2-250-400C\_9-28-16\_day-01.csv' ;  
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(2:3);
   case '09262016' 
    dataFile ='IPB1_Core_27b-_H2-250-400C__9-24-16_day-01.csv:02.csv';   
    startTime = 9;
    endTime = 0; 
    Experiment = AllFiles(2:3);   
end
case 'ipb1-0924-v169-27b'
Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\2016-09-24-CRIO-v169_CORE_26b';
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '09252016-09262016';
switch (whichDate)
  case '09025016-09262016' 
    dataFile ='IPB1_Core_27b-_H2-250-400C__9-24-16_day-01.csv:02.csv' ;  
    startTime = 3;
    endTime = 10; 
    Experiment = AllFiles(1:2);
   case '09262016' 
    dataFile ='IPB1_Core_27b-_H2-250-400C__9-24-16_day-01.csv:02.csv' ;  
    startTime = 9;
    endTime = 0; 
    Experiment = AllFiles(2:3);  
end
case 'ipb2-0909-v169-27b' %coreqpow =0
Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-09_CRIO_v169-core27b';
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '09024016';
switch (whichDate)
  case '09024016' 
    dataFile ='IPB2_Core_27b-_H2-250-400C__9-24-16_day-01.csv';   
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(1:1);
end
case 'ipb2-09-24_CRIO_v169-core27b'
Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-24_CRIO_v169-core27b';
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '09024016-09252016';
switch (whichDate)
  case '09024016-09252016' 
    dataFile ='IPB2_Core_27b-_H2-250-400C__9-24-16_day-03.csv';   
    startTime = 2;
    endTime = 0; 
    Experiment = AllFiles(1:2);
  case '09262016' 
    dataFile ='IPB2_Core_27b-_H2-250-400C__9-24-16_day-03.csv';   
    startTime = 0;
    endTime = 0; 
    Experiment = AllFiles(3:3);   
end
case 'ipb1-0820'
  Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\2016-08-20-CORE_26b';
  AllFiles = getall(Directory);  %SORTED BY DATE....
  whichDate = '08022016-08212016';
  switch (whichDate)
  case '1' 
    dataFile ='ALL'   
    startTime = 1.0;
    endTime = 11; 
    Experiment = AllFiles(1:20);
  case '08022016-08212016'
    dataFile ='IPB1-Core-26b-New-core-He'   
    startTime = 1.0; 
    endTime = 13.5; 
    Experiment = AllFiles(1:3);
  case '3'
    dataFile ='IPB1-Core-26b-New-core-H2' ; 
    startTime = 1.0;
    endTime = 9;
    Experiment = AllFiles(4:6);
  case '4'
    dataFile ='IPB1-Core-26b-New-core-1st-condition'  ; 
    startTime = 1.0; 
    endTime = 0; 
    Experiment = AllFiles(7:8);    
  case '5'
    dataFile ='IPB1-Core-26b-New-core-2nd-condition';  
    startTime = 1.5;
    endTime = 19; 
    Experiment = AllFiles(9:10);
  case '6'
    dataFile ='IPB1-Core-26b-New-core-3rd-condition' ; 
    startTime = 1.5;
    endTime = 0; 
    Experiment = AllFiles(11:12)
  case '7'
    dataFile ='IPB1-Core-26b-New-core-H2-D2' ; 
    startTime = 1.5; 
    endTime = 16; 
    Experiment = AllFiles(16:18);
  case '8'
    dataFile ='IPB1-Core-26b-New-core-H2-D2-Run2' ; 
    startTime = 3.5; 
    endTime = 12; 
    Experiment = AllFiles(19:21);
  case '9'
    dataFile ='IPB1-Core-26b-New-core-H2-D2-Run3';  
    startTime = 0; 
    endTime = 15; 
    Experiment = AllFiles(22:24);
  case '10'
    dataFile ='IPB1-Core-26b-New-core-H2-D2-Run5';  
    startTime = 0; 
    endTime = 0; 
    Experiment = AllFiles(25:26);
  case '11'
    dataFile ='IPB1-Core-26b-New-core-H2-D2-Run5';  
    startTime = 0; 
    endTime = 0; 
    Experiment = AllFiles(27:27);
  case '12'
    dataFile ='IPB1-Temp-sequence-150-100-150ns-50W-150C-400C-H2.csv' ;  
    %IPB1_Core_26b-New-core_He_150C-400C_day-01(02)(03).csv (8/20/2016 11:00 - 8/22/2016 10:28)
    startTime = 0; 
    endTime = 15;    
    Experiment = AllFiles(19:21);   
  case '13'
    dataFile ='IPB1-Temp-sequence-150-100-150ns-50W-150C-400C-H2.csv';   
    %IPB1_Core_26b-New-core_He_150C-400C_day-01(02)(03).csv (8/20/2016 11:00 - 8/22/2016 10:28)
    startTime = 0; 
    endTime = 0;   
    Experiment = AllFiles(22:22);
  otherwise
    exit
  end;    
case 'ipb1-0915'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\2016-09-15-CRIO-v167_CORE_26b';
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '09222016-09232016'; 
   switch (whichDate)
   case '09162016-09182016' 
     dataFile ='IPB1_Core\_26b-H2-CRIO\_v167\_150C-400C\_Run1\_day-01.csv : 04.csv';
     startTime = 1; 
     endTime = 20;  
     Experiment = AllFiles(1:4);
   case '09182016-09192016' 
     dataFile ='IPB1\_Core\_26b-H2-650C-300C\_Run1\_day-01.csv : 02.csv';
     startTime = 0; 
     endTime = 0;  
     Experiment = AllFiles(6:7);
   case '09212016-09222016' 
     dataFile ='\ISOPERIBOLIC_DATA\2016-09-15-CRIO-v167_CORE_26b\IPB1_Core_26b-H2-250C-400C_Run2_day-01.csv : 02.csv';
     startTime = 0; 
     endTime = 9;  
     Experiment = AllFiles(12:13);
  case '09222016-09232016' 
     dataFile ='\ISOPERIBOLIC_DATA\2016-09-15-CRIO-v167_CORE_26b\IPB1_Core_26b-H2-250C-400C_Run2_day-03.csv'
     startTime = 0; 
     endTime = 9;  
     Experiment = AllFiles(15:15);
   end      
case 'ipb2-08'
  Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-08-20-CORE_28_DC_Heater';
  AllFiles = getall(Directory);  %SORTED BY DATE....
  whichDate ='09022016';
  detailPlot = 1;
  switch (whichDate)
  case '08202016' 
    dataFile ='\2016-08-20-CORE_28_DC_Heater\IPB2_Core_28b-New-core_He_150C-400C_day-01.csv : 03.csv'   
    startTime = 0; %11 hours after 6:00
    endTime = 14;   %8/21/2016 20:33
    Experiment = AllFiles(1:3);
  case '08222016' 
    dataFile ='IPB2-core-28b-h2'   
    startTime = 2; %11 hours after 6:00
    endTime = 7;   %8/21/2016 20:33
    Experiment = AllFiles(4:6);
  case '09022016'  
    dataFile ='H2-150C-400C-DEUG-NEW-SW'   
    startTime = 0.5; %11 hours after 6:00
    endTime = 32;   %8/21/2016 20:33
    Experiment = AllFiles(13:16);
  otherwise
    exit
  end    
case 'ipb2-0905-164-28b'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-05_Crio_V164_core28b';
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '09052016'; 
   switch (whichDate)
   case '09062016-09072016' 
   dataFile ='\ISOPERIBOLIC2_DATA\2016-09-05_Crio_V164_core28b\IPB2_Core_28b-_H2_600C-300C_CRIO_V164_day-01.csv : 02.csv';
   startTime = 7.5; 
   endTime = 5;  
   Experiment = AllFiles(6:6);
   case '09052016' 
   dataFile ='\ISOPERIBOLIC2_DATA\2016-09-05_Crio_V164_core28b\IPB2_Core_28b-_H2_600C-300C_CRIO_V164_Edited.csv';
   startTime = 0; 
   endTime = 0;  
   Experiment = AllFiles(4:4);
   end    
case 'ipb2-0907-165-28b'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-07_Crio_V165_core28b';
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '09072016-09082016'; 
   switch (whichDate)
   case '09072016-09082016' 
     dataFile ='ISOPERIBOLIC2_DATA\2016-09-07_Crio_V165_core28b\IPB2-Core-28b--H2-150C-400C-Run1-day-01 : 02.csv';
     startTime = 1; 
     endTime = 0;  
     Experiment = AllFiles(1:2);
   case '09072016-09082016-200' 
     dataFile ='ISOPERIBOLIC2_DATA\2016-09-07_Crio_V165_core28b\IPB2-Core-28b--H2-150C-400C-Run1-day-01 : 02.csv';
     startTime = 1; 
     endTime = 0;  
     Experiment = AllFiles(1:2);
   case '09072016-09082016-250' 
     dataFile ='ISOPERIBOLIC2_DATA\2016-09-07_Crio_V165_core28b\2016-09-07-Crio-V165-core28b-IPB2-Core-28b--H2-150C-400C-Run1-day-01 : 02.csv';
     startTime = 1; 
     endTime = 0;  
     Experiment = AllFiles(2:2);
   end
case 'ipb2-0909-165-27b'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-09_CRIO_v165-core27b';
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '1';
   switch (whichDate)
   case '1' 
     dataFile ='2016-09-09-CRIO-v165-core27b';
     startTime = 0; 
     endTime = 0;  
     Experiment = AllFiles(1:1);  
   end        
case 'ipb2-0909-166-27b'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-09_CRIO_v166-core27b';
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '09112016-09122016';
   switch (whichDate)
   case '09112016-09122016' 
     dataFile ='2016-09-09-CRIO-v166-core27b-IPB2\_Core\_27b-\_H2\_600C-300C\_\_Run1_day-01.csv : 02.csv';
     startTime = 0; 
     endTime = 15;  
     Experiment = AllFiles(1:2);
   case '09122016' 
     dataFile ='IPB2\_Core\_27b-\_H2_600c-300C\_2probetest1\_EDITED.csv';
     startTime = 0; 
     endTime = 10;  
     Experiment = AllFiles(6:6);
   end    
case 'ipb2-0909-167-27b'
   Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC2_DATA\2016-09-09_CRIO_v167-core27b';
   AllFiles = getall(Directory);  %SORTED BY DATE....
   whichDate = '09122016';   
   switch (whichDate)
   case '09122016' 
     dataFile ='2016-09-09-CRIO-v167-core27b';
     startTime = 0.5; 
     endTime = 9.5;  
     Experiment = AllFiles(3:3);
   case '09142016-09152016' 
     dataFile ='2016-09-09-CRIO-v167-core27b';
     startTime = 0; 
     endTime = 10;  
     Experiment = AllFiles(7:9);    
   case '09162016-09182016' 
     dataFile ='2016-09-09-CRIO-v167-core27b';
     startTime = 5.5; 
     endTime =7.5 ;  
     Experiment = AllFiles(12:12);    
   case '09162016' 
     dataFile ='2016-09-09-CRIO-v167-core27b';
     startTime = 6; 
     endTime =13 ;  
     Experiment = AllFiles(12:12);    
   case '09192016-09202016' 
     dataFile ='2016-09-09-CRIO-v167-core27b';
     startTime = 0; 
     endTime = 0;  
     Experiment = AllFiles(16:17);    
   case '09212016' 
     dataFile ='2016-09-09-CRIO-v167-core27b data file IPB2_Core\_27b-\_H2-250-400C\_RUN1\_9-20-16\_day-01.csv';
     startTime = 0; 
     endTime = 0;  
     Experiment = AllFiles(18:18);    
   case '09222016' 
     dataFile ='2016-09-09-CRIO-v167-core27b data file: IPB2\_Core\_27b-\_H2-250-400C\_RUN1\_9-21-16\_day-01csv.csv';
     startTime = 0; 
     endTime = 0;  
     Experiment = AllFiles(20:20); 
   case '09232016' 
     dataFile ='2016-09-09-CRIO-v167-core27b data file: IPB2\_Core\_27b-\_H2-250-400C\_RUN1\_9-21-16\_day-02csv.csv';
     startTime = 0; 
     endTime = 0;  
     Experiment = AllFiles(21:21); 
   end  
end    
Experiment'
loadHHT 
%change a few messy variable names
QOccurred = QOccurred0x3F; clear QPulseOccurred0x3F
SeqStepNum = SeqStep0x23; clear SeqStep0x23
QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29
QPulseDelays = QPulseDelay0x28s0x29; clear QPulseDelay0x28s0x29
QkHz = QKHz; clear QKHz;
%change datetime to number
dateN=datenum(DateTime,'mm/dd/yyyy HH:MM:SS');
DateTime(1+startTime*360);
DateTime(end - endTime*360);
j1 = horzcat(dateN,...
     HeaterPower,...
     CoreTemp,...
     QPulseLengthns,...
     QkHz,...
     QPow,...
     SeqStepNum,...
     TerminationHeatsinkPower,...
     QPulsePCBHeatsinkPower,...
     CoreQPower,...
     CalorimeterJacketFlowrateLPM,...
     QPCBHeatsinkFlowrateLPM,...
     TerminationHeatsinkFlowrateLPM,...
     CalorimeterJacketPower,...
     CalorimeterJacketH2OInT,...
     CalorimeterJacketH2OOutT,...
     QPCBHeatsinkH2OInT,...
     QPCBHeatsinkH2OOutT,...
     TerminationHeatsinkH2OInT,...
     TerminationHeatsinkH2OOutT,...
     RoomTemperature,...
     QPulseVolt,...
     PressureSensorPSI,...
     InnerBlockTemp1,...
     InnerBlockTemp2,...
     OuterBlockTemp1,...
     OuterBlockTemp2,...
     QCur,...
     QSupplyPower,...
     QSupplyVolt);
%   11                           12                      13                             14                  
j1 = j1(1+startTime*360:end-endTime*360,:);
tmp_fit = j1(:,3);
%j1(any(isnan(j1),2),:)=[]; %take out rows with Nan
j1(isnan(j1)) = -2 ;
j1 = j1(j1(:,7) > 0,:); %only process data with seq
j1Size = size(j1,1);
dt = datetime(j1(:,1), 'ConvertFrom', 'datenum') ;
if (false)
figure
plotyy(dt,j1(:,5),dt,j1(:,6));
legend('qkHz','qPow')
grid on
figure
[gAx,gLine1,gLine2] = plotyy(dt,j1(:,5),dt,j1(:,6))
grid
legend('P_pi',' P_term')
ylabel(gAx(1),'Q Power (W)') % left y-axis
ylabel(gAx(2),'Term Therm Pow (W)') % right y-axis
%title([SYS,' HHT,',DateTime{1},' through ',DateTime{end}],'fontsize',11)
linkaxes(gAx,'x');
set(gAx(2),'XTickLabel',[]);
xlabel(gAx(1),'Date') % left y-axis
end

if (debugQPow == 1)

figure
hold on
aa_splot(dt,j1(:,4),'black','linewidth',1.5);
addaxis(dt,j1(:,5),'linewidth',1.5);
addaxis(dt,j1(:,6),[qpow1,qpow2]);
addaxis(dt,j1(:,10),[coreqpow1,coreqpow2]) ;
addaxis(dt,smooth(j1(:,22),11)); 
addaxis(dt,smooth(j1(:,28),11));
addaxis(dt,smooth(j1(:,29),11)); 
addaxis(dt,smooth(j1(:,30),11));
title(dataFile,'fontsize',11);
addaxislabel(1,'QPulseLen(ns)');
addaxislabel(2,'QkHz)');
addaxislabel(3,'qPow');
addaxislabel(4,'coreqPow');
addaxislabel(5,'Qcur');
addaxislabel(6,'QpulseVolt');
addaxislabel(7,'QSupplyPow');
addaxislabel(8,'QSupplyVolt'); 
%addaxislabel(6,'QPulseVolt'); 
%addaxislabel(7,'PressureSensorPSI'); 
end 
if (dailyPlot == 1)
figure(1)
hold on
aa_splot(dt,j1(:,2),'black','linewidth',1.5); %heater power
ylim([hp1, hp2])
addaxis(dt,j1(:,3),'linewidth',1.5); %temp
addaxis(dt,j1(:,4),'linewidth',1); %QpulseLeng
addaxis(dt,j1(:,6),[qpow1,qpow2]); %qPow
addaxis(dt,j1(:,10),[coreqpow1,coreqpow2]) ; %coreQPow
title(dataFile,'fontsize',11);
addaxislabel(1,'Heater Power(W)');
addaxislabel(2,'CoreTemp(C)');
addaxislabel(3,'QPulseWid(ns)');
addaxislabel(4,'QPow(W)');
addaxislabel(5,'CoreQPow(W)'); 
end 
if (flowratePlot)
figure
hold on
aa_splot(dt,j1(:,11),'black');
%ylim([0 80])
addaxis(dt,j1(:,12));
addaxis(dt,j1(:,13));
title(dataFile,'fontsize',20)
addaxislabel(1,'Jacket LPM');
addaxislabel(2,'PCB LPM');
addaxislabel(3,'Term LPM');
end
if (tempPlot)
figure(3)
hold on
aa_splot(dt,smooth(j1(:,21),20),'black');
%ylim([0 80])
addaxis(dt,smooth(j1(:,16),30));
addaxis(dt,smooth(j1(:,15),30));
addaxis(dt,smooth(j1(:,18),30));
addaxis(dt,smooth(j1(:,17),30));
addaxis(dt,smooth(j1(:,20),30));
addaxis(dt,smooth(j1(:,19),30));
title(dataFile,'fontsize',20);
addaxislabel(1,'Room Temp');
addaxislabel(2,'JacketOutT');
addaxislabel(3,'JacketInT');
addaxislabel(4,'PCBOutT');
addaxislabel(5,'PCBInT');
addaxislabel(6,'TermOutT');
addaxislabel(7,'TermInT');
end
if (qPowHeaterPowerPlot)
figure(1)
hold on
aa_splot(dt,j1(:,3),'black','linewidth',1.5);
%ylim([25 50])
addaxis(dt,j1(:,24));
%addaxis(dt,j1(:,25));
addaxis(dt,smooth(j1(:,26),30));
addaxis(dt,j1(:,6),[5,55]);
addaxis(dt,j1(:,10),[0,9]) ;
%addaxis(dt,j1(:,2),[hp1,hp2]);
%addaxis(dt,smooth(j1(:,15),30),[25.,25.44]) ;
title(dataFile,'fontsize',20);
addaxislabel(1,'Core Temp(C)');
addaxislabel(2,'InnerTemp1(C)');
addaxislabel(3,'Smoothed OuterTemp1(C)');
addaxislabel(4,'qPow(w)');
addaxislabel(5,'coreQPow(w)');
%addaxislabel(6,'heaterPower(w)');
end 
if (qPowOnlyPlot) 
figure(4)
hold on
aa_splot(dt,j1(:,3),'black','linewidth',1.5);
ylim([25 50])
addaxis(dt,j1(:,24),[25,50]);
%addaxis(dt,j1(:,25));
addaxis(dt,smooth(j1(:,26),30),[25.,25.44]);
addaxis(dt,j1(:,6),[5,55]);
addaxis(dt,j1(:,10),[0,5]) ;
addaxis(dt,smooth(j1(:,15),30),[25.,25.44]) ;
title(dataFile,'fontsize',20);
addaxislabel(1,'Core Temp(C)');
addaxislabel(2,'InnerTemp1(C)');
addaxislabel(3,'Smoothed OuterTemp1(C)');
addaxislabel(4,'qPow(w)');
addaxislabel(5,'coreQPow(w)');
addaxislabel(6,'jacketInT(C)');
end
if (heaterPowerOnlyPlot)
figure(5)
hold on
aa_splot(dt,j1(:,3),'black','linewidth',1.5);
ylim([0 500])
addaxis(dt,j1(:,24),[0,500]);
addaxis(dt,smooth(j1(:,26),30),[25,26]);
addaxis(dt,j1(:,2),[5,55]);
%addaxis(dt,j1(:,10),[0,7]) ;
title(dataFile,'fontsize',20);
addaxislabel(1,'Core Temp(C)');
addaxislabel(2,'InnerTemp1(C)');
addaxislabel(3,'Smoothed OuterTemp1(C)');
addaxislabel(4,'heaterPower(w)');
end
if (processYes == 1) 
hp = []; 
temp = [];
ql = [];
gf = [];
qPow = [];
dt1 = [];
qTerm = [];
qPCB = [];
coreQPow = [];
coreQPowCV = [];
qPCBCV = [];
qTermCV = [];
qPowCV = [];
i=0;
i1 = 1;
ii = 30; %600 seconds before to next seq.
if ii > 5;
  trim = round(200/ii); %k = ii*(trim/100)/2 through away one highset/lowest point trim = 200/ii
else
  trim = 0;
end    
seq2 = 0;
while (i < j1Size-1)  
  i = i+1;
  if abs(j1(i+1,7) - j1(i,7)) >= 1  %sequence changed or at least sequence has run more than an half hour
    i2 = i;
    if i2-i1 > 30 %only pick up the sequence has more then half hours runs
    seq2=seq2+1;
    seq = j1(i2,7);
    seq1(seq2)=seq;
    dt1(seq2) = j1(i2,1); 
    hp(seq2) = trimmean(j1(i2-ii:i2,2),trim);
    hp0(seq2)=hp(seq2);
    hpError(seq2)=std(j1(i2-ii:i2,2));
    temp(seq2)=trimmean(j1(i2-ii:i2,3),trim);
    tempError(seq2)=std(j1(i2-ii:i2,3));
    ql(seq2) = j1(i2,4);
    qf(seq2) = trimmean(j1(i2-ii:i2,5),trim);
    qPow(seq2) = trimmean(j1(i2-ii:i2,6),trim);
    if qPow(seq2) < 2
      hp0(seq2) = hp(seq2);
    end  
    qTerm(seq2) = trimmean(j1(i2-ii:i2,8),trim);
    qPCB(seq2) = trimmean(j1(i2-ii:i2,9),trim);
    coreQPow(seq2)=trimmean(j1(i2-ii:i2,10),trim);
    coreQPowError(seq2)=std(j1(i2-ii:i2,10));
    cjp(seq2) = trimmean(j1(i2-ii:i2,14),trim);
    jlpm(seq2) = trimmean(j1(i2-ii:i2,11),trim);
    PCBlpm(seq2) = trimmean(j1(i2-ii:i2,12),trim);
    termlpm(seq2) = trimmean(j1(i2-ii:i2,13),trim);
    jInT(seq2) = trimmean(j1(i2-ii:i2,15),trim);
    jOutT(seq2) = trimmean(j1(i2-ii:i2,16),trim);
    PCBInT(seq2) = trimmean(j1(i2-ii:i2,17),trim);
    PCBOutT(seq2) = trimmean(j1(i2-ii:i2,18),trim);
    termInT(seq2) = trimmean(j1(i2-ii:i2, 19),trim);
    termOutT(seq2) = trimmean(j1(i2-ii:i2,20),trim);
    roomT(seq2) = trimmean(j1(i2-ii:i2,21),trim); 
    InT1(seq2) = trimmean(j1(i2-ii:i2,24),trim);
    InT1Error(seq2)=std(j1(i2-ii:i2,24));
    InT2(seq2) = trimmean(j1(i2-ii:i2,25),trim);
    OutT1(seq2) = trimmean(j1(i2-ii:i2,26),trim);
    OutT1Error(seq2)=std(j1(i2-ii:i2,26));
    OutT2(seq2) = trimmean(j1(i2-ii:i2,27),trim);
    hpM =  mean(j1(i1:i2,2)); 
    qPowM =mean(j1(i1:i2,6)); 
    qTermM = mean(j1(i1:i2,8));
    qPCBM =mean(j1(i1:i2,9)); 
    coreQPowM = mean(j1(i1:i2,10));
    cjpM = mean(j1(i1:i2,14));
    qPowCV(seq2) = std(j1(i1:i2,6));
    qTermCV(seq2)=std(j1(i1:i2,8));
    qPCBCV(seq2) = std(j1(i1:i2,9));
    coreQPowCV(seq2)=std(j1(i1:i2,10));
    cjpCV(seq2)=std(j1(i1:i2,14));
    if qPowM > 0
      qPowCV(seq2)= qPowCV(seq2)/qPowM;
    end   
    if qTermM > 0
      qTermCV(seq2)=qTermCV(seq2)/qTermM;
    end 
    if qPCBM > 0
      qPCBCV(seq2) = qPCBCV(seq2)/qPCBM;
    end   
    if coreQPowM > 0 
      coreQPowCV(seq2)=coreQPowCV(seq2)/coreQPowM;
    end    
    if cjpM > 0 
      cjpCV(seq2)=cjpCV(seq2)/cjpM;
    end 
    i12(seq2)=i2-i1;
    i1 = i2+1; 
    end
  end
  
end 
s1 = horzcat(ql',hp',temp',qPow',coreQPow');
if (qpulseLen)
  %do plot x axis is pulseLen
  for ti = [150 250 300]
    st = s1((abs(s1(:,3)-ti) < 1),:);
    for qi = [30,35,40,45,50]  
     sq = st((abs(st(:,4)-qi)<1) ,:);
    figure
    hold on
    aa_splot(sq(:,1),sq(:,2),'black','linewidth',1.5);
    %addaxis(st(:,1),st(:,4),'linewidth',1.5);
    addaxis(sq(:,1),sq(:,5),'linewidth',1.5);
    title(ti,'fontsize',20);
    addaxislabel(1,'HP Drop(W)');
    %addaxislabel(2,'QPow(W)');
    addaxislabel(2,'CoreQPow(W)');
    end
  end
end  
dt2 = datetime(dt1, 'ConvertFrom', 'datenum') ;

if errorBarPlot ==1 
fi = 5;

figure(fi)
hold on
aa_splot(dt2,hp,'black','linewidth',1.5);
errorbar(dt1,hp,hpError,'black','linewidth',1.5);
figure(fi+1)
hold on
aa_splot(dt2,temp,'r','linewidth',1.5);
errorbar(dt1,temp,tempError,'r','linewidth',1.5);
figure(fi+2)
hold on
aa_splot(dt2,coreQPow,'blue','linewidth',1.5);
errorbar(dt1,coreQPow,coreQPowError,'blue','linewidth',1.5);
figure(fi+3)
hold on
aa_splot(dt2,InT1,'cyan','linewidth',1.5);
errorbar(dt1,InT1,InT1Error,'cyan','linewidth',1.5);
figure(fi+4)
hold on
aa_splot(dt2,OutT1,'green','linewidth',1.5);
errorbar(dt1,OutT1,OutT1Error,'green','linewidth',1.5);

figure(fi+5)
hold on
aa_splot(dt2,hp,'black','linewidth',1.5);
errorbar(dt1,hp,hpError,'black');
addaxis(dt2,temp,'linewidth',1.5);

addaxis(dt2,coreQPow,[4.5,8],'linewidth',1.5);
addaxis(dt2,InT1,'linewidth',1.5);
addaxis(dt2,OutT1,'linewidth',1.5);
legend('Heater Power(W)','CoreTemp(C)','CoreQPower(W)','InnerBlockTemp(C)','OutBlockTemp(C)');
title(dataFile,'fontsize',20);
addaxislabel(1,'Heater Power(W)');
addaxislabel(2,'CoreTemp');
addaxislabel(3,'CoreQPow(W)');
addaxislabel(4,'InnerBlockTemp');
addaxislabel(5,'OutBlockTemp');
end
fn = ['C:\jinwork\BEC\tmp\' reactor '-' whichDate '.csv'];            
delete(fn);
T=table(temp(:),ql(:),qf(:),hp(:),coreQPow(:),qPow(:),qPCB(:),qTerm(:),cjp(:),...
    roomT(:),jlpm(:),jInT(:),jOutT(:), PCBlpm(:),PCBInT(:),PCBOutT(:),termlpm(:),termInT(:),termOutT(:),...
    InT1(:),InT2(:),OutT1(:),OutT2(:),hpError(:),tempError(:),coreQPowError(:),InT1Error(:),OutT1Error(:),qPowCV(:),qPCBCV(:),qTermCV(:),cjpCV(:),seq1(:),i12(:),dt2(:),...
'VariableName',{'Temp','QL','QF','HP','CoreQPower','qPow','qPCB','qTerm','CJP','roomT','jLPM','jInT','jOutT',...
'PCBLPM','PCBInT','PCBOutT','termLPM','termInT','termOutT','InT1','InT2','OutT1','OutT2','hpError','tempError','coreQPowError',...
'InT1Error','OutT1Error','qPowCV','qPCBCV','qTermCV','cjpCV','seq','steps','date'});
writetable(T,fn);
end
