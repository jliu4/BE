function [P,c,riseTime,v1,v2,v3,alignV]  = calculateAlignedPower(fstMax,M,MM,delta,alignP,zterm,timeInterval,s2ns,coreL,inchNs,debug,tt,pi)
   v1 = 0;
   v2 = 0;
   v3 = 0;
   %align up   
   ifstMax = int32(fstMax);
   alignV = alignP*M(ifstMax,2);
   %find the alignP% alignment for v2
   j1 = max(1,fstMax-delta); ij1 = int32(j1);
   ij2 = min(ifstMax+delta,size(M,1));
   [c1 v1] = min(abs(M(ij1:ij2,2)-alignV));
   iv1 = int32(v1);
   [c2 v2] = min(abs(M(ij1+iv1:ij2,3)-alignV));
   iv2=int32(v2);
   [c3 v3] = min(abs(M(ij1+iv1+iv2:ij2,4)-alignV));
   iv3=int32(v3);
   
   if debug
     figure;
     hold on
     plot(M(ij1:ij2,1),M(ij1:ij2,2:4))
     plot(M(ifstMax,1),M(ifstMax,2), '^r', 'MarkerFaceColor','r')
     plot(M(ij1+iv1,1),alignV, '^g','MarkerFaceColor','g')
     plot(M(ij1+iv1+iv2,1),alignV, '^k','MarkerFaceColor','k')
     plot(M(ij1+iv1+iv2+iv3,1),alignV, '^c','MarkerFaceColor','c')
     hold off
     grid
   end
   %..j1..v1..v2..v3...j2
   riseTime = (fstMax-(v1+j1)) * timeInterval*s2ns;
   c = coreL/(v2*timeInterval)*inchNs/s2ns; %TODO JLIU
   if (v2 <= 0) || (v3 <= 0)
     msg = strcat(tt,'-',num2str(pi),' v1=',num2str(v1),' v2=',num2str(v2),' v3=',num2str(v3),' c=', num2str(c),' riseTime=',num2str(riseTime));
     disp(msg);
     figure;
     hold on
     plot(M(ij1:ij2,1),M(ij1:ij2,2:4))
     plot(M(ifstMax,1),M(ifstMax,2), '^r', 'MarkerFaceColor','r')
     plot(M(ij1+iv1,1),alignV, '^g','MarkerFaceColor','g')
     plot(M(ij1+iv1+iv2,1),alignV, '^k','MarkerFaceColor','k')
     plot(M(ij1+iv1+iv2+iv3,1),alignV, '^c','MarkerFaceColor','c')
     hold off
     grid
     v2 = 0;
     v3 = 0;
     iv2 = 0;
     iv3= 0;
   end
   deltaV = (MM(1:end-v2,1)-MM(1+v2:end,2)); 
   P = mean(deltaV(1:end-v3).*MM(1+v3+v2:end,3))/zterm; %TODO abs
end

