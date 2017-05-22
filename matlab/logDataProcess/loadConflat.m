%clean  
QPulseLengthns = QPulseLength0x28ns0x29; clear QPulseLength0x28ns0x29
power = 'q';
if isDC
  power = 'dc';
end  
plotTitle =strcat(tmpDir,'-',runDate,'-',power,'-',gas); 
%change datetime to number
rawData = horzcat(dateN,...
     SeqStepNum,...
     CoreHtrPow,...
     CoreReactorTemp,...
     QPulseLengthns,...
     QKHz,...
     QPow,...
     TerminationThermPow,...
     CoreGasIn,...
     CoreGasOut,...
     H2MakeupLPM,...
     PowOut);

%show startOffset and endOffset
DateTime(1+int16(startOffset*360))
DateTime(end - int16(endOffset*360))
rawData = rawData(1+int16(startOffset*360):end-int16(endOffset*360),:);
%(isnan(j1)) = -2 ;
rawData = rawData(rawData(:,2) > 0,:); %only process data with seq
%rawData(any(isnan(rawData)),:)=[]; %take out rows with NaN but not a good code
%rawData(any(isnan(rawData),2),:)=[];
%asignColumn name 
rawDataN = dataset({rawData,'dateN',...
     'SeqStepNum',...
     'HeaterPower',...
     'CoreTemp',...
     'QPulseLengthns',...
     'QKHz',...
     'QPow',...
     'TerminationThermPow',...
     'CoreGasIn',...
     'CoreGasOut',...
     'H2MakeupLPM',...
     'PowOut'});
     %'HydrogenValves'}); 
dt = datetime(rawDataN.dateN, 'ConvertFrom', 'datenum') ;
if tsPlot
  plotConflatTS(dt,hp1,hp2,rawDataN,plotTitle,pos,figname);
end 