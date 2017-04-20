clear; close all; clc
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\export_fig\altmany-export_fig-2763b78')
dataPath = 'D:\DropBox\Dropbox (BEC)\BECteam\Jin\waveform\';
fn = char(strcat(dataPath,'waveform.xlsx'));
waveform = readtable(fn);
input = waveform(2,:);
input.folder(1);
n = size(input,1);
%waveform = xlsread('waveform.xlsx');
%factor of min or max
vfactor = 0.94;% off 0.6 seconds for q-pulse measurement.
totalTime = 0.002;
nh = 21; %n header
%10% from the peak value
delta = 50;
deltat = 1.00000000012417E-09;
outputPath ='C:\jinwork\BEC\tmp\';
filen1 = strcat(outputPath,'waveform_041217-11.csv');
T1=cell2table(cell(0,11),...
'VariableName',{'folder','date','filename','T','Zterm','v1rms','v2rms','v3rms','CoreQPow','P','noise'});
figname = strcat(outputPath,'waveform_041217-11.pdf');
delete(figname);
pos = [10 10 1000 800];
for wi = 1:n
   folder = char(input.folder(wi));
   dateN = char(input.date(wi));
   filename = char(input.filename(wi));
   zterm = input.zterm(wi);
   filterCount = input.filterCount(wi);
   alignP = input.alignP(wi);
   mFactor = input.mFactor(wi);
   
   tt = char(strcat(folder,'-',dateN,'-',filename));
   fn = char(strcat(dataPath,folder,'\',filename));
   M = csvread(fn,nh,0);

   %Tin = 5000000/20; %knowing how many peaks;
   max2 = max(M(:,2));
   filterValue = filterCount * max2 /256
   min2 = min(M(:,2));
   y1 = [0,max2(1)];
   y = [min2(1),max2(1)];
   maxP = find(M(:,2) > mFactor*max2);
   minP = find(M(:,2) < mFactor*min2);
   fstMax = maxP(1);
   fstMin = minP(1);
   %estimate the period T
   T = abs(fstMax(1)-fstMin(1));
   
   fre = 2*T/totalTime*(4e-9);
   if false && (maxP(1) < 0.5*T || minP(1) < 0.5*T )
       %it might be smaller than a full starting wave
      maxP = find(M(0.5*T:end,2) > mFactor*max2);
      minP = find(M(0.5*T:end,2) < mFactor*min2);
      fstMax = 0.5*T+maxP(1);
      fstMin = 0.5*T+minP(1);
   end    

   %set start point
   firstP = min(fstMax,fstMin);
   lastMax = maxP(end);
   lastMin = minP(end);
   %set end point
   lastP = max(lastMax,lastMin);
   %plot alignment and p
   t1 = fstMax - 2*delta;
   t2 = fstMax + 8*delta;
   %t1 = max(1,fstMax - 0.5*T);
   %t2 = fstMax + T;
   %find a point of percent to align three waves
   %if alignV > 0
   alignV = alignP*M(fstMax,2);
   figure
   hold on;
   plot(M(1:fstMax+T,1),M(1:fstMax+T,2),M(1:fstMax+T,1),M(1:fstMax+T,3),M(1:fstMax+T,1),M(1:fstMax+T,4))
   x=[M(fstMax,1),M(fstMax,1)];
   plot(x,y1,'black','linewidth',1);
   hold off;
   %find the 10% alignment for v2 
   [c1 v1] = min(abs(M(fstMax-delta:fstMax+delta,2)-alignV));
   [c2 v2] = min(abs(M(fstMax-delta:fstMax+delta,3)-alignV));
   [c3 v3] = min(abs(M(fstMax-delta:fstMax+delta,4)-alignV));
   %M(fstMax-delta+v1,2)
   %M(fstMax-delta+v2,3)
   %M(fstMax-delta+v3,4)
   %v1,v2,v3
   v2s = v2-v1;
   v3s = v3-v1;
   if v2s <0 || v3s < 0
       v2s = 0;
       v3s = 0;
   end    
  % end
   %make plot 

   MM =M(firstP:lastP,2:4);
   %filter out noise.
   MM(abs(MM) < filterValue)= 0;
   n = size(MM,1);
   yrms= rms(MM);
   yfft = fft(MM)/n;
   yf=rms(abs(yfft));yrms/sqrt(n);
   P0 = (yrms(1)-yrms(2))*yrms(3)/zterm;
   %clean the noise
   
   %MM(abs(MM) < filterValue)= 0;
   deltaV = (MM(1:end-v2s,1)-MM(1+v2s:end,2));
   P1 = deltaV(1:end-v3s+v2s).*MM(1+v3s:end,3);
   n1 = size(P1);
   %deltaV1 = (M(firstP:end-2*T+lastP-v2s,2)-M(firstP+v2s:end-2*T+lastP,3));
   %size(deltaV)
   %size(MM(1+v3s:end,3))
   %size(deltaV(1:end-v3s+v2s))
   P = mean(abs(deltaV(1:end-v3s+v2s).*MM(1+v3s:end,3)))/zterm*0.94;

%   T1 =[T1;table(folder,dateN,filename,T,zterm,yrms(1),yrms(2),yrms(3),P0,P,filterValue,...
 %   'VariableName',{'folder','date','filename','T','Zterm','v1rms','v2rms','v3rms','CoreQPow','P','noise'})];

   pnote = [char(strcat('RMS Voltage Method: (rms(v1)-rms(v2))*rms(v3)/R = ',num2str(P0))),...
   char(strcat('Pulse Alignment Method: mean(abs(v1-v2)*v3)/R = ',num2str(P), ' with noise reduced by ', filterValue))];  
   p1 = char(strcat('RMS Voltage Method: (rms(v1)-rms(v2))*rms(v3)/R = ',num2str(P0)));
   p2 = char(strcat('Pulse Alignment Method: mean(abs(v1-v2)*v3)/R = ',num2str(P)));
 
   f1 = figure('Position',pos);
   
   subplot(3,1,1);
   grid on;
   grid minor;
   %hold on;
   suptitle(tt); 
   x=[M(fstMax,1),M(fstMax,1)];
   %dim = [0.15 0.25 0.5 0.5];
   %annotation('textbox',dim,'String',p1,'FitBoxToText','on');
   hold on;
   plot(M(t1:t2,1),M(t1:t2,2),M(t1:t2,1),M(t1:t2,3),M(t1:t2,1),M(t1:t2,4))
   %plot(x,y1);
   xlabel(p1);
   hold off;
   legend('v1','v2','v3');
   
   %ylabel('V'); 
   set(gca,'XTick',[]);
   subplot(3,1,2);
   grid on;
   grid minor;
   hold on;
   x=[M(fstMax-delta+v1,1),M(fstMax-delta+v1,1)];
   plot(M(t1:t2,1),M(t1:t2,2),M(t1:t2-v2s,1),M(t1+v2s:t2,3),M(t1:t2-v3s,1),M(t1+v3s:t2,4))
   plot(x,y1,'black','linewidth',1);
   text(x(1),y1(1),'\leftarrow aligned at 10% pulse amplitude');
   xlabel(p2);
   hold off;
   % dim = [0.15 0.25 0.5 0.5];
 
   %annotation('textbox',dim,'String',p2,'FitBoxToText','on');
   
   legend('v1','v2','v3');
   set(gca,'XTick',[]);
   subplot(3,1,3);
   grid on;
   grid minor;
   deltaV = (M(t1:t2-v2s,2)-M(t1+v2s:t2,3));
   P = deltaV(1:end-v3s+v2s).*M(t1+v3s:t2,4)/zterm*deltat;
   yyaxis left
   plot(M(t1:t2-v2s,1),deltaV);
   ylabel('v1-v2');
   yyaxis right
   plot(M(t1:t2-v3s,1),P);
   ylabel('P');
   export_fig(f1,figname,'-append');
   
   %vpexp = expFit1(M(fstMax:fstMax+delta,2:4),figname,pos,2)
   
   f2 = figure('Position',pos);
   subplot(3,1,1);
   suptitle(tt); 
   grid on;
   grid minor;
   plot(M(:,1),M(:,2),M(:,1),M(:,3),M(:,1),M(:,4))
   subplot(3,1,2);
   grid on;
   grid minor;
   hold on;
   
   x=[M(firstP,1),M(firstP,1)];
   plot(M(1:2*T,1),M(1:2*T,2),M(1:2*T,1),M(1:2*T,3),M(1:2*T,1),M(1:2*T,4))
   
   plot(x,y,'black','linewidth',1);
   text(x(1),y(2),'trim first pulse before \leftarrow','HorizontalAlignment','right');
   hold off;
   %set(gca,'XTick',[]);
   subplot(3,1,3);
   grid on;
   grid minor;
   x=[M(lastP,1),M(lastP,1)];
   hold on;
   plot(M(end-2*T:end,1),M(end-2*T:end,2),M(end-2*T:end,1),M(end-2*T:end,3),M(end-2*T:end,1),M(end-2*T:end,4))
   plot(x,y,'black','linewidth',1);
   text(x(1),y(2),'\rightarrow trim last pulse after');
   hold off;
   export_fig(f2,figname,'-append'); 

end
%writetable(T1,filen1);

