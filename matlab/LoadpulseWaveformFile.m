clear; close all; clc
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\export_fig\altmany-export_fig-2763b78')
dataPath = 'C:\Users\Owner\Dropbox (BEC)\BECteam\Jin\waveform\';
fn = char(strcat(dataPath,'waveform.xlsx'));
waveform = readtable(fn);
%waveform = xlsread('waveform.xlsx');
%factor of min or max
factor = 0.99;
nt = 5000000; %ntotal
np = 100000; %n test
nh = 21; %n header
alignP = 0.1;
delta = 100;
deltat = 1.00000000012417E-09;
tf = 4;
outputPath ='C:\jinwork\BEC\tmp\';
filen1 = strcat(outputPath,'waveform_041017-ipb3-37.csv');
T1=cell2table(cell(0,12),...
'VariableName',{'folder','date','filename','T','Zterm','v1rms','v2rms','v3rms','CoreQPow','P','v2A','v3A'});
figname = strcat(outputPath,'waveform_041017-ipb3-37.pdf');
delete(figname);
pos = [10 10 1000 800];
for wi = 4:4
   folder = table2cell(waveform(wi,1));
   dateN = table2cell(waveform(wi,2));
   filename = table2cell(waveform(wi,3));
   tt = char(strcat(folder,'-',dateN,'-',filename));
   fn = char(strcat(dataPath,folder,'\',filename));
   %zterm = str2double(table2cell(waveform(wi,7)));
   zterm = 2.09;
   %fnmat = char(strcat(fn,'.mat'));
   %read first np point to figure out alignment and throw away first pulse
   %M = csvread(fn,nh,0,[nh,0,np+nh-1,3]);
   M = csvread(fn,nh,0);
   %f2 = figure('Position',pos);
  % plot(M(:,1),M(:,2),M(:,1),M(:,3),M(:,1),M(:,4))
   %title(tt);
   %legend('v1','v2','v3');
   %export_fig(f2,figname,'-append');
   %find the fist pulse to throw away
   [c1 maxP] = min(abs(M(:,2)-factor*max(M(:,2))));
   [c2 minP] = min(abs(M(:,2)-factor*min(M(:,2))));
   %maxP = find(M(:,2)== 0.98*max(M(:,2)));
   %minP = find(M(:,2) == min(M(:,2)));
   fstMax = maxP(1);
   fstMin = minP(1);
   %estimate the period T
   T = abs(fstMax(1)-fstMin(1));
   %set starting point
   firstP = min(fstMax,fstMin);
   [c1 maxP] = min(abs(M(end-2*T:end,2)-factor*max(M(:,2))));
   [c2 minP] = min(abs(M(end-2*T:end,2)-factor*min(M(:,2))));
   lastMax = maxP(end);
   lastMin = minP(end);
   %set end point
   lastP = max(lastMax,lastMin);
   %plot alignment and p
   t1 = fstMax - delta;
   t2 = fstMax + tf*delta;
   alignV = alignP*M(fstMax,2);
   %find the 10% alignment for v2 
   [c1 v1] = min(abs(M(fstMax-0.3*delta:fstMax+0.3*delta,2)-alignV));
   [c2 v2] = min(abs(M(fstMax-0.3*delta:fstMax+0.3*delta,3)-alignV));
   [c3 v3] = min(abs(M(fstMax-0.3*delta:fstMax+0.3*delta,4)-alignV));
   v1,v2,v3
   v2s = v2-v1,v3s = v3-v1
   %make plot 
   f1 = figure('Position',pos);
   %tqStr = strcat(tStr);
   
   subplot(3,1,1);
   grid on;
   grid minor;
   %hold on;
   suptitle(tt); 
   x=[fstMax,fstMax];
   y=[0,300];
   plot(M(t1:t2,1),M(t1:t2,2),M(t1:t2,1),M(t1:t2,3),M(t1:t2,1),M(t1:t2,4))
   %line([fstMax fstMax],[0 300]);
   %set(gca,'YLim',[0 300])
   %plot(x,y);
   %hold off;
   legend('v1','v2','v3');
   %ylabel('V'); 
   set(gca,'XTick',[]);
   subplot(3,1,2);
   grid on;
   grid minor;
   plot(M(t1:t2,1),M(t1:t2,2),M(t1:t2-v2s,1),M(t1+v2s:t2,3),M(t1:t2-v3s,1),M(t1+v3s:t2,4))
   legend('v1','v2','v3');
   set(gca,'XTick',[]);
   subplot(3,1,3);
   grid on;
   grid minor;
   %calculate P = (v1-v2)*v3/R
   %hold on;
   deltaV = (M(t1:t2-v2s,2)-M(t1+v2s:t2,3));
   %size(deltaV)
   %size(M(t1+v3s:t2,4))
   %size(deltaV(1:end-v3s+v2s))
   P = deltaV(1:end-v3s+v2s).*M(t1+v3s:t2,4)/zterm*deltat;
   %plot(M(t1:t2-v2s,1),deltaV,M(t1:t2-v3s,1),P);
   yyaxis left
   plot(M(t1:t2-v2s,1),deltaV);
   ylabel('v1-v2');
   yyaxis right
   plot(M(t1:t2-v3s,1),P);
   ylabel('P');
   export_fig(f1,figname,'-append');
   f2 = figure('Position',pos);
   subplot(2,1,1);
   grid on;
   grid minor;
   %hold on;
   suptitle(tt); 
   plot(M(1:2*T,1),M(1:2*T,2),M(1:2*T,1),M(1:2*T,3),M(1:2*T,1),M(1:2*T,4))
   set(gca,'XTick',[]);
   subplot(2,1,2);
   grid on;
   grid minor;
   plot(M(firstP:2*T,1),M(firstP:2*T,2),M(firstP:2*T,1),M(firstP:2*T,3),M(firstP:2*T,1),M(firstP:2*T,4))
   export_fig(f2,figname,'-append'); 
   f3 = figure('Position',pos);
   subplot(2,1,1);
   grid on;
   grid minor;
   %hold on;
   suptitle(tt); 
   plot(M(end-2*T:end,1),M(end-2*T:end,2),M(end-2*T:end,1),M(end-2*T:end,3),M(end-2*T:end,1),M(end-2*T:end,4))
   set(gca,'XTick',[]);
   subplot(2,1,2);
   grid on;
   grid minor;
   plot(M(end-2*T:end-2*T+lastP,1),M(end-2*T:end-2*T+lastP,2),M(end-2*T:end-2*T+lastP,1),M(end-2*T:end-2*T+lastP,3),M(end-2*T:end-2*T+lastP,1),M(end-2*T:end-2*T+lastP,4))
   export_fig(f3,figname,'-append'); 

   % take last np points to throw away last pulse
   %Mend =csvread(fn,nt-np-1,0,[nt-np-1,0,nt,3]); 
   %find the last pulse to throw away
   %lastMax = find(Mend(:,2)==max(Mend(:,2)));
   %lastMin = find(Mend(:,2)==min(Mend(:,2)));
   %lastP = max(max(lastMax),max(lastMin));
  % T = max(fstMin)-min(fstMax) 
   %figure('name','end');
   %plot(Mend(:,1),Mend(:,2),Mend(1:end-v2s,1),Mend(1:end-v2s,3),Mend(1:end-v3s,1),Mend(1:end-v3s,4));
   %figure('name','endwo');
   %MendWo=Mend(1:lastP,:);
   %plot(MendWo(:,1),MendWo(:,2),MendWo(1:end-v2s,1),MendWo(1+v2s:end,3),MendWo(1:end-v3s,1),MendWo(1+v3s:end,4));
   %cut 
   %M2=M(firstP:end,:);
   %size(M2);
   
  % figure('name','begwo');
   %plot(M2(1:end,1),M2(1:end,2),M2(1:end-v2s,1),M2(1+v2s:end,3),M2(1:end-v3s,1),M2(1+v3s:end,4))
  % MT = csvread(fn,nh,0);
   %f2 = figure('Position',pos);
   %plot(MT(:,1),MT(:,2),MT(:,1),MT(:,3),MT(:,1),MT(:,4))
   %legend('v1','v2','v3');
   %export_fig(f2,figname,'-append');
   %yrms= rms(MT(firstP:end-np+lastP,2:4))/sqrt(n)
   %takeout first pulse and last pulse
   MM =M(firstP:end-2*T+lastP,2:4);
   n = size(MM,1);
   yrms= rms(MM);
   y = fft(MM)/n;
   yf=rms(abs(y));yrms/sqrt(n);
   P0 = (yrms(1)-yrms(2))*yrms(3)/zterm;
   
   deltaV = (MM(1:end-v2s,1)-MM(1+v2s:end,2));
   deltaV1 = (M(firstP:end-2*T+lastP-v2s,2)-M(1+v2s:end-2*T+lastP+v2s,3));
   %size(deltaV)
   %size(MM(1+v3s:end,3))
   %size(deltaV(1:end-v3s+v2s))
   P = mean(abs(deltaV(1:end-v3s+v2s).*MM(1+v3s:end,3)))/zterm;

   T1 =[T1;table(folder,dateN,filename,T,zterm,yrms(1),yrms(2),yrms(3),P0,P,v2s,v3s,...
    'VariableName',{'folder','date','filename','T','Zterm','v1rms','v2rms','v3rms','CoreQPow','P','v2A','v3A'})];
end
writetable(T1,filen1);

