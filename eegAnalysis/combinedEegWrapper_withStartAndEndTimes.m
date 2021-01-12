function combinedEegWrapper_withStartAndEndTimes(mDataPath, sDataPath, combinedEEGTable)
%
%   combinedEegWrapper_withStartAndEndTimes(mDataPath, sDataPath, combinedEEGTable)
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
%       Last Modified: January 11th, 2021
%
%	COPYRIGHT (C) 2021 
%   LICENSE:    
%       This software is offered freely and without warranty under 
%       the GNU (v3 or later) public license. See license file for
%       more information
%%

% List all mat-files in `mDataPath`
EEG_files = dir([mDataPath,'*.mat']);
EEG_files = extractfield(EEG_files,'name')';

% Read csv table corresponding to the above mat-files with surgery start-end info 
T = readtable(combinedEEGTable);
eegFileNames = T.eegFileNames;
%patientIDs = T.Patient;

% Process each mat-file via a for loop
for ii = 1:length(eegFileNames)
    
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
    saveas(figure(1),[sDataPath, eegFileNames{ii},'_Spectrogram.png']);
    close all
end