function [data_input] = PrepFittingData(run_data, data_labels)
% prepFittingData -- from measured time series data, construct the inputs,
% u, and outputs, y, to be used for fitting and analysis

% determine model type
model_type = run_data.model.type;

% set the output and input
power_in = run_data.heater_power.data + run_data.core_Q_power.data;
if ~isempty(strfind(model_type, 'one state'))
  y = run_data.core_temp.data;
  u = [power_in, y, run_data.outer_temp_1.data];
elseif ~isempty(strfind(model_type, 'two state'))
  y = [run_data.core_temp.data, run_data.inner_temp_1.data;];
  u = [power_in, y, run_data.outer_temp_1.data];
end

% package the dataset
data_input = iddata(y, u, run_data.delta_time.value, 'Name','Calorimeter Data');
% name the dataset variables
data_input = setNamesAndUnits(data_input, data_labels);
end
