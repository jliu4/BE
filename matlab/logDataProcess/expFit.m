function [fp] = expFit(data,figname,hp,coreT,tStr,seq2,ff)
%titleS = strcat(tStr,'-hp=',num2str(hp,4),'-coreT=',num2str(coreT,3));
x = 1:length(data);
x1 = reshape(x,[length(data),1]);
f = fit(x1,data,'exp2');
fp = coeffvalues(f);
if (false)
figure(ff);
grid on;
grid minor;
hold on;
%ylabel('Hp(w)');
%title(titleS);  
if seq2 < 26
subplot(5,5,seq2);
%b = gca; legend(b,'off');
plot(f,x1,data);
b = gca; legend(b,'off');
end
%legend(l2,'Location','northwest');
%fn = ['C:\jinwork\BEC\tmp\',titleS, '.csv'];
%T = table(data,'VariableName',{'hp'});
%writetable(T,fn);                
end
end