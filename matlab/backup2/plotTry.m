% Initial housekeeping
clear; close all; clc
addpath('C:\jinwork\BE\matlab\PolyfitnTools')
t=[1,2,3,4,5];
y=[2,3,4,5,6];
%https://www.mathworks.com/help/matlab/math/systems-of-linear-equations.html
x=t'\y';
x1=(polyfitn(t',y',1));
x1(1)
plot(t,y,'-o');
