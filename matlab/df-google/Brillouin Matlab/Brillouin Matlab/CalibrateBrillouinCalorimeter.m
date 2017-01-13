function run_data = CalibrateBrillouinCalorimeter(run_data, varargin)
% calibrateCalorimeter -- general calibration routine

if nargin == 2
  parameter_argin = varargin{1};
end

%% Prepare starting dynamic calorimeter models
model_type = run_data.model.type;
[model_name, energy_calc_code, model_class] = setModelNames(model_type);
[parameters, var_labels] = SetBrillouinModelParams(model_type);

% check if starting parameters were sent in the argument list
if exist('parameter_argin', 'var');
  % load in the fixed parameters
  for iParam = 1:numel(parameters)
    parameters(iParam).Value = parameter_argin(iParam);
  end
end

%% Construct the starting grey box model
if strcmp(model_class, 'idnlgrey')
  mGrey_start = idnlgrey(model_name, getOrder(var_labels), ...
                             parameters);
  for istate=1:numel(mGrey_start.InitialStates) %loop over the the number of states
  mGrey_start.InitialStates(istate).Fixed = 0; % do not fix the initial conditions of any state
  end  
elseif strcmp(model_class, 'idgrey') 
  if isstruct (parameters)
    param = paramStruct2Cell(parameters);
  else
    param = parameters;
  end
  mGrey_start = idgrey(model_name, param, 'c');
  if isstruct (parameters)
    for kp = 1:length(parameters)
      mGrey_start.Structure.Parameters(kp).Free = ~parameters(kp).Fixed;
      mGrey_start.Structure.Parameters(kp).Info.Unit = parameters(kp).Unit; 
    end
  end
end
mGrey_start = setNamesAndUnits( mGrey_start, var_labels );

%% Prepare the fitting data
% package the dataset
[data_input] = PrepFittingData(run_data, var_labels);
figure;
plot(data_input)

%% Fit a grey box model to the measured data
if isfield(run_data.fit,'stop')
  nstop = run_data.fit.stop;
else
  nstop = length(run_data.Time.data);
end
range_fit = run_data.fit.start:nstop;
run_data.fit.range = range_fit;

% fit (if needed) and compare the model
if strcmp(run_data.model.action, 'predict')
  mGrey = mGrey_start;
  [~, ~, x0] = compare(data_input(range_fit), mGrey);
else
  [mGrey, x0] = ...
    fitModel(data_input, mGrey_start, parameters, run_data);
end
figure;
cmp_opt = compareOptions('InitialCondition', x0);
compare(data_input(range_fit), mGrey, cmp_opt, 'b-.'); % plot the comparison
run_data.model.model = mGrey;

% display the parameters
range = (min(run_data.core_temp.data):max(run_data.core_temp.data))';
PlotModelParams(mGrey, range)

%% Plot the model fit to the temperature with 99% (2 sigma) confidence interval
simOpt = simOptions('InitialCondition', x0);
[ysim_obs, ~, x] = sim(mGrey, data_input(range_fit), simOpt);
ysim_obs = AddModeled(ysim_obs);
run_data = plotOutputWithConfidenceIntervals...
    ( {data_input(range_fit), ysim_obs}, {[], []}, run_data );
%% calculate energetics
% define energy input quantity required before COP calculation is meaningful 
run_data.fit.input_energy_threshold = 0; % (Joules)
run_data = feval(energy_calc_code, run_data, data_input(range_fit), x);
plotCOP(run_data);
plot_pCOP(run_data);
plotEnergies(run_data);
plotPowerResiduals(run_data);
%% notify completion
% keyboard
% beep
end

function param = paramStruct2Cell(parameters)
nparam = length(parameters);
if iscell(parameters)
  param = parameters;
  return
end
param = cell(nparam,2);
  for kp = 1:nparam
    param{kp,1} = parameters(kp).Name;
    param{kp,2} = parameters(kp).Value;
  end
end

function data = AddModeled (data )
noutput = length(data.OutputName);
for ko = 1:noutput
  data.OutputName{ko} = ['Modeled ',data.OutputName{ko}];
end
end