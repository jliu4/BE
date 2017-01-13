function run_data = loadBrillouinData (run_data, splitpath, experiment_name, map) 
%% load the data object into memory
fprintf('loading data...\n');
filespec = strcat(strjoin(splitpath(1:end-1), filesep),filesep, experiment_name);
fileID = fopen(filespec);
file_data = textscan(fileID, '%s', 'Delimiter', '\n');
nlines = length(file_data{1});
data_headers = textscan(file_data{1}{1}, '%s', 'Delimiter', ',');

%% process header information
nfields = length(map.names);
for k_map = 1:nfields
  index(k_map) = find(not(cellfun('isempty', strfind(data_headers{1}, ...
  map.headers{k_map}))));
  if isempty(index(k_map))
    fprintf('%s\n',data_headers{1}{:})
    error('data field %s not found.\n', map.headers{k_map})
  end
end

%% process date number and measurement information
nan_count = 0;
for k = 2:nlines
  line_data = textscan(file_data{1}{k}, '%s', 'Delimiter', ',');
  if length(line_data{1}{1})>1 % stop converting if data ends
    run_data.datenum(k - 1,1) = datenum(line_data{1}{1});
    for k_map = 1:nfields
      raw_data.(map.names{k_map}).data(k - 1, 1) = ...
        str2double(line_data{1}{index(k_map)});
      if any(isnan(raw_data.(map.names{k_map}).data(k - 1, 1)))
        nan_count = nan_count + 1;
        warning('Nan Values in raw data vector %s at line %d.\n', ...
          map.headers{k_map}, k);
      end
    end
  else
    break
  end
end
fprintf('Total NaNs encountered while loading dataset: %d\n', nan_count);

%% Determine down sampling
if isfield(run_data, 'downsample_factor')
  dsf = run_data.downsample_factor;
else
  dsf = length(run_data.datenum)/2000;
end

%% determine sampling interval
sample_interval_in_days = dsf * mean(diff(run_data.datenum)); % average time step
npoints = fix(length(run_data.datenum) / dsf);
fprintf('Fitting parameters using %d points.\n', npoints);
run_data.basetime.data = run_data.datenum(1) + ...
  sample_interval_in_days * (0 : npoints - 1)';
run_data.basetime.units = 'Days';
% base time in hours and seconds
run_data.Hours.data    = 24 * sample_interval_in_days * (0:npoints - 1)';
run_data.Hours.units   = 'Hours';
run_data.Time.data     = run_data.Hours.data * 3600;
run_data.Time.units    = 'Seconds';
run_data.delta_time.value    = 24 * 3600 * sample_interval_in_days;
run_data.delta_time.units    = 'Seconds';

%% Interpolate the datasets to the uniform time grid
for kfield = 1:nfields
  field = map.names{kfield};
  run_data.(field).data = ...
      interp1(run_data.datenum, raw_data.(field).data, run_data.basetime.data,...
              'spline', 'extrap');
  % set units
  run_data.(field).units = map.units{kfield};
end

%% Plot raw temperature and power data
% temperature and power
run_data.nStart = find(run_data.Hours.data > 0, 1);
run_data.nStop  = length(run_data.Hours.data);
if isfield(run_data,'core_Q_power')
  q_field = 'core_Q_power';
elseif isfield(run_data,'Q_power_supply')
  q_field = 'Q_power_supply';
elseif isfield(run_data,'Q_supply_power')
  q_field = 'Q_supply_power';
end
fields = {'Hours', 'heater_power', q_field, 'core_temp', 'inner_temp_1', 'outer_temp_1'};
plotRunData( run_data, fields, {'x', 'y1', 'y1', 'y2', 'y2', 'y2'});
% compare redundant temperature measurements
fields = {'Hours', 'inner_temp_1', 'inner_temp_2', 'outer_temp_1', 'outer_temp_2'};
plotRunData( run_data, fields, {'x', 'y1', 'y1', 'y1', 'y1'});
% plot room temperature
fields = {'Hours', 'room_temp'};
plotRunData( run_data, fields, {'x', 'y1'});
