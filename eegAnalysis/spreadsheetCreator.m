function spreadsheetCreator(mDataPath, patientdataFile)
%
%   spreadsheetCreator(mDataPath, patientdataFile)
%
%   OVERVIEW:   
%       Read EEG files which are in the .mat format, extract EEG
%       information and write it into a spreadsheet
%
%   INPUT:      
%       mDataPath - Path to the folder containing .mat files containing
%                            - eeg: eeg signal
%                            - hdr: header info
%       patientdataFile - Path to a file created by this script which shall
%                         contain EEG information
%
%   OUTPUT:
%       NONE
%
%   DEPENDENCIES & LIBRARIES:
%       https://github.com/cliffordlab/Sedline-Root-EEG-Toolbox
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

% List all mat-files in `mDataPath`
EEG_files = dir([mDataPath,'*.mat']);
EEG_files = extractfield(EEG_files,'name')';


%% Insert EEG file Information
%filename = 'patientdata.xlsx';
%filename = [repoRootFolder, 'data/patientInfo/', filename];
filename = patientdataFile;
record_name = cell(length(EEG_files),1);
or_number = zeros(length(EEG_files),1);
record_start_time = cell(length(EEG_files),1);
record_end_time = cell(length(EEG_files),1);

% Process each mat-file via a for loop
for ii = 1:length(EEG_files)
    clc;
    disp([num2str(ii), ' of ', num2str(length(EEG_files)), ' files...']);
    load([mDataPath, EEG_files{ii}], 'hdr');
    
    startDateTime = datetime([hdr.startDate,',',hdr.startTime],'Format','MM.dd.yy,HH.mm.ss');startDateTime.TimeZone = 'America/New_York';
    endDateTime = datetime([hdr.endDate,',',hdr.endTime],'Format','MM.dd.yy,HH.mm.ss');endDateTime.TimeZone = 'America/New_York';
    startDateTime = datestr(startDateTime, 'mm/dd/yy HH:MM:ss');
    endDateTime = datestr(endDateTime, 'mm/dd/yy HH:MM:ss');
    % Create Table
    record_name{ii,1} = EEG_files{ii};
    or_number(ii,1) = hdr.orNumber;
    record_start_time{ii,1} = startDateTime;
    record_end_time{ii,1} = endDateTime;
    
end

T = table(record_name,or_number,record_start_time,record_end_time);
writetable(T,filename,'Sheet',1);
