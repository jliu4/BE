clear; close all; clc
addpath('C:\jinwork\BE\matlab\waveform')
addpath('C:\jinwork\BE\matlab\altmany-export_fig-5be2ca4')
outputPath ='C:\jinwork\BEC\tmp\';
home = [getenv('HOMEDRIVE') getenv('HOMEPATH')];
if contains(home,'admin')
  dataPath = 'C:\Users\admin\Dropbox (BEC)\BECteam\Jin\waveform\';
else
  dataPath = 'D:\DropBox\Dropbox (BEC)\BECteam\Jin\waveform\';
end  
%control parameter
plotSummary = true; plotPos = true; plotNeg = true; plotCN = true;
plotErrBar = true;
fn = char(strcat(dataPath,'waveform53.xlsx'));
waveform = readtable(fn);
input = [waveform(34:34,:)];
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
cPos = 0; %propagate speed positive side
riseTimeNeg = 0;
cNeg = 0; %propagate speed negtive side
filen1 = strcat(outputPath,'waveform_0505-3.csv');
filen2 = strcat(outputPath,'waveform_0505-3-cv.csv');
output1 = cell2table(cell(0,22),...
'VariableName',{'folder','date','filename','pulseWidth','frequency','Zterm','v1rms','v2rms','v3rms','CoreQPow',...
'alignPowerPos','cPosM','riseTimePosM','cPosCV','riseTimePosCV',...
'alignPowerNeg','cNegM','riseTimeNegM','cNegCV','riseTimeNegCV','noise','type'});
output2 = cell2table(cell(0,6),...
'VariableName',{'loc','c','riseTime','v1','v2','v3'});
pw = [];
figname = strcat(outputPath,'waveform-0505-3.pdf');
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
   pw(wi) = wi;% pulseWidth;
   panelDivision = input.panelDivision(wi); %vol
   type = input.type(wi);
   tt = char(strcat(folder,'-',dateN,'-',num2str(pulseWidth),'-',type));
   fn = char(strcat(dataPath,folder,'\',filename));
   %read in big file  
   M = csvread(fn,nh,0);
   totalTime = M(end,1) - M(1,1);
   numPoint = size(M,1);
   timeInterval = totalTime/numPoint;%sec
   pulseWidthPoint = pulseWidth/timeInterval/s2ns; 
   %take out 
   M0 = M(isfinite(M(:,2)),2);
   %if there is inf, there is no sense to align them.   
   if size(M0,1) < numPoint
     continue;
   end     
   max2 = max(M(:,2));
   min2 = min(M(:,2));
   [pk1,lc1] = findpeaks(M(delta:end-delta,2),'MinPeakHeight',mFactor*max2,'MinPeakDistance',pulseWidthPoint);
   [pk2,lc2] = findpeaks(-M(delta:end-delta,2),'MinPeakHeight',-mFactor*min2,'MinPeakDistance',pulseWidthPoint);
   numOfPulse = size(pk1,1)+size(pk2,1); %count a positive pulse and a negtive pulse as two pulses
   %calculatePulseWid =abs(lc1(1)-lc2(1))*timeInterval*s2ns 
   frequency = int16(numOfPulse/totalTime/hz2kHz); %kHz as the frequency unit
   T = 1.0/(frequency*hz2kHz*timeInterval);
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
   t0 = 2*pulseWidthPoint;
   first1 = max(1,firstP - t0);
   first2 = min(numPoint,firstP + t0);
   last1 = max(1,lastP - t0);
   last2 = min(numPoint,lastP + t0);
   filterValue = filterCount * 4* panelDivision /128; %TODO JLIU 256?
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
   p1 = char(strcat('RMS Voltage Method: (rms(v1)-rms(v2))*rms(v3)/Z = ',num2str(P0),...
       ' rms(v1) = ',num2str(y1rms), ' rms(v2) = ',num2str(y2rms), ' rms(v3) = ',num2str(y3rms)));
   if plotSummary
      plotWaveFormSummary(M,max2,min2,frequency,filterValue,firstP,lastP,first1,first2,last1,last2,pos,figname,tt,p1)   
   end   
   
   yPos = [0,max2(1)];
   yNeg = [min2(1),0];
   
   if alignP > 0
     for pi = 1:size(lc1,1)
      fstMax = delta + lc1(pi);
      [pPos,cPos,riseTimePos,v1sPos,v2sPos,v3sPos,alignVPos] = calculateAlignedPower(fstMax,M,MM,delta,alignP,zterm,timeInterval,s2ns,coreL,inchNs);
     
      posArray(pi,1:6)=[delta+lc1(pi),cPos,riseTimePos,v1sPos,v2sPos,v3sPos];
      %only plot the first one
      if pi==1 && plotPos
        plotAligned(v1sPos,v2sPos,v3sPos,M,fstMax,delta,pulseWidthPoint,zterm,figname,P0,pPos,cPos,alignVPos,alignP,riseTimePos,pos,tt,p1,yPos(2),yPos)
      end  
     end
     cPosM(wi) = meanabs(posArray(isfinite(posArray(:,2)),2));
     cPosCV(wi) = std(posArray(isfinite(posArray(:,2)),2));
     riseTimePosM(wi) = mean(posArray(isfinite(posArray(:,3)),3));
     riseTimePosCV(wi) = std(posArray(isfinite(posArray(:,3)),3));
     for pi = 1:size(lc2,1)
       fstMin = delta + lc2(pi); 
       [pNeg,cNeg,riseTimeNeg,v1sNeg,v2sNeg,v3sNeg,alignVNeg] = calculateAlignedPower(fstMin,M,MM,delta,alignP,zterm,timeInterval,s2ns,coreL,inchNs);
       negArray(pi,1:6)=[delta+lc2(pi),cNeg,riseTimeNeg,v1sNeg,v2sNeg,v3sNeg];
       if pi == 1 && plotNeg
         plotAligned(v1sNeg,v2sNeg,v3sNeg,M,fstMin,delta,pulseWidthPoint,zterm,figname,P0,pNeg,cNeg,alignVNeg,alignP,riseTimeNeg,pos,tt,p1,yNeg(1),yNeg)
       end  
     end
     cNegM(wi) = meanabs(negArray(isfinite(negArray(:,2)),2));
     cNegCV(wi) = std(negArray(isfinite(negArray(:,2)),2));
     riseTimeNegM(wi) = mean(negArray(isfinite(negArray(:,3)),3));
     riseTimeNegCV(wi) = std(negArray(isfinite(negArray(:,3)),3));

      %take out 
     %size(pnArray); 
     %pn1 = pnArray(isfinite(pnArray));
     
     %size(pn1)
     if plotCN
     plotCNs(posArray,negArray,pos,figname,tt);
     end
   end
   output1 =[output1;table(folder,dateN,filename,pulseWidth,frequency,zterm,y1rms,y2rms,y3rms,P0,...
       pPos,cPosM(wi),riseTimePosM(wi),cPosCV(wi),riseTimePosCV(wi),...
       pNeg,cNegM(wi),riseTimeNegM(wi),cNegCV(wi),riseTimeNegCV(wi),filterValue,type,...
      'VariableName',{'folder','date','filename','pulseWidth','frequency','Zterm','v1rms','v2rms','v3rms','CoreQPow',...
      'alignPowerPos','cPosM','riseTimePosM','cPosCV','riseTimePosCV',...
      'alignPowerNeg','cNegM','riseTimeNegM','cNegCV','riseTimeNegCV','noise','type'})];
   output2 = [output2;table(posArray(:,1),posArray(:,2),posArray(:,3),posArray(:,4),posArray(:,5),posArray(:,6),...
      'VariableName',{'loc','c','riseTime','v1','v2','v3'})];
   output2 = [output2;table(negArray(:,1),negArray(:,2),negArray(:,3),negArray(:,4),negArray(:,5),negArray(:,6),...
      'VariableName',{'loc','c','riseTime','v1','v2','v3'})];
end
writetable(output1,filen1);
writetable(output2,filen2);
if plotErrBar
  f10 = figure('Position',pos);
  subplot(2,1,1);
  %suptitle(tt); 
  grid on;
  grid minor;
  hold on;  
  errorbar(pw,cPosM,cPosCV);
  legend('cPos');
  errorbar(pw,cNegM,cNegCV);
  legend('cNeg');
  set(gca,'XTick',[]);
  hold off;
  
  subplot(2,1,2);
  grid on;
  grid minor;
  hold on;  
  errorbar(pw,riseTimePosM,riseTimePosCV);
  legend('riseTimePos');
  %ylabel('riseTimePos');
  errorbar(pw,riseTimeNegM,riseTimeNegCV);
  legend('riseTimeNeg');
  xlabel('pulseWidth(ns)'); 
  %hold off;
  export_fig(f10,figname,'-append');
end    
