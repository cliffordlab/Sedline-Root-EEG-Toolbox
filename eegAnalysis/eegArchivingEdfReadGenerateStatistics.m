function [TotalUsefulDataCollected, LostData] = eegArchivingEdfReadGenerateStatistics(eDataPath)
%
%   [TotalUsefulDataCollected, LostData] = eegArchivingEdfReadGenerateStatistics(eDataPath)
%
%   OVERVIEW:   
%       Computes the length of true EEG signal and the length of signal 
%       that is not EEG in each EEG record 
%
%   INPUT:      
%       eDataPath - Path to the folder containing .edf EEG files 
%
%   OUTPUT:
%       TotalUsefulDataCollected - containers.Map object with information
%                                  about the total amount of EEG signal for
%                                  each EEG record.
%       LostData - containers.Map object with information about the total 
%                  amount of non-EEG signal for each EEG record.
%
%   DEPENDENCIES & LIBRARIES:
%       https://github.com/cliffordlab/Sedline-Root-EEG-Toolbox/eegAnalysis/orNumberExtraction.m
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
%       Last Modified: January 14th, 2020 
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

%load(data_length_info_edf);
TotalUsefulDataCollected = containers.Map('KeyType','char','ValueType','double');
LostData = containers.Map('KeyType','char','ValueType','double');
records = records(4:end)';

for ii = 1:length(records)
    
    % Check the file's naming convention and extract recording date
    if(records{ii}(1) == 'R')
        dateOfRecording=records{ii}(18:25);
    else
        dateOfRecording=records{ii}(1:8);
    end

    dataFolder = [eDataPath, records{ii}, '/'];
    eegList = dir([dataFolder, '*.edf']);
    eegList = extractfield(eegList,'name');
    
    % Read notes file and extract OR number
    orNumber = orNumberExtraction(dataFolder);

    totalLength = 0;
    lostData = 0;
    totalNumberOfFiles = length(eegList);
    zeroPercent = zeros(totalNumberOfFiles,1);
    failedToReadFile = 0;
    for jj = 1:totalNumberOfFiles
        % Construct EEG File name
        eegFile = [dataFolder, eegList{jj}];
        
        % Read header, signal and diiference-signal from the EEG file
        [header, signal, differenceSignal] = eegFileReader(eegFile, orNumber);
        fs = header.frequency(1);
        %zeroPercent(jj,1) = length(find(drecord==0))/length(drecord(:))*100;
        
        maxs = header.physicalMax;
        mins = header.physicalMin;
        flatData = [0.00432, 0.012620, 0.02093, 0.029240];
        c = ones(4,length(signal));
        for kk = 1:4
            for ll = 2:length(signal)
                try
                    if(differenceSignal(kk,ll) == 0 && round(signal(kk,ll)*100000)/100000==flatData(kk))
                        c(kk,ll) = 0;
                        continue
                    end
                catch
                end
                if(round(signal(kk,ll)*10)/10 == maxs(kk) || round(signal(kk,ll)*10)/10 == mins(kk))
                    c(kk,ll) = 2;
                end
            end
        end
        sig1 = signal(c==1);
        totalLength = totalLength+(length(sig1)/fs/4);
        lostData = lostData+((length(signal(:))-length(sig1))/fs/4);
        
    end
    if(~isKey(TotalUsefulDataCollected,...
            [dateOfRecording,'_OR',num2str(orNumber)]))
        TotalUsefulDataCollected([dateOfRecording,'_OR',num2str(orNumber)])...
            = totalLength;
        LostData([dateOfRecording,'_OR',num2str(orNumber)])...
            = lostData;
    else
        TotalUsefulDataCollected([dateOfRecording,'_OR',num2str(orNumber)])...
            = TotalUsefulDataCollected([dateOfRecording,'_OR',num2str(orNumber)])...
            +totalLength;
        LostData([dateOfRecording,'_OR',num2str(orNumber)])...
            = LostData([dateOfRecording,'_OR',num2str(orNumber)])...
            +lostData;
    end

end