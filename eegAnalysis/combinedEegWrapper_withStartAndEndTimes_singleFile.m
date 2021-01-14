function combinedEegWrapper_withStartAndEndTimes_singleFile(arg)
%
%   combinedEegWrapper_withStartAndEndTimes_singleFile(arg)
%
%   OVERVIEW:   
%       This is a wrapper script used to run on a set of 4-channel sedline 
%       EEG files that are in the .mat format. The mat files have a `sig` 
%       file and a `header` file. 
%
%   INPUT:      
%       arg - The row number in the "sqiFilteredSurgeryTable.xlsx" file
%             which has patient and surgery information - one surgery per
%             row. "arg" is in the string format.
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
%
%%

% Modify the local repoDirectotry name and uncomment the below line.
%repoDirectory = '/Users/pradyumna/Sedline-Root-EEG-Toolbox/';

mDataPath = [repoDirectory, 'data/combined_EEG_surgerySynced/'];
sDataPath = [repoDirectory, 'data/combined_EEG_surgerySynced_plots/'];
% Uncomment the below line after provideing the correct path to the xlsx
% file containing patient and suregery information.
%combinedEEGTable = [repoDirectory, 'data/patientInfo/sqiFilteredSurgeryTable.xlsx'];

ii = str2double(arg);

% List all mat-files in `mDataPath`
EEG_files = dir([mDataPath,'*.mat']);
EEG_files = extractfield(EEG_files,'name')';

% Read csv table corresponding to the above mat-files with surgery start-end info 
T = readtable(combinedEEGTable);
eegFileNames = T.eegFileNames;
%patientIDs = T.Patient;

% for ii = 1:length(eegFileNames)
    
    % Note the Physical location Start Time
    try
        temp = datestr(T.PhysicalLocationStartTimestamp(ii),'mm/dd/yy HH:MM:SS');
        timeInfo.pStart = [temp(1:6),'20',temp(7:end)];
    catch
        timeInfo.pStart = [];
    end
    
    % Note the Physical location End Time
    try
        temp = datestr(T.PhysicalLocationEndTimestamp(ii),'mm/dd/yy HH:MM:SS');
        timeInfo.pEnd = [temp(1:6),'20',temp(7:end)];
    catch
        timeInfo.pEnd = [];
    end
    
    % Note the Surgery Start Time
    try
        temp = datestr(T.SurgeryStartTimestamp{ii},'mm/dd/yy HH:MM:SS');
        timeInfo.sStart = [temp(1:6),'20',temp(7:end)];
    catch
        timeInfo.sStart = [];
    end
    
    % Note the Surgery End Time
    try
        temp = datestr(T.SurgeryStopTimestamp{ii},'mm/dd/yy HH:MM:SS');
        timeInfo.sEnd = [temp(1:6),'20',temp(7:end)];
    catch
        timeInfo.sEnd = [];
    end
    
    % Note the Anesthesia Start Time
    try
        temp = datestr(T.AnesthesiaStartTimestamp{ii},'mm/dd/yy HH:MM:SS');
        timeInfo.aStart = [temp(1:6),'20',temp(7:end)];
    catch
        timeInfo.aStart = [];
    end
    
    % Note the Anesthesia Stop Time
    try
        temp = datestr(T.AnesthesiaStopTimestamp{ii},'mm/dd/yy HH:MM:SS');
        timeInfo.aEnd = [temp(1:6),'20',temp(7:end)];
    catch
        timeInfo.aEnd = [];
    end

    % Note the EEG Start Time
    try
        temp = datestr(T.eegStartTimestamp(ii),'mm/dd/yy HH:MM:SS');
        timeInfo.eStart = [temp(1:6),'20',temp(7:end)];
    catch
        timeInfo.eStart = [];
    end
    
    % Note the EEG Stop Time
    try
        temp = datestr(T.eegEndTimestamp(ii),'mm/dd/yy HH:MM:SS');
        timeInfo.eEnd = [temp(1:6),'20',temp(7:end)];
    catch
        timeInfo.eEnd = [];
    end   
 
    % Load the mat-file
    load([mDataPath, eegFileNames{ii}]);
    
    % Compute SQI and spectrogram for the 4-channel EEG signal in the mat-file
    sqiAndSpectrogram(eeg,hdr,timeInfo);
    
    % Save figure generated within SQI_and_specrtrogram script and close the figure
    saveas(figure(1),[sDataPath, eegFileNames{ii}(1:end-4),'_Spectrogram.png']);
    close all
% end