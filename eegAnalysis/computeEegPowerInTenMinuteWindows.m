function allPowers = computeEegPowerInTenMinuteWindows(mDataPath, combinedEEGTable)
%
%   allPowers = computeEegPowerInTenMinuteWindows(mDataPath, combinedEEGTable)
%
%   OVERVIEW:   
%       This is a wrapper script used to select 10 minute analyzable
%       windows.
%
%   INPUT:      
%       mDataPath - Path to the folder containing .mat files containing
%                            - sig: eeg signal
%                            - header: header info
%       combinedEEGTable - CSV table corresponding to the above mat-files 
%                          with surgery start-end info
%
%   OUTPUT:
%       allPowers - A matlab structure with the computed signal powers.
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
%       Last Modified: January 11th, 2021
%
%	COPYRIGHT (C) 2021 
%   LICENSE:    
%       This software is offered freely and without warranty under 
%       the GNU (v3 or later) public license. See license file for
%       more information
%%

% combinedEEGTable and mDataPath are arguments to this function.
% combinedEEGTable = '../data/patientInfo/sqiFilteredSurgeryTable.xlsx';
% mDataPath = '/Users/pradyumna/Sedline-Root-EEG-Toolbox/data/combined_EEG_surgerySynced/';

% Read csv table corresponding to the above mat-files with surgery start-end info 
T = readtable(combinedEEGTable);
eegFileNames = T.eegFileNames;
dob = datetime(T.PatientBirthDate);
surgeryDate = datetime(T.SurgeryStartTimestamp) + calyears(2000);
startSamples = T.startingSample;
allAges = years(surgeryDate - dob);
%patientIDs = T.Patient;

nMin = 10;
if (isinf(nMin))
    saveFileName = 'normalizedEegPowers_EntireSignal_ZeroMean';
else
    saveFileName = ['normalizedEegPowers_',num2str(nMin),'Minutes_ZeroMean'];
end

% Process each mat-file via a for loop
for ii = 1:length(eegFileNames)
    disp([num2str(ii), ' out of ', num2str(length(eegFileNames))]);
    % Load the mat-file
    load([mDataPath, eegFileNames{ii}]);
    fs = 100; %Hz
    age = allAges(ii); 
    if (isinf(nMin))
        startSample = 1;
    else
        startSample = startSamples(ii);
        startSample = str2double(startSample{1});
    end
    
    if startSample == 0
        continue;
    end
    
    if (isinf(nMin))
        endSample = size(eeg,2);
    else
        endSample = startSample + fs*nMin*60 - 1;
    end
    
    sigFp1 = eeg(1,startSample:endSample);
    sigFp1(isnan(sigFp1)) = [];
    sigFp2 = eeg(2,startSample:endSample);
    sigFp2(isnan(sigFp2)) = [];
    sigF7 = eeg(3,startSample:endSample);
    sigF7(isnan(sigF7)) = [];
    sigF8 = eeg(4,startSample:endSample);
    sigF8(isnan(sigF8)) = [];
    
    pMax = hdr.physicalMax;
    pMin = hdr.physicalMin;
    
    ax(1)=subplot(221);plot((1/fs:1/fs:length(sigFp1)/fs)/60, sigFp1); hold on; plot([1/fs, length(sigFp1)/fs]/60, [pMin(1), pMin(1)], 'k--', [1/fs, length(sigFp1)/fs]/60, [pMax(1), pMax(1)], 'k--'); hold off;title('Fp1'); ylim([pMin(1) - 10, pMax(1) + 10]);xlabel('Time (minutes)'); ylabel('\textsf{Amplitude} ($\mu V$)', 'Interpreter', 'latex');
    ax(2)=subplot(222);plot((1/fs:1/fs:length(sigFp2)/fs)/60, sigFp2);hold on; plot([1/fs, length(sigFp2)/fs]/60, [pMin(2), pMin(2)], 'k--', [1/fs, length(sigFp2)/fs]/60, [pMax(2), pMax(2)], 'k--'); hold off;title('Fp2'); ylim([pMin(2) - 10, pMax(2) + 10]);xlabel('Time (minutes)'); ylabel('\textsf{Amplitude} ($\mu V$)', 'Interpreter', 'latex');
    ax(3)=subplot(223);plot((1/fs:1/fs:length(sigF7)/fs)/60, sigF7);hold on; plot([1/fs, length(sigF7)/fs]/60, [pMin(3), pMin(3)], 'k--', [1/fs, length(sigF7)/fs]/60, [pMax(3), pMax(3)], 'k--'); hold off;title('F7'); ylim([pMin(3) - 10, pMax(3) + 10]);xlabel('Time (minutes)'); ylabel('\textsf{Amplitude} ($\mu V$)', 'Interpreter', 'latex');
    ax(4)=subplot(224);plot((1/fs:1/fs:length(sigF8)/fs)/60, sigF8);hold on; plot([1/fs, length(sigF8)/fs]/60, [pMin(4), pMin(4)], 'k--', [1/fs, length(sigF8)/fs]/60, [pMax(4), pMax(4)], 'k--'); hold off;title('F8'); ylim([pMin(4) - 10, pMax(4) + 10]);xlabel('Time (minutes)'); ylabel('\textsf{Amplitude} ($\mu V$)', 'Interpreter', 'latex');
    
    % Wavelet Based Power
    [waveletBasedDeltaPower_sigFp1(ii),waveletBasedThetaPower_sigFp1(ii),...
       waveletBasedAlphaPower_sigFp1(ii),waveletBasedBetaPower_sigFp1(ii),...
       waveletBasedGammaPower_sigFp1(ii), T] = Energy_Calculator_V2(sigFp1,fs);
    [waveletBasedDeltaPower_sigFp2(ii),waveletBasedThetaPower_sigFp2(ii),...
       waveletBasedAlphaPower_sigFp2(ii),waveletBasedBetaPower_sigFp2(ii),...
       waveletBasedGammaPower_sigFp2(ii)] = Energy_Calculator_V2(sigFp2,fs);
    [waveletBasedDeltaPower_sigF7(ii),waveletBasedThetaPower_sigF7(ii),...
       waveletBasedAlphaPower_sigF7(ii),waveletBasedBetaPower_sigF7(ii),...
       waveletBasedGammaPower_sigF7(ii)] = Energy_Calculator_V2(sigF7,fs);
   [waveletBasedDeltaPower_sigF8(ii),waveletBasedThetaPower_sigF8(ii),...
       waveletBasedAlphaPower_sigF8(ii),waveletBasedBetaPower_sigF8(ii),...
       waveletBasedGammaPower_sigF8(ii)] = Energy_Calculator_V2(sigF8,fs);
    
    % Spectrogram Based Power
    [spectrogramBasedDeltaPower_sigFp1(ii),spectrogramBasedThetaPower_sigFp1(ii),...
        spectrogramBasedAlphaPower_sigFp1(ii),spectrogramBasedBetaPower_sigFp1(ii),...
        spectrogramBasedGammaPower_sigFp1(ii)] = spectrogramBasedEnergyCalculator(sigFp1,fs);
    [spectrogramBasedDeltaPower_sigFp2(ii),spectrogramBasedThetaPower_sigFp2(ii),...
        spectrogramBasedAlphaPower_sigFp2(ii),spectrogramBasedBetaPower_sigFp2(ii),...
        spectrogramBasedGammaPower_sigFp2(ii)] = spectrogramBasedEnergyCalculator(sigFp2,fs);
    [spectrogramBasedDeltaPower_sigF7(ii),spectrogramBasedThetaPower_sigF7(ii),...
        spectrogramBasedAlphaPower_sigF7(ii),spectrogramBasedBetaPower_sigF7(ii),...
        spectrogramBasedGammaPower_sigF7(ii)] = spectrogramBasedEnergyCalculator(sigF7,fs);
    [spectrogramBasedDeltaPower_sigF8(ii),spectrogramBasedThetaPower_sigF8(ii),...
        spectrogramBasedAlphaPower_sigF8(ii),spectrogramBasedBetaPower_sigF8(ii),...
        spectrogramBasedGammaPower_sigF8(ii)] = spectrogramBasedEnergyCalculator(sigF8,fs);
    
end
allPowers.waveletBasedDeltaPower_sigFp1 = waveletBasedDeltaPower_sigFp1;
allPowers.waveletBasedThetaPower_sigFp1 = waveletBasedThetaPower_sigFp1;
allPowers.waveletBasedAlphaPower_sigFp1 = waveletBasedAlphaPower_sigFp1;
allPowers.waveletBasedBetaPower_sigFp1 = waveletBasedBetaPower_sigFp1;
allPowers.waveletBasedGammaPower_sigFp1 = waveletBasedGammaPower_sigFp1;

allPowers.waveletBasedDeltaPower_sigFp2 = waveletBasedDeltaPower_sigFp2;
allPowers.waveletBasedThetaPower_sigFp2 = waveletBasedThetaPower_sigFp2;
allPowers.waveletBasedAlphaPower_sigFp2 = waveletBasedAlphaPower_sigFp2;
allPowers.waveletBasedBetaPower_sigFp2 = waveletBasedBetaPower_sigFp2;
allPowers.waveletBasedGammaPower_sigFp2 = waveletBasedGammaPower_sigFp2;

allPowers.waveletBasedDeltaPower_sigF7 = waveletBasedDeltaPower_sigF7;
allPowers.waveletBasedThetaPower_sigF7 = waveletBasedThetaPower_sigF7;
allPowers.waveletBasedAlphaPower_sigF7 = waveletBasedAlphaPower_sigF7;
allPowers.waveletBasedBetaPower_sigF7 = waveletBasedBetaPower_sigF7;
allPowers.waveletBasedGammaPower_sigF7 = waveletBasedGammaPower_sigF7;

allPowers.waveletBasedDeltaPower_sigF8 = waveletBasedDeltaPower_sigF8;
allPowers.waveletBasedThetaPower_sigF8 = waveletBasedThetaPower_sigF8;
allPowers.waveletBasedAlphaPower_sigF8 = waveletBasedAlphaPower_sigF8;
allPowers.waveletBasedBetaPower_sigF8 = waveletBasedBetaPower_sigF8;
allPowers.waveletBasedGammaPower_sigF8 = waveletBasedGammaPower_sigF8;

allPowers.spectrogramBasedDeltaPower_sigFp1 = spectrogramBasedDeltaPower_sigFp1;
allPowers.spectrogramBasedThetaPower_sigFp1 = spectrogramBasedThetaPower_sigFp1;
allPowers.spectrogramBasedAlphaPower_sigFp1 = spectrogramBasedAlphaPower_sigFp1;
allPowers.spectrogramBasedBetaPower_sigFp1 = spectrogramBasedBetaPower_sigFp1;
allPowers.spectrogramBasedGammaPower_sigFp1 = spectrogramBasedGammaPower_sigFp1;

allPowers.spectrogramBasedDeltaPower_sigFp2 = spectrogramBasedDeltaPower_sigFp2;
allPowers.spectrogramBasedThetaPower_sigFp2 = spectrogramBasedThetaPower_sigFp2;
allPowers.spectrogramBasedAlphaPower_sigFp2 = spectrogramBasedAlphaPower_sigFp2;
allPowers.spectrogramBasedBetaPower_sigFp2 = spectrogramBasedBetaPower_sigFp2;
allPowers.spectrogramBasedGammaPower_sigFp2 = spectrogramBasedGammaPower_sigFp2;

allPowers.spectrogramBasedDeltaPower_sigF7 = spectrogramBasedDeltaPower_sigF7;
allPowers.spectrogramBasedThetaPower_sigF7 = spectrogramBasedThetaPower_sigF7;
allPowers.spectrogramBasedAlphaPower_sigF7 = spectrogramBasedAlphaPower_sigF7;
allPowers.spectrogramBasedBetaPower_sigF7 = spectrogramBasedBetaPower_sigF7;
allPowers.spectrogramBasedGammaPower_sigF7 = spectrogramBasedGammaPower_sigF7;

allPowers.spectrogramBasedDeltaPower_sigF8 = spectrogramBasedDeltaPower_sigF8;
allPowers.spectrogramBasedThetaPower_sigF8 = spectrogramBasedThetaPower_sigF8;
allPowers.spectrogramBasedAlphaPower_sigF8 = spectrogramBasedAlphaPower_sigF8;
allPowers.spectrogramBasedBetaPower_sigF8 = spectrogramBasedBetaPower_sigF8;
allPowers.spectrogramBasedGammaPower_sigF8 = spectrogramBasedGammaPower_sigF8;

save(saveFileName,'allAges','allPowers', 'nMin');

disp('computeEegPowerInTenMinuteWindows.m has completed its run.');