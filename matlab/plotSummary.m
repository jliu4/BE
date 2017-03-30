function [tt,icT,hpdrop,v12,dqp,v122,hv,res,hva,hvb,hqpa,hqpb,resa,resb,hv0,hqp0,res0,ql,...
    hqp0sse,res0sse,icTsse] = plotSummary(pdata,isDC,efficiency,temp1,temp2)
%pdata = horzcat(coreT', inT', outT', ql', qf', hp', v1', v2', v3',qPow', termP', pcbP', qSP', qSV', h2',coreQPow');
%asignColumn name 

uniqCT = unique(int16(pdata(:,1)));
uniqCT(uniqCT>(temp2+3))=[];
uniqCT(uniqCT<(temp1-2))=[];
%assume for each run all temperatures have the same q-pulse length
uniqQL = unique(int16(pdata(:,4)));
i = 0;
for ti = 1:numel(uniqCT) 
  tdata = pdata(int16(pdata(:,1)) == uniqCT(ti),:);
  %exception 
  %we have to have at least 4 data points the first row needs to be no powerfor 
  %TODO JLIU where DC and Q both power zero.
  %need to have at least three datapoints for each temperature, and the
  %first row and last row qpow = 0
  if size(tdata,1) > 4 %&& tdata(1,16) < 1 && tdata(end,16) < 1 
    i = i + 1;
    tt(i) = uniqCT(ti);
    %hp0 = min(tdata(1,6),tdata(end,6)); %sometimes the first row is not converged yet
    %hp0 = tdata(end,6); %sometimes the first row is not converged yet
    %assuming first a few points end is better and 
    if tt(i) >= 300
      %TODO JLIU hacked here  
      hp0 = tdata(1,6);
    else
      hp0 = tdata(end,6);
    end  
    qp0 = tdata(1,10);
    termP0 = tdata(1,11);
    pcbP0 = tdata(1,12);
    %hiked here to accomodate sri-ipb2-33-lowvoltage run
    qtdata = tdata(2:end-1,:);
    %also filter out qPow < 1
    %qtdata = qtdata(qtdata(:,10) > 0.9,:);
    if isDC  %assign DC as index =1 for QL
      hpdrop(:,1,i) = hp0-qtdata(:,6);
      v12(:,1,i)= qtdata(:,14);%qsupplyPower
      dqp(:,1,i) = qtdata(:,13); %power 
      ql(1,i)=0; %assume pulselength of dc = 0
    else         
       for qi = 1:numel(uniqQL)
          if qi == 1 
            ql(qi)=uniqQL(qi);
          end  
          qtdata = qtdata(int16(qtdata(:,4)) == uniqQL(qi),:); 
          %if size(qtdata,1) < 5 %hike here
          %  qtdata(5,:)=qtdata(end-1,:);
          %end   
          %only take the data with q-pulse, assume two ends of each
          %temperature has no q-pulse
          %qtdata = tdata(2:end-1,:); 
          hpdrop(:,qi,i) = hp0-qtdata(:,6);
          v12(:,qi,i)= qtdata(:,7)-qtdata(:,8) ;
          qp(:,qi,i) = qtdata(:,10) - qp0;
          termp(:,qi,i) = qtdata(:,11) - termP0;
          pcbp(:,qi,i) = qtdata(:,12) - pcbP0;
         %dqp(:,i,ai) = qp(:,i,ai)-(termp(:,i,ai)+pcbp(:,i,ai))/efficiency;
          dqp(:,qi,i) = qp(:,qi,i)-(termp(:,qi,i))/efficiency;
          dqp(:,qi,i)=qtdata(:,16); %use coreQpow instead
       end  
    end 
    for qi = 1:numel(uniqQL)
        
      cT(:,qi,i) = qtdata(:,1);
      inT(:,qi,i) = qtdata(:,2);
  
      v122 = v12.*v12;
      hv = hpdrop./v122;
      res = v122./dqp;
      %hv10(:,i,ai) = fitlm(v122(:,i,ai),hpdrop(:,i,ai),'RobustOpts','on');
      hv10(:,qi,i)=polyfit(v122(:,qi,i),hpdrop(:,qi,i),1);
      hva(qi,i)=hv10(1,qi,i);
      hvb(qi,i)=hv10(2,qi,i);
      hv0(qi,i) = v122(:,qi,i)\hpdrop(:,qi,i); 
      hqp10(:,qi,i)=polyfit(dqp(:,qi,i),hpdrop(:,qi,i),1);
      hqpa(qi,i)=hqp10(1,qi,i);
      hqpb(qi,i)=hqp10(2,qi,i);
      hqp0(qi,i) = dqp(:,qi,i)\hpdrop(:,qi,i);
      hqp0sse(qi,i) = norm(dqp(:,qi,i)* hqp0(qi,i)-hpdrop(:,qi,i))^2;
      res10(:,qi,i)=polyfit(dqp(:,qi,i),v122(:,qi,i),1);
      resa(qi,i)=res10(1,qi,i);
      resb(qi,i)=res10(2,qi,i);
      res0(qi,i) = dqp(:,qi,i)\v122(:,qi,i);
      res0sse(qi,i) = norm(dqp(:,qi,i)* res0(qi,i)-v122(:,qi,i))^2;
      %icT(qi,i) = cT(:,qi,i)\ inT(:,qi,i);
      icT(qi,i) = mean(inT(:,qi,i)./cT(:,qi,i));
      icTsse(qi,i)=std(inT(:,qi,i)./cT(:,qi,i));
      %icTsse(qi,i) = norm(cT(:,qi,i)* icT(qi,i)-inT(:,qi,i))^2;
    end
  end
end

end
  

