function plotFFT1_4x(M,t1,t2,pos,figname,tt,Fs,bandwidth,visible )
     f1 = figure('Position',pos,'visible',visible);
 
     nfft = length(M(t1:t2,1));
    
   
     bin = Fs/nfft
     segmentLength =  Fs/bin/10e6
     bin = bandwidth;
     segmentLength =  Fs/bin/10e6
     
     infft2 = int32(nfft/2);
     F = ((0:1/nfft:1-1/nfft)*Fs).';
     subplot(2,2,1)
     suptitle(tt); 
     x = M(t1:t2,1)-M(t1,1);
     plot(x,M(t1:t2,2)); 
     %plot(x,M(t1:t2,2),x,M(t1:t2,3),x,M(t1:t2,4)); 
     grid on;
     grid minor;
     ylabel('[volt]');
     xlabel('time[s]');
     legend('v1');
     %y = M(t1:t2,2).*win;
     %ydft = fft(y);
     %my = abs(ydft);
     %axis tight  
     %nfft = length(M(:,1)); 
     Y1 = fft(M(t1:t2,2),nfft);
     
    
     mY1 = abs(Y1);
     
   
     pY1 = unwrap(angle(Y1));
   
  
     Y11 = fftshift(Y1);
    %figure;
    % plot(F(1:nfft/2)/1e6, 20*log10(abs(Y1(1:nfft/2))),F(1:nfft/2)/1e6,20*log10(abs(ydft(1:nfft/2))));
    % title('magnitude FFT');
    % xlabel('Frequency (mHz)');
    % ylabel('magnitude');
     
     subplot(2,2,2)
      [PSD1,F1]  = pwelch(M(t1:t2,2),ones(segmentLength,1),0,nfft,Fs,'power');
    
      plot(F1/1e6,10*log10(PSD1));
           xlabel('Frequency in MHz');
           grid on;
     grid minor;
     yy =strcat('Power spectrum in dB, bandwidth =', num2str(bin),'MHz'); 
      ylabel(yy);
      legend('v1');
      ax = axis;
     %axis([0 300 ax(3:4)])
     %%
     %%mY1(1) = 0;% remove the DC component for better visualization
     %%plot(F(1:nfft/2)/1e6, 10*log10(mY1(1:nfft/2)),F(1:nfft/2)/1e6, 10*log10(mY2(1:nfft/2)));
     %%title('magnitude response');
     %%xlabel('Frequency (MHz)');
     %%ylabel('magnitude');
     %%legend('v1','v2');
     %%ax = axis;
     %%
     axis([0 300 ax(3:4)])
     subplot(2,2,3)
     plot(F(1:nfft/2)/1e6,pY1(1:nfft/2));
     legend('v1');
     xlabel('Frequency in MHz')
     ylabel('Phase response in radians')
     grid on;
     grid minor;
     axis tight
     
     [P1,F1]=periodogram(M(t1:t2,2),[],nfft,Fs,'power');
    
     
     P1dBW = 10*log10(P1);
     power_at_DC_dBW1 = P1dBW(F==0)   % dBW
     fp = floor(power_at_DC_dBW1);
     [peakPowers_dBW, peakFreqIdx] = findpeaks(P1dBW,'minpeakheight',fp);
     peakFreqs_Hz = F(peakFreqIdx);
     np = length(peakFreqs_Hz)
     peakPowers_dBW;
      segmentLength = segmentLength/10;
      %bin = Fs/segmentLength/10e6
      bin = 0.1*bin;
     segmentLength = int32(Fs/bin/10e6)
     [P1,F1] = pwelch(M(t1:t2,2),ones(segmentLength,1),0,nfft,Fs,'power');
  
     subplot(2,2,4)
    % plot(F1/1e6,10*log10(P1),F2/1e6,10*log10(P2),F3/1e6,10*log10(P3));
     plot(F1/1e6,10*log10(P1));
     grid on;
     grid minor;
      xlabel('Frequency in MHz');
      yy =strcat('Power spectrum in dB, bandwidth =', num2str(bin),'MHz'); 
      ylabel(yy);
      legend('v1');
     ax = axis;
     axis([0 300 ax(3:4)])
     %axis([0 peakFreqs_Hz(np)/1e6 ax(3:4)])
 
  export_fig(f1,figname,'-append');

end

