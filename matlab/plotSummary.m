function plotSummary(pdata, pd, isDC, isHe )
lineC = {'k','b','r','c','g','m'};
%get unique ql
uniqQl = unique(pd.ql);
%get unique coreT
uniqCT = unique(int16(pd.coreT));

%for each ql and temp get hp0
hpdrop = [];qp=[];tp=[];pp=[];v12=[];v122=[];
i = 0;
for ti = 1:numel(uniqCT)
  tdata = pdata(int16(pdata(:,1)) == uniqCT(ti),:);
  if size(tdata,1) > 4
  i = i + 1;
  tt(i) = uniqCT(ti);
  hp0=min(tdata(1,6),tdata(end,6));
  qp0=tdata(1,9);
  termP0=tdata(1,10);
  pcbP0 = tdata(1,11);
  if isDC 
    qtdata = tdata(2:end-1,:);
    hpdrop(:,i) = hp0-qtdata(:,6);
    dqp(:,i) = qtdata(:,12); %power
    v12(:,i)= qtdata(:,13);
    v122=v12.*v12;
    hv = hpdrop./v122;
    res = v122./dqp;
    hv0(i) = hpdrop(:,i)\v122(:,i); 
    hqp0(i) = hpdrop(:,i)\dqp(:,i);
    res0(i) = v122(:,i)\dqp(:,i);
  else    
    qtdata = tdata((tdata(:,4)) == uniqQl(1),:);
    qtdata = qtdata(2:end-1,:);
    tq(:,i) = [ uniqCT(i),uniqQl(1)];
    hpdrop(:,i) = hp0-qtdata(:,6);
    qp(:,i) = qtdata(:,9) - qp0;
    tp(:,i) = qtdata(:,10) - termP0;
    pp(:,i) = qtdata(:,11) - pcbP0;
    dqp(:,i) = qp(:,i)-(tp(:,i)+pp(:,i))/0.93;
    v12(:,i)= qtdata(:,7)-qtdata(:,8) ;
    v122=v12.*v12;
    hv = hpdrop./v122;
    hv0(i) = hpdrop(:,i)\v122(:,i);  
    hqp0(i) = hpdrop(:,i)\dqp(:,i);
    res = v122./dqp;
    res0(i) = v122(:,i)\dqp(:,i);
  end
  end
end
figure
%grid
%hold on
plot(tt',hv0');
figure
plot(tt',hqp0');
figure
plot(tt',res0');
figure
grid
hold on
size(tt')

for i = 1:size(tt,2)
  ylabel('Resistance[Ohm]');
  xlabel('V^2[volt]'); 
  v122(:,i)
  hpdrop(:,i)
  %subplot(3,1,1);
  plot(v122(:,i),res(:,i),'-x');
  labels{i}=strcat('CoreTemp=',num2str(tt(i))); 
end  
figure
grid
hold on
for i = 1:size(tt,2)
  ylabel('HpDrop[w]');
  xlabel('V^2[volt]'); 
  v122(:,i)
  hpdrop(:,i)
  %subplot(3,1,2);
  plot(v122(:,i),hpdrop(:,i),'-o');
  labels{i}=strcat('CoreTemp=',num2str(tt(i))); 
end  
legend(labels);
figure
grid
hold on
for i = 1:size(tt,2)
    ylabel('HpDrop[w]');
    xlabel('coreQP'); 
    %subplot(3,1,3)
    plot(dqp(:,i),hpdrop(:,i),'-*');
    labels{i}=strcat('CoreTemp=',num2str(tt(i))); 
end  
legend(labels);
end
  
