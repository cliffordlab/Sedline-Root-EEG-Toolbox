function combinedEegPlotter(mDataPath)
%
%   combinedEegPlotter(mDataPath)
%
%   OVERVIEW:   
%       This scripts loads EEG mat files in a folder and plots them one by
%       one.
%
%   INPUT:      
%       mDataPath - Path to the folder containing .mat files containing
%                            - eeg: eeg signal
%                            - header: header info
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
%       Pradyumna B. Suresha
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

% Process each mat-file via a for loop
for ii = 1:length(EEG_files)
    
    load([mDataPath, EEG_files{ii}]);
    fs = header{1}.fs;
    tx = 1/fs : 1/fs :size(eeg,2)/fs;
    ax = zeros(4,1);
    for jj = 1:4
        ax(jj) = subplot(4,1,jj); plot(tx, eeg(jj,:));
    end
    
    linkaxes(ax, 'x');
    pause
end