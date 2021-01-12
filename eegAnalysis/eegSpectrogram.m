function eegSpectrogram(eDataPath, sDataPath)
%
%   eegSpectrogram(eDataPath, sDataPath)
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
%       sDataPath - Path to the folder where we save the Spectrogram.png
%                  files
%
%   OUTPUT:
%       NONE
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

% List all edf folders in `eDataPath`
records = dir([eDataPath, '*_*']);
recordFlags = [records.isdir];
records = extractfield(records,'name')';
records = records(recordFlags);

ss = 1;
win = 5;% 5 seconds
shift = 1;% 1 second
noverlap = win-shift;
nfft = 1024;
% 
for ii = 1:length(records)

    dataFolder = [eDataPath, records{ii}, '/'];
    eegList = dir([dataFolder, '*.edf']);
    eegList = extractfield(eegList,'name');
    eeg = [];
    
    orNumber = orNumberExtraction(dataFolder);
    
    for jj = 1:length(eegList)

        % Construct EEG File name
        eegFile = [dataFolder, eegList{jj}];
        
        % Read header, signal and diiference-signal from the EEG file
        [header, ~, ~] = eegFileReader(eegFile, orNumber);
        
        yl = {'Fp1','Fp2','F7','F8'};
        if(~isempty(val))
            figure(1);
            ax = zeros(4,1);
            for kk = 1:4
                ax(kk)=subplot(4,1,kk);
                spectrogram(val(kk,:),floor(win*fs),floor(noverlap*fs),0:1/fs:40/fs);view(90,-90)
                if(kk==1)
                    title({[header.startDate, ' : ', header.startTime];'Fp1'});
                else
                    title(yl{kk});
                end
            end
            
            set(findall(gcf,'-property','FontSize'),'FontSize',8);
            set(findall(gcf,'-property','fontweight'),'fontweight','bold');
            linkaxes(ax,'y');
            set(gcf,'units','normalized','outerposition',[0 0 1 1]);
            pause
            saveas(figure(1),[sDataPath, eegList{jj}, 'Spectrogram.png']);
        end
        ss = ss +1;
    end
end