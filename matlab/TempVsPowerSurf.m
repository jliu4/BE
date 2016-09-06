clear all;close all
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
M = csvread('C:\jinwork\BEC\tmp\tp1.csv',1)
temp=[100 200 275 300 400 500 600]
qkHz=[50 75 100]
qV=[50 100 150 200 250]
qVLen = 5
tempLen = 3
qkLen = 3
for i = 1:qVLen*tempLen
  for j = 1:qkLen
     z1(i,j) = M(i,2+j);
     z2(i,j) = M(qVLen+i,2+j);
     z3(i,j) = M(2*qVLen+i,2+j);
 
    end
end

figure(1)
axis([50 250 50 100]);
axis tight

subplot(1,2,1)
surf(x,y,z1')
ax = gca;
ax.XTick = [100 200]
ax.YTick = [50 75 100]
xlabel('qV')
ylabel('qH')
title('x^2')
subplot(1,2,2)
surf(x,y,z2')
ax = gca;
ax.XTick = [100 200]
ax.YTick = [50 75 100]
xlabel('qV');
ylabel('qH');
title('x')
%subplot(1,3,3)
%surf(x,y,z3')
%title('c')
figure(2)
ax = gca;
ax.XTick = [50 100 150 200 250]
ax.YTick = [50 75 100]
%axis([50 250 50 100]);
%axis tight
g1 = subplot(2,3,1)
surf(g1,x,y,z4')
ax = gca;
ax.XTick = [100 200]
ax.YTick = [50 75 100]
xlabel('qV');
ylabel('qH');
title('100')
subplot(2,3,2)

surf(x,y,z5')
ax = gca;
ax.XTick = [100 200]
ax.YTick = [50 75 100]
xlabel('qV');
ylabel('qH');
title('200')
  
subplot(2,3,3)
  
surf(x,y,z6')
title('300') 
ax = gca;
ax.XTick = [100 200]
ax.YTick = [50 75 100]
xlabel('qV');
ylabel('qH');
subplot(2,3,4)
surf(x,y,z7')
title('400')
subplot(2,3,5)

surf(x,y,z8')
title('500')
ax = gca;
ax.XTick = [100 200]
ax.YTick = [50 75 100]
subplot(2,3,6)
      
surf(x,y,z9')
title('600') 
ax = gca;
ax.XTick = [100 200]
ax.YTick = [50 75 100]
        
        