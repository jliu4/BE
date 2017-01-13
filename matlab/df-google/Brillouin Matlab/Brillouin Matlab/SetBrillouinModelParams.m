function [parameters, varLabels] = ...
  SetBrillouinModelParams(model_type)
% setModelParams -- 
% based on the model type, initialize the parameters, names and units
% this code is specific to the Brillouin calorimeter

%% determine model type
one_state = strcmp(model_type, 'one state');
two_state = ~isempty(strfind(model_type, 'two state'));
two_state_2_a_node_inputs = ~isempty(strfind(model_type, ...
                               'two state model with two a-node inputs'));
three_state = ~isempty(strfind(model_type, 'three state'));

%% initialize the parameters in the calorimeter model

if any([two_state, two_state_2_a_node_inputs])
  %0th, 1st and 2nd order non-linear parameters for ca
  % non-linear temrs in heat capacitites can reasonably take on negative values so long as net
  % value of the overall capacitance is positive 
  ca0 = 20;
  parameters(1) = struct('Name', 'ca0', 'Unit', 'J/°C', 'Value',  ca0, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  ca1 = 0;
  parameters(2) = struct('Name', 'ca1', 'Unit', 'J/°C^2', 'Value',  ca1, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  ca2 = 0;
  parameters(3) = struct('Name', 'ca2', 'Unit', 'J/°C^3', 'Value',  ca2, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', false);

  %0th, 1st and 2nd order non-linear parameters for cb
  cb0 = 600;
  parameters(4) = struct('Name', 'cb0', 'Unit', 'J/°C', 'Value',  cb0, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  cb1 = 0;
  parameters(5) = struct('Name', 'cb1', 'Unit', 'J/°C^2', 'Value',  cb1, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  cb2 = 0;
  parameters(6) = struct('Name', 'cb2', 'Unit', 'J/°C^3', 'Value',  cb2, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', true);

  %1st, 2nd & 3rd order non-linear parameters for kas
  kas0 = 0.02;
  parameters(7) = struct('Name', 'kas0', 'Unit', 'W/°C', 'Value',  kas0, ...
                       'Minimum', 0,    'Maximum', inf, 'Fixed', false);
  kas1 = 0; 
  parameters(8) = struct('Name', 'kas1', 'Unit', 'W/°C^2', 'Value',  kas1, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  kas2 = 0;
  parameters(9) = struct('Name', 'kas2', 'Unit', 'W/°C^3', 'Value',  kas2, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', true);                    

  %1st, 2nd & 3rd order non-linear parameters for kab
  kab0 = 0.7;
  parameters(10) = struct('Name', 'kab0', 'Unit', 'W/°C', 'Value',  kab0, ...
                       'Minimum', 0,    'Maximum', inf, 'Fixed', false);
  kab1 = 0; 
  parameters(11) = struct('Name', 'kab1', 'Unit', 'W/°C^2', 'Value',  kab1, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  kab2 = 0; 
  parameters(12) = struct('Name', 'kab2', 'Unit', 'W/°C^3', 'Value',  kab2, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', false); 

  % for kbs
  kbs0 = 0.05;
  parameters(13) = struct('Name', 'kbs0', 'Unit', 'W/°C', 'Value',  kbs0, ...
                       'Minimum', 0,    'Maximum', inf, 'Fixed', false);
  kbs1 = 0;
  parameters(14) = struct('Name', 'kbs1', 'Unit', 'W/°C^2', 'Value',  kbs1, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  kbs2 = 0; 
  parameters(15) = struct('Name', 'kbs2', 'Unit', 'W/°C^3', 'Value',  kbs2, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', false);   
end

if two_state_2_a_node_inputs 
  % add scaling factors for the a node input power
  % Pa = (a10 + a11 * Ta) * Pa1 + (a20 + a21 * Ta) * Pa2
  a10 = 1;
  parameters(16) = struct('Name', 'a10', 'Unit', '', 'Value',  a10, ...
                       'Minimum', 0, 'Maximum', inf, 'Fixed', true);
  a11 = 0;
  parameters(17) = struct('Name', 'a11', 'Unit', '/°C', 'Value',  a11, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  a12 = 0;
  parameters(18) = struct('Name', 'a12', 'Unit', '/°C^2', 'Value',  a12, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  a20 = 1;
  parameters(19) = struct('Name', 'a20', 'Unit', '', 'Value',  a20, ...
                       'Minimum', 0, 'Maximum', inf, 'Fixed', false);  
  a21 = 0.0;
  parameters(20) = struct('Name', 'a21', 'Unit', '/°C', 'Value',  a21, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', false); 
  a22 = 0.0;
  parameters(21) = struct('Name', 'a22', 'Unit', '/°C^2', 'Value',  a22, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', false); 
end

if three_state
  % 0th, 1st and 2nd order non-linear parameters for each element
  % non-linear temrs can reasonably take on negative values so long as net
  % value of the parameter is positive
  
  % ca
  ca0 = 60;
  parameters(1) = struct('Name', 'ca0', 'Unit', 'J/°C', 'Value',  ca0, ...
                       'Minimum', 0, 'Maximum', inf, 'Fixed', false);
  ca1 = 0;
  parameters(2) = struct('Name', 'ca1', 'Unit', 'J/°C^2', 'Value',  ca1, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  ca2 = 0;
  parameters(3) = struct('Name', 'ca2', 'Unit', 'J/°C^3', 'Value',  ca2, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  % cb
  cb0 = 68;
  parameters(4) = struct('Name', 'cb0', 'Unit', 'J/°C', 'Value',  cb0, ...
                       'Minimum', 0, 'Maximum', inf, 'Fixed', false);
  cb1 = 0;
  parameters(5) = struct('Name', 'cb1', 'Unit', 'J/°C^2', 'Value',  cb1, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  cb2 = 0;
  parameters(6) = struct('Name', 'cb2', 'Unit', 'J/°C^3', 'Value',  cb2, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
   % cc
  cc0 = 476;
  parameters(7) = struct('Name', 'cc0', 'Unit', 'J/°C', 'Value',  cc0, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  cc1 = 0;
  parameters(8) = struct('Name', 'cc1', 'Unit', 'J/°C^2', 'Value',  cc1, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  cc2 = 0;
  parameters(9) = struct('Name', 'cc2', 'Unit', 'J/°C^3', 'Value',  cc2, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  % kas
  kas0 = 0.02;
  parameters(10) = struct('Name', 'kas0', 'Unit', 'W/°C', 'Value',  kas0, ...
                       'Minimum', 0, 'Maximum', inf, 'Fixed', false);
  kas1 = 0; 
  parameters(11) = struct('Name', 'kas1', 'Unit', 'W/°C^2', 'Value',  kas1, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  kas2 = 0;
  parameters(12) = struct('Name', 'kas2', 'Unit', 'W/°C^3', 'Value',  kas2, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', true);                    
  % kab
  kab0 = 0.02;
  parameters(13) = struct('Name', 'kab0', 'Unit', 'W/°C', 'Value',  kab0, ...
                       'Minimum', 0, 'Maximum', inf, 'Fixed', false);
  kab1 = 0; 
  parameters(14) = struct('Name', 'kab1', 'Unit', 'W/°C^2', 'Value',  kab1, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  kab2 = 0; 
  parameters(15) = struct('Name', 'kab2', 'Unit', 'W/°C^3', 'Value',  kab2, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', true); 
  % kbs
  kbs0 = 0.0;
  parameters(16) = struct('Name', 'kbs0', 'Unit', 'W/°C', 'Value',  kbs0, ...
                       'Minimum', 0, 'Maximum', inf, 'Fixed', false);
  kbs1 = 0.0;
  parameters(17) = struct('Name', 'kbs1', 'Unit', 'W/°C^2', 'Value',  kbs1, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', false);
  kbs2 = 0; 
  parameters(18) = struct('Name', 'kbs2', 'Unit', 'W/°C^3', 'Value',  kbs2, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', true);   
  % kbc
  kbc0 = 1.15;
  parameters(19) = struct('Name', 'kbc0', 'Unit', 'W/°C', 'Value',  kbc0, ...
                       'Minimum', 0, 'Maximum', inf, 'Fixed', false);
  kbc1 = 0; 
  parameters(20) = struct('Name', 'kbc1', 'Unit', 'W/°C^2', 'Value',  kbc1, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  kbc2 = 0; 
  parameters(21) = struct('Name', 'kbc2', 'Unit', 'W/°C^3', 'Value',  kbc2, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', true); 
  % kcs
  kcs0 = 0.029;
  parameters(22) = struct('Name', 'kcs0', 'Unit', 'W/°C', 'Value',  kcs0, ...
                       'Minimum', 0, 'Maximum', inf, 'Fixed', false);
  kcs1 = 0;
  parameters(23) = struct('Name', 'kcs1', 'Unit', 'W/°C^2', 'Value',  kcs1, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', true);
  kcs2 = 0; 
  parameters(24) = struct('Name', 'kcs2', 'Unit', 'W/°C^3', 'Value',  kcs2, ...
                       'Minimum', -inf, 'Maximum', inf, 'Fixed', true);   
end
%% initialize labels for state, input and output variables
varLabels.TimeUnit   = 'seconds';
if     one_state
  % State variables:    x = [Ta]
  % Input:              u = [input power, Ta, Ts]
  % Output:             y = [Ta];
  varLabels.StateName  = {'T-Core'};
  varLabels.StateUnit  = {'°C'};
  varLabels.InputName  = {'Input Power', 'T-core',...
                              'T_Outer'};
  varLabels.InputUnit  = {'Watts', '°C', '°C'};
  varLabels.OutputName = {'T-Core'};
  varLabels.OutputUnit = {'°C'};
  
elseif two_state
  % State variables:    x = [T_a, T_b] Temperatures proximal and distal to heat
  %                                    source respectively
  % Output:             y = [T_a, T_b];
  varLabels.StateName  = {'T_Core', 'T_Inner'};
  varLabels.StateUnit  = {'°C', '°C'};
  varLabels.OutputName = {'T-core', 'T-Inner'};
  varLabels.OutputUnit = {'°C', '°C'};
  if two_state_2_a_node_inputs
  % Input:              u = [heater power, core-Q-power, T_a, T_b, Ts]
    varLabels.InputName  = {'Heater Power', 'Core-Q-Power', 'T_Core', ...
                            'T_Inner', 'T_Outer'};
    varLabels.InputUnit  = {'Watts', 'Watts', '°C', '°C', '°C'};
  else
  % Input:              u = [input power, T_a, T_b, Ts]
    varLabels.InputName  = {'Input Power','T_Core', ...
                            'T_Inner', 'T_Outer'};
    varLabels.InputUnit  = {'Watts', '°C', '°C', '°C'};  
  end
  
elseif three_state
  % State variables:    x = [T_a, T_b, Tc]
  % Input:              u = [core-Q-power, heater power, T_a, T_b, Tc, Ts]
  % Output:             y = [T_a, T_b];
  if ~isempty(strfind(model_type, 'measure Tb and Tc'));
    varLabels.StateName  = {'Ta', 'T_Core', 'T_Inner'};
    varLabels.InputName  = {'Core-Q-Power', 'Heater Power', 'Ta', 'T_Core', ...
                          'T_Inner', 'T_Outer'};
    varLabels.OutputName = {'T-core', 'T-Inner'};
    varLabels.OutputUnit = {'°C', '°C'};
  elseif ~isempty(strfind(model_type, 'measure Ta and Tc'));
    varLabels.StateName  = {'T_Core', 'Ta', 'T_Inner'};
    varLabels.InputName  = {'Core-Q-Power', 'Heater Power', 'T_Core', 'Tb', ...
                          'T_Inner', 'T_Outer'};
    varLabels.OutputName = {'T-core', 'T-Inner'};
    varLabels.OutputUnit = {'°C', '°C'};
  elseif ~isempty(strfind(model_type, 'a and c sources'));
    varLabels.StateName  = {'T_Core-a', 'T_Inner', 'T_Core-c'};
    varLabels.InputName  = {'Core-Q-Power', 'Heater Power', 'T_Core-a', 'T_inner', ...
                          'T_Core-c', 'T_Outer'};
    varLabels.OutputName = {'T-core-a', 'T-Inner', 'T-core-c'};
    varLabels.OutputUnit = {'°C', '°C', '°C'};
  end
  varLabels.StateUnit  = {'°C', '°C', '°C'};
  varLabels.InputUnit  = {'Watts', 'Watts', '°C', '°C', '°C', '°C'}; 

end

end

