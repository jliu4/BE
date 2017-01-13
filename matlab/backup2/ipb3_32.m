function [startOffset,endOffset,hp1,hp2,cqp1,cqp2,Directory,Experiment] = ipb3_32(folder,runDate,startF, endF,startOffset,endOffset,hp1,hp2,cqp1,cqp2)
rtFolder='C:\Users\Owner\Dropbox (BEC)\IPB3_DATA\';    
subFolder = {'2016-11-28-16-crio-V177-CORE_B31_He',...
             '2016-11-28-16-crio-V179-CORE_B31_He',...
             '2016-12-05-16-crio-V179-CORE_B31_He',...
             '2016-12-05-16-crio-V181-CORE_B31_He',...
             '2016-12-14-16-crio-V181-CORE_B32_He',...
             '2016-12-19-16-crio-V181-CORE_B32_H2'};

switch folder 
case 5    
Directory=char(strcat(rtFolder,subFolder(folder)));
AllFiles = getall(Directory);  
switch (runDate)
case '12182016' 
    hp1 = 5; 
    hp2= 40;
    Experiment = AllFiles(4:4); 
end    
case 6
Directory=char(strcat(rtFolder,subFolder(folder)));
AllFiles = getall(Directory); 
switch (runDate)
case '12172016' 
    hp1 = 5; 
    hp2= 40;
    Experiment = AllFiles(4:4);         
case '12182016' 
    hp1 = 5;
    hp2= 40;
    Experiment = AllFiles(5:5);     
case '12192016' 
    startOffset = 1;
    hp1 = 5;
    hp2= 40;
    Experiment = AllFiles(5:6);        
case '12202016' 
    hp1 = 5;
    hp2= 40;
    Experiment = AllFiles(1:2);        
case '12212016' 
    hp1 = 10;
    hp2= 40;
    Experiment = AllFiles(7:8);        
case '12242016' 
    startOffset = 5;
    hp1 = 10;
    hp2= 60;
    Experiment = AllFiles(11:12);        
case '12272016' 
    hp1 = 10;
    hp2= 60;
    Experiment = AllFiles(16:17);        
case '12282016' 
    hp1 = 10;
    hp2= 60;
    Experiment = AllFiles(18:20);    
case '12302016'    
    hp1 = 5; 
    hp2= 40;
    Experiment = AllFiles(21:22);    
case '12312016'    
    endOffset = 20; 
    hp1 = 5; 
    hp2= 60;
    Experiment = AllFiles(23:25);     
case '01022017'    
    hp1 = 5; 
    hp2= 60;
    Experiment = AllFiles(27:28);     
case '01042017'    
    hp1 = 5; 
    hp2= 60;
    Experiment = AllFiles(29:32);     
case '01092017'    
    hp1 = 5; 
    hp2= 60;
    Experiment = AllFiles(34:34);
case '01102017'    
    hp1 = 5; 
    hp2= 60;
    Experiment = AllFiles(35:36);        
case '01112017'    
    hp1 = 5; 
    hp2= 60;
    Experiment = AllFiles(37:38);       
end    
case 4
Directory=char(strcat(rtFolder,subFolder(folder)));
AllFiles = getall(Directory);     

switch (runDate)
case '12092016' 
    hp1 = 5; 
    hp2= 40;
    Experiment = AllFiles(4:5);
case '12172016'    
    hp1 = 5; 
    hp2= 40;
    Experiment = AllFiles(1:3);
end %date
end %folder
end
