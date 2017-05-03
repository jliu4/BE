clear; close all; clc
addpath('C:\jinwork\BE\matlab')

matfileFolder='C:\jinwork\BE\matlab\df-google\matfiles';
matfileSub = genpath(matfileFolder);
remain = matfileSub;
listOfFolderNames = {};
while true
	[singleSubFolder, remain] = strtok(remain, ';');
	if isempty(singleSubFolder)
		break;
	end
	listOfFolderNames = [listOfFolderNames singleSubFolder];
end
numberOfFolders = length(listOfFolderNames)
for k = 1 : numberOfFolders
	% Get this folder and print it out.
	thisFolder = listOfFolderNames{k};
	fprintf('Processing folder %s\n', thisFolder);
	filePattern = sprintf('%s/*.mat', thisFolder);
	baseFileNames = dir(filePattern);
	numberOfMatfiles = length(baseFileNames);
    if numberOfMatfiles >= 1
		% Go through all those image files.
		for f = 1 : numberOfMatfiles
			fullFileName = fullfile(thisFolder, baseFileNames(f).name);
			fprintf('%s\n',baseFileNames(f).name);
            %str=char(string(files(1,fi)))   
            S = load(fullFileName);
            run_data = S.run_data;
            model=run_data.model;
            model1=run_data.model.model;

            param = S.run_data.model.model.Parameters;
            parameters = [param(:).Value];
            paramName =[param(:).Name];
            filen = strcat('C:\jinwork\BEC\tmp\parameters','.csv');
            dlmwrite(filen,parameters,'-append');
        end   
   else
		fprintf('     Folder %s has no image files in it.\n', thisFolder);
   end
end
%clear S
       
%dlmwrite(filen,[run_data.fitting_script_filename,parameters],'-append');

%T=cell2table(cell(0,21),...
%'VariableName',{'ca0','ca1','ca2','cb0','cb1','cb2','kas0','kas1','kas2','kab0','kab1','kab2','kbs0','kbs1','kbs2','a10',...
%'a11','a12','a20','a21','a22'});
%T =[T;table(parameters,'VariableName',{'ca0','ca1','ca2','cb0','cb1','cb2','kas0','kas1','kas2','kab0','kab1','kab2','kbs0','kbs1','kbs2','a10',...
%'a11','a12','a20','a21','a22'})];

 %writetable(T,filen1);
