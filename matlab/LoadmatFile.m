clear; close all; clc
addpath('C:\jinwork\BE\matlab')
addpath('C:\jinwork\BE\matlab\df-google\ipb1-30')
addpath('C:\jinwork\BE\matlab\df-google\sri-ipb2-33b')
matfile = 'ipb1-30b-h2-dc-calibration_DKF_calibration.05.mat';
matfile = 'sri-ipb2-33b-he-dc-calibration.mat';

S = load(matfile)
run_data = S.run_data;
param = S.run_data.model.model.Parameters;
%clear S
parameters = [param(:).Value];
filen = strcat('C:\jinwork\BEC\tmp\parameters','.csv');
dlmwrite(filen,parameters,'-append');
%dlmwrite(filen,[run_data.fitting_script_filename,parameters],'-append');

%T=cell2table(cell(0,21),...
%'VariableName',{'ca0','ca1','ca2','cb0','cb1','cb2','kas0','kas1','kas2','kab0','kab1','kab2','kbs0','kbs1','kbs2','a10',...
%'a11','a12','a20','a21','a22'});
%T =[T;table(parameters,'VariableName',{'ca0','ca1','ca2','cb0','cb1','cb2','kas0','kas1','kas2','kab0','kab1','kab2','kbs0','kbs1','kbs2','a10',...
%'a11','a12','a20','a21','a22'})];

 %writetable(T,filen1);
