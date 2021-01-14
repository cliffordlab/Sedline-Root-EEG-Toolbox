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
%       Last Modified: January 14th, 2020 
%
%	COPYRIGHT (C) 2021 
%   LICENSE:    
%       This software may be modified and distributed under the terms
%       of the BSD 3-Clause license. See the LICENSE file in this repo for 
%       details.
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