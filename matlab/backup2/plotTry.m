% Initial housekeeping
clear; close all; clc
addpath('C:\jinwork\BE\matlab\PolyfitnTools')
%d1 runs, tempratures, qlen, datapoint
c=cell(5,7,3,5);
c(1,1,1,1) = 1000;
c(1,1,1,2)= 5000;
c(1,1,1,3)= 6000;
c(1,1,2,1)= 100;
c(1,1,2,1)=500;
c(1,1,3,1)=600;
c(1,1,1,:)

t=[1,2,3,4,5];
y=[2,3,4,5,6];
t1=[0,max(t)];
x=t'\y';
y1=[0,x*t1(2)];
%https://www.mathworks.com/help/matlab/math/systems-of-linear-equations.html

x1=(polyfitn(t',y',1));
x1(1)
plot(t,y,'-o',t1,y1,'--');
