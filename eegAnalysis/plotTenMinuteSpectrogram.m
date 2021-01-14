function plotTenMinuteSpectrogram(combinedEEGTable)
%
%   plotTenMinuteSpectrogram(combinedEEGTable)
%
%   OVERVIEW:   
%       This plot generates, displays and saves spectrogram corresponding
%       to 10-minute long EEG snippets which have been selected by the 
%       authors via visual inspection.
%
%   INPUT:      
%       NONE
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
% Read csv table corresponding to the above mat-files with surgery start-end info 
T = readtable(combinedEEGTable);
eegFileNames = T.eegFileNames;
dob = datetime(T.PatientBirthDate);
surgeryDate = datetime(T.SurgeryStartTimestamp) + calyears(2000);
startSamples = T.startingSample;
allAges = years(surgeryDate - dob);
%patientIDs = T.Patient;

nMin = 10;

% Process each mat-file via a for loop
for ii = 1:length(eegFileNames)
    disp([num2str(ii), ' out of ', num2str(length(eegFileNames))]);
    % Load the mat-file
    load([mDataPath, eegFileNames{ii}]);
    fs = 100; %Hz
    age = allAges(ii); 
    startSample = startSamples(ii);
    startSample = str2double(startSample{1});
    if startSample == 0
        continue;
    end
    
    endSample = startSample + fs*nMin*60;
    
    sigFp2 = eeg(2,startSample:endSample);
    sigFp2(isnan(sigFp2)) = [];
    sigF7 = eeg(3,startSample:endSample);
    sigF7(isnan(sigF7)) = [];
    
    spectrogram(sigF7,hann(5*fs),2.5*fs,512,fs);
    colormap jet;
    view([90,-90]);
    title(['Age = ', num2str(age)]);
    
    % Please create a folder names "tenMinuteSpectrograms" in the current
    % folder.
    saveas(gcf,['tenMinuteSpectrograms/',eegFileNames{ii}(1:end-4),'.png']);
    
    clc;
    
end