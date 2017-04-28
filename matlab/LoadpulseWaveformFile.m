clear; close all; clc
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\export_fig\altmany-export_fig-2763b78')
dataPath = 'D:\DropBox\Dropbox (BEC)\BECteam\Jin\waveform\';
outputPath ='C:\jinwork\BEC\tmp\';
%dataPath = 'C:\Users\admin\Dropbox (BEC)\BECteam\Jin\waveform\';
fn = char(strcat(dataPath,'waveform1.xlsx'));
waveform = readtable(fn);
%input = [waveform(1:10,:);waveform(14:14,:);waveform(16:23,:)];
%input = [waveform(2:9,:);waveform(3,:);waveform(6,:);waveform(8:10,:)];
input = [waveform(1:19,:)];
numWaveform = size(input,1);
vfactor = 0.94;% off 0.6 seconds for each 10 seconds q-pulse measurement.
nh = 21; %waveform file header
Fs = 2.5*1000000000; %sampling frequency 2.5 ghz.
c = 0; %propagate speed
inchNs = 0.0847253; % [inch/ns] speed light
coreL = 16.5; %inch
riseTime = 0;
filen1 = strcat(outputPath,'waveform_042817.csv');
T1=cell2table(cell(0,14),...
'VariableName',{'folder','date','filename','input_frequency','frequency','Zterm','v1rms','v2rms','v3rms','CoreQPow','alignPower','c','riseTime','noise'});
figname = strcat(outputPath,'waveform-042817.pdf');
delete(figname);
pos = [10 10 1000 800];
for wi = 1:numWaveform
   folder = input.folder(wi);
   dateN = input.date(wi);
   filename = input.filename(wi);
   zterm = input.zterm(wi);
   filterCount = input.filterCount(wi);
   alignP = input.alignP(wi);
   mFactor = input.mFactor(wi);
   input_frequency = input.frequency(wi); %kHz-Hz
   delta = input.delta(wi);
   downSample = input.downSample(wi);
   pulseWidth = input.pulseWidth(wi); %ns
   panelDivision = input.panelDivision(wi); %vol
   tt = char(strcat(folder,'-',dateN,'-',filename));
   fn = char(strcat(dataPath,folder,'\',filename));
   %read in big file  
   M = csvread(fn,nh,0);
   if false
   figure
   
   plot(M(:,1),M(:,2),M(:,1),M(:,3),M(:,1),M(:,4))
   figure
   
   plot(M(1:3*T,1),M(1:3*T,2),M(1:3*T,1),M(1:3*T,3),M(1:3*T,1),M(1:3*T,4))
   figure
   plot(M(end-3*T:end,1),M(end-3*T:end,2),M(end-3*T:end,1),M(end-3*T:end,3),M(end-3*T:end,1),M(end-3*T:end,4))
   
   end

   totalTime = M(end,1) - M(1,1);
   numPoint = size(M,1);
   timeInterval = totalTime/numPoint;
   %take out 
   M0 = M(isfinite(M(:,2)),2);
   %if there is inf, there is no sense to align them.   
   if size(M0,1) < numPoint
      continue;
   end     
   max2 = max(M(:,2));
   min2 = min(M(:,2));
   %make sure to catch the complete pulse, so trim some before and after.
   [pk1,lc1] = findpeaks(M(delta:end-delta,2),'MinPeakProminence',0.5*max2,'MinPeakHeight',mFactor*max2,'MinPeakDistance',pulseWidth);
   [pk2,lc2] = findpeaks(-M(delta:end-delta,2),'MinPeakProminence',-0.5*min2,'MinPeakHeight',-mFactor*min2,'MinPeakDistance',pulseWidth);
   numOfPulse = size(pk1,1)+size(pk2,1); %count a positive pulse and a negtive pulse as two pulses
   %frequency = numOfPulse/totalTime/1000; %as per seconds how many pulses
   frequency = numOfPulse; %kHz as the frequency unit
   T = 1.0/(frequency*1000*timeInterval);
   fstMax = delta + lc1(1);
   fstMin = delta + lc2(1);
   lastMax = delta + lc1(end);
   lastMin = delta + lc2(end);
   %trim before firstP; trim after lastP
   %use the same max or min to trim
   firstP = fstMax;
   lastP = lastMax;
   if fstMax < fstMin
      firstP = fstMin;
      lastP = uint32(lastMin);
   end   
   %firstP = min(fstMax,fstMin);
 
   first1 = max(1,firstP - 4*pulseWidth);
   first2 = min(numPoint,firstP + 4*pulseWidth);
   %lastP =  uint32(max(lastMax,lastMin));
   last1 = max(1,lastP - 4*pulseWidth);
   last2 = min(numPoint,lastP + 4*pulseWidth);
   filterValue = filterCount * 4* panelDivision /128; %TODO JLIU 256?
   y1 = [0,max2(1)];
   y = [min2(1),max2(1)];
   
   t1 = max(1,fstMax - 8*pulseWidth);
   t2 = fstMax + 8*pulseWidth;
   v1 = 0;
   v2s = 0;
   v3s = 0;
   if alignP > 0 %do alignment
   alignV = alignP*M(fstMax,2);
   %find the 10% alignment for v2 
   [c1 v1] = min(abs(M(fstMax-delta:fstMax+delta,2)-alignV));
   [c2 v2] = min(abs(M(fstMax-delta:fstMax+delta,3)-alignV));
   [c3 v3] = min(abs(M(fstMax-delta:fstMax+delta,4)-alignV));
   %M(fstMax-delta+v1,2)
   %M(fstMax-delta+v2,3)
   %M(fstMax-delta+v3,4)
   %v1,v2,v3
   riseTime = (delta-v1) * 0.4;
   v2s = v2-v1;
   c = coreL/(v2s*timeInterval)*inchNs/1e9;
   v3s = v3-v1;
   if v2s <0 || v3s < 0
       v2s = 0;
       v3s = 0;
   end    
   end
   %make plot 

   MM =M(firstP:lastP,2:4);
   %filter out noise.
   MM(abs(MM) <= filterValue)= 0;
   n = size(MM,1);
   y1rms = rms(MM(isfinite(MM(:,1)),1));
   y2rms = rms(MM(isfinite(MM(:,2)),2));
   y3rms = rms(MM(isfinite(MM(:,3)),3));
   yrms= rms(MM(:,1:3));
   yfft = fft(MM)/n;
   yf=rms(abs(yfft));yrms/sqrt(n);
   P0 = (y1rms-y2rms)*y3rms/zterm;
   %clean the noise
   
   %MM(abs(MM) < filterValue)= 0;
   deltaV = (MM(1:end-v2s,1)-MM(1+v2s:end,2));
   P1 = deltaV(1:end-v3s+v2s).*MM(1+v3s:end,3);
   n1 = size(P1);
   %deltaV1 = (M(firstP:end-2*T+lastP-v2s,2)-M(firstP+v2s:end-2*T+lastP,3));
   %size(deltaV)
   %size(MM(1+v3s:end,3))
   %size(deltaV(1:end-v3s+v2s))
   %P = mean(abs(deltaV(1:end-v3s+v2s).*MM(1+v3s:end,3)))/zterm;
   P =mean(deltaV(1:end-v3s+v2s).*MM(1+v3s:end,3))/zterm;
   
   T1 =[T1;table(folder,dateN,filename,input_frequency,frequency,zterm,y1rms,y2rms,y3rms,P0,P,c,riseTime,filterValue,...
    'VariableName',{'folder','date','filename','input_frequency','frequency','Zterm','v1rms','v2rms','v3rms','CoreQPow','alignPower','c','riseTime','noise'})];

   p1 = char(strcat('RMS Voltage Method: (rms(v1)-rms(v2))*rms(v3)/Z = ',num2str(P0),...
       ' rms(v1) = ',num2str(y1rms), ' rms(v2) = ',num2str(y2rms), ' rms(v3) = ',num2str(y3rms)));
   
   p2 = char(strcat('Pulse Alignment Method: mean((v1-v2)*v3)/Z = ',num2str(P),' Z=', num2str(zterm), ' propagate speed = ',num2str(c),'c rmsP/alignP = ',num2str(P0/P) ));
   p3 = char(strcat('max(v1) = ', num2str(max2),' min(v1) = ', num2str(min2), ' frequency = ',num2str(frequency),'kHz riseTime = ', num2str(riseTime),'ns filter noise = ', num2str(filterValue)));
   p4 = char(strcat('\leftarrow', 'aligned at ',num2str(alignP*100), '% pulse amplitude'));
  
   p4 = ['\leftarrow aligned at ' num2str(alignP*100)  '% pulse amplitude'];
   p5 = ['riseTime = ' num2str(riseTime) 'ns \rightarrow' ];
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
   annotation('textbox',[0.14,0.78,0.1,0.1],'String',p3,'FitBoxToText','on');
   x=[M(firstP,1),M(firstP,1)];
   plot(M(first1:first2,1),M(first1:first2,2),M(first1:first2,1),M(first1:first2,3),M(first1:first2,1),M(first1:first2,4))
   
   plot(x,y,'black');
   text(x(1),y(2),'trim first pulse before \leftarrow','HorizontalAlignment','right');
   hold off;
   %set(gca,'XTick',[]);
   subplot(3,1,3);
   grid on;
   grid minor;
   x=[M(lastP,1),M(lastP,1)];
   hold on;
   plot(M(last1:last2,1),M(last1:last2,2),M(last1:last2,1),M(last1:last2,3),M(last1:last2,1),M(last1:last2,4))
   plot(x,y,'black');
   text(x(1),y(2),'\rightarrow trim last pulse after');
   hold off;
   export_fig(f2,figname,'-append'); 

   f1 = figure('Position',pos);
   if (v2s > 0 && v3s > 0)
   subplot(3,1,1);
   grid on;
   grid minor;
   %hold on;
   suptitle(tt); 
   x = [M(fstMax,1),M(fstMax,1)];
  
   x1=[M(fstMax-delta+v1,1),M(fstMax-delta+v1,1)];
   dim = [0.14 0.645 0.1 0.1];
   annotation('textbox',dim,'String',p1,'FitBoxToText','on');
   hold on;
   plot(M(t1:t2,1),M(t1:t2,2),M(t1:t2,1),M(t1:t2,3),M(t1:t2,1),M(t1:t2,4))
   plot(x,y1,'black','linewidth',1);
   plot(x1,y1,'black','linewidth',1);
   text(x1(1),y(2), p5,'HorizontalAlignment','right');
   %plot(x,y1);
   %xlabel(p1);
   hold off;
   legend('v1','v2','v3');
   
   %ylabel('V'); 
   set(gca,'XTick',[]);
   subplot(3,1,2);
   grid on;
   grid minor;
   hold on;
   
   plot(M(t1:t2,1),M(t1:t2,2),M(t1:t2-v2s,1),M(t1+v2s:t2,3),M(t1:t2-v3s,1),M(t1+v3s:t2,4))
   plot(x1,y1,'black','linewidth',1);
   %annotation('arrow',x(1),alignV,p4);
   %text(x(1),alignV,'\leftarrow aligned at 5% pulse amplitude');
   text(x1(1),alignV,p4);
   %xlabel(p2);
   hold off;
   dim = [0.14 0.35 0.1 0.1];
   annotation('textbox',dim,'String',p2,'FitBoxToText','on');
   legend('v1','v2','v3');
   set(gca,'XTick',[]);
   subplot(3,1,3);
   grid on;
   grid minor;
   deltaV = (M(t1:t2-v2s,2)-M(t1+v2s:t2,3));
   P = deltaV(1:end-v3s+v2s).*M(t1+v3s:t2,4)/zterm;
   yyaxis left
   plot(M(t1:t2-v2s,1),deltaV);
   ylabel('v1-v2');
   yyaxis right
   plot(M(t1:t2-v3s,1),P);
   ylabel('Instantaneous Pulse Power');
   
   else
   Ms = M(1 : downSample : end,:);
   t1s = max(1,fix(t1/downSample));
   t2s = fix(t2/downSample);
   subplot(2,1,1);
   grid on;
   grid minor;
   %hold on;
   suptitle(tt); 
   
   dim = [0.14 0.52 0.1 0.1];
   annotation('textbox',dim,'String',p1,'FitBoxToText','on');
   hold on;
   plot(Ms(t1s:t2s,1),Ms(t1s:t2s,2),Ms(t1s:t2s,1),Ms(t1s:t2s,3),Ms(t1s:t2s,1),Ms(t1s:t2s,4))
   %plot(x,y1);
   %xlabel(p1);
   hold off;
   legend('v1','v2','v3');
    
   %ylabel('V'); 
   set(gca,'XTick',[]);

   dim = [0.14 0.05 0.1 0.1];
   % dim = [0.15 0.25 0.5 0.5];
 
   annotation('textbox',dim,'String',p2,'FitBoxToText','on');
   
   legend('v1','v2','v3');
   set(gca,'XTick',[]);
   subplot(2,1,2);
   grid on;
   grid minor;
   deltaV = (Ms(t1s:t2s,2)-Ms(t1s:t2s,3));
   P = deltaV(1:end).*Ms(t1s:t2s,4)/zterm;
   yyaxis left
   plot(Ms(t1s:t2s,1),deltaV);
   ylabel('v1-v2');
   yyaxis right
   plot(Ms(t1s:t2s,1),P);
   ylabel('Instantaneous Pulse Power');
   %vpexp = expFit1(M(fstMax:fstMax+delta,2:4),figname,pos,2)
   end
export_fig(f1,figname,'-append');
end
writetable(T1,filen1);

