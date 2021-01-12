function orNumber = orNumberExtraction(dataFolder)
%
%   orNumberExtraction(dataFolder)
%
%   OVERVIEW:   
%       Extracts operating room number from the Notes file 
%
%   INPUT:      
%       dataFolder - Full path to a folder containing a file named 
%                    'Notes*.txt' 
%
%   OUTPUT:
%       NONE
%
%   DEPENDENCIES & LIBRARIES:
%       NONE
%
%   REFERENCE: 
%       NONE
%
%	REPO:       
%       https://github.com/cliffordlab/Sedline-Root-EEG-Toolbox
%
%   ORIGINAL SOURCE AND AUTHORS:     
%       Pradyumna Byappanahalli Suresh
%       Last Modified: January 11th, 2021
%
%	COPYRIGHT (C) 2021
%   LICENSE:    
%       This software is offered freely and without warranty under 
%       the GNU (v3 or later) public license. See license file for
%       more information
%
%%

noteFile = dir([dataFolder, 'Notes*.txt']);
noteFile = extractfield(noteFile,'name');
fileID = fopen([dataFolder, noteFile{1}],'r');
fgets(fileID);fgets(fileID);
orNumberLine = fgets(fileID);
orNumberLineSplits = regexp(orNumberLine, ' ', 'split');
orNumber = str2double(orNumberLineSplits{2});
fclose(fileID);

return
end