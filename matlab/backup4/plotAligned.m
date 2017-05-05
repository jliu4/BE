function plotAligned(v1,v2s,v3s,M,fstMax,delta,pulseWidthPoint,zterm,figname,P0,P,c,alignV,alignP,riseTime,pos,tt,p1,y,y1)
  p2 = char(strcat('Pulse Alignment Method: mean((v1-v2)*v3)/Z = ',num2str(P),' Z=', num2str(zterm), ' propagate speed = ',num2str(c),'c rmsP/alignP = ',num2str(P0/P) ));
  
   p4 = ['\leftarrow aligned at ' num2str(alignP*100)  '% pulse amplitude'];
   p5 = ['riseTime = ' num2str(riseTime) 'ns \rightarrow' ];
 t10 = max(800,pulseWidthPoint);
   t1 = max(1,fstMax - t10);
   t2 = fstMax + t10;
f1 = figure('Position',pos);
   if (v2s > 0 && v3s > 0)
   subplot(3,1,1);
   grid on;
   grid minor;
   %hold on;
   suptitle(tt); 
   x = [M(fstMax,1),M(fstMax,1)];
   x1=[M(fstMax-delta+v1,1),M(fstMax-delta+v1,1)];
   dim = [0.14 0.6 0.1 0.1];
   annotation('textbox',dim,'String',p1,'FitBoxToText','on');
   hold on;
   plot(M(t1:t2,1),M(t1:t2,2),M(t1:t2,1),M(t1:t2,3),M(t1:t2,1),M(t1:t2,4))
   plot(x,y1,'black','linewidth',1);
   plot(x1,y1,'black','linewidth',1);
   text(x1(1),y, p5,'HorizontalAlignment','right');
   hold off;
   legend('v1','v2','v3');
   set(gca,'XTick',[]);
   subplot(3,1,2);
   grid on;
   grid minor;
   hold on;
   plot(M(t1:t2,1),M(t1:t2,2),M(t1:t2-v2s,1),M(t1+v2s:t2,3),M(t1:t2-v3s,1),M(t1+v3s:t2,4))
   plot(x1,y1,'black','linewidth',1);
   text(x1(1),alignV,p4);
   hold off;
   dim = [0.14 0.3 0.1 0.1];
   annotation('textbox',dim,'String',p2,'FitBoxToText','on');
   legend('v1','v2','v3');
   set(gca,'XTick',[]);
   subplot(3,1,3);
   grid on;
   grid minor;
   deltaV = (M(t1:t2-v2s,2)-M(t1+v2s:t2,3));
   P = deltaV(1:end-v3s+v2s).*M(t1+v3s:t2,4)/zterm;
   yyaxis left
   plot(M(t1:t2-v2s,1),deltaV);
   ylabel('v1-v2');
   yyaxis right
   plot(M(t1:t2-v3s,1),P);
   ylabel('Instantaneous Pulse Power');
   
   else
   Ms = M(1 : downSample : end,:);
   t1s = max(1,fix(t1/downSample));
   t2s = fix(t2/downSample);
   subplot(2,1,1);
   grid on;
   grid minor;
   %hold on;
   suptitle(tt); 
   
   dim = [0.14 0.52 0.1 0.1];
   annotation('textbox',dim,'String',p1,'FitBoxToText','on');
   hold on;
   plot(Ms(t1s:t2s,1),Ms(t1s:t2s,2),Ms(t1s:t2s,1),Ms(t1s:t2s,3),Ms(t1s:t2s,1),Ms(t1s:t2s,4))
   %plot(x,y1);
   %xlabel(p1);
   hold off;
   legend('v1','v2','v3');
    
   %ylabel('V'); 
   set(gca,'XTick',[]);

   dim = [0.14 0.05 0.1 0.1];
   % dim = [0.15 0.25 0.5 0.5];
 
   annotation('textbox',dim,'String',p2,'FitBoxToText','on');
   
   legend('v1','v2','v3');
   set(gca,'XTick',[]);
   subplot(2,1,2);
   grid on;
   grid minor;
   deltaV = (Ms(t1s:t2s,2)-Ms(t1s:t2s,3));
   P = deltaV(1:end).*Ms(t1s:t2s,4)/zterm;
   yyaxis left
   plot(Ms(t1s:t2s,1),deltaV);
   ylabel('v1-v2');
   yyaxis right
   plot(Ms(t1s:t2s,1),P);
   ylabel('Instantaneous Pulse Power');
   %vpexp = expFit1(M(fstMax:fstMax+delta,2:4),figname,pos,2)
   end
%export_fig(f1,figname,'-append');

end

