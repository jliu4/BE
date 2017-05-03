%%get all data file names from directory and put in Experiment variable for loading
function Experiment = getall(Directory)
cd(Directory)
Experiment={};
foo=dir;
%9x1 struct array containing the fields:
%
%    name
%    date
%    bytes
%    isdir
%    datenum
%    statinfo
%%first 2 in foo are just directory '.' and '..'

for ii=3:length(foo)
    fdn(ii-2)=datenum(foo(ii).date);
end
[Sfdn,ifdn]=sort(fdn);
sfoo=foo(ifdn+2);

for ff=1:length(sfoo)
    files{ff}=sfoo(ff).name;
    Testexp=findstr('csv',files{ff});
    if length(Testexp) >=1
        Experiment=[Experiment files{ff}];
    else
    end
end

end