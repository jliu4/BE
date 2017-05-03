function plotCNs(posArray,negArray,pos,figname,tt)
  f5 = figure('Position',pos);

   %if (v2s > 0 && v3s > 0)
   subplot(2,1,1)
   grid on;
   grid minor;
   %hold on;
   suptitle(tt); 
   
   plot(posArray(:,1),posArray(:,2))
   yyaxis left
   ylabel('c');
  
  
   yyaxis right
    plot(posArray(:,1),posArray(:,3));
   ylabel('RiseTime');
   
   subplot(2,1,2)
   grid on;
   grid minor;
   %hold on; 
   
   plot(negArray(:,1),negArray(:,2))
   yyaxis left
   ylabel('c');
  
  
   yyaxis right
    plot(negArray(:,1),negArray(:,3));
   ylabel('RiseTime');


   export_fig(f5,figname,'-append');

end

