function plotWaveFormSummary(M,max2,min2,frequency,filterValue,firstP,lastP,first1,first2,last1,last2,pos,figname,tt,p1,visible)   

   p3 = char(strcat('max(v1) = ', num2str(max2),' min(v1) = ', num2str(min2), ' frequency = ',num2str(frequency),'kHz filter noise = ', num2str(filterValue,2)));
   y = [min2(1),max2(1)];
   f2 = figure('Position',pos,'visible',visible);
   subplot(3,1,1);
   suptitle(tt); 
   plot(M(:,1),M(:,2),M(:,1),M(:,3))
   grid on;
   grid minor;
   xlabel('time');
   %set(gca,'XTick',[]);
   ylabel('[volt]');
   dim = [0.14 0.57 0.1 0.1];
   % dim = [0.15 0.25 0.5 0.5];
 
   annotation('textbox',dim,'String',p3,'FitBoxToText','on'); 
   subplot(3,1,2);
   grid on;
   grid minor;
   hold on;
   set(gca,'XTick',[]);
   %annotation('textbox',[0.14,0.78,0.1,0.1],'String',p3,'FitBoxToText','on');
   x=[M(firstP,1),M(firstP,1)];
   plot(M(first1:first2,1),M(first1:first2,2),M(first1:first2,1),M(first1:first2,3))
   dim = [0.14 0.27 0.1 0.1];
   %xlabel('time');
   ylabel('[volt]');
   annotation('textbox',dim,'String',p1,'FitBoxToText','on');

   plot(x,y,'black');
   text(x(1),y(2),'trim first pulse before \leftarrow','HorizontalAlignment','right');
   hold off;
   %set(gca,'XTick',[]);
   subplot(3,1,3);
   grid on;
   grid minor;
   x=[M(lastP,1),M(lastP,1)];
   hold on;
   plot(M(last1:last2,1),M(last1:last2,2),M(last1:last2,1),M(last1:last2,3))
   plot(x,y,'black');
   set(gca,'XTick',[]);
   %xlabel('time');
   ylabel('[volt]');
   text(x(1),y(2),'\rightarrow trim last pulse after');
   hold off;
   export_fig(f2,figname,'-append');
end   