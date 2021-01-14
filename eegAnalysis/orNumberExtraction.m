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
%       Last Modified: January 14th, 2021
%
%	COPYRIGHT (C) 2021
%   LICENSE:    
%       This software may be modified and distributed under the terms
%       of the BSD 3-Clause license. See the LICENSE file in this repo for 
%       details.
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