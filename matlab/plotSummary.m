function [tt,icT,hpdrop,v12,dqp,v122,hv,res,hva,hvb,hqpa,hqpb,resa,resb,hv0,hqp0,res0] = plotSummary(pdata,isDC,efficiency,ai)
%pdata = horzcat(coreT', inT', outT', ql', qf', hp', v1', v2', qPow', termP', pcbP', qSP', qSV', h2',coreQPow');
% Create palette
%palette = hsv(K + 1);
%colors = palette(idx, :);
%set dc vs.q and he vs.h2
 %tt=[];hpdrop=[];v12=[];dqp=[];v122=[];hv=[];res=[];hv0=[];hqp0=[];res0=[];
%get unique coreT
uniqCT = unique(int16(pdata(:,1)));
uniqCT(uniqCT>402)=[];
uniqCT(uniqCT<198)=[];
%tt=[];hpdrop=[];qp=[];tp=[];pp=[];v12=[];dqp=[];v122=[];hv=[];res=[];termp=[];pcbp=[];hv0=[];hqp0=[];res0=[];
i = 0;
for ti = 1:numel(uniqCT) 
  tdata = pdata(int16(pdata(:,1)) == uniqCT(ti),:);
  %exception 
  %we have to have at least 4 data points the first row needs to be no powerfor 
  if size(tdata,1) > 4 %&& tdata(1,9) < 5 
  i = i + 1;
  tt(i,ai) = uniqCT(ti);
  %condition is pdata.coreQPow = 0
 % if tdata(1,9) < 5
 % assume the first row in the temperature mode is no q and dc power.
    hp0 = min(tdata(1,6),tdata(end,6)); %sometimes the first row is not converged yet
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
    if size(qtdata,1) < 5 %hike here
       qtdata(5,:)=qtdata(end-1,:);
    end   
    hpdrop(:,i,ai) = hp0-qtdata(:,6);
    v12(:,i,ai)= qtdata(:,7)-qtdata(:,8) ;
    qp(:,i,ai) = qtdata(:,9) - qp0;
    termp(:,i,ai) = qtdata(:,10) - termP0;
    pcbp(:,i,ai) = qtdata(:,11) - pcbP0;
    %dqp(:,i,ai) = qp(:,i,ai)-(termp(:,i,ai)+pcbp(:,i,ai))/efficiency;
    dqp(:,i,ai) = qp(:,i,ai)-(termp(:,i,ai))/efficiency;
    dqp(:,i,ai)=qtdata(:,15); %use coreQpow instead
  end  
  cT(:,i,ai) = qtdata(:,1);
  inT(:,i,ai) = qtdata(:,2);
  
  v122=v12.*v12;
  hv = hpdrop./v122;
  res = v122./dqp;
  %hv10(:,i,ai) = fitlm(v122(:,i,ai),hpdrop(:,i,ai),'RobustOpts','on');
  hv10(:,i,ai)=polyfit(v122(:,i,ai),hpdrop(:,i,ai),1);
  hva(i,ai)=hv10(1,i,ai);
  hvb(i,ai)=hv10(2,i,ai);
  hv0(i,ai) = v122(:,i,ai)\hpdrop(:,i,ai); 
  hqp10(:,i,ai)=polyfit(dqp(:,i,ai),hpdrop(:,i,ai),1);
  hqpa(i,ai)=hqp10(1,i,ai);
  hqpb(i,ai)=hqp10(2,i,ai);
  hqp0(i,ai) = dqp(:,i,ai)\hpdrop(:,i,ai);
  res10(:,i,ai)=polyfit(dqp(:,i,ai),v122(:,i,ai),1);
  resa(i,ai)=res10(1,i,ai);
  resb(i,ai)=res10(2,i,ai);
  res0(i,ai) = dqp(:,i,ai)\v122(:,i,ai);
  %icT1=polyfit(cT(:,i,ai),inT(:,i,ai),1);
  icT(i,ai) = cT(:,i,ai)\ inT(:,i,ai);
  end
end

end
  

