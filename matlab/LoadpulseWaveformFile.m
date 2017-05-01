clear; close all; clc
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\export_fig\altmany-export_fig-5be2ca4')
dataPath = 'D:\DropBox\Dropbox (BEC)\BECteam\Jin\waveform\';
outputPath ='C:\jinwork\BEC\tmp\';
%dataPath = 'C:\Users\admin\Dropbox (BEC)\BECteam\Jin\waveform\';
fn = char(strcat(dataPath,'waveform.xlsx'));
waveform = readtable(fn);
input = [waveform(21:28,:)];
%input = [waveform(2:9,:);waveform(3,:);waveform(6,:);waveform(8:10,:)];
%input = [waveform(20:27,:)];
numWaveform = size(input,1);
vfactor = 0.94;% off 0.6 seconds for each 10 seconds q-pulse measurement.
nh = 21; %waveform file header
s2ns = 1e9;
hz2kHz = 1e3;
Fs = 2.5*1e9; %sampling frequency 2.5 ghz.

inchNs = 0.0847253; % [inch/ns] speed light
coreL = 16.5; %inch
riseTimePos = 0;
cPos = 0; %propagate speed up
riseTimeNeg = 0;
cNeg = 0; %propagate speed

filen1 = strcat(outputPath,'waveform_0501-2.csv');
T1=cell2table(cell(0,17),...
'VariableName',{'folder','date','filename','input_frequency','frequency','Zterm','v1rms','v2rms','v3rms','CoreQPow',...
'alignPowerPos','cPos','riseTimePos','alignPowerNeg','cNeg','riseTimeNeg','noise'});
figname = strcat(outputPath,'waveform-0501-2.pdf');
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
   timeInterval = totalTime/numPoint;%sec
   pulseWidthPoint = pulseWidth/timeInterval/s2ns; 
   %pulseWidthPoint = pulseWidth/0.4;
   %take out 
   %M0 = M(isfinite(M(:,2)),2);
   %if there is inf, there is no sense to align them.   
   %if size(M0,1) < numPoint
   %   continue;
  % end     
   max2 = max(M(:,2));
   min2 = min(M(:,2));
   
   %make sure to catch the complete pulse, so trim some before and after.
   %[pk1,lc1] = findpeaks(M(delta:end-delta,2),'MinPeakProminence',0.5*max2,'MinPeakHeight',mFactor*max2,'MinPeakDistance',pulseWidth);
   %[pk2,lc2] = findpeaks(-M(delta:end-delta,2),'MinPeakProminence',-0.5*min2,'MinPeakHeight',-mFactor*min2,'MinPeakDistance',pulseWidth);
   [pk1,lc1] = findpeaks(M(delta:end-delta,2),'MinPeakHeight',mFactor*max2,'MinPeakDistance',pulseWidthPoint);
   [pk2,lc2] = findpeaks(-M(delta:end-delta,2),'MinPeakHeight',-mFactor*min2,'MinPeakDistance',pulseWidthPoint);
   %[pk1,lc1] = findpeaks(M(:,2),'MinPeakHeight',mFactor*max2,'MinPeakDistance',pulseWidthPoint);
   %[pk2,lc2] = findpeaks(-M(:,2),'MinPeakHeight',-mFactor*min2,'MinPeakDistance',pulseWidthPoint);
   numOfPulse = size(pk1,1)+size(pk2,1); %count a positive pulse and a negtive pulse as two pulses
   calculatePulseWid =abs(lc1(1)-lc2(1))*timeInterval*s2ns
   
   frequency = int16(numOfPulse/totalTime/hz2kHz); %kHz as the frequency unit
   T = 1.0/(frequency*hz2kHz*timeInterval)
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
   t0 = int16(0.8*pulseWidthPoint);
   first1 = max(1,firstP - t0);
   first2 = min(numPoint,firstP + t0);
   %lastP =  uint32(max(lastMax,lastMin));
   last1 = max(1,lastP - t0);
   last2 = min(numPoint,lastP + t0);
   %first1 = max(1,firstP - 4*delta);
   %first2 = min(numPoint,firstP + 4*delta);
   %lastP =  uint32(max(lastMax,lastMin));
   %last1 = max(1,lastP - 4*delta);
   %last2 = min(numPoint,lastP + 4*delta);
   filterValue = filterCount * 4* panelDivision /128; %TODO JLIU 256?
   yPos = [0,max2(1)];
   yNeg = [min2(1),0];
   y = [min2(1),max2(1)];
   
   v1sPos = 0;
   v2sPos = 0;
   v3sPos = 0;
   if alignP > 0 %do alignment
   %align up   
   alignVPos = alignP*M(fstMax,2);
   %find the alignP% alignment for v2 
   [c1 v1sPos] = min(abs(M(fstMax-delta:fstMax+delta,2)-alignVPos));
   [c2 v2] = min(abs(M(fstMax-delta:fstMax+delta,3)-alignVPos));
   [c3 v3] = min(abs(M(fstMax-delta:fstMax+delta,4)-alignVPos));
 
   %v1,v2,v3
   riseTimePos = (delta-v1sPos) * timeInterval*s2ns;
   v2sPos = v2-v1sPos;
   cPos = coreL/(v2sPos*timeInterval)*inchNs/s2ns;
   
   v3sPos = v3-v1sPos;
   if v2sPos <0 || v3sPos < 0
       v2sPos = 0;
       v3sPos = 0;
   end 
   alignVNeg = alignP*M(fstMin,2);
   %find the alignP% alignment for v2 
   [c1 v1sNeg] = min(abs(M(fstMin-delta:fstMin+delta,2)-alignVNeg));
   [c2 v2] = min(abs(M(fstMin-delta:fstMin+delta,3)-alignVNeg));
   [c3 v3] = min(abs(M(fstMin-delta:fstMin+delta,4)-alignVNeg));
 
   %v1,v2,v3
   riseTimeNeg = (delta-v1sNeg) * timeInterval*s2ns;
   v2sNeg = v2-v1sNeg;
   cNeg = coreL/(v2sNeg*timeInterval)*inchNs/s2ns;
   
   v3sNeg = v3-v1sNeg;
   if v2sNeg <0 || v3sNeg < 0
       v2sNeg = 0;
       v3sNeg = 0;
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
   
   pPos = calculateAlignedPower(v2sPos, v3sPos, MM,zterm);
   pNeg = calculateAlignedPower(v2sNeg, v3sNeg, MM,zterm);

   
   T1 =[T1;table(folder,dateN,filename,input_frequency,frequency,zterm,y1rms,y2rms,y3rms,P0,pPos,cPos,riseTimePos,pNeg,cNeg,riseTimeNeg,filterValue,...
    'VariableName',{'folder','date','filename','input_frequency','frequency','Zterm','v1rms','v2rms','v3rms','CoreQPow',...
    'alignPowerPos','cPos','riseTimePos','alignPowerNeg','cNeg','riseTimeNeg','noise'})];

   p1 = char(strcat('RMS Voltage Method: (rms(v1)-rms(v2))*rms(v3)/Z = ',num2str(P0),...
       ' rms(v1) = ',num2str(y1rms), ' rms(v2) = ',num2str(y2rms), ' rms(v3) = ',num2str(y3rms)));
   
  p3 = char(strcat('max(v1) = ', num2str(max2),' min(v1) = ', num2str(min2), ' frequency = ',num2str(frequency),'kHz filter noise = ', num2str(filterValue)));
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
   %export_fig(f2,figname,'-append'); 
   plotAligned(v1sPos,v2sPos,v3sPos,M,fstMax,delta,pulseWidthPoint,zterm,figname,P0,pPos,cPos,alignVPos,alignP,riseTimePos,pos,tt,p1,yPos(2),yPos)
   plotAligned(v1sNeg,v2sNeg,v3sNeg,M,fstMin,delta,pulseWidthPoint,zterm,figname,P0,pNeg,cNeg,alignVNeg,alignP,riseTimeNeg,pos,tt,p1,yNeg(1),yNeg)
end
writetable(T1,filen1);

