% Initial housekeeping
clear; close all
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
%Control parameters
dailyPlot = 0;
exponentialFit = 0;
debugQPow = 1;
flowratePlot = 0;
tempPlot = 0;
qPowOnlyPlot = 0;
heaterPowerOnlyPlot = 0;
qPowHeaterPowerPlot = 0;
qpulseLen = 0;
processYes = 0;
errorBarPlot = 0;
%plot bounds setting
hp1 = 10;
hp2 = 25; 
qpow1 = 5;
qpow2 = 55;
coreqpow1 = 0;
coreqpow2 = 5;
% list reactors,cores and directories starting from the most recent ones
%reactor='google'; %merge files for google, test before the loading
%reactor='2016-11-01-CRIO-v174_CORE_30b_He';
%reactor='2016-11-01-CRIO-v180_CORE_30b_He'
%reactor='sri-ipb2-27b-1116';
%reactor='ipb3-32b-h2';
%reactor='ipb3-32b-he';
%reactor='ipb3-36b';
switch (reactor)
case 'google' 
%list directories under google 
Directory='C:\Users\Owner\Dropbox (BEC)\BECteam\Jin\google\ipb1_30b\5-heaterpower-only';
if (1==0)
Directory='C:\Users\Owner\Dropbox (BEC)\BECteam\Jin\google\ipb1_30b\6-qpow-only';
Directory='C:\Users\Owner\Dropbox (BEC)\BECteam\Jin\google\sri-ipb2-27b\2-heaterpow-only';
Directory='C:\Users\Owner\Dropbox (BEC)\BECteam\Jin\google\sri-ipb2-27b\3-qpow8hours';
Directory='C:\Users\Owner\Dropbox (BEC)\BECteam\Jin\google\sri-ipb2-27b\4-qpow-heaterpow-83ns';
Directory='C:\Users\Owner\Dropbox (BEC)\BECteam\Jin\google\sri-ipb2-27b\7-qpow-heaterpow-100ns';
Directory='C:\Users\Owner\Dropbox (BEC)\BECteam\Jin\google\sri-ipb2-27b\qpow-heatpower125w';
Directory='C:\Users\Owner\Dropbox (BEC)\BECteam\Jin\google\sri-ipb2-27b\q-calibration';
Directory='C:\Users\Owner\Dropbox (BEC)\BECteam\Jin\google\ipb3-32b';
Directory='C:\Users\Owner\Dropbox (BEC)\BECteam\Jin\google\ipb1_30b\DC-calibration';
Directory='C:\Users\Owner\Dropbox (BEC)\BECteam\Jin\google\ipb1_30b\DC-temp-control';
end
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = 'anydate';
switch (whichDate)
case 'anydate' 
    dataFile =Directory;
    startTime = 0;
    endTime = 0; 
    hp1 = 5;
    hp2= 40;
    Experiment = AllFiles(4:4);            
end  
case 'ipb3-36b' 
Directory='C:\Users\Owner\Dropbox (BEC)\IPB3_DATA\2016-12-09-16-crio-V181-CORE_B36_FOIL_H2'
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '12132016';
switch (whichDate)
case '12062016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='ipb3-h2-36b';
    startTime = 0;
    endTime = 8; 
    hp1 = 30;
    hp2= 110;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(6:7);        
case '12132016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='ipb3-h2-36b';
    startTime = 0;
    endTime = 8; 
    hp1 = 30;
    hp2= 110;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(8:9);          
end 
case 'ipb3-32b-he' 
%Directory='C:\Users\Owner\Dropbox (BEC)\IPB3_DATA\2016-12-05-16-crio-V181-CORE_B31_He';
Directory='C:\Users\Owner\Dropbox (BEC)\IPB3_DATA\2016-12-14-16-crio-V181-CORE_B32_He';
%Directory='C:\Users\Owner\Dropbox (BEC)\IPB3_DATA\2016-12-19-16-crio-V181-CORE_B32_H2';
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '12172016';
switch (whichDate)
case '12172016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='ipb3-he-32b';
    startTime = 0;
    endTime = 0; 
    hp1 = 5; 
    hp2= 40;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(1:3);
end    
case 'ipb3-32b-h2' 
%Directory='C:\Users\Owner\Dropbox (BEC)\IPB3_DATA\2016-12-05-16-crio-V181-CORE_B31_He';
Directory='C:\Users\Owner\Dropbox (BEC)\IPB3_DATA\2016-12-14-16-crio-V181-CORE_B32_He';
Directory='C:\Users\Owner\Dropbox (BEC)\IPB3_DATA\2016-12-19-16-crio-V181-CORE_B32_H2';
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '12282016';
switch (whichDate)
case '12172016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='ipb3-he-32b';
    startTime = 0;
    endTime = 0; 
    hp1 = 5; 
    hp2= 40;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(4:4);         
case '12182016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='ipb3-he-32b';
    startTime = 0.0;
    endTime = 0; 
    hp1 = 5;
    hp2= 40;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(5:5);     
case '12192016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='ipb3-he-32b';
    startTime = 1;
    endTime = 0; 
    hp1 = 5;
    hp2= 40;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(5:6);        
case '12202016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='ipb3-h2-32b';
    startTime = 0;
    endTime = 0; 
    hp1 = 5;
    hp2= 40;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(1:2);        
case '12212016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='ipb3-h2-32b';
    startTime = 0;
    endTime = 0; 
    hp1 = 10;
    hp2= 40;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(7:8);        
case '12242016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='ipb3-h2-32b';
    startTime = 5;
    endTime = 0; 
    hp1 = 10;
    hp2= 60;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(11:12);        
case '12272016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='ipb3-d2-32b';
    startTime = 0;
    endTime = 0; 
    hp1 = 10;
    hp2= 60;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(16:17);        
case '12282016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='ipb3-d2-32b';
    startTime = 0;
    endTime = 0; 
    hp1 = 10;
    hp2= 60;
    coreqpow1=1;
    coreqpow2=6;
    Experiment = AllFiles(18:20);      
end    
case '2016-11-01-CRIO-v180_CORE_30b_He' 
Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\2016-11-01-CRIO-v180_CORE_30b_He';
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '12242016';
switch (whichDate)
case '12092016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='ipb1';
    startTime = 5;
    endTime = 0; 
    hp1 = 0;
    hp2= 15;
    coreqpow1=0;
    coreqpow2=10;
    Experiment = AllFiles(12:13);  
case '12242016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='ipb1';
    startTime = 5;
    endTime = 0; 
    hp1 = 0;
    hp2= 15;
    coreqpow1=0;
    coreqpow2=10;
    Experiment = AllFiles(24:27);     
end    
case '2016-11-01-CRIO-v174_CORE_30b_He' 
Directory='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\2016-11-01-CRIO-v174_CORE_30b_He';
%Directory='C:\Users\Owner\Dropbox (BEC)\BECteam\Jen';
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '11102016';
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
    Experiment = AllFiles(18:21);
case '11162016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='IPB1-Q-Power-only-sequence-HeliumDFR-day-01.csv-02.csv';
    startTime = 0;
    endTime = 0; 
    hp1 = 10;
    hp2 = 20;
    Experiment = AllFiles(23:25);        
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
case '12022016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='IPB1-Qpow-HeaterPower-20w';
    startTime = 0;
    endTime = 0; 
    hp1 = 7.5;
    hp2 = 40;
    qpow1 = 15;
    qpow2 = 55;
    coreqpow1 = 1;
    coreqpow2 = 6;
    Experiment = AllFiles(40:41);       
case '12042016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='IPB1-Qpow-HeaterPower-20w';
    startTime = 0;
    endTime = 0; 
    hp1 = 7.5;
    hp2 = 40;
    qpow1 = 15;
    qpow2 = 55;
    coreqpow1 = 1;
    coreqpow2 = 6;
    Experiment = AllFiles(43:45);       
case '12062016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='IPB1-Qpow-HeaterPower-20w';
    startTime = 0;
    endTime = 0; 
    hp1 = 7.5;
    hp2 = 40;
    qpow1 = 15;
    qpow2 = 55;
    coreqpow1 = 1;
    coreqpow2 = 6;
    Experiment = AllFiles(47:48);    
case '12072016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='IPB1-Qpow-HeaterPower-20w';
    startTime = 0;
    endTime = 0; 
    hp1 = 10;
    hp2 = 21;
    qpow1 = 15;
    qpow2 = 55;
    coreqpow1 = 1;
    coreqpow2 = 6;
    Experiment = AllFiles(50:52);             
case '12092016' 
    %dataFile ='\ISOPERIBOLIC_DATA\2016-10-27-CRIO-v174_CORE_29b_H2\PB1_Core_29b_H2_150C-400C_QP50W_300VDC-day-01.csv';  
    dataFile ='IPB1-Qpow-HeaterPower-20w';
    startTime = 0;
    endTime = 0; 
    hp1 = 10;
    hp2 = 21;
    qpow1 = 15;
    qpow2 = 55;
    coreqpow1 = 1;
    coreqpow2 = 6;
    Experiment = AllFiles(50:52);             
    
end  
case 'sri-ipb2-27b-1116' 
Directory='C:\Users\Owner\Dropbox (BEC)\SRI-IPB2\2016-11-16_SRI_v174-core27b';
%Directory='C:\jinwork\BEC\Data'
AllFiles = getall(Directory);  %SORTED BY DATE....
whichDate = '12162016';
switch (whichDate)
  case '11192016-11212016' 
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
  case '11262016-11292016' %qpowonly 8 hours 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\qpowOnly8hours';   
    startTime =70;
    endTime = 0; 
    hp1 =5;
    hp2=40;
    Experiment = AllFiles(8:8);    
  case '11302016-12012016' %heater power at 20w and qpow form 10-50-10, 100ns
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\heatpowerQpow-100ns';   
    startTime =0;
    endTime = 0; 
    hp1 =15;
    hp2=25;
    Experiment = AllFiles(11:13);   
  case '12032016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\heatpowerQpow-83ns';   
    startTime =0;
    endTime = 0; 
    hp1 =15;
    hp2=25;
    Experiment = AllFiles(14:15);      
  case '12042016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\temp-83ns';   
    startTime =0;
    endTime = 0; 
    coreqpow1 =5;
    coreqpow2=10;
    hp1 =15;
    hp2=40;
    Experiment = AllFiles(17:18);      
  case '12062016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\heaterpower-qpow-9167ns';   
    startTime =0;
    endTime = 0; 
    coreqpow1 =5;
    coreqpow2=10;
    hp1 =15;
    hp2=40;
    Experiment = AllFiles(19:21);      
  case '12072016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\heaterpower-qpow-9167ns';   
    startTime =0;
    endTime = 0; 
    coreqpow1 =0;
    coreqpow2=10;
    hp1 =10;
    hp2=21;
    Experiment = AllFiles(23:25);
  case '12082016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\hp012525-qpow02550';   
    startTime =0;
    endTime = 0; 
    coreqpow1 =0;
    coreqpow2=15;
    hp1 =10;
    hp2=26;
    Experiment = AllFiles(26:29);        
  case '12162016' 
    dataFile ='\SRI-IPB2\2016-09-30_SRI_v171-core27b\hp012525-qpow02550';   
    startTime =0;
    endTime = 0; 
    coreqpow1 =0;
    coreqpow2=10;
    hp1 =0;
    hp2=21;
    Experiment = AllFiles(36:36);      
end
end    
Experiment'
loadHHT 
%change a few messy variable names
QOccurred = QOccurred0x3F; clear QPulseOccurred0x3F
%SeqStepNum = SeqStep0x23; clear SeqStep0x23
QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29
QPulseDelays = QPulseDelay0x28s0x29; clear QPulseDelay0x28s0x29
QkHz = QKHz; clear QKHz;
%change datetime to number
dateN=datenum(DateTime,'mm/dd/yyyy HH:MM:SS');
DateTime(1+int16(startTime*360));
DateTime(end - int16(endTime*360));
j1 = horzcat(dateN,...
     HeaterPower,...
     CoreTemp,...
     InnerBlockTemp1,...
     QPulseLengthns,...
     QkHz,...
     QPow,...
     SeqStepNum,...
     TerminationHeatsinkPower,...
     QPulsePCBHeatsinkPower,...
     CoreQPower,...
     CoreQV1Rms,...
     CoreQV2Rms,...);

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
     OuterBlockTemp1,...
     QCur,...
     QSupplyPower,...
     QSupplyVolt,...
     CoreQV1Rms,...
     CoreQV2Rms);
%   11                           12                      13                             14                  
j1 = j1(1+startTime*360:end-endTime*360,:);
%j1(any(isnan(j1),2),:)=[]; %take out rows with Nan
%j1(isnan(j1)) = -2 ;
%j1 = j1(j1(:,7) > 0,:); %only process data with seq
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
addaxis(dt,smooth(j1(:,22),11)); 
addaxis(dt,smooth(j1(:,23),11));
title(dataFile,'fontsize',11);
addaxislabel(1,'QPulseLen(ns)');
addaxislabel(2,'QkHz)');
addaxislabel(3,'qPow');
addaxislabel(4,'coreqPow');
addaxislabel(5,'Qcur');
addaxislabel(6,'QpulseVolt');
addaxislabel(7,'QSupplyPow');
addaxislabel(8,'QSupplyVolt'); 
addaxislabel(9,'QPulseVolt'); 
addaxislabel(10,'PressureSensorPSI'); 
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
addaxis(dt,j1(:,31),[0,12]); %CoreQV1Rms
addaxis(dt,j1(:,32),[0,12]) ; %CoreQV2Rms
%addaxis(dt,j1(:,5)) ; %qkHz
title(dataFile,'fontsize',11);
addaxislabel(1,'Heater Power(W)');
addaxislabel(2,'CoreTemp(C)');
addaxislabel(3,'QPulseWid(ns)');
addaxislabel(4,'QPow(W)');
addaxislabel(5,'CoreQPow(W)'); 
addaxislabel(6,'CoreQV1Rms(Volt)');
addaxislabel(7,'CoreQV2Rms(Volt)'); 
%addaxislabel(8,'qkHz'); 
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
addaxis(dt,j1(:,2),[hp1,hp2]);
%addaxis(dt,smooth(j1(:,15),30),[25.,25.44]) ;
title(dataFile,'fontsize',20);
addaxislabel(1,'Core Temp(C)');
addaxislabel(2,'InnerTemp1(C)');
addaxislabel(3,'Smoothed OuterTemp1(C)');
addaxislabel(4,'qPow(w)');
addaxislabel(5,'coreQPow(w)');
addaxislabel(6,'heaterPower(w)');
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
ctFit = [];
itFit = [];
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
    coreQPow(seq2)=trimmean(j1(i1:i2,10),trim);
    coreQV1RMS(seq2)=trimmean(j1(i1:i2,31),trim);
    coreQV2RMS(seq2)=trimmean(j1(i1:i2,32),trim);
    qSupplyP(seq2) = trimmean(j1(i2-ii:i2,22),trim); 
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
    OutT1(seq2) = trimmean(j1(i2-ii:i2,26),trim);
    OutT1Error(seq2)=std(j1(i2-ii:i2,26));
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
    if exponentialFit 
      size1 = length(j1(i1:i2,3));
      x=1:size1;
      x1 = reshape(x,[size1,1]);  
      f1 = fit(x1,j1(i1:i2,3),'exp2');
      ctFit(seq2,1:4)= coeffvalues(f1);
      f2 = fit(x1,j1(i1:i2,24),'exp2');
      itFit(seq2,1:4)= coeffvalues(f2);
      %figure
      % plot(f,x1,j1(i1:i2,3));
    end
    i12(seq2)=i2-i1;
    i1 = i2+1; 
    end
  end 
end 
dt2 = datetime(dt1, 'ConvertFrom', 'datenum') ;
fn = ['C:\jinwork\BEC\tmp\' reactor '-' whichDate '.csv'];            
delete(fn);
T=table(temp(:),InT1(:),ql(:),qf(:),hp(:),coreQPow(:),coreQV1RMS(:), coreQV2RMS(:),qPow(:),qPCB(:),qTerm(:),cjp(:),...
    roomT(:),jlpm(:),jInT(:),jOutT(:), PCBlpm(:),PCBInT(:),PCBOutT(:),termlpm(:),termInT(:),termOutT(:),...
    OutT1(:),hpError(:),tempError(:),coreQPowError(:),InT1Error(:),OutT1Error(:),qPowCV(:),qPCBCV(:),qTermCV(:),cjpCV(:),seq1(:),i12(:),dt2(:),...
'VariableName',{'Temp','InT1','QL','QF','HP','CoreQPower','V1Rms','V2Rms','qPow','qPCB','qTerm','CJP','roomT','jLPM','jInT','jOutT',...
'PCBLPM','PCBInT','PCBOutT','termLPM','termInT','termOutT','OutT1','hpError','tempError','coreQPowError',...
'InT1Error','OutT1Error','qPowCV','qPCBCV','qTermCV','cjpCV','seq','steps','date'});
writetable(T,fn);
fileID = fopen(['C:\jinwork\BEC\tmp\' reactor '-expFit' whichDate '.csv'],'w');
%fprintf(fileID,'%4s %12s\n','x','exp(x)');
fprintf(fileID,'%6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f %6.2f\n',ctFit,itFit);
fclose(fileID);
end
