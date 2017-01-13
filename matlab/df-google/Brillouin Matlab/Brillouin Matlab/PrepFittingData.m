function [data_input] = PrepFittingData(run_data, data_labels)
% prepFittingData -- from measured time series data, construct the inputs,
% u, and outputs, y, to be used for fitting and analysis

% determine model type
model_type = run_data.model.type;

% determine what type of q-power is used
if isfield(run_data,'core_Q_power')
  q_field = 'core_Q_power';
elseif isfield(run_data,'Q_power_supply')
  q_field = 'Q_power_supply';
elseif isfield(run_data,'Q_supply_power')
  q_field = 'Q_supply_power';
end

% determine the size of the input data
data_size = size(run_data.heater_power.data);

%% set the output and input
power_in = run_data.heater_power.data + run_data.(q_field).data;
% one state
if ~isempty(strfind(model_type, 'one state'))
  y = run_data.core_temp.data;
  u = [power_in, y, run_data.outer_temp_1.data];
% two state
elseif ~isempty(strfind(model_type, 'two state'))
  y = [run_data.core_temp.data, run_data.inner_temp_1.data;];
  if ~isempty(strfind(model_type, 'two a-node inputs'))
    u = [run_data.heater_power.data, run_data.(q_field).data, y, ...
      run_data.outer_temp_1.data];
  else
    u = [power_in, y, run_data.outer_temp_1.data];
  end
% three state
elseif ~isempty(strfind(model_type, 'three state'))
  y = [run_data.core_temp.data, run_data.inner_temp_1.data];
  if ~isempty(strfind(model_type, 'measure Tb and Tc'))
    u = [run_data.(q_field).data, ...
         run_data.heater_power.data, ...
         999e9*ones(data_size), y, run_data.outer_temp_1.data];
  elseif ~isempty(strfind(model_type, 'measure Ta and Tc'))
    u = [run_data.(q_field).data, ...
         run_data.heater_power.data, ...
         y(:,1), 999e9*ones(data_size), y(:,2), run_data.outer_temp_1.data];    
  elseif ~isempty(strfind(model_type, 'a and c sources'))
    y = [run_data.core_temp.data, ...
         run_data.inner_temp_1.data,...
         run_data.core_temp.data];
    u = [run_data.(q_field).data, ...
         run_data.heater_power.data, ...
         y, run_data.outer_temp_1.data];    
  end
end

%% package the dataset
data_input = iddata(y, u, run_data.delta_time.value, 'Name','Calorimeter Data');
% name the dataset variables
data_input = setNamesAndUnits(data_input, data_labels);
end
