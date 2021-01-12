function generateSqiStatistics(eDataPath, sDataPath)
%
%   generateSqiStatistics(eDataPath, sDataPath)
%
%   OVERVIEW:   
%       This script computes the amount of flat-line and the amount of NaN 
%       signal in a given EEG record and plots this information.
%
%   INPUT:      
%       eDataPath - Path to the folder containing .edf EEG files
%       sDataPath - Path to the folder where we save the Spectrogram.png
%                   files
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

% 
for ii = 1:length(records)
    if (strcmp(records{ii}, '.DS_Store'))
        continue;
    end
    dataFolder = [eDataPath, records{ii}, '/'];
    eegList = dir([dataFolder, '*.edf']);
    eegList = extractfield(eegList,'name');
    
    orNumber = orNumberExtraction(dataFolder);

    for jj = 1:length(eegList)
        eegFile = [dataFolder, eegList{jj}];
        [header, signal, differenceSignal] = eegFileReader(eegFile, orNumber);
        fs = header.fs;
        if(~isempty(signal))
            maxs = header.physicalMax;
            mins = header.physicalMin;
            flat_data = [0.00432, 0.012620, 0.02093, 0.029240];
            % loop throgh the file for SQI details.
            
            c = [];
            for kk = 1:4
                for ll = 2:length(signal)
                    try
                        if(differenceSignal(kk,ll) == 0 && round(signal(kk,ll)*100000)/100000==flat_data(kk))
                            c(kk,ll) = 0;
                            continue
                        end
                    catch
                    end
                    if(round(signal(kk,ll)*10)/10 == maxs(kk) || round(signal(kk,ll)*10)/10 == mins(kk))
                        c(kk,ll) = 2;
                    else
                        c(kk,ll) = 1;
                    end
                end
            end
            c = [c,[0,1,2;0,1,2;0,1,2;0,1,2]];
            figure(2);
            yl = {'Fp1','Fp2','F7','F8'};
            for kk = 1:4
                ax(kk) = subplot(4,1,kk);imagesc(1/fs:1/fs:length(c)/fs,ones(length(c),1),c(kk,:));ylabel(yl{kk});set(gca,'YTicklabel',[]);
                if(kk==1)
                    title([header.startDate, ' : ', header.startTime ]);
                end
            end
            xlabel('time (sec)');
            set(findall(gcf,'-property','FontSize'),'FontSize',16);
            set(findall(gcf,'-property','fontweight'),'fontweight','bold');
            map = [0 0 0;0 0 1;1 0 0];
            colormap(map);
            linkaxes(ax);
            figure(2);cb = colorbar('manual','Position',[0.92 0.11 0.02 0.815]);
            set(cb,'YTicklabel',[]);
            hYlabel = ylabel(cb,'Flatline                         Clean EEG                        Clipping');
            set(hYlabel,'Rotation',90);
            set(gcf,'units','normalized','outerposition',[0 0 1 1]);
            saveas(figure(2),[sDataPath, eegList{jj}, 'recordSQI.png']);
            pause
        end
        ss = ss + 1;
    end
end