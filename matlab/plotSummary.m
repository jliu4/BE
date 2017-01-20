function plotSummary(pdata, pd, isDC, isHe )
lineC = {'k','b','r','c','g','m'};
%get unique ql
uniqQl = unique(pd.ql);
%get unique coreT
uniqCT = unique(int16(pd.coreT));

%for each ql and temp get hp0
hpdrop = [];qp=[];tp=[];pp=[];v12=[];v122=[];

for ti = 1:numel(uniqCT)-1
  tdata = pdata(int16(pdata(:,1)) == uniqCT(ti),:);
  hp0=min(tdata(1,6),tdata(end,6));
  qp0=tdata(1,9);
  termP0=tdata(1,10);
  pcbP0 = tdata(1,11);
  if isDC 
    qtdata = qtdata(2:end-1,:);
    hpdrop(:,ti) = hp0-qtdata(:,6);
    dqp(:,ti) = qtdata(:,12); %power
    v12(:,ti)= qtdata(:,13)
    v122=v12.*v12;
    vh = hpdrop./v122;
    resistance = v122./qqp;
    vh0(ti) = hpdrop(:,ti)\v122(:,ti);    
  else    
    qtdata = tdata((tdata(:,4)) == uniqQl(1),:);
    qtdata = qtdata(2:end-1,:);
    tq(:,ti) = [ uniqCT(ti),uniqQl(1)];
    hpdrop(:,ti) = hp0-qtdata(:,6);
    qp(:,ti) = qtdata(:,9) - qp0;
    tp(:,ti) = qtdata(:,10) - termP0;
    pp(:,ti) = qtdata(:,11) - pcbP0;
    dqp(:,ti) = qp(:,ti)-(tp(:,ti)+pp(:,ti))/0.93;
    v12(:,ti)= qtdata(:,7)-qtdata(:,8) ;
    v122=v12.*v12;
    vh = hpdrop./v122;
    vh0(ti) = hpdrop(:,ti)\v122(:,ti);   
    resistance = v122./dqp;
  end
 
end
figure
grid
hold on
for i = 1:size(uniqCT)-1
  ylabel('Resistance[Ohm]');
  xlabel('V^2[volt]'); 
  v122(:,i)
  hpdrop(:,i)
  %subplot(3,1,1);
  plot(v122(:,i),resistance(:,i),'-x');
  labels{i}=strcat('CoreTemp=',num2str(uniqCT(i))); 
end  
figure
grid
hold on
for i = 1:size(uniqCT)-1
  ylabel('HpDrop[w]');
  xlabel('V^2[volt]'); 
  v122(:,i)
  hpdrop(:,i)
  %subplot(3,1,2);
  plot(v122(:,i),hpdrop(:,i),'-o');
  labels{i}=strcat('CoreTemp=',num2str(uniqCT(i))); 
end  
legend(labels);
figure
grid
hold on
for i = 1:size(uniqCT)-1
    ylabel('HpDrop[w]');
    xlabel('coreQP'); 
    %subplot(3,1,3)
    plot(dqp(:,i),hpdrop(:,i),'-*');
    labels{i}=strcat('CoreTemp=',num2str(uniqCT(i))); 
end  
legend(labels);
end
  

