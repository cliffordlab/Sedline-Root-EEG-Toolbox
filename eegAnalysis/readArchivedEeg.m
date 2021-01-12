function [header, signal, differenceSignal] = readArchivedEeg(eDataPath)
%
%   [header, signal, differenceSignal] = readArchivedEeg(eDataPath)
%
%   OVERVIEW:   
%       This script is used to read EEG signals in edf files saved by 
%       Raspberry Pi uploads of edf files from Root monitor using scripts 
%       in the following github repo: 
%       https://github.com/cliffordlab/Sedline-Monitor  
%       and plot the spectrogram for each edf file. We also create a header
%       file for each edf file.
%
%   INPUT:      
%       eDataPath - Path to the folder containing .edf EEG files
%
%   OUTPUT:
%       header -  EEG signal header information
%       signal - EEg signal
%       differenceSignal - Difference signal corresponding to EEG signal
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
%
%%

% List all folders in `eDataPath`
records = dir([eDataPath, '*_*']);
recordFlags = [records.isdir];
records = extractfield(records,'name')';
records = records(recordFlags);

for ii = 1:length(records)
    
    dataFolder = [eDataPath, records{ii}, '/'];
    eegList = dir([dataFolder, '*.edf']);
    eegList = extractfield(eegList,'name');
    
    orNumber = orNumberExtraction(dataFolder);

    for jj = 1:length(eegList)
        
        % Construct EEG File name
        eegFile = [dataFolder, eegList{jj}];
        
        % Read header, signal and difference-signal from the EEG file
        [header, signal, differenceSignal] = eegFileReader(eegFile, orNumber);
        
    end
end