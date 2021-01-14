function sqiAndSpectrogram(signal,header,timeInfo)
%
%   sqiAndSpectrogram(signal,header,timeInfo)
%
%   OVERVIEW:   
%       This script reads a EEG signal, its header and computes various SQI
%       metrics and plots (1) the signal spectrogram with overlayed time
%       information and (2) SQI information
%
%   INPUT:      
%       timeInfo - Information about various start and stop times is a
%                  matlab structure format
%       header - EEG signal header information
%       signal - EEg signal 
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
%       Pradyumna Byappanahalli Suresh
%       Last Modified: January 14th, 2021 
%
%	COPYRIGHT (C) 2021
%   LICENSE:    
%       This software may be modified and distributed under the terms
%       of the BSD 3-Clause license. See the LICENSE file in this repo for 
%       details.
%
%%
% differenceSignal = diff(signal,10,2);
differenceSignal = diff(signal,1,2);
%fs = header.frequency(1);
fs = 100;
% lsec= length(sig)/fs;
% zero_percent = length(find(differenceSignal==0))/length(differenceSignal(:))*100;
% startDate = [header.startDate(4:5),'.',header.startDate(1:2),'.20',header.startDate(7:8)];
startDateTime = timeInfo.eStart;
orNumber = header.orNumber;
%zperc = ((100-zero_percent)*lsec)/100;
maxs = header.physicalMax;
mins = header.physicalMin;
flat_data = [0.00432, 0.012620, 0.02093, 0.029240];
% c = [];
% for ii = 1:4
%     for jj = 2:length(signal)
%         try
%             if(differenceSignal(ii,jj) == 0 && round(signal(ii,jj)*100000)/100000==flat_data(ii))
%                 c(ii,jj) = 0;
%                 continue
%             end
%         catch
%         end
%         if(round(signal(ii,jj)*10)/10 == maxs(ii) || round(signal(ii,jj)*10)/10 == mins(ii))
%             c(ii,jj) = 2;
%         else
%             c(ii,jj) = 1;
%         end
%     end
% end
% c = [c,[0,1,2;0,1,2;0,1,2;0,1,2]];
% figure(2);
% yl = {'Fp1','Fp2','F7','F8'};
% for ii = 1:4
%     ax(ii) = subplot(4,1,ii);imagesc(1/fs:1/fs:length(c)/fs,ones(length(c),1),c(ii,:));ylabel(yl{ii});set(gca,'YTicklabel',[]);
%     if(ii==1)
%         title([sdate, ' : ', hdr.starttime ]);
%     end
% end
% xlabel('time (sec)');
% set(findall(gcf,'-property','FontSize'),'FontSize',16);
% set(findall(gcf,'-property','fontweight'),'fontweight','bold');
% map = [0 0 0;0 0 1;1 0 0];
% colormap(map);
% linkaxes(ax);
% figure(2);cb = colorbar('manual','Position',[0.92 0.11 0.02 0.815]);
% set(cb,'YTicklabel',[]);
% hYlabel = ylabel(cb,'Flatline                         Clean EEG                        Clipping');
% set(hYlabel,'Rotation',90);
% set(gcf,'units','normalized','outerposition',[0 0 1 1]);
nSamples = size(signal,2);
lags = calcLags(timeInfo, nSamples, fs);
windowLength = 30;% 30 seconds
shift = 15;% 15 second
noverlap = windowLength-shift;
nfft = 1024;
figure('DefaultAxesFontSize',16);
tfreq = min([50,fs/2]);
uplim = ceil((tfreq/(fs/2))*(nfft/2));
%xx = [1/(fs*3600), length(sig)/(fs*3600)];

yl = {'Fp1','Fp2','F7','F8'};

for ii = 1:4
    ax(ii)=subplot(4,1,ii);
    %spectrogram(sig(ii,:),floor(win*fs),floor(noverlap*fs),0:1/fs:fs/fs);view(90,-90)
    %s = spectrogram(sig(ii,:),floor(win*fs),floor(noverlap*fs),nfft,fs);%view(90,-90)
    [~, s, F] = calculatePsdEmory(signal(ii,:),fs, nfft, windowLength ,shift) ;
    s(s<10^-4) = NaN;
    %xx = flipud(log(abs(s(1:uplim,:))));
    %xx = xx/sqrt(sum(sum(xx.^2)));
    %Sur_St_expand = 0;
    %Phy_St_expand = 0;
    %Sur_End_expand = 0;
    %Phy_End_expand = 0;
    surgeryStartExpand = floor(-lags.surgeryStartLag/shift);
    phyStartExpand = floor(-lags.phyStartLag/shift);
    aneStartExpand = floor(-lags.aneStartLag/shift);
    surgeryEndExpand = floor(lags.surgeryEndLag/shift);
    phyEndExpand = floor(lags.phyEndLag/shift);
    aneEndExpand = floor(lags.aneEndLag/shift);
    maxStart = max([surgeryStartExpand,phyStartExpand,aneStartExpand]);
    maxEnd = max([surgeryEndExpand,phyEndExpand,aneEndExpand]);
    if(maxStart>0)
        s = [nan(size(s,1),maxStart),s];
    else
        maxStart = 0;
    end
    EEG_Start_loc = maxStart;
    if(maxEnd>0)
        s = [s,nan(size(s,1),maxEnd)];
    else
        maxEnd = 0;
    end
    EEG_End_loc = size(s,2) - maxEnd;
    xx = [1, size(s,2)];
    yy = [0 tfreq];
    % Add aditional K=50 columns of nans in beginning and end for better visualization.
    K = 50;
    s = [nan(size(s,1),K),s, nan(size(s,1),K)];
    xx = [xx(1)-K, xx(end)+K];
    
    
    
    imagesc(xx,yy,flipud(log(abs(s(1:uplim,:)))));
    hold on;
    try % If no date-time is available.... then skip
        plot(-aneStartExpand+EEG_Start_loc+1,1:tfreq,'r>', 'MarkerSize', 5, 'LineWidth',3);
        plot(-phyStartExpand+EEG_Start_loc+1,1:tfreq,'mo', 'MarkerSize', 5, 'LineWidth',3);
        plot(-surgeryStartExpand+EEG_Start_loc+1,1:tfreq,'ko', 'MarkerSize', 5, 'LineWidth',3);

        plot(surgeryEndExpand+EEG_End_loc,1:tfreq,'ko', 'MarkerSize', 5, 'LineWidth',3);
        plot(phyEndExpand+EEG_End_loc,1:tfreq,'mo', 'MarkerSize', 5, 'LineWidth',3);
        plot(aneEndExpand+EEG_End_loc,1:tfreq,'r<', 'MarkerSize', 5, 'LineWidth',3);
        
        text(-aneStartExpand+EEG_Start_loc+1,10,sprintf('Anesthesia\nbegins'),'FontSize',10,'FontWeight','bold','Color','red','BackgroundColor', 'white','HorizontalAlignment','center','VerticalAlignment','middle','Margin',1);
        text(-phyStartExpand+EEG_Start_loc+1,25,sprintf('Patient enters\nthe room'),'FontSize',10,'FontWeight','bold','Color','magenta','BackgroundColor', 'white','HorizontalAlignment','center','VerticalAlignment','middle','Margin',1);
        text(-surgeryStartExpand+EEG_Start_loc+1,5,sprintf('Surgery\nbegins'),'FontSize',10,'FontWeight','bold','Color','black','BackgroundColor', 'white','HorizontalAlignment','center','VerticalAlignment','middle','Margin',1);
        text(surgeryEndExpand+EEG_End_loc+1,5,sprintf('Surgery\nends'),'FontSize',10,'FontWeight','bold','Color','black','BackgroundColor', 'white','HorizontalAlignment','center','VerticalAlignment','middle','Margin',1);
        text(phyEndExpand+EEG_End_loc+1,25,sprintf('Patient exits\nthe room'),'FontSize',10,'FontWeight','bold','Color','magenta','BackgroundColor', 'white','HorizontalAlignment','center','VerticalAlignment','middle','Margin',1);        
        text(aneEndExpand+EEG_End_loc+1,10,sprintf('Anesthesia\nends'),'FontSize',10,'FontWeight','bold','Color','red','BackgroundColor', 'white','HorizontalAlignment','center','VerticalAlignment','middle','Margin',1);
    catch
    end
    yticks(tfreq-(floor(tfreq/10)*10):10:tfreq);
    yticklabels((floor(tfreq/10)*10):-10:0);
    xticks(1:round(size(s,2)/5):size(s,2));
    tStart = datetime(timeInfo.eStart) - seconds(EEG_Start_loc*shift);
    timeLabels = datestr(tStart:seconds(shift*round(size(s,2)/5)):tStart + seconds(shift*(size(s,2)-K)), 'hh:MM');
    %xticklabels(0:floor((100*shift/3600)*10)/10:(size(s,2)*shift)/3600)
    xticklabels(timeLabels)
    if(ii==1)
        title({['OR: ', num2str(orNumber)];['EEG Recording Start Date/Time: ', startDateTime]});
    end
    ylabel({yl{ii};'Frequency (Hz)'});xlabel ('time (HH:MM)');colorbar
end

%set(findall(gcf,'-property','FontSize'),'FontSize',16);
set(findall(gcf,'-property','fontweight'),'fontweight','bold');
colormap('parula')
linkaxes(ax,'y');
set(gcf,'units','normalized','outerposition',[0 0 1 1]);
dim = [.9 .49 .3 .3];
%str = {'<I Anesthesia Begins','-- Surgery begins','AB: ','SE: Surgery ends','AE: Anesthesia Ends','PL: Patient leaves the room'};
%annotation('textbox',dim,'String',str,'FitBoxToText','on','FontWeight','Bold');

end