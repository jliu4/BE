function [P,c,riseTime,v1s,v2s,v3s,alignV]  = calculateAlignedPower(fstMax,M,MM,delta,alignP,zterm,timeInterval,s2ns,coreL,inchNs,debug)
   v1s = 0;
   v2s = 0;
   v3s = 0;
   %align up   
   ifstMax = int32(fstMax);
   alignV = alignP*M(ifstMax,2);
   %find the alignP% alignment for v2
   j1 = max(1,fstMax-delta);
   ij1 = int32(j1);
  % [c1 v1s] = min(abs(M(fstMax-delta:fstMax+delta,2)-alignV));
  % [c2 v2] = min(abs(M(fstMax-delta:fstMax+delta,3)-alignV));
  % [c3 v3] = min(abs(M(fstMax-delta:fstMax+delta,4)-alignV));
   [c1 v1s] = min(abs(M(ij1:ifstMax,2)-alignV));
   
   [c2 v2] = min(abs(M(ij1+v1s:ifstMax,3)-alignV));
   
   [c3 v3] = min(abs(M(ij1+v1s:ifstMax,4)-alignV));
   if debug
   figure;
   
   hold on
  
   plot(M(ij1:ifstMax,1),M(ij1:ifstMax,2:4))
   plot(M(ifstMax,1),alignV, '^r', 'MarkerFaceColor','r')
   plot(M(ij1+v1s,1),alignV, '^g','MarkerFaceColor','g')
   plot(M(ij1+v1s+v2,1),alignV, '^k','MarkerFaceColor','k')
   plot(M(ij1+v1s+v3,1),alignV, '^c','MarkerFaceColor','c')
   hold off
   grid
   end
   %v1,v2,v3
   
   riseTime = (fstMax-(v1s+j1)) * timeInterval*s2ns;
   v2s = v2;
   
   c = coreL/(v2s*timeInterval)*inchNs/s2ns; %TODO JLIU
   
   v3s = v3;
 
   if v2s <0 || v3s < 0 || v3s-v2s < 0
       v2s = 0;
       v3s = 0;
   end 
   deltaV = (MM(1:end-v2s,1)-MM(1+v2s:end,2));
   P1 = deltaV(1:end-v3s+v2s).*MM(1+v3s:end,3);
   P = mean(deltaV(1:end-v3s+v2s).*MM(1+v3s:end,3))/zterm;
end

