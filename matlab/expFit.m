function [fp] = expFit(data,figname,hp,coreT,tStr)
titleS = strcat(tStr,'-hp=',num2str(hp,4),'-coreT=',num2str(coreT,3));
x = 1:length(data);
x1 = reshape(x,[length(data),1]);
f = fit(x1,data,'exp2');
fp = coeffvalues(f);
if (false)
ff=figure;
grid on;
grid minor;
hold on;
%ylabel('Hp(w)');
title(titleS);  
plot(f,x1,data);
%legend(l2,'Location','northwest');
%fn = ['C:\jinwork\BEC\tmp\',titleS, '.csv'];
%T = table(data,'VariableName',{'hp'});
%writetable(T,fn);                
export_fig(ff,figname,'-append');
end
end