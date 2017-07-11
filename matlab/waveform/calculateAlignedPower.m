function [P,c,riseTime,v1,v2,v3,alignV,dvdt,riseTime12,dvdt12,j12]  = calculateAlignedPower(fstMax,M,MM,delta,alignP,zterm,timeInterval,s2ns,coreL,inchNs,debug,tt,pi,mVolt)
   v1 = 0;
   v2 = 0;
   v3 = 0;
   %align up   
   ifstMax = int32(fstMax);
   %it should be alignP * mVolt;
   signM = sign(M(ifstMax,2));
   alignV = alignP*signM*mVolt;
  % alignV = alignP*mVolt;
   %find the alignP% alignment for v2
   j1 = max(1,fstMax-delta); ij1 = int32(j1);
   ij2 = min(ifstMax+delta,size(M,1));
   [c1 v1] = min(abs(M(ij1:ij2,2)-alignV));
   iv1 = int32(v1);
   [c2 v2] = min(abs(M(ij1+iv1:ij2,3)-alignV));
   iv2=int32(v2);
   [c3 v3] = min(abs(M(ij1+iv1+iv2:ij2,4)-alignV));
   iv3=int32(v3);
   
   %..j1..v1..v2..v3...j2

   riseTime = (fstMax-(v1+j1)) * timeInterval*s2ns;
   dvdt =abs((M(ifstMax,2)-M(iv1+ij1,2)))/riseTime;
   
   v12 = 0.5*(M(ij1+iv1:ij2-iv2,2) + M(ij1+iv1+iv2:ij2,3));
   
   j12 = find(signM*v12 > signM*M(ifstMax,2),1,'first');
   if isempty(j12)
    j12 = find(signM*v12 > 0.9*signM*M(ifstMax,2),1,'first');
     %sometimes max(0.5*(v1+v2)) is smaller than 80% max v2
     %so we reduce it 
   end
   
   riseTime12 = j12 * timeInterval*s2ns;
   dvdt12 =abs((v12(j12)-M(iv1+ij1,2)))/riseTime12;
   c = coreL/(v2*timeInterval)*inchNs/s2ns; %TODO JLIU
   
   if debug
     figure;
     hold on
     plot(M(ij1:ij2,1),M(ij1:ij2,2:4))
     plot(M(ij1+iv1:ij2-iv2,1),v12)
     plot(M(ifstMax,1),M(ifstMax,2), '^r', 'MarkerFaceColor','r')
     plot(M(ij1+iv1,1),alignV, '^g','MarkerFaceColor','g')
     plot(M(ij1+iv1+iv2,1),alignV, '^k','MarkerFaceColor','k')
     plot(M(ij1+iv1+iv2+iv3,1),alignV, '^c','MarkerFaceColor','c')
     plot(M(ij1+iv1+j12,1),v12(j12), '^b','MarkerFaceColor','b')
     hold off
     grid
   end
   if (v2 <= 0) || (v3 <= 0)
     msg = strcat(tt,'-',num2str(pi),' v1=',num2str(v1),' v2=',num2str(v2),' v3=',num2str(v3),' c=', num2str(c),' riseTime=',num2str(riseTime),...
         ' dvdt=',num2str(dvdt),' y1=',num2str(M(ifstMax,2)),...
     ' y2=',num2str(M(iv1+ij1,2)),' x1=', num2str(fstMax),' x2=',num2str(iv1+ij1));
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
 
   end
   %calculate 0.5*(v1+v2) where probably the core most active part 
   
   deltaV = (MM(1:end-iv2,1)-MM(1+iv2:end,2)); 
   P = mean(deltaV(1:end-iv3).*MM(1+iv3+iv2:end,3))/zterm; %TODO abs
end

