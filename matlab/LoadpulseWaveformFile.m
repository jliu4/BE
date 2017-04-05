clear; close all; clc
addpath('C:\jinwork\BE\matlab')
dataPath = 'C:\Users\Owner\Dropbox (BEC)\BECteam\Jin\';
waveform = readtable('waveform.xlsx');
%waveform = xlsread('waveform.xlsx');
n = size(waveform,1);
lowB = 2;
for wi = 1:n
   core = table2cell(waveform(wi,1));
   dateN = table2cell(waveform(wi,2));
   folder = table2cell(waveform(wi,3));
   filename = table2cell(waveform(wi,4));
   tt = char(strcat(core,dateN));
  
   fn = char(strcat(dataPath,folder,'\',filename));
   %M = csvread(fn,21,0);
   M = csvread(fn,21,0,[21,0,100000,3]);
   size(M)
   figure
   plot(M(:,1),M(:,2),M(:,1),M(:,3),M(:,1),M(:,4));
   legend('v1','v2','v3');
   title(tt,'fontsize',11);
   %plot(M(:,1),M(:,2),M(:,1),M(:,3),M(:,1),M(:,4));
   %legend('v1','v2','v3');

   M((abs(M(:,2)) < lowB),:) = [];
   size(M)
   M((abs(M(:,3)) < lowB),:) = [];
   size(M)
   M((abs(M(:,4)) <lowB),:) = [];
   size(M)
   figure
   plot(M(:,1),M(:,2),M(:,1),M(:,3),M(:,1),M(:,4));
   legend('v1','v2','v3');
   title(tt,'fontsize',11);
end

if false
v1rms = rms(M(:,2));
v2rms = rms(M(:,3));
v3rms = rms(M(:,4));
p1 = (v1rms-v2rms).*v3rms;
size(p1)
p2 = ((M(:,2)-M(:,3)).*M(:,4));
size(p2)
figure
plot(M(:,1),p1,M(:,1),p2);
legend('rms','norms');
end
%filter out values below 2



