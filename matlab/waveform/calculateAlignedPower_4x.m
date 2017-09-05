function [P,c,riseTime,v1,v2,v3,alignV,dvdt,riseTime12,dvdt12,j12]  = calculateAlignedPower_4x(fstMax,M,MM,delta,alignP,zterm,timeInterval,s2ns,coreL,inchNs,debug,tt,pi,mVolt)
   v1 = 0;
   v2 = 0;
   v3 = 0;
   c=0.3;
   riseTime12 = 0;
   dvdt12 = 0;
   j12 = 0;
   %align up   
   ifstMax = int32(fstMax);
   %it should be alignP * mVolt;
   signM = sign(M(ifstMax,2));
   alignV = alignP*signM*mVolt;
  % alignV = alignP*mVolt;
   %find the alignP% alignment for v2
   %sometimes the noise is too high, so increase alignP will solve the
   %problem.
   j1 = max(1,fstMax-delta); ij1 = int32(j1);
   ij2 = min(ifstMax+delta,size(M,1));
   [c1 v1] = min(abs(M(ij1:ij2,2)-alignV));
   iv1 = int32(v1);
   iv2 = iv1;
   
   %..j1..v1..v2..v3...j2

   riseTime = (fstMax-(v1+j1)) * timeInterval*s2ns;
   dvdt =abs((M(ifstMax,2)-M(iv1+ij1,2)))/riseTime;
   
   if debug
       
        disp(v1);
     
        disp(j12);
     figure;
    
     hold on
     plot(M(ij1:ij2,1),M(ij1:ij2,2:3));
    
    
     plot(M(ifstMax,1),M(ifstMax,2), '^r', 'MarkerFaceColor','r')
     plot(M(ij1+iv1,1),alignV, '^g','MarkerFaceColor','g')
    
      legend('v1','v2','(v1+v2)/2','80v1','10v1','10v2','10v3','80(v1+v2)/2');
     hold off
     grid
   end

   %calculate 0.5*(v1+v2) where probably the core most active part 
   
   deltaV = (MM(1:end-iv2,1)-MM(1+iv2:end,2)); 
   P = mean(deltaV(1:end).*MM(1+iv2:end,2))/zterm; %TODO abs
end

