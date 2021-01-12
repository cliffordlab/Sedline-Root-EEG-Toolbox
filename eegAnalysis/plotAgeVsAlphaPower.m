function plotAgeVsAlphaPower(mDataPath, combinedEEGTable, nMin)
%
%   computeEegPowerInTenMinuteWindows(mDataPath, combinedEEGTable, nMin)
%
%   OVERVIEW:   
%       This is a wrapper script used to select 10 minute analyzable
%       windows.
%
%   INPUT:      
%       mDataPath - Path to the folder containing .mat files containing
%                            - sig: eeg signal.
%                            - header: header info.
%       combinedEEGTable - CSV table corresponding to the above mat-files 
%                          with surgery start-end info.
%       nMin - the length of signal in minutes to be selected for analysis.
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
%       Last Modified: January 11th, 2021
%
%	COPYRIGHT (C) 2021 
%   LICENSE:    
%       This software is offered freely and without warranty under 
%       the GNU (v3 or later) public license. See license file for
%       more information
%
%%
eegFileIndices = [269, 185, 260, 499]; % All 178 Hz sinals
T = readtable(combinedEEGTable);
eegFileNames = T.eegFileNames;
dob = datetime(T.PatientBirthDate);
surgeryDate = datetime(T.SurgeryStartTimestamp) + calyears(2000);
startSamples = T.startingSample;
allAges = years(surgeryDate - dob);
sig = {};
nSec = 60;
jj = 1;
winLength = 10; %seconds
shift = 5; %seconds
nfft = 1024;
maxFreq = 50; % Hz

figure(1);
% Process each mat-file via a for loop
for ii = eegFileIndices
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
    
    sigFp2 = eeg(2,startSample:endSample);
    sigFp2(isnan(sigFp2)) = [];
    
    sigFp2 = sigFp2(:);
    sigFp2 = sigFp2 - mean(sigFp2);
    
    sig{jj,1} = sigFp2;
    
    [~, nPSD, ~]=calculatePsdEmory (sig{jj,1}, fs, nfft, winLength, shift);

    %uplim = ceil((maxFreq/(fs/2))*(nfft/2));
    allPSDs{jj,1} = log(abs(nPSD));%(1:uplim,:)));
    jj = jj + 1;
end
% ax(1)=subplot(221);plot(1/fs:1/fs:length(sig{1})/fs, sig{1});title('20-year-old patient');
% ax(2)=subplot(222);plot(1/fs:1/fs:length(sig{2})/fs, sig{2});title('40-year-old patient');
% ax(3)=subplot(223);plot(1/fs:1/fs:length(sig{3})/fs, sig{3});title('60-year-old patient');
% ax(4)=subplot(224);plot(1/fs:1/fs:length(sig{4})/fs, sig{4});title('80-year-old patient');
bottom = min(min(cell2mat(allPSDs)));
top  = max(max(cell2mat(allPSDs)));
ages = [20, 40, 60, 80];
for jj = 1:4
    nPSD = allPSDs{jj};
    yy = [0 maxFreq]; % Hz
    xx = [1, size(nPSD,2)];
    ax(jj) = subplot(1,4,jj);imagesc(xx,yy,flipud(nPSD));hold on;
    plot([1, 118], [50-8, 50-8], 'k--',[1, 118], [50-12, 50-12], 'k--'); hold off;
    yt = yticks;
    yticklabels(fliplr(yt));
    %xt = xticks * shift;
    %tx = (1:size(nPSD,2)) * shift;
    %xt = [0, 120, 240, 360, 480, 600] / shift;
    xt = [5, 300, 590] / shift;
    xticks(xt);
    %xticklabels(xt * shift / 60);
    xticklabels([0, 5, 10]);
    yticks([0:10:50]);
    caxis manual;
    caxis([bottom top]);
    colormap('jet');
    xlabel('Time (minutes)');
    ylabel('Frequency (Hz)');
    title([num2str(ages(jj)), '-year-old-patient']);
end

h = colorbar;
set(get(h,'label'),'string','Power (dB)');

%spectrogram(sig, hann(1024), 512, 512, fs);

