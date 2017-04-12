function [fp] = expFit1(data,figname,pos,delta)
%titleS = strcat(tStr,'-hp=',num2str(hp,4),'-coreT=',num2str(coreT,3));
[m,n] = size(data);
f3 = figure('Position',pos);
for i = 1:n
  for j = 1:m-1
    if abs(data(j,i)-data(j+1,i)) > delta  
      x = j:m;
      f = fit(x',data(j:m,i),'exp2');
      fp = coeffvalues(f);
      t = char(strcat('v',i,'-a*exp(b*t)+c*exp(d*t),a=',num2str(fp(1)),' b=',num2str(fp(2)),' c=',num2str(fp(3)),' d=',num2str(fp(4))));
      subplot(3,1,i);
      plot(f,x1,data);

xlabel(t);
      x = 1:m;
f = fit(x',data,'exp2');

if (true)

grid on;
grid minor;
hold on;
%ylabel('Hp(w)');
%title(titleS);  

%subplot(3,,seq2);
%b = gca; legend(b,'off');

%b = gca; legend(b,'off');
export_fig(f3,figname,'-append');
end
%legend(l2,'Location','northwest');
%fn = ['C:\jinwork\BEC\tmp\',titleS, '.csv'];
%T = table(data,'VariableName',{'hp'});
%writetable(T,fn);                
end
