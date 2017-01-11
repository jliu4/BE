function [fp] = expFit(data)
x = 1:length(data);
x1 = reshape(x,[length(data),1]);
f = fit(x1,data,'exp2');
fp = coeffvalues(f);
%figure
%plot(f,x1,data);
end