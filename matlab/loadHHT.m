%% Import data from text file.
%%made universal on 10/28 so that I could deal with changing columns and labels!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialize variables.

  alldata=[];
for ff=1:length(Experiment)
    filename = [Directory,'\',Experiment{ff}];
    
    delimiter = ',';
    startRow = 2;
    
  
    foo=importdata(filename);
    labels=foo.textdata(1,:);
    
    
    if ff==1
      
        labels = foo.textdata(1,:);
        v = genvarname(labels); %format options?
        nc = length(v);
        %% Allocate imported array to column variable names
        
        DateTime = deal(foo.textdata(2:end,1));
        coo=foo.data;
        %look for extra labels in data...
        TFcrap = strncmp(DateTime,'Date',4); %
        extra = find(TFcrap ==1);
        
        DateTime(extra)=[];
        coo(extra,:)=[];
        for nn=2:nc %for each column, except date...doesn't work with text in other columns
            vnn=v{nn};
            eval([vnn ' = coo(:,nn-1);']);
            
        end
       
        
    else
        ff
        coo=foo.data;
        Dtemp=deal(foo.textdata(2:end,1));
        
            %look for extra labels in data...
        TFcrap = strncmp(Dtemp,'Date',4); %
        TFextra = find(TFcrap ==1);
        NDcrap = strncmp(Dtemp,'0',2);
        NDextra = find(NDcrap ==1);
        %NDcrap = find(length(Dtemp(ff)) <= 18); %some dates are '0'
        extra=union(TFextra,NDextra)
        
        Dtemp(extra)=[];
        coo(extra,:)=[];
        DateTime = [DateTime ; Dtemp];
        for nn=2:nc %for each column, except date...doesn't work with text in other columns
            vnn=v{nn};
            clear vtemp vtmpVc
            vtemp = eval(vnn);
            vtmpVc=[vtemp ; coo(:,nn-1)];
            eval([vnn ' = vtmpVc;']);
            
        end
    end
  
    alldata=[alldata;coo];
    clear coo
end

%%try using deal??