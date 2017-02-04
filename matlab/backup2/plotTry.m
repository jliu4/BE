% Initial housekeeping
clear; close all; clc
addpath('C:\jinwork\BE\matlab\PolyfitnTools')
color
for i = 1:10
    i
    ii=int8((i-1)/2)+mod(i,2)
end    
t=[1,2,3,4,5];
y=[2,3,4,5,6];
t1=[0,max(t)];
x=t'\y';
y1=[0,x*t1(2)];
%https://www.mathworks.com/help/matlab/math/systems-of-linear-equations.html

x1=(polyfitn(t',y',1));
x1(1)
plot(t,y,'-o',t1,y1,'--');
