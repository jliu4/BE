function [startOffset,endOffset,hp1,hp2,cqp1,cqp2,Directory,Experiment] = ipb1_29(folder,runDate,startOffset,endOffset,hp1,hp2,cqp1,cqp2)
rtFolder='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\';    
subFolder = {'2016-09-29-CRIO-v170_CORE_29b'...
             '2016-09-30-CRIO-v171_CORE_29b',...
             '2016-10-24-CRIO-v173_CORE_29b_H2',...
             '2016-10-27-CRIO-v174_CORE_29b_H2'};
switch folder 
case 1    
Directory=char(strcat(rtFolder,subFolder(folder)));
AllFiles = getall(Directory);
switch (runDate)
  case '09302016' %he dc run1
    Experiment = AllFiles(1:2);
end     
case 2    
Directory=char(strcat(rtFolder,subFolder(folder)));
AllFiles = getall(Directory);
runDate = '10012016';
switch (runDate)
  case '10012016'  %he dc run2
    Experiment = AllFiles(1:4);
  case '10042016' 
    Experiment = AllFiles(6:7);  %he dc run3
  case '11272016' 
    Experiment = AllFiles(9:10);  % 
  case '11262016-11292016' %qpowonly 8 hours 
    startOffset =70;
    hp1 =5;
    hp2=40;
    Experiment = AllFiles(8:8);    
  case '11302016-12012016' %heater power at 20w and qpow form 10-50-10, 100ns  
    hp1 =15;
    hp2=25;
    Experiment = AllFiles(11:13);   
  case '12032016' 
    hp1 =15;
    hp2=25;
    Experiment = AllFiles(14:15);      
  case '12042016' 
    cqp1 =5;
    cqp2=10;
    hp1 =15;
    hp2=40;
    Experiment = AllFiles(17:18);      
  case '12062016' 
    cqp1 =5;
    cqp2=10;
    hp1 =15;
    hp2=40;
    Experiment = AllFiles(19:21);      
  case '12072016' 
    cqp1 =0;
    cqp2=10;
    hp1 =10;
    hp2=21;
    Experiment = AllFiles(23:25);
  case '12082016' 
    cqp1 =0;
    cqp2=15;
    hp1 =10;
    hp2=26;
    Experiment = AllFiles(26:29);        
  case '12162016' 
    cqp1 =0;
    cqp2=10;
    hp1 =0;
    hp2=21;
    Experiment = AllFiles(36:36);      
end
case 4
Directory=char(strcat(rtFolder,subFolder(folder)));
AllFiles = getall(Directory);

switch (runDate)
  case '12222016' 
    startOffset = 4;
    Experiment = AllFiles(9:11);
  case '12292016' 
    startOffset = 5;
    Experiment = AllFiles(17:18);  
  case '12312016' 
    Experiment = AllFiles(20:21);
  case '01032017' 
    Experiment = AllFiles(24:25);
  case '01052017' 
    Experiment = AllFiles(27:29);   
 case '01072017' 
    Experiment = AllFiles(30:32);
 case '01092017' 
    Experiment = AllFiles(33:35);   
end %date
end %folder
end %reactor

