function run_data = CalibrateBrillouinCalorimeter(run_data,varargin)
% calibrateGen3Kanthal -- general calibration routine for GenIII Kanthal
% Calorimeter
if nargin == 2
  fixed_parameter_values = varargin{1};
end

%% Prepare starting dynamic calorimeter models
model_type = run_data.model.type;
[obs_model_name, energy_calc_code, model_class] = setModelNames(model_type);
[parameters, varLabels_obs, varLabels_mod] = SetBrillouinModelParams(model_type);

if (exist('fixed_parameter_values') == 1) %if there are fixed values defined
  for iParam = 1:numel(parameters)
    parameters(iParam).Value=fixed_parameter_values(iParam);
  end
end
model_class = 'idnlgrey';
obs_model_name = 'BE';
%% Construct the starting grey box model of the observations
if strcmp(model_class, 'idnlgrey');
    
  mGrey_start_obs = idnlgrey(obs_model_name, getOrder(varLabels_obs), ...
                             parameters);
  for istate=1:numel(mGrey_start_obs.InitialStates) %loop over the the number of states
  mGrey_start_obs.InitialStates(istate).Fixed = 0; % do not fix the initial conditions of any state
  end  
elseif strcmp(model_class, 'idgrey') 
  if isstruct (parameters)
    param = paramStruct2Cell(parameters);
  else
    param = parameters;
  end
  mGrey_start_obs = idgrey(obs_model_name, param, 'c');
  if isstruct (parameters)
    for kp = 1:length(parameters)
      mGrey_start_obs.Structure.Parameters(kp).Free = ~parameters(kp).Fixed;
      mGrey_start_obs.Structure.Parameters(kp).Info.Unit = parameters(kp).Unit; 
    end
  end
end
mGrey_start_obs = setNamesAndUnits( mGrey_start_obs, varLabels_obs );

%% Prepare the fitting data
% package the dataset
[data_input] = PrepFittingData(run_data, varLabels_obs);

%% Fit a grey box model to the measured data
if isfield(run_data.fit,'stop')
  nstop = run_data.fit.stop;
else
  nstop = length(run_data.Time.data);
end
range_fit = run_data.fit.start:nstop;
run_data.fit.range = range_fit;

% fit the model
[mGrey, x0] = ...
  fitModel(data_input, mGrey_start_obs, parameters, run_data);
run_data.model.model = mGrey;

% display the model fit
figure
cmp_opt = compareOptions('InitialCondition', x0);
compare(data_input(range_fit), mGrey, cmp_opt); % plot the comparison

%% Plot the model fit to the temperature with 99% (2 sigma) confidence interval
simOpt = simOptions('InitialCondition', x0);
[ysim_obs, ~, x] = sim(mGrey, data_input(range_fit), simOpt);
ysim_obs = AddModeled(ysim_obs);
run_data = plotOutputWithConfidenceIntervals...
    ( {data_input(range_fit), ysim_obs}, {[], []}, run_data );
%% calculate energetics
% define energy input quantity required before COP calculation is meaningful 
run_data.fit.input_energy_threshold = 1; % (Joules)
run_data = feval(energy_calc_code, run_data, data_input(range_fit), x);
plotCOP(run_data);
plotEnergies(run_data);
plotPowerResiduals(run_data);
%% notify completion
keyboard
beep
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