function runData = AddDataPath(splitpath)

%AddCharlestonRepo();

% add folder 1 level above path with all subfolders folders 
datapath = strcat(strjoin(splitpath(1:end-1),filesep));
addpath(genpath(datapath));
runData.fitting_script_filename = strcat(splitpath{end},'');

% get and store the path to the calling file
filepath = strcat(strjoin(splitpath(1:end-1),filesep));
runData.fitting_script_filepath = filepath;

end

