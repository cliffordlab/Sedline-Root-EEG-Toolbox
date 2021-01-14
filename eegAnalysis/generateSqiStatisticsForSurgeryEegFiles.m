function generateSqiStatisticsForSurgeryEegFiles(mDataPath, surgeryFile, sqiFilteredSurgeryTableFile, eegSignalQualityFile)
%
%   generateSqiStatisticsForSurgeryEegFiles(mDataPath, surgeryFile, sqiFilteredSurgeryTableFile, eegSignalQualityFile)
%
%   OVERVIEW:   
%       EEG files for which we have surgery information, we compute the 
%       amount of flat-line signal, clipping signal, nan-signal, clean EEG
%       signal and the total signal length. Further we compute variuous 
%       statistics corresponding to each of these metrics and create
%       different plots
%
%   INPUT:      
%       mDataPath - Path to the folder containing .mat files containing
%                            - eeg: eeg signal
%                            - hdr: header info
%       surgeryFile - xlsx file with surgery info which can be read as a
%                     table
%       sqiFilteredSurgeryTableFile - Surgery xlsx file generated after
%                                     filtering the rows based on the 
%                                     metrics: eSQI and total length 
%       eegSignalQualityFile - The .mat file used to save the various EEG
%                              signal quality metrics
%
%   OUTPUT:
%       NONE
%
%   DEPENDENCIES & LIBRARIES:
%       boxplot2-pkg: https://github.com/kakearney/boxplot2-pkg
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
% List of mat-files to process

surgeryTable = readtable(surgeryFile);
eegFileList = surgeryTable.eegFileNames;
%anesthesiaStartTime = datetime(surgeryTable.AnesthesiaStartTimestamp,'InputFormat','MM/dd/yy HH:mm:SS');
%anesthesiaStopTime = datetime(surgeryTable.AnesthesiaStopTimestamp,'InputFormat','MM/dd/yy HH:mm:SS');
eegStartTimestamp = surgeryTable.eegStartTimestamp;
eegEndTimestamp = surgeryTable.eegEndTimestamp;
orNumbers = surgeryTable.orNumbers;

flatLineSeconds = zeros(length(eegFileList), 1);
noSignalSeconds = zeros(length(eegFileList), 1);
clippingSeconds = zeros(length(eegFileList), 1);
cleanSeconds = zeros(length(eegFileList), 1);
totalSeconds = zeros(length(eegFileList), 1);

%% 
for ii = 1:length(eegFileList)
    
    eegFile = [mDataPath, eegFileList{ii}];
    load(eegFile);
    orNumber = orNumbers(ii);
    fs = hdr.fs;
    
    eegFileStart = datetime([hdr.startDate,',',hdr.startTime],'Format','MM.dd.yy,HH.mm.ss');
    startAt = round(seconds(eegStartTimestamp(ii) - eegFileStart) * fs) + 1;
    %if (eegStartTimestamp(ii) < anesthesiaStartTime(ii) - hours(1))
    %    startAt = round(seconds((anesthesiaStartTime(ii) - hours(1)) - eegStartTimestamp(ii)) * fs);
    %end
    
    eegFileEnd = datetime([hdr.endDate,',',hdr.endTime],'Format','MM.dd.yy,HH.mm.ss');
    endAt = length(eeg) - round(seconds(eegFileEnd - eegEndTimestamp(ii)) * fs) - 1;
    %if (eegEndTimestamp(ii) > anesthesiaStopTime(ii) + hours(1))
    %    endAt = length(eeg) - round(seconds(eegEndTimestamp(ii) - (anesthesiaStopTime(ii) + hours(1))) * fs);
    %end
    
    if(~isempty(eeg))
        eeg = eeg(:,startAt:endAt);
        differenceSignal = diff(eeg,1,2);
        differenceSignal = round(differenceSignal*1000)/1000;
        maxs = hdr.physicalMax;
        mins = hdr.physicalMin;
        flat_data = [0.0043, 0.0126, 0.0209, 0.0292];
        % loop throgh the file for SQI details.
        
        c = ones(4, size(eeg,2));
        %c = [];
        for kk = 1:4
%             for ll = 2:length(eeg)
            locs = isnan(eeg(kk,:));
            c(kk,locs) = 3;
            locs = differenceSignal(kk,:) == 0 & round(eeg(kk,2:end)*10000)/10000==flat_data(kk);
            c(kk,locs) = 0;
            locs = find(round(eeg(kk,:)*10)/10 > maxs(kk) | round(eeg(kk,:)*10)/10 < mins(kk));
            c(kk,locs) = 2;
%             if isnan(eeg(kk,ll))
%                 c(kk,ll) = 3;
%                 continue;
%             end
%             try
%                 if(differenceSignal(kk,ll) == 0 && round(eeg(kk,ll)*10000)/10000==flat_data(kk))
%                     c(kk,ll) = 0;
%                     continue
%                 end
%             catch
%             end
%             if(round(eeg(kk,ll)*10)/10 == maxs(kk) || round(eeg(kk,ll)*10)/10 == mins(kk))
%                 c(kk,ll) = 2;
%             else
%                 c(kk,ll) = 1;
%             end
%             end
        end
        %c = [c,[0,1,2,3;0,1,2,3;0,1,2,3;0,1,2,3]];
        for jj = 1:4
            flatLineSeconds(ii,jj) = sum(c(jj,:)==0)/fs;
            noSignalSeconds(ii,jj) = sum(c(jj,:)==3)/fs;
            clippingSeconds(ii,jj) = sum(c(jj,:)==2)/fs;
            cleanSeconds(ii,jj) = sum(c(jj,:)==1)/fs;
            totalSeconds(ii,jj) = cleanSeconds(ii,jj) + clippingSeconds(ii,jj) + flatLineSeconds(ii,jj);
        end
    end
    clc;
    disp(['Processed ', num2str(ii), ' of ', num2str(length(eegFileList)),...
        ' files. Current Fs = ', num2str(fs)]);
        
        
% % %         figure(2);
% % %         yl = {'Fp1','Fp2','F7','F8'};
% % %         for kk = 1:4
% % %             ax(kk) = subplot(4,1,kk);imagesc(1/fs:1/fs:length(c)/fs,ones(length(c),1),c(kk,:));ylabel(yl{kk});set(gca,'YTicklabel',[]);
% % %             if(kk==1)
% % %                 title([hdr.startDate, ' : ', hdr.startTime ]);
% % %             end
% % %         end
% % %         xlabel('time (sec)');
% % %         set(findall(gcf,'-property','FontSize'),'FontSize',16);
% % %         set(findall(gcf,'-property','fontweight'),'fontweight','bold');
% % %         map = [0 0 0;0 0 1;1 0 0;0 1 0];
% % %         colormap(map);
% % %         linkaxes(ax);
% % %         figure(2);cb = colorbar('manual','Position',[0.92 0.11 0.02 0.815]);
% % %         set(cb,'YTicklabel',[]);
% % %         hYlabel = ylabel(cb,'Flatline                         Clean EEG                        Clipping                        NoSignal');
% % %         set(hYlabel,'Rotation',90);
% % %         set(gcf,'units','normalized','outerposition',[0 0 1 1]);
% % %         %saveas(figure(2),['../EEG/', pi_list{pi}, '/', upload_list{upload},'/edf/',days_list{days},'/',EEG_list{EEG_file}(1:end-4),'_plots/','recordSQI.png']);
% % %         figure(1);
% % %         ax(1) = subplot(411);plot(eeg(1,:));
% % %         ax(2) = subplot(412);plot(eeg(2,:));
% % %         ax(3) = subplot(413);plot(eeg(3,:));
% % %         ax(4) = subplot(414);plot(eeg(4,:));
% % %         pause
% % %     end
end
totals = cleanSeconds + clippingSeconds + flatLineSeconds + noSignalSeconds;
totals = totals(:,1); % Includes nans
totalSeconds = totalSeconds(:,1); % Excludes nans.
meanCleanSeconds = mean(cleanSeconds, 2);
%save([repoRootFolder, 'data/patientInfo/eegSignalQuality.mat'], 'flatLineSeconds', 'noSignalSeconds', 'clippingSeconds', 'cleanSeconds', 'totalSeconds');
save(eegSignalQualityFile, 'flatLineSeconds', 'noSignalSeconds', 'clippingSeconds', 'cleanSeconds', 'totalSeconds');
%% SQI filtered surgery table
%surgeryFile = [repoRootFolder, 'data/patientInfo/SurgeryTable.xlsx']; 
surgeryTable = readtable(surgeryFile);

sqiThreshold = 0.5;
sqiFilteredSurgeryTable = surgeryTable;

%load([repoRootFolder, 'data/patientInfo/eegSignalQuality.mat'])
load(eegSignalQualityFile)
totalSeconds = totalSeconds(:,1); % Excludes nans.
sqi = cleanSeconds ./ repmat(totalSeconds,[1,4]);

indices1 = find(sqi(:,1)>sqiThreshold & sqi(:,2)>sqiThreshold & sqi(:,3)>sqiThreshold & sqi(:,4)>sqiThreshold);
indices2 = find(totalSeconds >= 1800); % less than 30 minutes.

indices = intersect(indices1, indices2);

sqiFilteredSurgeryTable = sqiFilteredSurgeryTable(indices,:);
%filename = [repoRootFolder, 'data/patientInfo/sqiFilteredSurgeryTable.xlsx']; 
filename = sqiFilteredSurgeryTableFile;
writetable(sqiFilteredSurgeryTable,filename,'Sheet',1);

flatLineSeconds = flatLineSeconds(indices,:);
noSignalSeconds = noSignalSeconds(indices,:);
clippingSeconds = clippingSeconds(indices,:);
cleanSeconds = cleanSeconds(indices,:);
totalSeconds = totalSeconds(indices,:);

%%
pth = './boxplot2-pkg/';
addpath(fullfile(pth, 'boxplot2')); 
addpath(fullfile(pth, 'minmax')); 
%load([repoRootFolder, 'data/patientInfo/eegSignalQuality.mat'])
load(eegSignalQualityFile)

y = randn(4,4,618);
y(1,:,:) = flatLineSeconds';
y(2,:,:) = clippingSeconds';
y(3,:,:) = cleanSeconds';
y(4,:,:) = totalSeconds';
x = 1:4;

h = boxplot2(y,x);
% Alter linestyle and color
cmap = get(0, 'defaultaxescolororder');
for ii = 1:4
structfun(@(x) set(x(ii,:), 'color', cmap(ii,:), ...
'markeredgecolor', cmap(ii,:)), h);
end
set([h.lwhis h.uwhis], 'linestyle', '-');
set(h.out, 'marker', 'none');
%set(h,{'linew'},{2})
legend({'Fp1', 'Fp2', 'F7', 'F8'},'Location','northwest');
grid on;
%ylim([-1, 15]);
xticks([1,2,3,4]);
xticklabels({'Flat Line Signal', 'Clipped Signal', 'EEG Signal', 'Total'});
xlabel('Signal category');
ylabel('Hours');
set(gca,'FontSize',24);
set(gca,'YScale','log');
set(findobj(gca,'type','line'),'linew',3)

%% Stats
eSQI = cleanSeconds./repmat(totalSeconds, [1,4]);
round([min(flatLineSeconds)', prctile(flatLineSeconds,25)', median(flatLineSeconds)', prctile(flatLineSeconds, 75)', max(flatLineSeconds)']) % Seconds;
round([min(clippingSeconds)', prctile(clippingSeconds,25)', median(clippingSeconds)', prctile(clippingSeconds, 75)', max(clippingSeconds)']) % Seconds;
round([min(cleanSeconds)'/60, prctile(cleanSeconds,25)'/60, median(cleanSeconds)'/60, prctile(cleanSeconds, 75)'/60, max(cleanSeconds)'/60]) % Minutes;
round([min(totalSeconds)'/60, prctile(totalSeconds,25)'/60, median(totalSeconds)'/60, prctile(totalSeconds, 75)'/60, max(totalSeconds)'/60]) % Minutes;
round([min(eSQI)', prctile(eSQI,25)', median(eSQI)', prctile(eSQI, 75)', max(eSQI)']*100)/100 % Hours
%% Stats
[min(flatLineSeconds)', prctile(flatLineSeconds,25)', median(flatLineSeconds)', prctile(flatLineSeconds, 75)', max(flatLineSeconds)'] % Minutes;
[min(clippingSeconds)', prctile(clippingSeconds,25)', median(clippingSeconds)', prctile(clippingSeconds, 75)', max(clippingSeconds)'] % Seconds
[min(cleanSeconds)', prctile(cleanSeconds,25)', median(cleanSeconds)', prctile(cleanSeconds, 75)', max(cleanSeconds)'] % Hours
[min(totalSeconds)', prctile(totalSeconds,25)', median(totalSeconds)', prctile(totalSeconds, 75)', max(totalSeconds)'] % Hours

%% Area Plot
%load([repoRootFolder, 'data/patientInfo/eegSignalQuality.mat'])
load(eegSignalQualityFile)

X = [mean(flatLineSeconds, 2), mean(clippingSeconds,2), mean(cleanSeconds,2), mean(totalSeconds,2)];
meanX = mean(X,1);
X = sortrows(X,4);
figure; hold on;
s1 = scatter(1:length(X(:,1)), X(:,1), 'bx', 'LineWidth', 3); s1.MarkerEdgeAlpha = .8; 
s2 = scatter(1:length(X(:,2)), X(:,2), 'mo', 'LineWidth', 1.5); s2.MarkerEdgeAlpha = .8;
s3 = scatter(1:length(X(:,3)), X(:,3), 'r+', 'LineWidth', 3); s3.MarkerEdgeAlpha = .8;
s4 = scatter(1:length(X(:,4)), X(:,4), 'k.'); s4.MarkerEdgeAlpha = .8;

%plot([1,618], [meanX(1), meanX(1)], 'b--', 'LineWidth', 3);
%plot([1,618], [meanX(2), meanX(2)], 'm--', 'LineWidth', 3);
%plot([1,618], [meanX(3), meanX(3)], 'r--', 'LineWidth', 3);
%plot([1,618], [meanX(4), meanX(4)], 'k--', 'LineWidth', 3);

plot([25, 25], [10^-3, 10^8], 'k--', 'LineWidth', 3);
plot([1, 618], [1800, 1800], 'k--', 'LineWidth', 3);

set(gca,'YScale','log');
legend({'Flat-Line Signal', 'Clipping Signal','True EEG Signal', 'Total'}, 'Location', 'northwest');
legend({'Average Amount of Flat-Line Signal',...
    'Average Amount of Clipping Signal',...
    'Average Amount of True EEG Signal',...
    'Total Signal Length'}, 'Location', 'northwest');
xlim([1,620])
ylim([10^-3, 10^8])
set(gca,'FontSize',24);
yticks([10^-2, 10^0, 10^2, 10^4])
xticks([25, 200, 400, 600])
xlabel('EEG Record Number');
ylabel('Signal Length (seconds)');
grid on
%% Loop to confirm flat line content and clipping content.

for ii = 1:length(eegFileList)
    eegFile = [mDataPath, eegFileList{ii}];
    load(eegFile);
    orNumber = orNumbers(ii);
    fs = hdr.fs;
    
    eegFileStart = datetime([hdr.startDate,',',hdr.startTime],'Format','MM.dd.yy,HH.mm.ss');
    startAt = round(seconds(eegStartTimestamp(ii) - eegFileStart) * fs) + 1;
    %if (eegStartTimestamp(ii) < anesthesiaStartTime(ii) - hours(1))
    %    startAt = round(seconds((anesthesiaStartTime(ii) - hours(1)) - eegStartTimestamp(ii)) * fs);
    %end
    
    eegFileEnd = datetime([hdr.endDate,',',hdr.endTime],'Format','MM.dd.yy,HH.mm.ss');
    endAt = length(eeg) - round(seconds(eegFileEnd - eegEndTimestamp(ii)) * fs) - 1;
    
    tx = (eegFileStart:seconds(1/fs):eegFileStart + seconds((size(eeg,2)-1)/fs));
    
    for jj = 1:4
        ax(jj) = subplot(4,1,jj);plot(tx, eeg(jj,:));hold on;
        title([eegFileList{ii}, ': Flat = ', num2str(round(flatLineSeconds(ii,jj)/totals(ii,jj)*100)),...
            '%, Clip = ', num2str(round(clippingSeconds(ii,jj)/totals(ii,jj) * 100)),...
            '%, Nan = ', num2str(round(noSignalSeconds(ii,jj)/totals(ii,jj)*100)), '%'], 'Interpreter', 'none');
        plot([eegFileStart + seconds(startAt/fs), eegFileStart + seconds(startAt/fs)], [min(eeg(jj,:)), max(eeg(jj,:))]);
        plot([eegFileStart + seconds(endAt/fs), eegFileStart + seconds(endAt/fs)], [min(eeg(jj,:)), max(eeg(jj,:))]);hold off;
        grid on;
    end
    xlabel('Time');
    linkaxes(ax, 'x');

    
    pause
    
end