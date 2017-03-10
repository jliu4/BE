%% Initial housekeeping
clear;
close all;
splitpath = strsplit(mfilename('fullpath'), filesep);
containing_dir = strjoin(splitpath(1:end - 1), filesep);
index = find(not(cellfun('isempty', strfind(splitpath, ...
  'Project Brillouin - CONFIDENTIAL'))));
brillouin_repo = strcat(strjoin(splitpath(1:index), filesep), filesep, ...
  'Brillouin Matlab');
addpath(genpath(brillouin_repo));
run_data = AddBrillouinRepo(splitpath);
%% Load data (from *.mat or *.tdms as neccesary)
experiment_name = 'ipb1-30b-he-DC-calibration-heaterPower20w.csv';
matfile = strcat(containing_dir, filesep, ...
  strrep(experiment_name, '.csv', '.mat'));
calibration_file = 'ipb1-30b-he-DC-calibration100hours.mat';

% define data import
map.headers = {'Heater Power',  'Q Supply Power', ...
               'Core Temp', ...
               'Inner Block Temp 1', 'Inner Block Temp 2', ...
               'Outer Block Temp 1', 'Outer Block Temp 2', ...
               'Room Temperature'};
map.names   = {'heater_power',  'Q_power_supply', ...
               'core_temp', ...
               'inner_temp_1', 'inner_temp_2', ...
               'outer_temp_1', 'outer_temp_2', 'room_temp' };
map.units   = {'Watts',  'Watts', ...
               'Celsius', ...
               'Celsius', 'Celsius', ...
               'Celsius', 'Celsius', 'Celsius'};

% load data
run_data = loadBrillouinData (run_data, splitpath, experiment_name, map);

%% Dataset specific information
run_data.fit.start  = run_data.nStart;
run_data.fit.stop   = run_data.nStop;
% run_data.model.type = 'two state master model zero Kelvin ground';
run_data.model.type = 'two state model with two a-node inputs';
% run_data.model.type = 'three state 2 source model measure Tb and Tc';
% run_data.model.type = 'three state 2 source model measure Ta and Tc';
% run_data.model.type = 'three states a and c sources';
run_data.fit.max_iter = 50;

%% Run calibration

if true % grab calibration parameters from the previous run
  if exist(calibration_file, 'file') == 2
    S = load(matfile);
    param = S.run_data.model.model.Parameters;
    clear S
    parameters = [param(:).Value];
    run_data = CalibrateBrillouinCalorimeter(run_data, parameters);
  else
    fprintf('No starting parameters found.\n');
  end
else % generate and save calibration parameters
  run_data = CalibrateBrillouinCalorimeter(run_data);
  save(matfile, 'run_data')
end
