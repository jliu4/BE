function [startOffset,endOffset,hp1,hp2,cqp1,cqp2,Directory,Experiment] = ipb1_30(folder,runDate,startF, endF, startOffset,endOffset,hp1,hp2,cqp1,cqp2)
rtFolder='C:\Users\Owner\Dropbox (BEC)\ISOPERIBOLIC_DATA\';    
subFolder = {'2016-11-01-CRIO-v174_CORE_30b_He'...
             '2016-11-01-CRIO-v180_CORE_30b_He'};

switch folder 
case 2    
Directory=char(strcat(rtFolder,subFolder(folder)));
AllFiles = getall(Directory);
switch (runDate)
case '12092016' 
    startOffset = 5;
    hp1 = 0;
    hp2= 15;
    Experiment = AllFiles(12:13);  
case '12182016' %DC temperature control
    startOffset = 5;
    hp1 = 0;
    hp2= 50;
    Experiment = AllFiles(21:23);     
case '12242016' %not useful, something went to wrong with excitation, 
    startOffset = 5;
    hp1 = 0;
    hp2= 15;
    Experiment = AllFiles(24:27); 
case '12262016' %40 hours excitation
    startOffset = 5;
    hp1 = 0;
    hp2= 45;
    Experiment = AllFiles(28:30);         
case '12302016' %100 hours calibration
    startOffset = 5;
    hp1 = 0;
    hp2= 45;
    Experiment = AllFiles(31:35);     
case '01012017' 
    hp1 = 0;
    hp2= 45;
    Experiment = AllFiles(36:38); 
case '01052017' 
    hp1 = 0;
    hp2= 45;
    Experiment = AllFiles(48:51);       
case '01072017' 
    hp1 = 0;
    hp2= 45;
    Experiment = AllFiles(52:53); 
case '01112017' 
    hp1 = 0;
    hp2= 45;
    Experiment = AllFiles(58:58);     
end    
case 1
Directory=char(strcat(rtFolder,subFolder(folder)));
AllFiles = getall(Directory);

switch (runDate)
case '11012016' 
    hp1 = 5;
    hp2= 40;
    Experiment = AllFiles(1:2);        
case '11102016' 
    hp1 = 5;
    hp2=10;
    Experiment = AllFiles(1:15);
case '11082016' 
    hp1 = 0;
    hp2=20;
    Experiment = AllFiles(11:17);      
case '11112016' 
    hp1 = 0;
    hp2=20;
    Experiment = AllFiles(14:17);    
 case '11122016' %250c
    startOffset = 17;
    hp1 = 16;
    hp2 = 20;
    Experiment = AllFiles(15:16);    
case '11152016' 
    hp1 = 10;
    hp2 = 20;
    Experiment = AllFiles(18:21);
case '11162016' 
    hp1 = 10;
    hp2 = 20;
    Experiment = AllFiles(23:25);        
case '11172016' 
    startOffset = 10.4;
    hp1 = 10;
    hp2 = 20;
    Experiment = AllFiles(23:25);   
case '11192016' %250c
    startOffset = 9;
    hp1 = 16;
    hp2 = 30;
    Experiment = AllFiles(28:28);    
case '11212016' %300c
    startOffset = 16;
    hp1 = 19;
    hp2 = 26;
    Experiment = AllFiles(28:29);     
case '11272016' %250-300-400c
    hp1 = 19;
    hp2 = 40;
    Experiment = AllFiles(30:33);    
case '11282016' 
    startOffset = 17;
    hp1 = 5;
    hp2 = 10;
    Experiment = AllFiles(35:35);          
case '11292016' 
    startOffset = 18;
    hp1 = 7.5;
    hp2 = 40;
    cqp1 = 1;
    cqp2 = 6;
    Experiment = AllFiles(36:39);   
case '12022016' 
    hp1 = 7.5;
    hp2 = 40;
    cqp1 = 1;
    cqp2 = 6;
    Experiment = AllFiles(40:41);       
case '12042016' 
    hp1 = 7.5;
    hp2 = 40;
    cqp1 = 1;
    cq2 = 6;
    Experiment = AllFiles(43:45);       
case '12062016' 
    hp1 = 7.5;
    hp2 = 40;
    cqp1 = 1;
    cqp2 = 6;
    Experiment = AllFiles(47:48);    
case '12072016' 
    hp1 = 10;
    hp2 = 21;
    cqp1 = 1;
    cqp2 = 6;
    Experiment = AllFiles(50:52);             
case '12092016' 
    hp1 = 10;
    hp2 = 21;
    cqp1 = 1;
    cqp2 = 6;
    Experiment = AllFiles(50:52);             
end %date
end %folder
end

