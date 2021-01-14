function combinedEegWrapper(mDataPath, sDataPath, combinedEEGTable)
%
%   combinedEegWrapper(mDataPath, sDataPath, combinedEEGTable)
%
%   OVERVIEW:   
%       This is a wrapper script used to run on a set of 4-channel sedline 
%       EEG files that are in the .mat format. The mat files have a `sig` 
%       file and a `header` file.
%
%   INPUT:      
%       mDataPath - Path to the folder containing .mat files containing
%                            - sig: eeg signal
%                            - header: header info
%       sDataPath - Path to the folder where we save the Spectrogram.png
%                  files
%       combinedEEGTable - CSV table corresponding to the above mat-files 
%                          with surgery start-end info
%
%   OUTPUT:
%       NONE
%
%   DEPENDENCIES & LIBRARIES:
%       https://github.com/cliffordlab/Sedline-Root-EEG-Toolbox/eegAnalysis/sqiAndSpectrogram.m
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
%%

% List all mat-files in `mDataPath`
EEG_files = dir([mDataPath,'*.mat']);
EEG_files = extractfield(EEG_files,'name')';

% Read csv table corresponding to the above mat-files with surgery start-end info 
T = readtable(combinedEEGTable);
tableinfo = table2cell(T);

% Process each mat-file via a for loop
for ii = 1:length(EEG_files)
    % EEG_files{ii}
    
    % parse tableinfo for patientID
    id = find(strcmp(tableinfo(:,2), EEG_files{ii}(1:end-4)));
    
    % Note the Physical location Start Time
    try
        temp = datestr(tableinfo{id,5},'mm/dd/yy HH:MM:SS');
        timeInfo.Pstart = [temp(1:6),'20',temp(7:end)];
    catch
        timeInfo.Pstart = [];
    end
    
    % Note the Physical location End Time
    try
        temp = datestr(tableinfo{id,6},'mm/dd/yy HH:MM:SS');
        timeInfo.Pend = [temp(1:6),'20',temp(7:end)];
    catch
        timeInfo.Pend = [];
    end
    
    % Note the Surgery Start Time
    try
        temp = datestr(tableinfo{id,7},'mm/dd/yy HH:MM:SS');
        timeInfo.Sstart = [temp(1:6),'20',temp(7:end)];
    catch
        timeInfo.Sstart = [];
    end
    
    % Note the Surgery End Time
    try
        temp = datestr(tableinfo{id,8},'mm/dd/yy HH:MM:SS');
        timeInfo.Send = [temp(1:6),'20',temp(7:end)];
    catch
        timeInfo.Send = [];
    end
    
    % Load the mat-file
    load([mDataPath, EEG_files{ii}]);
    
    % Compute SQI and spectrogram for the 4-channel EEG signal in the mat-file
    sqiAndSpectrogram(sig,header,timeInfo);
    
    % Save figure generated within SQI_and_specrtrogram script and close the figure
    saveas(figure(1),[sDataPath, EEG_files{ii},'_Spectrogram.png']);
    close all
end