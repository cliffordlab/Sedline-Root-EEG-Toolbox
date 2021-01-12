function [header,sig] = combineSingleDayData(file1,file2)
%
%   [header,sig] = combineSingleDayData(file1,file2)
%
%   OVERVIEW:   
%       Combine to different EEG mat files that were captured on the same
%       day and correspond to the same surgery
%
%   INPUT:      
%       file1 - First EEG mat file 
%       file2 - Second EEG mat file 
%
%   OUTPUT:
%       header - header corresponding to the combined files
%       sig - signal corresponding to the combined files
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
%
%%

% load file1
header = [];
sig = [];
try
    load(file1);
catch
    disp('Error loading file');
    return;
end
header1 = header;
sig1 = sig;

% load file2
header = [];
sig = [];
try
    load(file2);
catch
    disp('Error loading file');
    return;
end
header2 = header;
sig2 = sig;

nansamples = seconds(datetime(header2.starttime,'InputFormat','HH.mm.ss')...
    - datetime(header1.starttime,'InputFormat','HH.mm.ss'))*header1.frequency(1)...
    - header1.samples;
nansamples = round(nansamples);
sig = [sig1,nan(size(sig1,1),nansamples),sig2];

header = header1;
header.samples = length(sig);
end