function [parameters, varLabels_obs, varLabels_mod] = ...
  SetBrillouinModelParams(model_type)
% setModelParams -- 
% based on the model type, initialize the parameters, names and units
% this code is specific to the Brillouin calorimeter
% Note (2016-06-10) varLables_mod is being deprecated DKF

%% determine model type
one_state = strcmp(model_type, 'one state');
two_state = strcmp(model_type, 'two state master model zero Kelvin ground');

%% initialize the parameters in the calorimeter model
                      
if two_state 
%0th, 1st and 2nd order non-linear parameters for ca
% non-linear temrs in heat capacitites can reasonably take on negative values so long as net
% value of the overall capacitance is positive 
ca0 = 115;
parameters(1) = struct('Name', 'ca0', 'Unit', 'J/°C', 'Value',  ca0, ...
                     'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
ca1 = 0;
parameters(2) = struct('Name', 'ca1', 'Unit', 'J/°C^2', 'Value',  ca1, ...
                     'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
ca2 = 0;
parameters(3) = struct('Name', 'ca2', 'Unit', 'J/°C^3', 'Value',  ca2, ...
                     'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
                 
%0th, 1st and 2nd order non-linear parameters for cb
cb0 = 522;
parameters(4) = struct('Name', 'cb0', 'Unit', 'J/°C', 'Value',  cb0, ...
                     'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
cb1 = 0;
parameters(5) = struct('Name', 'cb1', 'Unit', 'J/°C^2', 'Value',  cb1, ...
                     'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
cb2 = 0;
parameters(6) = struct('Name', 'cb2', 'Unit', 'J/°C^3', 'Value',  cb2, ...
                     'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
                 
%1st, 2nd & 3rd order non-linear parameters for kas
kas0 = 0.024;
parameters(7) = struct('Name', 'kas0', 'Unit', 'W/°C', 'Value',  kas0, ...
                     'Minimum', 0, 'Maximum', inf, 'Fixed', false);
kas1 = 0; 
parameters(8) = struct('Name', 'kas1', 'Unit', 'W/°C^2', 'Value',  kas1, ...
                     'Minimum', 0, 'Maximum', inf, 'Fixed', true);
kas2 = 0;
parameters(9) = struct('Name', 'kas2', 'Unit', 'W/°C^3', 'Value',  kas2, ...
                     'Minimum', 0, 'Maximum', inf, 'Fixed', true);                    
                     
%1st, 2nd & 3rd order non-linear parameters for kab
kab0 = 1.0;
parameters(10) = struct('Name', 'kab0', 'Unit', 'W/°C', 'Value',  kab0, ...
                     'Minimum', 0, 'Maximum', inf, 'Fixed', false);
kab1 = 0; 
parameters(11) = struct('Name', 'kab1', 'Unit', 'W/°C^2', 'Value',  kab1, ...
                     'Minimum', 0, 'Maximum', inf, 'Fixed', true);
kab2 = 0; 
parameters(12) = struct('Name', 'kab2', 'Unit', 'W/°C^3', 'Value',  kab2, ...
                     'Minimum', 0, 'Maximum', inf, 'Fixed', true); 

% for kbs
kbs0 = 0.056;
parameters(13) = struct('Name', 'kbs0', 'Unit', 'W/°C', 'Value',  kbs0, ...
                     'Minimum', 0, 'Maximum', inf, 'Fixed', false);
kbs1 = 0;
parameters(14) = struct('Name', 'kbs1', 'Unit', 'W/°C^2', 'Value',  kbs1, ...
                     'Minimum', 0, 'Maximum', inf, 'Fixed', true);
kbs2 = 0; 
parameters(15) = struct('Name', 'kbs2', 'Unit', 'W/°C^3', 'Value',  kbs2, ...
                     'Minimum', -inf, 'Maximum', inf, 'Fixed', true);   
                    
              
end


%% initialize labels for state, input and output variables
varLabels_obs.TimeUnit   = 'seconds';
if     one_state
  % State variables:    x = [Ta]
  % Input:              u = [input power, Ta, Ts]
  % Output (observed):  y = [Ta];
  % Output (modeled):   y = [modeled power out;
  %                          inferred power out;
  %                          excess heat rate;
  %                          stored energy];
  varLabels_obs.StateName  = {'T-Core'};
  varLabels_obs.StateUnit  = {'°C'};
  varLabels_obs.InputName  = {'Input Power', 'T-core',...
                              'T_Outer'};
  varLabels_obs.InputUnit  = {'Watts', '°C', '°C'};
  varLabels_obs.OutputName = {'T-Core'};
  varLabels_obs.OutputUnit = {'°C'};
  
elseif two_state
    
  % State variables:    x = [T_a, T_b] Temperatures proximal and distal to heat
  %                                    source respectively
  % Input:              u = [input power, T_a, T_b, Ts]
  % Output (observed):  y = [T_a, T_b];
  % Output (modeled):   y = [modeled power out;
  %                          inferred power out;
  %                          residual heat rate;
  %                          stored energy];
  varLabels_obs.StateName  = {'T_Core', 'T_Inner'};
  varLabels_obs.StateUnit  = {'°C', '°C'};
  varLabels_obs.InputName  = {'Input Power','T_Core', ...
                              'T_Inner', 'T_Outer'};
  varLabels_obs.InputUnit  = {'Watts', '°C', '°C', '°C'};
  varLabels_obs.OutputName = {'T-core', 'T-Inner'};
  varLabels_obs.OutputUnit = {'°C', '°C'};
end
varLabels_mod =varLabels_obs;
varLabels_mod.OutputName = {'Q out modelled', 'Q out inferred', 'Q residual', ...
  'Stored heat - modelled', 'Stored heat - inferred'};
varLabels_mod.OutputUnit = {'Watts', 'Watts', 'Watts', 'Joules', 'Joules'};

end

