function [fp] = expFit(data,figname,hp,coreT,tStr,seq2,ff,pos,ct)
titleS = strcat(tStr,'-hp=',num2str(hp,4),'-coreT=',num2str(coreT,3));
decay = 0;
x = 1:length(data);
x1 = reshape(x,[length(data),1]);
f = fit(x1,data,'exp2');
fp = coeffvalues(f);
if (true)
%jj=figure(ff);

%hold on;

if ct == 1 && seq2 < 26
deltaT = 0.3; % 1 degree
fexp = figure('Position',pos);
grid on;
grid minor;

%subplot(5,5,seq2);
%b = gca; legend(b,'off');
plot(f,x1,data);
ylabel('coreT');
title(titleS); 
if fp(2) < fp(4)
  a1 = abs(fp(1));
  p1 = fp(2);
else  
  a1 = abs(fp(3));
  p1 = fp(4);
end
decay = 10/3600*log(deltaT/a1)/p1;
tau = -10/3600/min(fp(2),fp(4));

txt1 = ['tau = ' num2str(tau,'%.2f') ', Time converge:' num2str(decay,'%.2f') ' hour'  ]; text(x1(1), data(1), txt1);
export_fig(fexp,figname,'-append');
end
%b = gca; legend(b,'off');
end
%legend(l2,'Location','northwest');
%fn = ['C:\jinwork\BEC\tmp\',titleS, '.csv'];
%T = table(data,'VariableName',{'hp'});
%writetable(T,fn);                
fp = [fp decay];

end