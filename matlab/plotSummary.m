function [tt,hpdrop,v12,dqp,v122,hv,res,hv0,hqp0,res0,power,gas] = plotSummary(pdata,pd,isDC,isHe,efficiency,ai )
% Create palette
%palette = hsv(K + 1);
%colors = palette(idx, :);
%set dc vs.q and he vs.h2
power = 'q';
if isDC
  power = 'dc';
end  
gas = 'h2';
if isHe
  gas = 'he';
end   
%get unique coreT
uniqCT = unique(int16(pd.coreT));
tt=[];hpdrop=[];qp=[];tp=[];pp=[];v12=[];v122=[];
i = 0;
for ti = 1:numel(uniqCT)
  tdata = pdata(int16(pdata(:,1)) == uniqCT(ti),:);
  if size(tdata,1) > 4 && tdata(1,9) < 5
  i = i + 1;
  tt(i,ai) = uniqCT(ti);
  %condition is pdata.coreQPow = 0
 % if tdata(1,9) < 5
 % assume the first row in the temperature mode is no q and dc power.
    hp0 = tdata(1,6);
    qp0 = tdata(1,9);
    termP0 = tdata(1,10);
    pcbP0 = tdata(1,11);
 % else   
    %hp0=tdata(end,6));
    %qp0=tdata(end,9);
    %termP0=tdata(end,10);
    %pcbP0 = tdata(end,11);
%  end  
  if isDC 
    qtdata = tdata(2:end-1,:);
    hpdrop(:,i,ai) = hp0-qtdata(:,6);
    v12(:,i,ai)= qtdata(:,13);%qsupplyPower
    dqp(:,i,ai) = qtdata(:,12); %power    
  else    
    qtdata = tdata(2:end-1,:);
    hpdrop(:,i,ai) = hp0-qtdata(:,6);
    v12(:,i,ai)= qtdata(:,7)-qtdata(:,8) ;
    qp(:,i) = qtdata(:,9) - qp0;
    tp(:,i) = qtdata(:,10) - termP0;
    pp(:,i) = qtdata(:,11) - pcbP0;
    dqp(:,i,ai) = qp(:,i)-(tp(:,i)+pp(:,i))/efficiency;
  end  
  v122=v12.*v12;
  hv = hpdrop./v122;
  res = v122./dqp;
 
  hv0(i,ai) = v122(:,i,ai)\hpdrop(:,i,ai);  
  hqp0(i,ai) = dqp(:,i,ai)\hpdrop(:,i,ai);   
  res0(i,ai) = dqp(:,i,ai)\v122(:,i,ai);
  end
end

end
  

