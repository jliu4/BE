 clear; close all; clc
addpath('C:\jinwork\BE\matlab\waveform')
addpath('C:\jinwork\BE\matlab\altmany-export_fig-5be2ca4')
addpath('C:\jinwork\BE\matlab\FrequencyAnalysisExample');
outputPath ='C:\jinwork\BEC\tmp\';
home = [getenv('HOMEDRIVE') getenv('HOMEPATH')];
if contains(home,'admin')
  dataPath = 'C:\Users\admin\Dropbox (BEC)\Jin\waveform\';
else
  dataPath = 'D:\DropBox\Dropbox (BEC)\Jin\waveform\';
end  
debug = true;

visible = 'on';
%control parameters
plotSummary = true; plotPos = true; plotNeg = true; plotCN = true; plotErrBar = true;
fftAnalysis = false;

fn = char(strcat(dataPath,'waveform.xlsx'));
waveform = readtable(fn);
input = [waveform(71:71,:)];
%input = [waveform(2:9,:);waveform(3,:);waveform(6,:);waveform(8:10,:)];
numWaveform = size(input,1);
vfactor = 0.94;% off 0.6 seconds for each 10 seconds q-pulse measurement.
nh = 21; %waveform file header lines
s2ns = 1e9;
hz2kHz = 1e3;
Fs = 2.5*1e9; %sampling frequency 2.5 ghz.
inchNs = 0.0847253; %  speed light in unit [inch/ns]
filen1 = strcat(outputPath,'sri-ipb1-41-052517.csv');
output1 = cell2table(cell(0,22),...
'VariableName',{'folder','date','filename','pulseWidth','frequency','Zterm','CoreQPow','v1rms','v2rms','v3rms',...
'alignPowerPos','cPosM','riseTimePosM','cPosCV','riseTimePosCV',...
'alignPowerNeg','cNegM','riseTimeNegM','cNegCV','riseTimeNegCV','noise','type'});
figname = strcat(outputPath,'sri-ipb1-41-052517.pdf');
delete(figname);
pos = [10 10 1000 800];
for wi = 1:numWaveform
   folder = input.folder(wi);
   dateN = input.date(wi);
   filename = input.filename(wi)
   voltage = input.voltage(wi);
   
   zterm = input.zterm(wi);
   filterCount = input.filterCount(wi);
   alignP = input.alignP(wi);
   mFactor = input.mFactor(wi);
   input_frequency = input.frequency(wi); %kHz-Hz
   delta = input.delta(wi);
   coreL = input.coreL(wi);  %core length in inch
   pulseWidth = input.pulseWidth(wi); %ns
   panelDivision = input.panelDivision(wi); %vol
   type = input.type(wi);
   tt = char(strcat(folder,'-',dateN,'-',filename,'-',type,'-',num2str(filterCount)));
   fn = char(strcat(dataPath,folder,'\',filename));
   %read in big file  
   M = csvread(fn,nh,0);
   totalTime = M(end,1) - M(1,1);
   numPoint = size(M,1);
   timeInterval = totalTime/numPoint; %sec
   pulseWidthPoint = pulseWidth/timeInterval/s2ns; 
   %take out 
   M0 = M(isfinite(M(:,2)),2);
   filterValue = filterCount *4* panelDivision /128; %TODO JLIU 256?
   %if there is inf, there is no sense to align them.   
   if size(M0,1) < numPoint
     msg = strcat('file:',filename,'has inf');  
     disp(msg);  
     continue;
   end   
  
   max2 = max(M(:,2));
   min2 = min(M(:,2));
   switch char(type)
       case {'square';'square-cal';'Trapezoid'}
        %mVolt = min(max2,-min2); %
        mVolt = 0.5*voltage;
        it1 = delta;
        it2 = 3*delta; %max(1000,pulseWidthPoint+0.5*delta);
       case {'singleNarrow'}
        mVolt = min(max2,-min2);
        it1 = delta;
        it2 = 3*delta;
       case {'dualNarrow'}
        mVolt = min(max2,-min2);
        it1 = 10*delta; %min(1000,pulseWidthPoint+0.5*delta);
        it2 = 3*delta;  
   end   
       
   %[pk10,lc10] = findpeaks(M(delta:end-delta,2),'MinPeakProminence',100,'MinPeakHeight',mFactor*max2,'MinPeakDistance',pulseWidthPoint);
   %[pk20,lc20] = findpeaks(-M(delta:end-delta,2),'MinPeakProminence',100,'MinPeakHeight',-mFactor*min2,'MinPeakDistance',pulseWidthPoint);
   lc10 = []; lc20 = []; lc1 = []; lc2 = [];
   [pk10,lc10] = findpeaks(M(:,2),'MinPeakHeight',mFactor*max2,'MinPeakDistance',pulseWidthPoint);
   [pk20,lc20] = findpeaks(-M(:,2),'MinPeakHeight',-mFactor*min2,'MinPeakDistance',pulseWidthPoint);
   if lc10(1) < delta
     lc10(1) = [];
   end
   if lc10(end) > numPoint - delta
     lc10(end) = [];
   end  
   if lc20(1) < delta
     lc20(1) = [];
   end
   if lc20(end) > numPoint - delta
     lc20(end) = [];
   end  
   numOfPulse = size(lc10,1)+size(lc20,1); %count a positive pulse and a negtive pulse as two pulses
   %calculatePulseWid =abs(lc1(1)-lc2(1))*timeInterval*s2ns 
   frequency = int32(numOfPulse/totalTime/hz2kHz) %kHz as the frequency unit
   if fftAnalysis  
     xrange = 4;
      %filter out noise.
      M0 = M(:,2:4);
      
      M0(abs(M0) <= filterValue*0)= 0;
      M1 = horzcat(M(:,1),M0(:,1:3));
   
     t1 = int32(lc20(1)-2*delta);
     t2 = int32(lc20(2)-2*delta);
     plotFFT(M1,t1,t2,pos,figname,tt,Fs,xrange,visible);
  end
  %continue;
   
 %find the peak at the edge
   if alignP > 0 
   j1 = size(lc10,1);
   ii = 0;
   for i = 1:j1
     i2 = int32(lc10(i));  
     i1 = int32(max(i2-pulseWidthPoint,1));
     %ji2 = find(M(i1:i2,2) > mFactor*max2,1,'first'); %TODO  should use the same max
     ji2 = find(M(i1:i2,2) > mFactor*mVolt,1,'first'); %TODO  should use the same max
     ji3 = max(lc10(i)-pulseWidthPoint,1)+ji2;
     if  ji3 > delta
       ii = ii + 1;  
       lc1(ii) = ji3;
     end  
   end  
   j1 = size(lc20,1);
   ii = 0;
   for i = 1:j1
     i2 = int32(lc20(i));
     i1 = int32(max(lc20(i)-pulseWidthPoint,1));
     jm = min(M(i1:i2,2));
     %ji2 = find(-M(i1:i2,2) > -mFactor*min2,1,'first');
     ji2 = find(-M(i1:i2,2) > mFactor*mVolt,1,'first');
     ji3 = max(lc20(i)-pulseWidthPoint,1)+ji2;
     if  ji3 > delta
       ii = ii + 1;  
       lc2(ii) = ji3;
     end  
   end  
   else
     lc1 = lc10;
     lc2 = lc20;
   end 
   if debug
   figure;
   hold on
   plot(M(:,1), M(:,2)/max2);
   plot(M(int32(lc1),1), M(int32(lc1),2)/max2, '^g', 'MarkerFaceColor','g')
   plot(M(int32(lc2),1), M(int32(lc2),2)/-min2, '^c', 'MarkerFaceColor','r')
   hold off
   grid
   end
   fstMax = lc1(1);
   fstMin = lc2(1);
   lastMax = lc1(end);
   lastMin = lc2(end);
   %trim before firstP; trim after lastP
   %use the same max or min to trim
   firstP = int32(fstMax);
   lastP = int32(lastMax);
   if fstMax > fstMin
      firstP = int32(fstMin);
      lastP = int32(lastMin);
   end   

   first1 = max(1,firstP - it1);
   first2 = min(numPoint,firstP + it2);
   last1 = max(1,lastP - it1);
   last2 = min(numPoint,lastP + it2);
   filterValue = filterCount *4* panelDivision /128; %TODO JLIU 256?
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
      plotWaveFormSummary(M,max2,min2,frequency,filterValue,firstP,lastP,first1,first2,last1,last2,pos,figname,tt,p1,visible)   
   end   
   if alignP == 0
     msg = strcat('file:',filename,'has zero align value');  
     disp(msg);    
     continue;
   end     
   yPos = [0,max2(1)];
   yNeg = [min2(1),0];
   posArray = [];
   negArray = [];
   if alignP > 0
     j1 = size(lc1,2); 
     for pi = 1:j1   
      fstMax =lc1(pi);   
      [pPos,cPos,riseTimePos,v1sPos,v2sPos,v3sPos,alignVPos] = calculateAlignedPower(fstMax,M,MM,delta,alignP,zterm,timeInterval,s2ns,coreL,inchNs,debug,tt,pi);  
      posArray(pi,1:6)=[lc1(pi),cPos,riseTimePos,v1sPos,v2sPos,v3sPos];
      %only plot the first one
      if pi==1 && plotPos %let's plot two
        plotAligned(v1sPos,v2sPos,v3sPos,M,fstMax,delta,zterm,figname,P0,pPos,cPos,alignVPos,alignP,riseTimePos,pos,tt,yPos(2),yPos,visible,it1,it2)
      end  
     end
     cPosM(wi) = meanabs(posArray(isfinite(posArray(:,2)),2));
     cPosCV(wi) = std(posArray(isfinite(posArray(:,2)),2));
     riseTimePosM(wi) = mean(posArray(isfinite(posArray(:,3)),3));
     riseTimePosCV(wi) = std(posArray(isfinite(posArray(:,3)),3));
     j1 = size(lc2,2); 
     for pi = 1:j1
       fstMin = lc2(pi);
       [pNeg,cNeg,riseTimeNeg,v1sNeg,v2sNeg,v3sNeg,alignVNeg] = calculateAlignedPower(fstMin,M,MM,delta,alignP,zterm,timeInterval,s2ns,coreL,inchNs,debug,tt,pi);
       negArray(pi,1:6)=[lc2(pi),cNeg,riseTimeNeg,v1sNeg,v2sNeg,v3sNeg];
       if pi == 1 && plotNeg
         plotAligned(v1sNeg,v2sNeg,v3sNeg,M,fstMin,delta,zterm,figname,P0,pNeg,cNeg,alignVNeg,alignP,riseTimeNeg,pos,tt,yNeg(1),yNeg,visible,it1,it2)
       end  
     end
     cNegM(wi) = meanabs(negArray(isfinite(negArray(:,2)),2));
     cNegCV(wi) = std(negArray(isfinite(negArray(:,2)),2));
     riseTimeNegM(wi) = mean(negArray(isfinite(negArray(:,3)),3));
     riseTimeNegCV(wi) = std(negArray(isfinite(negArray(:,3)),3));
     if plotCN
        plotCNs(posArray,negArray,pos,figname,tt,visible);

     end
   end
   output1 =[output1;table(folder,dateN,filename,pulseWidth,frequency,zterm,P0*0.94*0.94,y1rms,y2rms,y3rms,...
       pPos,cPosM(wi),riseTimePosM(wi),cPosCV(wi),riseTimePosCV(wi),...
       pNeg,cNegM(wi),riseTimeNegM(wi),cNegCV(wi),riseTimeNegCV(wi),filterValue,type,...
      'VariableName',{'folder','date','filename','pulseWidth','frequency','Zterm','CoreQPow','v1rms','v2rms','v3rms',...
      'alignPowerPos','cPosM','riseTimePosM','cPosCV','riseTimePosCV',...
      'alignPowerNeg','cNegM','riseTimeNegM','cNegCV','riseTimeNegCV','noise','type'})];
end
writetable(output1,filen1);
if plotErrBar
  n = size(cPosM,2);
  pw = 1:n;
  f10 = figure('Position',pos,'visible',visible);
  subplot(2,1,1);
  suptitle(figname); 
  grid on;
  grid minor;
  hold on;  
  p1=errorbar(pw,cPosM,cPosCV,'-x'); 
  p2=errorbar(pw,cNegM,cNegCV,'-o');  
  %set(gca,'XTick',[]);
  hold off;
  legend([p1,p2],'cPos','cNeg')
  subplot(2,1,2);
  grid on;
  grid minor;
  hold on;  
  p1=errorbar(pw,riseTimePosM,riseTimePosCV,'-x');
  p2=errorbar(pw,riseTimeNegM,riseTimeNegCV,'-o');
  legend('riseTimeNeg');
  hold off;
  legend([p1,p2],'riseTimePos','riseTimeNeg')
  export_fig(f10,figname,'-append');
end    
