function cropEegOmitInitialFlatLine(mDataPath, sDataPath, flatDataFile)
% 
%   cropEegOmitInitialFlatLine(mDataPath, sDataPath, flatDataFile)
%
%   OVERVIEW:   
%       This script is run on a set of 4-channel sedline EEG files that are 
%       in the .mat format. The mat files have a `eeg` file and a `header` 
%       file. We then crop the initial flat-line if present within the 
%       signal.
%
%   INPUT:      
%       mDataPath - Path to the folder containing .mat files containing
%                            - sig: eeg signal
%                            - header: header info
%       sDataPath - Path to the folder where we save the Spectrogram.png
%                   files
%       flatDataFile - Mat-file containing the amplitudes of flat-line for
%                      all four EEG channels.
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
%%

% List all mat-files in `mDataPath`
EEG_files = dir([mDataPath,'*.mat']);
EEG_files = extractfield(EEG_files,'name')';

% Optionally open a csv file to write information about the cropped files
% fp = fopen([repoRootFolder, 'outputs/archivedEegList.csv'],'w');
% fprintf(fp, ['Data archived from OR,	Recording name with date-time and Device ID, Start date, Start time, End time, Cropped?, ',...
%    'Original Start Date, Original Start Time, Original End Time \n']);

% Load flatDataValue
load(flatDataFile);

% Process each mat-file via a for loop
for ii = 1:length(EEG_files)
    clc;
    disp([num2str(ii), ' of ', num2str(length(EEG_files)), ' files...']);
    load([mDataPath, EEG_files{ii}]);
    if (isempty(eeg))
        continue
    end
    %%%%%%%%%%%%
    %printfs = [];
    %for ss = 1:length(header)
    %    printfs = [printfs, mean(header{ss}.frequency)];
    %end
    %disp(EEG_files{ii});
    %printfs
    %pause
    %%%%%%%%%%%%
    hdr = header{1};
    hdr = rmfield(hdr, 'samples');
    hdr = rmfield(hdr, 'secondsInterval');
    hdr = rmfield(hdr, 'fileName');
    
    fs = hdr.fs;
    startDateTime = datetime([hdr.startDate,',',hdr.startTime],'Format','MM.dd.yy,HH.mm.ss');
    endDateTime = datetime([hdr.endDate,',',hdr.endTime],'Format','MM.dd.yy,HH.mm.ss');
    
    neeg = round(eeg*100000)/100000;
    flatData = round(flatData*100000)/100000;
    for jj = 1:4
        neeg(jj,isnan(neeg(jj,:))) = flatData(jj);
        neeg(jj,neeg(jj,:)==-flatData(jj)) = flatData(jj);
    end
    dEeg = diff(neeg')'; % Compute difference signal of the EEG signal
    
    % Plot and visualize the signal
    tx = 1/fs : 1/fs :size(eeg,2)/fs;
%     ax = zeros(4,1);
%     figure(1); 
%     for jj = 1:4
%         ax(jj) = subplot(4,1,jj); plot(tx, eeg(jj,:));
%     end
%     
%     linkaxes(ax, 'x');
    
    [locX,locY] = find(dEeg); % Find indices with non-zero values
    emptySignalFlag = 0;
    if isempty(locY)
        eeg = [];
        tx = [];
        emptySignalFlag = 1;
        hdr.originalEndDate = hdr.endDate;
        hdr.originalEndTime = hdr.endTime;
        hdr.endDate = '';
        hdr.endTime = '';
        hdr.originalStartDate = hdr.startDate;
        hdr.originalStartTime = hdr.startTime;
        hdr.startDate = '';
        hdr.startTime = '';
        hdr.croppedFull = 1;

    end
    locY = locY + 1; % Find corresponding indices in the eeg signal
    locY1 = locY(locX == 1); locY2 = locY(locX == 2); locY3 = locY(locX == 3); locY4 = locY(locX == 4);
    if (~isempty(locY))
        if isempty(locY1)
            locY1 = [locY1;locY(1);locY(end)]; 
        end
        if isempty(locY2)
            locY2 = [locY2;locY(1);locY(end)]; 
        end
        if isempty(locY3)
            locY3 = [locY3;locY(1);locY(end)]; 
        end
        if isempty(locY4)
            locY4 = [locY4;locY(1);locY(end)]; 
        end
    end
    yThreshold = 100;
    
    locYThreshold = size(eeg,2) - yThreshold;
    
    % The below condition checks if the last non flat line signal occurs much earlier rather than occurring at the last sample 
    if (~emptySignalFlag)
        hdr.croppedFull = 0;
        if (locY1(end) < locYThreshold && locY2(end) < locYThreshold && locY3(end) < locYThreshold && locY4(end) < locYThreshold)
            locYEnd = max([locY1(end), locY2(end), locY3(end), locY4(end)]);
            newEndDateTime = endDateTime - seconds((size(eeg,2) - locYEnd)/fs);
            newEndDate = [sprintf('%02d.',month(newEndDateTime)),...
                sprintf('%02d.',day(newEndDateTime)), num2str(year(newEndDateTime))];
            newEndTime = [sprintf('%02d.',hour(newEndDateTime)),...
                sprintf('%02d.',minute(newEndDateTime)),sprintf('%02d',floor(second(newEndDateTime)))];
            
            % Crop eeg to omit the initial flat line and modify the hdr
            hdr.croppedAtEnd = 1;
            eeg = eeg(:,1:locYEnd);
            txNew = tx(1:locYEnd); % For debug purposes
            hdr.originalEndDate = hdr.endDate;
            hdr.originalEndTime = hdr.endTime;
            hdr.endDate = newEndDate;
            hdr.endTime = newEndTime;
        else
            hdr.originalEndDate = hdr.endDate;
            hdr.originalEndTime = hdr.endTime;
            hdr.croppedAtEnd = 0;
            txNew = tx;
        end
        
        % The below condition checks if the first non flat line signal occurs much later rather than occurring at the first sample 
        if (locY1(1) > 2 && locY2(1) > 2 && locY3(1) > 2 && locY4(1) > 2)
            locYStart = min([locY1(1), locY2(1), locY3(1), locY4(1)]);
            newStartDateTime = startDateTime + seconds(locYStart/fs);
            newStartDate = [sprintf('%02d.',month(newStartDateTime)),...
                sprintf('%02d.',day(newStartDateTime)), num2str(year(newStartDateTime))];
            newStartTime = [sprintf('%02d.',hour(newStartDateTime)),...
                sprintf('%02d.',minute(newStartDateTime)),sprintf('%02d',floor(second(newStartDateTime)))];
            
            % Crop eeg to omit the initial flat line and modify the hdr
            hdr.croppedAtStart = 1;
            eeg = eeg(:,locYStart:end);
            txNew = txNew(locYStart:end);
            hdr.originalStartDate = hdr.startDate;
            hdr.originalStartTime = hdr.startTime;
            hdr.startDate = newStartDate;
            hdr.startTime = newStartTime;
        else
            hdr.originalStartDate = hdr.startDate;
            hdr.originalStartTime = hdr.startTime;
            hdr.croppedAtStart = 0;
        end
        
        % For debug purposes
        %for jj = 1:4
        %    figure(1);ax(jj) = subplot(4,1,jj); hold on; plot(txNew, eeg(jj,:) + 100,'--');hold off;
        %end
    end
    
    orNumber = hdr.orNumber;
    
    % Construct a message corresponding to the cropping performed
    if (emptySignalFlag)
        cropMessage = 'Entire signal';
    elseif (hdr.croppedAtStart == 1 && hdr.croppedAtEnd == 1)
        cropMessage = 'Start & End';
    elseif (hdr.croppedAtStart == 1)
        cropMessage = 'Start';
    elseif (hdr.croppedAtEnd == 1)
        cropMessage = 'End';
    else
        cropMessage = '';
    end
    if (~emptySignalFlag)
        delete([mDataPath, EEG_files{ii}]);
        save([sDataPath, EEG_files{ii}],'eeg', 'hdr');
    else
        delete([mDataPath, EEG_files{ii}]);
    end
    
    % Optionally, write information to a table
    % fprintf(fp, [num2str(orNumber), ',', EEG_files{ii}, ',', hdr.startDate,',',  hdr.startTime, ',', hdr.endTime, ',', cropMessage,  ',',...
    %     hdr.originalStartDate,',',  hdr.originalStartTime, ',', hdr.originalEndTime,'\n']);
    
end