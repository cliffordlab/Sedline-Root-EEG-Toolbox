function matchSurgeryToEeg(mDataPath, eegRoomSurgeryInfoFile, combinedEegSurgerySyncedFolder, matchSurgeryToEegFile)
%
%   matchSurgeryToEeg(mDataPath, eegRoomSurgeryInfoFile, combinedEegSurgerySyncedFolder, matchSurgeryToEegFile)
%
%   OVERVIEW:   
%       
%
%   INPUT:      
%       mDataPath - Path to the folder containing .mat files containing
%                            - eeg: eeg signal
%                            - hdr: header info
%       eegRoomSurgeryInfoFile - Patient info file name format. There are
%                                seperate files for each OR number. This 
%                                string contains the common name amongst 
%                                those files.
%       combinedEegSurgerySyncedFolder - Full path to a folder where
%                                        modified EEG files with header 
%                                        info shall be stored as mat-files
%       matchSurgeryToEegFile - Excel file with matched EEG timestamps and
%                               patient IDs
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

% List all mat-files in `mDataPath`
EEG_files = dir([mDataPath,'*.mat']);
EEG_files = extractfield(EEG_files,'name')';

sizet = zeros(8,1);
for ii = [1,2,3,4,5,6,8]
    %csvFile = [repoRootFolder, 'data/patientInfo/EUOSH EEG Room ', num2str(ii), '.csv'];
    csvFile = [eegRoomSurgeryInfoFile, num2str(ii), '.csv'];
    eval(['t', num2str(ii), ' = readtable(csvFile);']);
    eval(['sizet(ii) = height(t', num2str(ii), ');']);
    eval(['t', num2str(ii), '.visited = zeros(sizet(ii), 1);']);
    
    eval(['t = t', num2str(ii),';']);
    phyStartDateTimes = datetime(t.PhysicalLocationStartTimestamp);
    phyEndDateTimes = datetime(t.PhysicalLocationEndTimestamp);
    if ii == 3
        phyStartDateTimes = phyStartDateTimes + calyears(2000);
        phyEndDateTimes = phyEndDateTimes + calyears(2000);
    end
    t.PhysicalLocationStartTimestamp = phyStartDateTimes;
    t.PhysicalLocationEndTimestamp = phyEndDateTimes;
    eval(['t', num2str(ii),' = t;']);
end

opt1 = 0;
opt234 = 0;
opt5 = 0;
next = 1;
patientIDs = [];
orNumbers = [];
rowNumbersAll = [];
eegFileNames = cell(2,1);
PhysicalLocationStartTimestamp = [];
PhysicalLocationEndTimestamp = [];
eegStartTimestamp = [];
eegEndTimestamp = [];
% 
%% Process each mat-file via a for loop
for ii = 1:length(EEG_files)
    clc;
    disp([num2str(ii), ' of ', num2str(length(EEG_files)), ' files...']);
    load([mDataPath, EEG_files{ii}],'hdr'); % Load only the hdr.
    orNumber = hdr.orNumber;
    eval(['t = t', num2str(orNumber),';']);
    
    startDateTime = datetime([hdr.startDate,',',hdr.startTime],'Format','MM.dd.yy,HH.mm.ss');
    endDateTime = datetime([hdr.endDate,',',hdr.endTime],'Format','MM.dd.yy,HH.mm.ss');
    
    phyStartDateTimes = t.PhysicalLocationStartTimestamp;
    phyEndDateTimes = t.PhysicalLocationEndTimestamp;
    visited = t.visited;
    
    [rowNumbers, visited, optNumbers] = matchDateTime(startDateTime, endDateTime, phyStartDateTimes, phyEndDateTimes, visited);
    t.visited = visited;
    eval(['t', num2str(orNumber),' = t;']);

    % Opt 1:  Times match perfectly:
    if (optNumbers~=0)
        for jj = 1:length(optNumbers)
            opt = optNumbers(jj);
            if (opt == 1)
                opt1 = opt1 + 1;
            end
            
            % Opt 234: EEG and surgery do not intersect well:
            if (opt == 2 || opt == 3 || opt == 4)
                opt234 = opt234 + 1;
            end
            
            % Opt 5: Surgery is inside 1 EEG recording:
            if (opt == 5)
                opt5 = opt5 + 1;
            end
            
            rowNumbersAll = [rowNumbersAll; orNumber *1000 + rowNumbers(jj)];
            patientID = t.PatientEMPINbr(rowNumbers(jj));
            if iscell(patientID)
                patientID = patientID{1};
            end
            if ischar(patientID)
                patientID = str2double(patientID);
            end
            patientIDs = [patientIDs;patientID];
            orNumbers = [orNumbers;orNumber];
            eegFileNames{next} = EEG_files{ii};
            PhysicalLocationStartTimestamp = [PhysicalLocationStartTimestamp; phyStartDateTimes(rowNumbers(jj))];
            PhysicalLocationEndTimestamp = [PhysicalLocationEndTimestamp; phyEndDateTimes(rowNumbers(jj))];
            eegStartTimestamp = [eegStartTimestamp; startDateTime];
            eegEndTimestamp = [eegEndTimestamp; endDateTime];
            hdr.patientID = patientID;
            hdr.option = optNumbers;
            next = next + 1;
        end
    end
    
end

%% Process each surgery row and accordingly modify EEG file and save it.
h = 0;%Hour
for ii = 1:length(patientIDs)
    clc;
    disp([num2str(ii), ' of ', num2str(length(patientIDs)), ' files...']);
    patientID = patientIDs(ii);
    physicalLocationStart = PhysicalLocationStartTimestamp(ii);
    physicalLocationEnd = PhysicalLocationEndTimestamp(ii);
    orNumber = orNumbers(ii);
    eegFile = eegFileNames{ii};
    
    if(strcmp(eegFileNames{ii}, 'Root_2000008338_20171107_093120.mat'))
        disp('Here')
    end
    
    if (eegFile(1) == 'R')
        searchTerm = [eegFile(1:25), '*.mat'];
    else
        searchTerm = [eegFile(1:9), '*', eegFile(16:end)];
        
    end
    
    currentFiles = dir([mDataPath, searchTerm]);
    currentFiles = extractfield(currentFiles, 'name')';
    
    if (length(currentFiles) == 1)
        if (strcmp(currentFiles{1},eegFile)) % Sanity Check
            load([mDataPath, eegFile]);
            fs = hdr.fs;
            currentStartDateTime = datetime([hdr.startDate,',',hdr.startTime],'Format','MM.dd.yy,HH.mm.ss');
            
            if(physicalLocationStart - hours(h) > currentStartDateTime)
                startAt = round(seconds(physicalLocationStart - currentStartDateTime) * fs) + 1;
                eegStart = physicalLocationStart;
            else
                startAt = 1;
                eegStart = currentStartDateTime;
            end
            
            currentEndDateTime = datetime([hdr.endDate,',',hdr.endTime],'Format','MM.dd.yy,HH.mm.ss');
            
            if(physicalLocationEnd + hours(h) < currentEndDateTime)
                endAt = size(eeg,2) - round(seconds(currentEndDateTime - physicalLocationEnd) * fs) - 1;
                eegEnd = physicalLocationEnd;
            else
                endAt = size(eeg,2);
                eegEnd = currentEndDateTime;
            end
            
            eeg = eeg(:,startAt:endAt);
            
            startDate = [sprintf('%02d.',month(eegStart)),sprintf('%02d.',day(eegStart)),num2str(year(eegStart))];
            startTime = [sprintf('%02d.',hour(eegStart)),sprintf('%02d.',minute(eegStart)),sprintf('%02d',floor(second(eegStart)))];
              
            endDate = [sprintf('%02d.',month(eegEnd)),sprintf('%02d.',day(eegEnd)),num2str(year(eegEnd))];
            endTime = [sprintf('%02d.',hour(eegEnd)),sprintf('%02d.',minute(eegEnd)),sprintf('%02d',floor(second(eegEnd)))];
            
            hdr.startDate = startDate;
            hdr.startTime = startTime;
            hdr.endDate = endDate;
            hdr.endTime = endTime;
            hdr.patientID = patientID;
            
        else
            disp('What is happening here?')
            pause
        end
    else
    
        % Create one EEG file for the entire day by concatenating all files
        clear header
        signal = [];
        for jj = 1:length(currentFiles)
            try
                if (jj > 1)
                    % Note the end-date-time of previous file in the current record
                    previousEndDateTime = datetime([hdr.endDate,',',hdr.endTime],'Format','MM.dd.yy,HH.mm.ss');
                end
                
                load([mDataPath, currentFiles{jj}]);
                currentStartDateTime = datetime([hdr.startDate,',',hdr.startTime],'Format','MM.dd.yy,HH.mm.ss');
                
                if (jj > 1)
                    if (previousEndDateTime < currentStartDateTime)
                        nanSignal = nan(size(signal,1),round(seconds(currentStartDateTime - previousEndDateTime) * hdr.fs));
                        eeg = [nanSignal, eeg];
                    end
                end
                
                signal = [signal,eeg];
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
            hdr = header{1};
            
            eegStart = datetime([hdr.startDate,',',hdr.startTime, '.000'],'Format','MM.dd.yy,HH.mm.ss.SSS');
            fs = hdr.fs;
            tx = eegStart + seconds(0:1/fs:(size(signal,2) - 1)/fs);
            
            locs = find(tx > (physicalLocationStart - hours(h)) & tx < (physicalLocationEnd + hours(h)));
            
            eegStart = tx(locs(1));
            eegEnd = tx(locs(end));
            
            eegStart.Format = 'MM.dd.yy,HH.mm.ss';
            eegEnd.Format = 'MM.dd.yy,HH.mm.ss';
            
            startDate = [sprintf('%02d.',month(eegStart)),sprintf('%02d.',day(eegStart)),num2str(year(eegStart))];
            startTime = [sprintf('%02d.',hour(eegStart)),sprintf('%02d.',minute(eegStart)),sprintf('%02d',floor(second(eegStart)))];
              
            endDate = [sprintf('%02d.',month(eegEnd)),sprintf('%02d.',day(eegEnd)),num2str(year(eegEnd))];
            endTime = [sprintf('%02d.',hour(eegEnd)),sprintf('%02d.',minute(eegEnd)),sprintf('%02d',floor(second(eegEnd)))];
            
            hdr.startDate = startDate;
            hdr.startTime = startTime;
            hdr.endDate = endDate;
            hdr.endTime = endTime;
            hdr.patientID = patientID;
            
            eeg = signal(:, locs);
        else
            eeg = [];
            hdr = [];
        end
    end        
    if (eegFile(1) == 'R')
        record = [eegFile(1:16),...
            num2str(year(eegStart)), sprintf('%02d',month(eegStart)), sprintf('%02d',day(eegStart)), '_', ...
            sprintf('%02d',hour(eegStart)), sprintf('%02d',minute(eegStart)), sprintf('%02d',floor(second(eegStart))), '.mat'];
    else
        record = [num2str(year(eegStart)), sprintf('%02d',month(eegStart)), sprintf('%02d',day(eegStart)), '_', ...
            sprintf('%02d',hour(eegStart)), sprintf('%02d',minute(eegStart)), sprintf('%02d',floor(second(eegStart))), ...
            eegFile(16:end)];
    end
    
    eegFileList{ii,1} = record;
    eegStartDateTime{ii,1} = datetime([hdr.startDate,',',hdr.startTime],'Format','MM.dd.yy,HH.mm.ss');
    eegEndDateTime{ii,1} = datetime([hdr.endDate,',',hdr.endTime],'Format','MM.dd.yy,HH.mm.ss');

    save([combinedEegSurgerySyncedFolder ,record],'eeg','hdr');
end

%% Write Excel File

[~, patientLocs] = unique(patientIDs);
patientLocs = sort(patientLocs);
[~, dateLocs] = unique(PhysicalLocationStartTimestamp);
dateLocs = sort(dateLocs);

locs = union(patientLocs, dateLocs);

eegFileList = eegFileList(locs);
patientIDs = patientIDs(locs);
orNumbers = orNumbers(locs);
PhysicalLocationStartTimestamp = PhysicalLocationStartTimestamp(locs);
PhysicalLocationEndTimestamp = PhysicalLocationEndTimestamp(locs);
eegStartDateTime = eegStartDateTime(locs);
eegEndDateTime = eegEndDateTime(locs);

%filename = 'matchSurgeryToEeg.xlsx';
filename = matchSurgeryToEegFile;
T = table(eegFileList, patientIDs, orNumbers, PhysicalLocationStartTimestamp,...
    PhysicalLocationEndTimestamp, eegStartDateTime, eegEndDateTime);
writetable(T,filename,'Sheet',1);

end
%% 
function [rowNumbers, visited, opt] = matchDateTime(startDateTime, endDateTime, phyStartDateTimes, phyEndDateTimes, visited);
    
opt = [];
rowNumbers = [];

% Opt 1: Times match perfectly: (within h = 1 hour)
h = 1;%Hour
startLocs = find(abs(seconds(startDateTime - phyStartDateTimes))< h *3600);
endLocs = find(abs(seconds(endDateTime - phyEndDateTimes)) < h * 3600);
if (length(startLocs) == 1)
    if (startLocs == endLocs)
        rowNumbers = [rowNumbers;startLocs];
        visited(startLocs) = visited(startLocs) + 1;
        opt = 1;
        return
    end
end

% Opt 5: EEG starts -> phyStartDateTime -> phyEndDateTimes -> EEG ends
startLocs = find(startDateTime < phyStartDateTimes);
endLocs = find(endDateTime > phyEndDateTimes);
startLocs = intersect(startLocs,endLocs);
if(~isempty(startLocs))
    rowNumbers = [rowNumbers;startLocs];
    visited(startLocs) = visited(startLocs) + 1;
    opt = 5*ones(length(startLocs),1);
    return
end


% Opt 2: EEG starts -> (in h = 1 hour) phyStartDateTime -> EEG ends -> phyEndDateTimes
stimeDiff = seconds(phyStartDateTimes - startDateTime);
startLocs = find(stimeDiff > 0*3600 & stimeDiff < h *3600);
endLocs = find(endDateTime > phyStartDateTimes & endDateTime < phyEndDateTimes);
if (~isempty(startLocs))
    if (startLocs == endLocs)
        rowNumbers = [rowNumbers;startLocs];
        visited(startLocs) = visited(startLocs) + 1;
        opt = 2;
        return
    end
end

% Opt 3: phyStartDateTimes -> EEG starts -> EEG ends -> phyEndDateTime occurs
startLocs = find(startDateTime > phyStartDateTimes & startDateTime < phyEndDateTimes);
endLocs = find(endDateTime > phyStartDateTimes & endDateTime < phyEndDateTimes);
startLocs = intersect(startLocs,endLocs);
if (~isempty(startLocs))
    rowNumbers = [rowNumbers;startLocs];
    visited(startLocs) = visited(startLocs) + 1;
    opt = 3;
end

% Opt 4: phyStartDateTimes -> EEG starts -> phyEndDateTime -> (in h = 1 hour) EEG ends 
startLocs = find(startDateTime > phyStartDateTimes & startDateTime < phyEndDateTimes);
etimeDiff = seconds(endDateTime - phyEndDateTimes);
endLocs = find(etimeDiff > 0*3600 & etimeDiff < h *3600);
if (~isempty(startLocs))
    if (startLocs == endLocs)
        rowNumbers = [rowNumbers;startLocs];
        visited(startLocs) = visited(startLocs) + 1;
        opt = 4;
    end
end

if(isempty(opt))
    opt = 0;
end
return
end