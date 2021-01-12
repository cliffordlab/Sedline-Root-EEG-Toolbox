function acousticEvokedPotentials(eegFilesLocation, audioFile, audioStartDateTime, eegStartTime, eegEndTime)
%
%   acousticEvokedPotentials(eegFilesLocation, audioFile, audioStartDateTime, eegStartTime, eegEndTime)
%
%   OVERVIEW:   
%       Process EEG signal and the corresponding audio signal.
%
%   INPUT:      
%       eegFilesLocation - The full path the directory containing EEG files
%                          in the edf format.
%       audioFile - The fullpath to audio file,.
%       audioStartDateTime - The exact date-time when the audio signal
%                            began.
%       eegStartTime - The exact start date-time when we clip EEG signal
%                      for plotting.
%       eegEndTime - The exact end date-time when we clip EEG signal for
%                    plotting.
%
%   OUTPUT:
%       NONE
%
%   DEPENDENCIES & LIBRARIES:
%       calculatePsdEmory.m
%
%   REFERENCE: 
%       NONE
%
%	REPO:       
%       https://github.com/cliffordlab/Sedline-Root-EEG-Toolbox
%
%   ORIGINAL SOURCE AND AUTHORS:     
%       Pradyumna Byappanahalli Suresh
%       Last Modified: Jan 11th, 2021 
%
%	COPYRIGHT (C) 2021
%   LICENSE:    
%       This software is offered freely and without warranty under 
%       the GNU (v3 or later) public license. See license file for
%       more information
%
%% Read the subject's EEG signal which was captured while the subject was asleep

% Check if the input variable 'eegFileLocation' is a character string and is not empty
if(~isa(eegFilesLocation,'char') || strcmp(eegFilesLocation, ''))
   disp ('eegFileLocation: Please enter a valid EEG files location');
   return;
end

% Check if the input variable 'eegFileLocation' is a valid string with the
% location information corresponding to edf EEG files and read the list all
% the edf EEG files in the location
try
    eegFiles = dir([eegFilesLocation, '*.edf']);
catch
    disp ('eegFileLocation: Please enter a valid EEG files location');
    return;
end

% Obtain the list of edf EEG files in the input location
try
    eegFiles = extractfield(eegFiles,'name')';
catch
    disp('There are no edf EEG files in the input eegFileLocation');
    return;
end

% Declare empty variables to store the eeg signal and the corresponding headers
eeg = [];
hdr = cell(length(eegFiles),1);

% Read the edf EEG files and store the signals and their headers
for ii = 1:length(eegFiles)
    [hdr{ii}, sig] = edfread([eegFilesLocation, eegFiles{1}]);
    eeg = [eeg, sig];
end

% Extract signal sampling frequency from the header file
fsEEG = hdr{1}.frequency(1); 

% Extract the EEG signal's start date/time and compute its end date/time based on signal length 
eegStartDateTime = datetime([hdr{1}.startdate,',',hdr{1}.starttime, '.000'],'Format','dd.MM.yy,HH.mm.ss.SSS'); 
eegEndDateTime = eegStartDateTime + seconds((length(eeg)-1)/fsEEG);

% Construct the time-vector for the EEG signal
tEEG = (eegStartDateTime:seconds(1/fsEEG):eegEndDateTime)';

%% Read the audio file which was played into subject's ears while the subject was asleep

% Check if the input variable 'audioFile' is a character string and is not empty
if(~isa(audioFile,'char') || strcmp(audioFile, ''))
   disp ('audioFile: Please enter a valid audio file location');
   return;
end

% Check if the input variable 'audioFile' is a valid string with the location 
% information corresponding to the audio file and read the audio file
try
    [audioSignal, fsAudio] = audioread(audioFile);
catch
    disp('audioFile: lease enter a valid EEG files location');
    return
end

% Using the audio signal length and 'audioStartDateTime', construct the 'audioEndDateTime'
audioEndDateTime = audioStartDateTime + seconds((length(audioSignal)-1)/fsAudio);

% Construct the time-vector for the audio signal
tAudio = (audioStartDateTime:seconds(1/fsAudio):audioEndDateTime)';


%% EEG plot when audio was played in subject's years

% Crop the EEG signal based on the inputs 'eegStartTime' and 'eegEndTime'
sig = eeg(:,tEEG > eegStartTime & tEEG < eegEndTime);

% Construct corresponding time vector
tx = 1/fsEEG:1/fsEEG:(size(sig,2))/fsEEG;

% Define ylables and the coordinates for shading the region when the audio was played
ylabels = {'Fp1', 'Fp2', 'F7', 'F8'};
X = [8.8, 8.8, 54, 54];
Y = [-15, 5.5, 5.5, -15; -10, 15, 15, -10; -20, 30, 30, -20; -10, 30, 30, -10];

% Declare figure and axes
figure(1);
ax = ones(4,1);

% Plot four subplots each corresponding to an EEG channel
for ii = 1:4
    ax(ii) = subplot(4,1,ii); plot(tx, sig(ii,:),'b','LineWidth',2);hold on;
    h = fill(X,Y(ii,:),'y'	); hold off;
    set(h,'facealpha',.3)
    ylim(Y(ii,1:2));
    ylabel({ylabels{ii}, 'Amplitude', '$$(\mu V)$$'},'Interpreter','latex');
    set(gca,'FontSize',24);
    xlim([0, 90]);
    yticks([Y(ii,1), 0, Y(ii,2)]);
end
xlabel('time (seconds)');



%% Plot EEG signal and the recorded audio signal in five subplots

% Declare figure and axes
figure(2);
ax = ones(5,1);

% Plot four subplots each corresponding to an EEG channel
for ii = 1:4
    ax(ii) = subplot(5,1,ii); plot(tEEG, eeg(ii,:));hold on;
end

% Plot the audio signal in a fifth subplot and link axes
ax(5) = subplot(515); plot(tAudio, audioSignal);
linkaxes(ax, 'x');

%% Plot EEG Spectrogram and the audio spectrogram

% Set spectrogram settings
windowLength = 2; %seconds
shift = 1; %second
nfft = 1024;

% Set time-axis settings
nXticks = 10;
datefmt = 'MM:SS';

% Set frequency-axis upper limit
tfreq = min([40,fsEEG/2]);
uplim = ceil((tfreq/(fsEEG/2))*(nfft/2));

% Crop the time-axis of the audio to include a specific region
tStart = audioStartDateTime + seconds(1770);
tEnd = tStart + seconds(100);

% Crop the EEG signal to include time-points corresponding to the cropped audio time-axis
eegLocations = tEEG >= tStart & tEEG <= tEnd;
eeg = eeg(:, eegLocations);

% Crop the audio signal to include a specific region for spectrogram computation
audioLocations = tAudio >= tStart & tAudio <= tEnd;
audioSignal = audioSignal(audioLocations, 1);

% Declare figure and axes
figure(3);
ax1 = ones(5,1);

% Compute EEG spectrogram and plot them along four subplots each corresponding to an EEG channel
for ii = 1:4
    sig = eeg(ii, :);
    [~, s, ~] = calculatePsdEmory(sig,fsEEG, nfft, windowLength, shift) ; 
    ax1(ii) = subplot(5,1,ii);
    xx = [1, size(s,2)];
    yy = [0 tfreq];
    imagesc(xx,yy,flipud(log(abs(s(1:uplim,:)))));
    yticks(tfreq-(floor(tfreq/10)*10):10:tfreq);
    yticklabels((floor(tfreq/10)*10):-10:0);
    xticks(1:(size(s,2) - 1)/nXticks:size(s,2));
    xlabels = cellstr(datestr( tStart:seconds(nWindows*shift)/nXticks:tStart + seconds(nWindows*shift), datefmt ));
    xticklabels(xlabels);
    ylabel('Frequency (Hz)');xlabel ('time');colorbar
end

% Compute audio spectrogram and plot it along the fifth subplot
sig = audioSignal;
tfreq = fsAudio/2 + 1;
[~, s, ~] = calculatePsdEmory(sig,fsAudio, nfft, windowLength, shift); 
ax1(5) = subplot(5,1,5);
xx = [1, size(s,2)];
yy = [0 tfreq];
imagesc(xx,yy,flipud(log(abs(s))));
yticks(tfreq-(floor(tfreq/10000)*10000):10000:tfreq);
yticklabels((floor(tfreq/10000)*10000):-10000:0);
xticks(1:(size(s,2) - 1)/nXticks:size(s,2));
xlabels = cellstr(datestr( tStart:seconds(nWindows*shift)/nXticks:tStart + seconds(nWindows*shift), datefmt ));
xticklabels(xlabels);
ylabel('Frequency (Hz)');xlabel ('time');colorbar


