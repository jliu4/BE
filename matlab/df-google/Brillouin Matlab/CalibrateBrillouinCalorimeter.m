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
  % identify the number of parameters to assign
  nparam = min(numel(parameter_argin),numel(parameters));
  % load in the fixed parameters
  for iParam = 1:nparam
    if isstruct(parameter_argin)
      pfields = fieldnames(parameter_argin);
      for kpf = 1:length(pfields)
        pfield = pfields{kpf};
        parameters(iParam).(pfield) = parameter_argin.(pfield)(iParam);
      end
    else
    parameters(iParam).Value = parameter_argin(iParam);
    end
  end
end

npoints = length(run_data.basetime.data);
fprintf('Analyzing dataset of length %d points.\n', npoints);

%% Construct the starting grey box model
if strcmp(model_class, 'idnlgrey')
  mGrey_start = idnlgrey(model_name, getOrder(var_labels), parameters);
%   for istate=1:numel(mGrey_start.InitialStates) %loop over the the number of states
%   mGrey_start.InitialStates(istate).Fixed = 0; % do not fix the initial conditions of any state
%   end  
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
  if isfield(run_data.fit, 'x0') && ...
    numel(mGrey.InitialStates) == numel(run_data.fit.x0)
    x0 = run_data.fit.x0;
  else
    [~, ~, x0] = compare(data_input(range_fit), mGrey);
  end
else
  [mGrey, x0] = ...
    fitModel(data_input, mGrey_start, parameters, run_data);
end
figure;
% Compare measurement to prediction, plot and report fit percentage
cmp_opt = compareOptions('InitialCondition', x0);
compare(data_input(range_fit), mGrey, cmp_opt, 'b-.'); % plot
if strcmp(run_data.model.action, 'predict') % report fit
  [~, fit, ~] = compare(data_input(range_fit), mGrey, cmp_opt, 'b-.');
  for kfit = 1:length(fit)
    var = mGrey.InitialStates(kfit).Name;
    fitval = fit(kfit);
    fprintf('Fit Percentage %.2f%% for %s\n', fitval, var)
  end
end
run_data.model.model = mGrey;

%% Compute the internal states of the system
simOpt = simOptions('InitialCondition', x0);
[~, ~, x] = sim(mGrey, data_input(range_fit), simOpt);
run_data.x = x;
run_data.data_input = data_input;

%% display the parameters
PlotModelParams(mGrey, run_data)
PlotModelPowerScaling(mGrey, run_data)

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