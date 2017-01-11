function [startOffset,endOffset,hp1,hp2,cqp1,cqp2,Directory,Experiment,dataFile,whichDate] = sri_ipb2_27(startOffset,endOffset,hp1,hp2,cqp1,cqp2)
rtFolder='C:\Users\Owner\Dropbox (BEC)\SRI-IPB2\';    
subFolder = {'2016-09-24_SRI_v170-core27b'...
             '2016-09-30_SRI_v171-core27b',...
             '2016-11-16_SRI_v174-core27b',...
             '2016-12-16_SRI_v181-core27b'};
folder = 4;
switch folder 
case 2    
Directory=char(strcat(rtFolder,subFolder(folder)));
AllFiles = getall(Directory);
whichDate = '01052017';
dataFile =strcat(Directory,whichDate); 
switch (whichDate)
  case '10152016' 
    Experiment = AllFiles(20:22);
end     
case 3    
Directory=char(strcat(rtFolder,subFolder(folder)));
AllFiles = getall(Directory);
whichDate = '12162016';
dataFile =strcat(Directory,whichDate); 
switch (whichDate)
  case '11192016-11212016'  
    Experiment = AllFiles(3:5);
  case '11222016' 
    startOffset =22;
    hp1 =5;
    hp2=10;
    Experiment = AllFiles(6:6);  
  case '11272016' 
    endOffset = 55; 
    hp1 =5;
    hp2=40;
    Experiment = AllFiles(8:8);    
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
whichDate = '01072017';
dataFile =strcat(Directory,whichDate); 
switch (whichDate)
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
end %date
end %folder
end %reactor

