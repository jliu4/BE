function helperFrequencyAnalysisPlot1(F,Ymag,Yangle,NFFT,ttlMag,label,ttlPhase)
% Plot helper function for the FrequencyAnalysisExample

% Copyright 2012 The MathWorks, Inc.

figure
subplot(2,1,1)
plot(F(1:NFFT/2)/1e3,20*log10(Ymag(1:NFFT/2)));
if nargin > 4 && ~isempty(ttlMag)
  tstr = {'Magnitude response of the waveform ',ttlMag};
else
  tstr = {'Magnitude response of the waveform'};
end
title(tstr)
xlabel('Frequency in kHz')
ylabel(label)
grid on;
axis tight 
subplot(2,1,2)
plot(F(1:NFFT/2)/1e3,Yangle(1:NFFT/2));
if nargin > 6
  tstr = {'Phase response of the waveform',ttlPhase};
else  
  tstr = {'Phase response of the waveform'};
end
title(tstr)
xlabel('Frequency in kHz')
ylabel('radians')
grid on;
axis tight