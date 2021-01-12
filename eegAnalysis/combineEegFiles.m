function combineEegFiles(eDataPath, sDataPath)
%
%   combineEegFiles(eDataPath, sDataPath)
%
%   OVERVIEW:   
%       This is a wrapper script used to run on a .edf EEG files, combine
%       them and save corresponding .mat EEG files.
%
%   INPUT:      
%       eDataPath - Path to the folder containing .edf EEG files
%       sDataPth - Path to the folder where we save the Spectrogram.png
%                  files
%
%   OUTPUT:
%       NONE
%
%   DEPENDENCIES & LIBRARIES:
%       https://github.com/cliffordlab/Sedline-Root-EEG-Toolbox/eegAnalysis/eegFileReader.m
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

% List all folders in `eDataPath`
records = dir([eDataPath, '*_*']);
recordFlags = [records.isdir];
records = extractfield(records,'name')';
records = records(recordFlags);

% 
for ii = 1:length(records)
    clc;
    disp([num2str(ii), ' of ', num2str(length(records)), ' files. Record:', records{ii}]);    
    dataFolder = [eDataPath, records{ii}, '/'];
    eegList = dir([dataFolder, '*.edf']);
    eegList = extractfield(eegList,'name');
    eeg = [];
    
    orNumber = orNumberExtraction(dataFolder);
    clear header

    for jj = 1:length(eegList)

        try 
            eegFile = [dataFolder, eegList{jj}];
            if (jj > 1)
                % Note the end-date-time of previous file in the current record
                previousEndDateTime = datetime([hdr.endDate,',',hdr.endTime],'Format','MM.dd.yy,HH.mm.ss');
            end
            [hdr, signal] = eegFileReader(eegFile, orNumber); % eegFile has the format: /path/to/the/RECORD/fileName.edf. 
            if (isempty(signal))
                continue;
            end
            % Note the start-date-time of current file in the current record
            currentStartDateTime = datetime([hdr.startDate,',',hdr.startTime],'Format','MM.dd.yy,HH.mm.ss');
            if (jj > 1)
                if (previousEndDateTime < currentStartDateTime)
                    nanSignal = nan(size(signal,1),round(seconds(currentStartDateTime - previousEndDateTime) * hdr.fs));
                    signal = [nanSignal, signal];
                end
            end
                
            eeg = [eeg,signal];
            header{jj+1,1} = hdr;
            
        catch
            % Handle skipping files that are unreadable
            continue;
        end
        
    end
    if exist('header','var')
        header{1} = header{2};
        header{1}.endDate = header{end}.endDate;
        header{1}.endTime = header{end}.endTime;
        save([sDataPath,records{ii}],'eeg','header');
    end
end
