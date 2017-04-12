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
      grid on;
      grid minor;
      plot(f,x',data);
      xlabel(t);
      continue;
    end
  end
end
            
end
