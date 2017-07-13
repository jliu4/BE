function plotCNs(posArray,negArray,pos,figname,tt,visible)
  f5 = figure('Position',pos,'visible',visible);
   %if (v2s > 0 && v3s > 0)
   subplot(3,1,1)
   %hold on;
   suptitle(tt); 
   plot(posArray(:,1),posArray(:,2),'-x')
   grid on;
   grid minor;
   yyaxis left
   ylabel('c[speed light]');
   yyaxis right
   plot(posArray(:,1),posArray(:,3),'-o',posArray(:,1),posArray(:,8),'-*');
   legend('cPos','riseTimePos','riseTime12Pos');
   set(gca,'XTick',[]);
   grid on;
   grid minor;
   ylabel('riseTime[ns]');
   
   subplot(3,1,2)
   grid on;
   grid minor;
   %hold on; 
   plot(negArray(:,1),negArray(:,2),'-x')
   grid on;
   grid minor;
   yyaxis left
   ylabel('c[speed light]');
   yyaxis right
   plot(negArray(:,1),negArray(:,3),'-o',negArray(:,1),negArray(:,8),'-*');
   legend('c','riseTimeNeg','riseTime12Neg');
   set(gca,'XTick',[]);
   grid on;
   grid minor;
   ylabel('riseTime[ns]');
   subplot(3,1,3)
   grid on;
   grid minor;
   hold on; 
   plot(posArray(:,1),posArray(:,7),'-x');
   plot(negArray(:,1),negArray(:,7),'-o');
   plot(posArray(:,1),posArray(:,9),'-+');
   plot(negArray(:,1),negArray(:,9),'-*');
   grid on;
   grid minor;
   set(gca,'XTick',[]);
   ylabel('dv/dt[volt/ns]');
   legend('dv/dt-Pos','dv/dt-Neg','dv/dt12-Pos','dv/dt12-Neg');
   export_fig(f5,figname,'-append');

end

