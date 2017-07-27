function plotFFT1(M,t1,t2,pos,figname,tt,Fs,xrange,visible )
     f1 = figure('Position',pos,'visible',visible);
 
     nfft = length(M(t1:t2,1));
     infft2 = int32(nfft/2);
     F = ((0:1/nfft:1-1/nfft)*Fs).';
     subplot(2,2,1)
     suptitle(tt); 
     x = M(t1:t2,1)-M(t1,1);
     plot(x,M(t1:t2,2),x,M(t1:t2,3),x,M(t1:t2,4)); 
     grid on;
     grid minor;
     ylabel('[volt]');
     xlabel('time[s]');
     legend('v1','v2','v3');
     %axis tight  
     %nfft = length(M(:,1)); 
     Y1 = fft(M(t1:t2,2),nfft);
     Y2 = fft(M(t1:t2,3),nfft);
     Y3 = fft(M(t1:t2,4),nfft);
     mY1 = abs(Y1);
     
     mY2 = abs(Y2);
     mY3 = abs(Y3);
     pY1 = unwrap(angle(Y1));
     pY2 = unwrap(angle(Y2));
     pY3 = unwrap(angle(Y3));
    
  
     Y11 = fftshift(Y1);
    % figure;
     %plot(F(1:NFFT/2)/1e6, 20*log10(abs(Y11)));
     %title('magnitude FFT');
     %xlabel('Frequency (mHz)');
     %ylabel('magnitude');
     
     subplot(2,2,2)
     mY1(1) = 0;% remove the DC component for better visualization
     plot(F(1:nfft/2)/1e6, 10*log10(mY1(1:nfft/2)));
     title('magnitude response');
     xlabel('Frequency (mHz)');
     ylabel('magnitude');
     ax = axis;
     
     axis([0 50 ax(3:4)])
     subplot(2,2,3)
     plot(F(1:nfft/2)/1e6,pY1(1:nfft/2));
     
     xlabel('Frequency in mHz')
     ylabel('radians')
     grid on;
     axis tight
     [P1,F1]=periodogram(M(t1:t2,2),[],nfft,Fs,'power');
     [P2,F2]=periodogram(M(t1:t2,3),[],nfft,Fs,'power');
     [P3,F3]=periodogram(M(t1:t2,4),[],nfft,Fs,'power');
     
     P1dBW = 10*log10(P1);
     power_at_DC_dBW1 = P1dBW(F==0)   % dBW
     fp = floor(power_at_DC_dBW1);
     [peakPowers_dBW, peakFreqIdx] = findpeaks(P1dBW,'minpeakheight',fp);
     peakFreqs_Hz = F(peakFreqIdx);
     np = length(peakFreqs_Hz)
     peakPowers_dBW;
    segmentLength = int32(nfft/4);
    
     [P1,F1] = pwelch(M(t1:t2,2),ones(segmentLength,1),0,nfft,Fs,'power');
     [P2,F2] = pwelch(M(t1:t2,3),ones(segmentLength,1),0,nfft,Fs,'power');
     [P3,F3] = pwelch(M(t1:t2,4),ones(segmentLength,1),0,nfft,Fs,'power');
     subplot(2,2,4)
    % plot(F1/1e6,10*log10(P1),F2/1e6,10*log10(P2),F3/1e6,10*log10(P3));
     plot(F1/1e6,10*log10(P1));
      xlabel('Frequency in mHz');
      ylabel('Power spectrum (dBW)');
      %legend('v1','v2','v3');
     ax = axis;
     axis([0 50 ax(3:4)])
     %axis([0 peakFreqs_Hz(np)/1e6 ax(3:4)])
  [PSD,F]  = pwelch(M(t1:t2,2),ones(segmentLength,1),0,nfft,Fs,'psd');
  figure;
  plot(F/1e6,10*log10(PSD));
  ax = axis;
  axis([0 50 ax(3:4)])
  export_fig(f1,figname,'-append');

end

