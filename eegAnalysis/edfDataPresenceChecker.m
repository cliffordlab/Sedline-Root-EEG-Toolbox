function edfDataPresenceChecker(eDataPath)
%
%   edfDataPresenceChecker(eDataPath)
%
%   OVERVIEW:   
%       This script is used to create a dictionary with keys being a string
%       in the following format: 'yyyymmdd_ORx' where,
%           yyyy denotes year
%           mm denotes month
%           dd denotes date &
%           x denotes OR number.
%       Further the value for each key is always 1. Hence if a key is
%       present that implies that an edf record exists for the day:
%       'yyyymmdd' which was recorded in OR 'x'.      
%       Note that this script does not check for empty (flat-line) signal.
%       Include the checking of empty (flat-line) signal in next update.
%
%   INPUT:      
%       eDataPath - Path to the folder containing .edf EEG files
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
%       Pradyumna Byappanahalli Suresha
%       Last Modified: January 14th, 2021 
%
%	COPYRIGHT (C) 2021 
%   LICENSE:    
%       This software may be modified and distributed under the terms
%       of the BSD 3-Clause license. See the LICENSE file in this repo for 
%       details.
%
%%

% List all folders in `eDataPath`
records = dir([eDataPath, '*_*']);
recordFlags = [records.isdir];
records = extractfield(records,'name')';
records = records(recordFlags);
folderNames = records;

% Append Done directories
recordsTemp = dir([eDataPath, 'done/*_*']);
recordTempFlags = [recordsTemp.isdir];
recordsTemp = extractfield(recordsTemp,'name')';
recordsTemp = recordsTemp(recordTempFlags);
folderNamesTemp = recordsTemp;
for ii = 1:length(recordsTemp)
    recordsTemp{ii} = ['done/', recordsTemp{ii}];
end
records = [records;recordsTemp];
folderNames = [folderNames;folderNamesTemp];

% Create a containers map (read dictionary)
dataPresent = containers.Map('KeyType','char','ValueType','double');

for ii = 1:length(records)
    
    % Check the file's naming convention and extract recording date
    if(folderNames{ii}(1) == 'R')
        dateOfRecording=folderNames{ii}(17:24);
    else
        dateOfRecording=folderNames{ii}(1:8);
    end
    
    dataFolder = [eDataPath, records{ii}, '/'];
    % Read notes file and extract OR number
    orNumber = orNumberExtraction(dataFolder);
    
    % Check if the key is present - else update.
    if(~isKey(dataPresent,...
            [dateOfRecording,'_OR',num2str(orNumber)]))
        dataPresent([dateOfRecording,'_OR',num2str(orNumber)])...
            = 1;
    end
end