clear all;close all
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\addaxis5')
M = csvread('C:\jinwork\BEC\data\tp123.csv',1)
temp=[100 200 275 300 400 500 600]
qkHz=[50 75 100]
%qV=50:50:250
qVLen = 5
tempLen = 6
qkLen = 3
for i = 1:5
 x(i)=M(2+(i-1)*3,1);
    for j = 1:3
        if i ==1 
           y(j) = M(j+1,2);
        end
        z1(i,j) = M((i-1)*3 + j+1,3);
        z2(i,j) = M((i-1)*3 + j+1,4);
        z3(i,j) = M((i-1)*3 + j+1,5);
        z4(i,j) = M((i-1)*3 + j+1,6);
        z5(i,j) = M((i-1)*3 + j+1,7);
        z6(i,j) = M((i-1)*3 + j+1,8);
        z7(i,j) = M((i-1)*3 + j+1,9);
        z8(i,j) = M((i-1)*3 + j+1,10);
        z9(i,j) = M((i-1)*3 + j+1,11);
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
        
        