function [header, signal, differenceSignal] = eegFileReader(eegFile, orNumber)
%
%   [header, signal, differenceSignal] = eegFileReader(eegFile, orNumber)
%
%   OVERVIEW:   
%       This script extracts the header and signal information from a given
%       EEG file, computes the corresponding difference signal and returns
%
%   INPUT:      
%       eegFile - Full path to EEG file
%       orNumber - Operating Room number where EEG was captured
%
%   OUTPUT:
%       header - Header info of the EEG signal
%       signal - EEG signal extracted from the EEG file in the path
%       differenceSignal - Difference signal corresponding to the extracted
%                          EEG signal
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
%       Last Modified: January 11th, 2021
%
%	COPYRIGHT (C) 2021
%   LICENSE:    
%       This software is offered freely and without warranty under 
%       the GNU (v3 or later) public license. See license file for
%       more information

%%
splits = regexp(eegFile, '/', 'split');
fileName = splits{end}(1:end-4);
record = splits{end - 1};
try
    [header, signal] = edfread(eegFile);
    fs = header.frequency(1);

    % Sanity check for all fs to be equal
    try
        if (unique(header.frequency) == fs)
        end
    catch
        disp('The sampling frequencies of differnt EEG channel do not match!');
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    resampleFs = 100;
    tx = 1/fs:1/fs:length(signal(1,:))/fs;
    signal = resample(signal', tx, resampleFs)';
    header.fs = resampleFs;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %differenceSignal = diff(val,10,2);
    differenceSignal = diff(signal,1,2);
    %zero_percent = length(find(dval==0))/length(dval(:))*100;
    flatSignalProportion = length(find(differenceSignal==0))/length(differenceSignal(:))*100;
    header.startDate = [header.startdate(4:5),'.',header.startdate(1:2),'.20',header.startdate(7:8)];
    header.startTime = header.starttime;
    header = rmfield(header, 'startdate');
    header = rmfield(header, 'starttime');
    
    header.secondsInterval = length(signal)/resampleFs;
    header.flatSignalProportion = flatSignalProportion;
    
    %Info{ss,8} = [hdr.startdate(4:5),'.',hdr.startdate(1:2),'.20',hdr.startdate(7:8)];
    %Info{ss,9} = hdr.starttime;
    %Info{ss,14} = length(val)/fs;
    %Info{ss,15} = zero_percent;
    %Info{ss,16} = ((100-zero_percent)*Info{ss,14})/100;
    dt = datetime([header.startDate,',',header.startTime],'Format','MM.dd.yy,HH.mm.ss')+seconds(header.secondsInterval);
    endDate = [sprintf('%02d.',month(dt)),sprintf('%02d.',day(dt)),num2str(year(dt))];
    endTime = [sprintf('%02d.',hour(dt)),sprintf('%02d.',minute(dt)),sprintf('%02d',floor(second(dt)))];
    %Info{ss,10} = enddate;
    %Info{ss,11} = endtime;
    header.endDate = endDate;
    header.endTime = endTime;
    %for xx = 0:jj-1
    %    Info{ss-xx,12} = enddate;
    %    Info{ss-xx,13} = endtime;
    %end
    %if (hdr.frequency(1)<64)
    %fs = hdr.frequency(1);
    %ax(1) = subplot(411);plot(1/fs:1/fs:length(signal)/fs,signal(1,:));title([pi_list{pi}, '/', upload_list{upload},'/edf/',days_list{days},'/',EEG_list{EEG_file}]);
    %ax(2) = subplot(412);plot(1/fs:1/fs:length(signal)/fs,signal(2,:));
    %ax(3) = subplot(413);plot(1/fs:1/fs:length(signal)/fs,signal(3,:));
    %ax(4) = subplot(414);plot(1/fs:1/fs:length(signal)/fs,signal(4,:));
    %end
    header.valid = 'True';
catch
    %Info{ss,8} = 'FileIsCorrupt';
    %Info{ss,9} = 'FileIsCorrupt';
    %Info{ss,10} = 'FileIsCorrupt';
    %Info{ss,11} = 'FileIsCorrupt';
    %Info{ss,14} = 0;
    %Info{ss,15} = 1000;
    %Info{ss,16} = 0;
    header.valid = 'False';
end
if (strcmp(record(1),'2'))
    recordStartDate = [record(5:6),'.',record(7:8),'.',record(1:4)];
    recordStartTime = [record(10:11),'.',record(12:13),'.',record(14:15)];
else
    recordStartDate = [record(end-10:end-9),'.',record(end-8:end-7),'.',record(end-14:end-11)];
    recordStartTime = [record(end-5:end-4),'.',record(end-3:end-2),'.',record(end-1:end)];
end
header.orNumber = orNumber;
header.fileName = fileName;
header.recordStartDate = recordStartDate;
header.recordStartTime = recordStartTime;

%Info{ss,1} = OR_number;
%Info{ss,2} = pi_list(pi);
%Info{ss,3} = upload_list(upload);
%Info{ss,4} = days_list(days);
%Info{ss,5} = eegList(jj);
%Info{ss,6} = Operation_date;
%Info{ss,7} = Operation_time;
%if(isempty(Info{ss,10}))
%    Info{ss,10} = 0;
%end
%if(isnan(Info{ss,10}))
%    Info{ss,10} = 0;
%end
%disp([header.startDate, '-', header.startTime, ' to ', header.endDate, '-', header.endTime]);
return
end