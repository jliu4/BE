function AddCharlestonRepo( )
% Add the main Charleston Repo to the path, including subfolders
    fp = mfilename('fullpath');
    a = strsplit(fp, filesep);
    mainrepo = strcat(strjoin(a(1:3), filesep), filesep, 'charleston', ...
      filesep, 'code', filesep, 'Matlab');
    addpath(genpath(mainrepo))    
end

