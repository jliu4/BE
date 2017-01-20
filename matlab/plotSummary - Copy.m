function plotSummary(pdata, pd, isDC, isHe )
lineC = {'k','b','r','c','g','m'};
%get unique ql
uniqQl = unique(pd.ql);
%get unique coreT
uniqCT = unique(int16(pd.coreT));

%for each ql and temp get hp0
i = 0;
j = 0;
hpdrop = [];qp=[];tp=[];pp=[];v12=[];v122=[];
figure
grid
hold on
for ti = 1:numel(uniqCT)-1
  i = i + 1;  
  tdata = pdata(int16(pdata(:,1)) == uniqCT(ti),:);
  hp0=min(tdata(1,6),tdata(end,6));
  qp0=tdata(1,9);
  termP0=tdata(1,10);
  pcbP0 = tdata(1,11);
  if isDC 
      
  else    
   for qi = 1:numel(uniqQl)
    %q-pusle length only valid when there is q-pulse  
    j = j + 1;  
    qtdata = tdata((tdata(:,4)) == uniqQl(qi),:);
    qtdata = qtdata(2:end-1,:);
    tq(:,j,i) = [ uniqCT(ti),uniqQl(qi)];
    hpdrop(:,j,i) = hp0-qtdata(:,6);
    qp(:,j,i) = qtdata(:,9) - qp0;
    tp(:,j,i) = qtdata(:,10) - termP0;
    pp(:,j,i) = qtdata(:,11) - pcbP0;
    dqp(:,j,i) = qp(:,j,i)-(tp(:,j,i)+pp(:,j,i))/0.93
    v12(:,j,i)= qtdata(:,7)-qtdata(:,8) ;
    v122=v12.*v12;
    vh = hpdrop./v122;
    vh0(j,i) = hpdrop(:,j,i)\v122(:,j,i);   
    

   end
    
  end
  ylabel('HpDrop[w]');
    xlabel('(V^2[volt]'); 
    plot(v122(:,j,i),hpdrop(:,j,i),'-o');
    labels{i}=strcat('CoreTemp=',num2str(uniqCT(i))); 
end 
v122

legend(labels);
figure
grid
hold on
for i = 1:size(uniqCT)-1
   ylabel('HpDrop[w]');
    xlabel('(V1-V2)^2[volt]'); 
    v122(:,1,i)
    hpdrop(:,1,i)
    plot(v122(:,1,i),hpdrop(:,1,i),'-o');
    labels{i}=strcat('CoreTemp=',num2str(uniqCT(i))); 

end  
legend(labels);
figure
grid
hold on
for i = 1:size(uniqCT)-1
  %for j = 1:size(uniqQl)
    ylabel('HpDrop[w]');
    xlabel('coreQP'); 
    plot(dqp(:,i,1),hpdrop(:,i,1),'-*');
    labels{i}=strcat('CoreTemp=',num2str(uniqCT(i))); 
  %end
end  
legend(labels);
end
  

