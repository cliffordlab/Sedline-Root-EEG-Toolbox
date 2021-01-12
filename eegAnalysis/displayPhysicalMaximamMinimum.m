function displayPhysicalMaximamMinimum(mDataPath, surgeryTable)
%
%   displayPhysicalMaximamMinimum(mDataPath, surgeryTable)
%
%   OVERVIEW:   
%       This script extracts physicalMaximum and physicalMinimum values 
%       from header files.
%
%   INPUT:      
%       mDataPath - Path to the folder containing .mat files containing
%                            - sig: eeg signal
%                            - hdr: header info
%       surgeryTable - A mat file consisting of aggregating patient 
%                      information. It has a field called 'eegFileNames'
%                      which is a cell array consisting of the EEG file
%                      names that are present in 'mDataPath'
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
%       Last Modified: January 11th, 2020 
%
%	COPYRIGHT (C) 2021 
%   LICENSE:    
%       This software is offered freely and without warranty under 
%       the GNU (v3 or later) public license. See license file for
%       more information
%
%%
load(surgeryTable);

eegFileNames = surgeryTable.eegFileNames;

physicalMaximums = [];
physicalMinimums = [];

for ii = 1: length(eegFileNames)
    load([mDataPath, eegFileNames{ii}]);
    physicalMaximums = [physicalMaximums;hdr.physicalMax];
    physicalMinimums = [physicalMinimums;hdr.physicalMin];
end