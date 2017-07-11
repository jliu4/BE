function plotFFT1(M,t1,t2,pos,figname,tt,Fs,xrange,visible )
     f1 = figure('Position',pos,'visible',visible);
 
     nfft = length(M(t1:t2,1));
     infft2 = int32(nfft/2);
    % fre = numPoint/nfft
     subplot(2,2,1)
     suptitle(tt); 
     x = M(t1:t2,1)/M(1,1);
     plot(x,M(t1:t2,2),x,M(t1:t2,3),x,M(t1:t2,4)); 
     grid on;
     grid minor;
     ylabel('volt');
     xlabel('time');
     legend('v1','v2','v3');
     %axis tight  
     %nfft = length(M(:,1)); 
     Y1 = fft(M(t1:t2,2),nfft);
     %take out DC
     %Y1(1) =0;
     Y2 = fft(M(t1:t2,3),nfft);
     %Y2(1) =0;
    
     Y3 = fft(M(t1:t2,4),nfft);
     %Y3(1) =0;
     F = ((0:1/nfft:1-1/nfft)*Fs).';
     mY1 = abs(Y1);
     mY2 = abs(Y2);
     mY3 = abs(Y3);
     pY1 = unwrap(angle(Y1));
     pY2 = unwrap(angle(Y2));
     pY3 = unwrap(angle(Y3));
     subplot(2,2,2)
     %yyaxis left
     %plot(F(1:nfft/2)/1e6,20*log10(mY1(1:nfft/2)),F(1:nfft/2)/1e6,20*log10(mY2(1:nfft/2)),F(1:nfft/2)/1e6,20*log10(mY3(1:nfft/2)));
     plot(F(1:infft2)/1e6,20*log10(mY1(1:infft2)));
     %plot(F(1:nfft/2)/1e3,mY1(1:nfft/2),F(1:nfft/2)/1e3,mY2(1:nfft/2),F(1:nfft/2)/1e3,mY3(1:nfft/2));
     grid on;
     grid minor;
     %legend('v1','v2','v3');
     ylabel('v1 dB Magnitude of FFT [volt^2]')
     %yyaxis right
     %cla
     %cla reset
     %plot(F(1:nfft/2)/1e5,pY1(1:nfft/2),F(1:nfft/2)/1e3,pY2(1:nfft/2),F(1:nfft/2)/1e3,pY3(1:nfft/2));
     %grid on;
     %grid minor;
     %ylabel('radians')
     %tstr = {'Magnitude response of the waveform'};
     xlabel('Frequency in mHz')
     ax = axis;
     axis([0 xrange*1e2 ax(3:4)])
     axis([0 150 ax(3:4)])
     subplot(2,2,3);
     grid on;
     F1 = (0:1/nfft:1/2-1/nfft)*Fs;
     [P1,F]=periodogram(M(t1:t2,2),[],nfft,Fs,'power');
     [P2,F]=periodogram(M(t1:t2,3),[],nfft,Fs,'power');
     [P3,F]=periodogram(M(t1:t2,4),[],nfft,Fs,'power');
 
     %plot(F/1e3,10*log10(P1),F/1e3,10*log10(P2),F/1e3,10*log10(P3));
     %legend('v1','v2','v3');
     %plot(F1/1e3,(Y1(1:nfft/2)),F1/1e3,(Y2(1:nfft/2)),F1/1e3,(Y3(1:nfft/2)));
     plot(F(1:infft2)/1e6,20*log10(mY2(1:infft2))); 
     grid on;
     grid minor;
     xlabel('Frequency in mHz')
     %ylabel('Power spectrum (dBW)')
     ylabel('v2 dB Magnitude of FFT [volt^2]')
     %legend('v1','v2','v3');
     ax = axis;
     axis([0 150 ax(3:4)])
   

     %ax = axis;
     %axis([-0.5 1*1e8 ax(3:4)])
     subplot(2,2,4);
    
     %segmentLength = frequency;
     segmentLength = nfft;
     [P1,F]=pwelch(M(t1:t2,2),ones(segmentLength,1),0,nfft,Fs,'power');
     [P2,F]=pwelch(M(t1:t2,3),ones(segmentLength,1),0,nfft,Fs,'power');
     [P3,F]=pwelch(M(t1:t2,4),ones(segmentLength,1),0,nfft,Fs,'power');
      plot(F(1:infft2)/1e6,20*log10(mY3(1:infft2))); 
      %plot(F/1e6,20*log10(P1),F/1e6,20*log10(P2),F/1e6,20*log10(P3));
     %  plot(F/1e6,P1,F/1e6,P2,F/1e6,P3);
      grid on;
      grid minor;
      xlabel('Frequency in mHz')
      ylabel('v3 dB Magnitude of FFT [volt^2]');
      %ylabel('Power spectrum')
      %legend('v1','v2','v3');
      ax = axis;
      axis([0 150 ax(3:4)])
  export_fig(f1,figname,'-append');

end

