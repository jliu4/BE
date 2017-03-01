% Analysis #47
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
experiment_name = 'ipb1-30-h2-dc-calibration022417.csv';
matfile = strcat(containing_dir, filesep, ...
  strrep(experiment_name, '.csv', '.mat'));
parameter_file = 'ipb1-30-h2-dc-calibration022417_DKF_calibration_01.mat';
calibration_file = 'ipb1-30-h2-dc-calibration022417_DKF_calibration_01.mat';

% define data import
map.headers = {'Heater Power',  'Q Supply Power', ...
               'Core Temp', ...
               'Inner Block Temp 1', 'Inner Block Temp 2', ...
               'Outer Block Temp 1', 'Outer Block Temp 2', ...
               'Room Temperature'};
map.names   = {'heater_power',  'Q_supply_power', ...
               'core_temp', ...
               'inner_temp_1', 'inner_temp_2', ...
               'outer_temp_1', 'outer_temp_2', 'room_temp' };
map.units   = {'Watts',  'Watts', ...
               'Celsius', ...
               'Celsius', 'Celsius', ...
               'Celsius', 'Celsius', 'Celsius'};

if ~isempty(strfind(experiment_name,'-q-'))
  map.headers{2} = 'Core Q Power';
  map.names{2}   = 'core_Q_power';
end

% load data
run_data.downsample_factor = 2;
if false % exist(matfile, 'file') == 2
  S = load(matfile);
  run_data = S.run_data;
  clear S
else
  run_data = loadBrillouinData (run_data, splitpath, experiment_name, map);
end

%% Dataset specific information
run_data.fit.start  = run_data.nStart;
run_data.fit.stop   = run_data.nStop;
run_data.fit.x0 = [run_data.core_temp.data(run_data.fit.start); ...
                   run_data.inner_temp_1.data(run_data.fit.start)];
% run_data.model.type = 'two state master model zero Kelvin ground';
% run_data.model.type = 'two state model with two a-node inputs';
run_data.model.type = 'two state model with two a-node inputs using T modelled';
run_data.fit.max_iter = 10;

%% Run calibration

if false % predict response from a calibration run's parameters
  if exist(calibration_file, 'file') == 2
    S = load(calibration_file);
    if true % strcmp(run_data.model.type, S.run_data.model.type)
      param = S.run_data.model.model.Parameters;
      clear S
      parameters = [param(:).Value];
      run_data.model.action = 'predict';
      run_data = CalibrateBrillouinCalorimeter(run_data, parameters);
    else
      error('Prediction using model type %s requires calibration of the same type.\n',...
        run_data.model.type);
    end
  else
    fprintf('No starting parameters found.\n');
  end
else % produce calibration parameters from the current run
  run_data.model.action = 'fit';
  if exist('parameter_file', 'var') == 1 % use preexisting starting parameters
    if exist(parameter_file, 'file') == 2
      S = load(parameter_file);
      param = S.run_data.model.model.Parameters;
      clear S
      parameters = [param(:).Value];
      run_data = CalibrateBrillouinCalorimeter(run_data, parameters);
    else
      run_data = CalibrateBrillouinCalorimeter(run_data);
    end
  else  
    run_data = CalibrateBrillouinCalorimeter(run_data);
  end
  save(matfile, 'run_data')
end
