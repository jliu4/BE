function plotAligned(v1,v2s,v3s,M,fstMax,delta,zterm,figname,P0,P,c,alignV,alignP,riseTime,pos,tt,y,y1,visible,it1,it2,dvdt,mFactor,...
    riseTime12,dvdt12,j12)
        
  ifstMax = int32(fstMax);
  j1 = max(1,fstMax-delta); ij1 = int32(j1);
  iv1 = int32(v1);
  p2 = char(strcat('Pulse Alignment Method: mean((v1-v2)*v3)/Z = ',num2str(P,'%.2f'),' Z=', num2str(zterm), ' propagate speed = ',num2str(c,'%.2f'),'c rmsP/alignP = ',num2str(P0/P,'%.2f') ));
  p3 = [num2str(mFactor*100) '%=' num2str(M(ifstMax,2))  '\rightarrow'];
  p4 = ['\leftarrow aligned at ' num2str(alignP*100) '%=' num2str(M(iv1+ij1,2))];
  p5 = ['riseTime:' num2str(riseTime,'%.1f') 'ns; dvdt:' num2str(dvdt,'%.1f') 'v/ns\rightarrow'];
  p6 = ['riseTime12:' num2str(riseTime12,'%.1f') 'ns; dvdt12:' num2str(dvdt12,'%.1f') 'v/ns\rightarrow'];
  plot(M(ij1+iv1,1),alignV, '^g','MarkerFaceColor','g')
   
   t1 = max(1,ifstMax - it1);
   t2 = min(ifstMax + it2,size(M,1));
   f1 = figure('Position',pos,'visible',visible);
   %if (v2s > 0 && v3s > 0)
   subplot(3,1,1);
   
   %hold on;
   suptitle(tt); 
   x = [M(ifstMax,1),M(ifstMax,1)];
   x1=[M(ifstMax-delta+iv1,1),M(ifstMax-delta+iv1,1)];
   
   dim = [0.14 0.6 0.1 0.1];
   annotation('textbox',dim,'String',p2,'FitBoxToText','on');
   hold on;
   plot(M(t1:t2,1),M(t1:t2,2),M(t1:t2,1),M(t1:t2,3),M(t1:t2,1),M(t1:t2,4))
   plot(x,y1,'black','linewidth',1);
   plot(x1,y1,'black','linewidth',1);
   plot(M(ifstMax,1),M(ifstMax,2), '^r', 'MarkerFaceColor','r')
   text(M(ifstMax,1),M(ifstMax,2), p3,'HorizontalAlignment','right');
   grid on;
   grid minor;
   text(x1(1),y, p5,'HorizontalAlignment','right');
   hold off;
   legend('v1','v2','v3');
   set(gca,'XTick',[]);
   
   subplot(3,1,2);
   grid on;
   grid minor;
   hold on;
   v12 = 0.5*(M(t1:t2-v2s,2) + M(t1+v2s:t2,3));
  
   plot(M(t1:t2,1),M(t1:t2,2),M(t1:t2-v2s,1),M(t1+v2s:t2,3),M(t1:t2-v3s-v2s,1),M(t1+v3s+v2s:t2,4))
   plot(M(t1:t2-v2s,1),v12);
   plot(x1,y1,'black','linewidth',1);
   grid on;
   grid minor;
   plot(M(ij1+iv1,1),M(ij1+iv1,2), '^g', 'MarkerFaceColor','g')
   text(M(ij1+iv1,1),M(ij1+iv1,2), p4);
   
   plot(M(ij1+iv1+j12,1),v12(ij1+iv1+j12-t1), '^c', 'MarkerFaceColor','c')
   text(M(ij1+iv1+j12,1),v12(ij1+iv1+j12-t1), p6,'HorizontalAlignment','right');
   %dim = [0.14 0.6 0.1 0.1];
   %dim = [0.14 0.27 0.1 0.1];
   %annotation('textbox',dim,'String',p6,'FitBoxToText','on');
  
   %plot(x1(1),alignV, '^g', 'MarkerFaceColor','g')
   %text(x1(1),alignV,p4);
   
   hold off;
   %dim = [0.14 0.3 0.1 0.1];
   %annotation('textbox',dim,'String',p2,'FitBoxToText','on');
   legend('v1','v2','v3','(v1+v2)/2');
   set(gca,'XTick',[]);
   subplot(3,1,3);
   grid on;
   grid minor;
   deltaV = (M(t1:t2-v2s,2)-M(t1+v2s:t2,3));
   P = deltaV(1:end-v3s).*M(t1+v3s+v2s:t2,4)/zterm;
   yyaxis left
   plot(M(t1:t2-v2s,1),deltaV);
   grid on;
   grid minor;
   ylabel('v1-v2');
   yyaxis right
   plot(M(t1:t2-v3s-v2s,1),P);
   ylabel('Instantaneous Pulse Power');
   export_fig(f1,figname,'-append');

end

