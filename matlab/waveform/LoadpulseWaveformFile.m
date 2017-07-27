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
debug = false;

visible = 'on';
%control parameters
plotSummary = true; plotPos = true; plotNeg = true; plotCN = true; plotErrBar = true;
fftAnalysis = true;

fn = char(strcat(dataPath,'waveform.xlsx'));
waveform = readtable(fn);
%input = [waveform(22,:);waveform(7,:);waveform(51,:);waveform(73:74,:)];
%input = [waveform(2:9,:);waveform(3,:);waveform(6,:);waveform(8:10,:)];
%input = [waveform(75,:);waveform(63,:);waveform(79:80,:)]; %ipb4-44
%vs.ipb41-44
%input = [waveform(83:86,:)]; %ipb41-44

input = [waveform(64,:);waveform(66,:)]; 
input = [waveform(64:67,:);waveform(67,:)]; 
figname = 'ipb3-43-72717.pdf';
filen1 = strcat(outputPath, strrep(figname, '.pdf', '.csv'));
figname = strcat(outputPath,figname);
numWaveform = size(input,1);
vfactor = 0.94;% off 0.6 seconds for each 10 seconds q-pulse measurement.
nh = 21; %waveform file header lines
s2ns = 1e9; %second to ns
hz2kHz = 1e3; %hz to kHz
Fs = 2.5*1e9; %sampling frequency 2.5 gHz.
inchNs = 0.0847253; %  speed light in unit [inch/ns]
output1 = cell2table(cell(0,34),...
'VariableName',{'folder','date','filename','pulseWidth','frequency','Zterm','CoreQPow','v1rms','v2rms','v3rms',...
'alignPowerPos','cPosM','riseTimePosM','dvdtPosM','riseTime12PosM','dvdt12PosM','cPosCV','riseTimePosCV','dvdtPosCV','riseTime12PosCV','dvdt12PosCV',...
'alignPowerNeg','cNegM','riseTimeNegM','dvdtNegM','riseTime12NegM','dvdt12NegM','cNegCV','riseTimeNegCV','dvdtNegCV','riseTime12NegCV','dvdt12NegCV',...
'noise','type'});
delete(figname);
pos = [10 10 1000 800];
for wi = 1:numWaveform
   folder = input.folder(wi);
   dateN = input.date(wi);
   filename = input.filename(wi)
   voltage = input.voltage(wi);
   
   zterm = input.zterm(wi);
   filterCount = input.filterCount(wi);
   alignP = input.alignP(wi); %where v1,v2 and v3 aligned 0.05 or 0.1
   mFactor = input.mFactor(wi); %where riser time peak 
   input_frequency = input.frequency(wi); %kHz-Hz
   delta = input.delta(wi); %use the range to seach the 
   coreL = input.coreL(wi);  %core length in inch
   pulseWidth = input.pulseWidth(wi); %ns
   panelDivision = input.panelDivision(wi); %vol
   filterValue = filterCount/256 * panelDivision *4; 
   type = input.type(wi); 
   tt = char(strcat(folder,'-',dateN,'-',filename,'-',type,'-',num2str(filterCount)));
   fn = char(strcat(dataPath,folder,'\',filename));
   %read in big file  
   M = csvread(fn,nh,0);
   totalTime = M(end,1) - M(1,1);
   numPoint = size(M,1);
   timeInterval = totalTime/(numPoint-1); %sec
   pulseWidthPoint = pulseWidth/timeInterval/s2ns;
   %take out 
   M0 = M(isfinite(M(:,2)),2);
   %if there is inf, there is no sense to align them.   
   if size(M0,1) < numPoint
     msg = strcat('file:',filename,'has inf');  
     disp(msg);  
     continue;
   end   
   max2 = max(M(:,2));
   min2 = min(M(:,2));
   switch char(type)
       case {'square';'Trapezoid'}
        %mVolt = min(max2,-min2); %
        mVolt = 0.5*voltage; %regular pulse causes the over shoot, and max and min actuall 10% higher than desired. 
        it1 = delta;
        it2 = 3*delta; %it2=max(1000,pulseWidthPoint+0.5*delta);
        ift1 = 3*delta;
       case {'square-lpf'} %low pass filter cause the voltage not reach the desired peak
        mVolt = min(max2,-min2);
        it1 = 2*delta;
        it2 = 3*delta; %it2=max(1000,pulseWidthPoint+0.5*delta);  
        ift1 = 6*delta;
       case {'singleNarrow'}
        mVolt = min(max2,-min2);
        it1 = delta;
        it2 = 3*delta;
        ift1 = 3*it1;
       case {'dualNarrow'}
        mVolt = min(max2,-min2);
        it1 = 10*delta; %min(1000,pulseWidthPoint+0.5*delta);
        ift1 = it1;
        it2 = 3*delta;  
   end   
       
   %[pk10,lc10] = findpeaks(M(delta:end-delta,2),'MinPeakProminence',100,'MinPeakHeight',mFactor*max2,'MinPeakDistance',pulseWidthPoint);
   %[pk20,lc20] = findpeaks(-M(delta:end-delta,2),'MinPeakProminence',100,'MinPeakHeight',-mFactor*min2,'MinPeakDistance',pulseWidthPoint);
   lc10 = []; lc20 = []; lc1 = []; lc2 = [];
   %find the peaks near min and max of the waveform instead intended peaks.
   [pk10,lc10] = findpeaks(M(:,2),'MinPeakHeight',mFactor*max2,'MinPeakDistance',pulseWidthPoint);
   [pk20,lc20] = findpeaks(-M(:,2),'MinPeakHeight',-mFactor*min2,'MinPeakDistance',pulseWidthPoint);
   %eliminate the first peak if it is too close to the edge.
   %eliminate the last peak if it is too close to the edge.
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
   frequency = int32(numOfPulse/totalTime/hz2kHz); %kHz as the frequency unit
   if fftAnalysis  
     xrange = 4;
      %filter out noise.
      M0 = M(:,2:4);
     
      M0(abs(M0) <= filterValue*8)= 0;
      M1 = horzcat(M(:,1),M0(:,1:3));
   
     t1 = int32(lc10(2)-ift1);
     t2 = int32(lc10(2)+pulseWidthPoint+it2);
     %t2 = int32(lc20(2)-2*delta);
     test = strcat(outputPath,'jinfft.csv');
     %csvwrite(test,M1(:,1));
     plotFFT1(M1,t1,t2,pos,figname,tt,Fs,xrange,visible);
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
     ji2 = find(M(i1:i2,2) > mFactor*mVolt,1,'first'); %switch to set max, eliminate all unexpected reflection, noise etc.
     
     ji3 = max(lc10(i)-pulseWidthPoint,1)+ji2; % can not move to pass first point
    
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
     ji2 = find(-M(i1:i2,2) > mFactor*mVolt,1,'first');%switch to set max, eliminate all unexpected reflection, noise etc.
     ji3 = max(lc20(i)-pulseWidthPoint,1)+ji2;% can not move to pass first point
     if  ji3 > delta
       ii = ii + 1;  
       lc2(ii) = ji3;
     end  
   end  
 else
   lc1 = lc10;
   lc2 = lc20;
 end

 if false
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
   %[noise floor level ADC counts/sizeof(byte)] x [(QSetV/4) x 4 scope divisions]
   
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
   p1 = char(strcat('RMS Voltage Method: (rms(v1)-rms(v2))*rms(v3)/Z = ',num2str(P0,'%.2f'),...
       ' rms(v1) = ',num2str(y1rms,'%.2f'), ' rms(v2) = ',num2str(y2rms,'%.2f'), ' rms(v3) = ',num2str(y3rms,'%.2f')));
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
      [pPos,cPos,riseTimePos,v1sPos,v2sPos,v3sPos,alignVPos,dvdtPos,riseTime12Pos,dvdt12Pos,j12Pos] = calculateAlignedPower(fstMax,M,MM,delta,alignP,zterm,timeInterval,s2ns,coreL,inchNs,debug,tt,pi,mVolt);  
      posArray(pi,1:9)=[lc1(pi),cPos,riseTimePos,v1sPos,v2sPos,v3sPos,dvdtPos,riseTime12Pos,dvdt12Pos];
      %only plot the first one
      if pi==1 && plotPos %let's plot two
        plotAligned(v1sPos,v2sPos,v3sPos,M,fstMax,delta,zterm,figname,P0,pPos,cPos,alignVPos,alignP,riseTimePos,pos,tt,yPos(2),yPos,visible,it1,it2,dvdtPos,mFactor,...
            riseTime12Pos,dvdt12Pos,j12Pos);
      end  
     end
     cPosM(wi) = meanabs(posArray(isfinite(posArray(:,2)),2));
     cPosCV(wi) = std(posArray(isfinite(posArray(:,2)),2));
     riseTimePosM(wi) = mean(posArray(isfinite(posArray(:,3)),3));
     riseTimePosCV(wi) = std(posArray(isfinite(posArray(:,3)),3));
     dvdtPosM(wi) = mean(posArray(isfinite(posArray(:,7)),7));
     dvdtPosCV(wi) = std(posArray(isfinite(posArray(:,7)),7));
     riseTime12PosM(wi) = mean(posArray(isfinite(posArray(:,8)),8));
     riseTime12PosCV(wi) = std(posArray(isfinite(posArray(:,8)),8));
     dvdt12PosM(wi) = mean(posArray(isfinite(posArray(:,9)),9));
     dvdt12PosCV(wi) = std(posArray(isfinite(posArray(:,9)),9));
     j1 = size(lc2,2); 
     for pi = 1:j1
       
       fstMin = lc2(pi);
      
       [pNeg,cNeg,riseTimeNeg,v1sNeg,v2sNeg,v3sNeg,alignVNeg,dvdtNeg,riseTime12Neg,dvdt12Neg,j12Neg] = calculateAlignedPower(fstMin,M,MM,delta,alignP,zterm,timeInterval,s2ns,coreL,inchNs,debug,tt,pi,mVolt);
       
       negArray(pi,1:9)=[lc2(pi),cNeg,riseTimeNeg,v1sNeg,v2sNeg,v3sNeg,dvdtNeg,riseTime12Neg,dvdt12Neg];
       
       if pi == 1 && plotNeg
         plotAligned(v1sNeg,v2sNeg,v3sNeg,M,fstMin,delta,zterm,figname,P0,pNeg,cNeg,alignVNeg,alignP,riseTimeNeg,pos,tt,yNeg(1),yNeg,visible,it1,it2,dvdtNeg,mFactor,...
             riseTime12Neg,dvdt12Neg,j12Neg);
       end  
     end
     cNegM(wi) = meanabs(negArray(isfinite(negArray(:,2)),2));
     cNegCV(wi) = std(negArray(isfinite(negArray(:,2)),2));
      
     riseTimeNegM(wi) = mean(negArray(isfinite(negArray(:,3)),3));
     riseTimeNegCV(wi) = std(negArray(isfinite(negArray(:,3)),3));
     
     dvdtNegM(wi) = mean(negArray(isfinite(negArray(:,7)),7));
     dvdtNegCV(wi) = std(negArray(isfinite(negArray(:,7)),7));
     riseTime12NegM(wi) = mean(negArray(isfinite(negArray(:,8)),8));
     riseTime12NegCV(wi) = std(negArray(isfinite(negArray(:,8)),8));
     
     dvdt12NegM(wi) = mean(negArray(isfinite(negArray(:,9)),9));
     dvdt12NegCV(wi) = std(negArray(isfinite(negArray(:,9)),9));
     if plotCN
        plotCNs(posArray,negArray,pos,figname,tt,visible);
     end
   end
   output1 =[output1;table(folder,dateN,filename,pulseWidth,frequency,zterm,P0*0.94,y1rms,y2rms,y3rms,...
       pPos,cPosM(wi),riseTimePosM(wi),dvdtPosM(wi),riseTime12PosM(wi),dvdt12PosM(wi),cPosCV(wi),riseTimePosCV(wi),dvdtPosCV(wi),riseTime12PosCV(wi),dvdt12PosCV(wi),...
       pNeg,cNegM(wi),riseTimeNegM(wi),dvdtNegM(wi),riseTime12NegM(wi),dvdt12NegM(wi),cNegCV(wi),riseTimeNegCV(wi),dvdtNegCV(wi),riseTime12NegCV(wi),dvdt12NegCV(wi),...
       filterValue,type,...
       'VariableName',{'folder','date','filename','pulseWidth','frequency','Zterm','CoreQPow','v1rms','v2rms','v3rms',...
'alignPowerPos','cPosM','riseTimePosM','dvdtPosM','riseTime12PosM','dvdt12PosM','cPosCV','riseTimePosCV','dvdtPosCV','riseTime12PosCV','dvdt12PosCV',...
'alignPowerNeg','cNegM','riseTimeNegM','dvdtNegM','riseTime12NegM','dvdt12NegM','cNegCV','riseTimeNegCV','dvdtNegCV','riseTime12NegCV','dvdt12NegCV',...
'noise','type'})];
     
end
writetable(output1,filen1);
if plotErrBar
  n = size(cPosM,2);
  pw = 1:n;
  f10 = figure('Position',pos,'visible',visible);
  subplot(3,1,1);
  suptitle(figname); 
  grid on;
  grid minor;
  hold on;  
  p1=errorbar(pw,cPosM,cPosCV,'-x'); 
  p2=errorbar(pw,cNegM,cNegCV,'-o');  
  ylabel('c[speed light]');
  set(gca,'XTick',[]);
  hold off;
  legend([p1,p2],'cPos','cNeg')
  subplot(3,1,2);
  grid on;
  grid minor;
  hold on;  
  p1=errorbar(pw,riseTimePosM,riseTimePosCV,'-x');
  p2=errorbar(pw,riseTimeNegM,riseTimeNegCV,'-o');
  p3=errorbar(pw,riseTime12PosM,riseTime12PosCV,'-+');
  p4=errorbar(pw,riseTime12NegM,riseTime12NegCV,'-*');
  ylabel('riseTime[ns]');
  set(gca,'XTick',[]);
  hold off;
  legend([p1,p2,p3,p4],'riseTimePos','riseTimeNeg','riseTime12Pos','riseTime12Neg')
  subplot(3,1,3);
  grid on;
  grid minor;
  hold on;  
  p1=errorbar(pw,dvdtPosM,dvdtPosCV,'-x');
  p2=errorbar(pw,dvdtNegM,dvdtNegCV,'-o');
  p3=errorbar(pw,dvdt12PosM,dvdt12PosCV,'-+');
  p4=errorbar(pw,dvdt12NegM,dvdt12NegCV,'-*');
  ylabel('dv/dt[volt/ns]');
  hold off;
  legend([p1,p2,p3,p4],'dv/dtPos','dv/dtNeg','dv/dt12Pos','dv/dt12Neg')
  set(gca,'xtick',1:numWaveform);
  export_fig(f10,figname,'-append');
end    
