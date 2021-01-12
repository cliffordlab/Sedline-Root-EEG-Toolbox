function eegBandEnergiesAndSpectrograms(eDataPath, sPlotPath)
%
%   eegBandEnergiesAndSpectrograms(eDataPath, sPlotPath)
%
%   OVERVIEW:   
%       This script plots the different computed EEG powers.       
%
%   INPUT:      
%       eDataPath - Path to the folder containing .edf EEG files
%       sPlotPath - Path to save plots
%
%   OUTPUT:
%       NONE
%
%   DEPENDENCIES & LIBRARIES:
%       https://github.com/cliffordlab/Sedline-Root-EEG-Toolbox/eegAnalysis/eegFileReader.m
%       https://github.com/cliffordlab/Sedline-Root-EEG-Toolbox/eegAnalysis/Energy_Calculator.m
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
clear
windowLength = 30;% 30 seconds
shift = 15;% 15 second
noverlap = windowLength-shift;
nfft = 1024;

% List all edf folders in `eDataPath`
records = dir([eDataPath, '*_*']);
recordFlags = [records.isdir];
records = extractfield(records,'name')';
records = records(recordFlags);
ss = 1;

% 
for ii = 1:length(records)

    dataFolder = [eDataPath, records{ii}, '/'];
    eegList = dir([dataFolder, '*.edf']);
    eegList = extractfield(eegList,'name');
    
    orNumber = orNumberExtraction(dataFolder);

    for jj = 1:length(eegList)
        
        % Construct EEG File name
        eegFile = [dataFolder, eegList{jj}];
        
        % Read header, signal and diiference-signal from the EEG file
        [header, signal, ~] = eegFileReader(eegFile, orNumber);
        
        %figure(1);
        %ax(1) = subplot(411);plot(1/fs:1/fs:length(signal)/fs,signal(1,:));ylabel('Fp1 (uV)');xlim([1, length(signal)/fs]);title([header.startDate, ' : ', hdr.starttime ]);
        %ax(2) = subplot(412);plot(1/fs:1/fs:length(signal)/fs,signal(2,:));ylabel('Fp2 (uV)');xlim([1, length(signal)/fs]);
        %ax(3) = subplot(413);plot(1/fs:1/fs:length(signal)/fs,signal(3,:));ylabel('F7 (uV)');xlim([1, length(signal)/fs]);
        %ax(4) = subplot(414);plot(1/fs:1/fs:length(signal)/fs,signal(4,:));ylabel('F8 (uV)');xlabel('time (sec)');xlim([1, length(signal)/fs]);
        %set(findall(gcf,'-property','FontSize'),'FontSize',16);
        %set(findall(gcf,'-property','fontweight'),'fontweight','bold');
        %linkaxes(ax,'y');
        %set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        %saveas(figure(1),[sPlotPath,eegFile(1:end-4),'signal.fig']);
        %saveas(figure(1),[sPlotPath,'signal.png']);
        
        yl = [{'Fp1';'[(uV)^2/s]'},{'Fp2';'[(uV)^2/s]'},{'F7';'[(uV)^2/s]'},{'F8';'[(uV)^2/s]'}];
        if(~isempty(signal))
            for kk = 1:4
                ll = 1;
                mm = 1;
                while ll+win*fs-1<length(signal)
                    s = signal(kk,ll:ll+floor(windowLENGTH*fs-1));
                    ll = ll+floor(shift*fs);
                    % Replace the Energy_Calculator function with a
                    % function of your choice to compute EEG power in
                    % different energy bands.
                    [D(kk,mm),T(kk,mm),A(kk,mm),B(kk,mm),G(kk,mm)] = Energy_Calculator(s,fs); 
                    mm = mm+1;
                end
            end
            figure(2);
            for kk = 1:4
                ax(kk) = subplot(4,1,kk);plot(D(kk,:),'b','LineWidth',2);ylim([0, max(2*median(D,2))]);
                ylabel(yl(:,kk))
                if(kk==1)
                    title([header.startDate, ' : ', hdr.starttime, ' : Delta Power' ]);
                end
            end
            xlabel('time (sec)');
            set(findall(gcf,'-property','FontSize'),'FontSize',16);
            set(findall(gcf,'-property','fontweight'),'fontweight','bold');
            linkaxes(ax,'y');
            set(gcf,'units','normalized','outerposition',[0 0 1 1]);
            saveas(figure(2),[sPlotPath,'DeltaPower.png']);
            
            figure(3);
            for kk = 1:4
                ax(kk) = subplot(4,1,kk);plot(T(kk,:),'b','LineWidth',2);ylim([0, max(2*median(T,2))]);
                ylabel(yl(:,kk))
                if(kk==1)
                    title([header.startDate, ' : ', hdr.starttime, ' : Theta Power' ]);
                end
            end
            xlabel('time (sec)');
            set(findall(gcf,'-property','FontSize'),'FontSize',16);
            set(findall(gcf,'-property','fontweight'),'fontweight','bold');
            linkaxes(ax,'y');
            set(gcf,'units','normalized','outerposition',[0 0 1 1]);
            saveas(figure(3),[sPlotPath,'ThetaPower.png']);
            
            figure(4);
            for kk = 1:4
                ax(kk) = subplot(4,1,kk);plot(A(kk,:),'b','LineWidth',2);ylim([0, max(2*median(A,2))]);
                ylabel(yl(:,kk))
                if(kk==1)
                    title([header.startDate, ' : ', hdr.starttime, ' : Alpha Power' ]);
                end
            end
            xlabel('time (sec)');
            set(findall(gcf,'-property','FontSize'),'FontSize',16);
            set(findall(gcf,'-property','fontweight'),'fontweight','bold');
            linkaxes(ax,'y');
            set(gcf,'units','normalized','outerposition',[0 0 1 1]);
            saveas(figure(4),[sPlotPath,'AlphaPower.png']);
            
            figure(5);
            for kk = 1:4
                ax(kk) = subplot(4,1,kk);plot(B(kk,:),'b','LineWidth',2);ylim([0, max(2*median(B,2))]);
                ylabel(yl(:,kk))
                if(kk==1)
                    title([header.startDate, ' : ', hdr.starttime, ' : Beta Power']);
                end
            end
            xlabel('time (sec)');
            set(findall(gcf,'-property','FontSize'),'FontSize',16);
            set(findall(gcf,'-property','fontweight'),'fontweight','bold');
            linkaxes(ax,'y');
            set(gcf,'units','normalized','outerposition',[0 0 1 1]);
            saveas(figure(5),[sPlotPath,'BetaPower.png']);
            
            figure(6);
            for kk = 1:4
                ax(kk) = subplot(4,1,kk);plot(G(kk,:),'b','LineWidth',2);ylim([0, max(2*median(G,2))]);
                ylabel(yl(:,kk));
                if(kk==1)
                    title([header.startDate, ' : ', hdr.starttime, ' : Gamma Power' ]);
                end
            end
            xlabel('time (sec)');
            set(findall(gcf,'-property','FontSize'),'FontSize',16);
            set(findall(gcf,'-property','fontweight'),'fontweight','bold');
            linkaxes(ax,'y');
            set(gcf,'units','normalized','outerposition',[0 0 1 1]);
            saveas(figure(6),[sPlotPath,'GammaPower.png']);
        end
        ss = ss +1;
        % % %                 if(~isempty(signal))
        % % %                 maxs = hdr.physicalMax;
        % % %                 mins = hdr.physicalMin;
        % % %                 flat_data = [0.00432, 0.012620, 0.02093, 0.029240];
        % % %                 % loop throgh the file for SQI details.
        % % %
        % % %                 c = [];
        % % %                 for kk = 1:4
        % % %                     for jj = 2:length(signal)
        % % %                         try
        % % %                         if(differenceValue(kk,jj) == 0 && round(signal(kk,jj)*100000)/100000==flat_data(kk))
        % % %                             c(kk,jj) = 0;
        % % %                             continue
        % % %                         end
        % % %                         catch
        % % %                         end
        % % %                         if(round(signal(kk,jj)*10)/10 == maxs(kk) || round(signal(kk,jj)*10)/10 == mins(kk))
        % % %                             c(kk,jj) = 2;
        % % %                         else
        % % %                             c(kk,jj) = 1;
        % % %                         end
        % % %                     end
        % % %                 end
        % % %                 c = [c,[0,1,2;0,1,2;0,1,2;0,1,2]];
        % % %                 figure(2);
        % % %                 yl = {'Fp1','Fp2','F7','F8'};
        % % %                 for kk = 1:4
        % % %                     ax(kk) = subplot(4,1,kk);imagesc(1/fs:1/fs:length(c)/fs,ones(length(c),1),c(kk,:));ylabel(yl{kk});set(gca,'YTicklabel',[]);
        % % %                     if(kk==1)
        % % %                         title([header.startDate, ' : ', hdr.starttime ]);
        % % %                     end
        % % %                 end
        % % %                 xlabel('time (sec)');
        % % %                 set(findall(gcf,'-property','FontSize'),'FontSize',16);
        % % %                 set(findall(gcf,'-property','fontweight'),'fontweight','bold');
        % % %                 map = [0 0 0;0 0 1;1 0 0];
        % % %                 colormap(map);
        % % %                 linkaxes(ax);
        % % %                 figure(2);cb = colorbar('manual','Position',[0.92 0.11 0.02 0.815]);
        % % %                 set(cb,'YTicklabel',[]);
        % % %                 hYlabel = ylabel(cb,'Flatline                         Clean EEG                        Clipping');
        % % %                 set(hYlabel,'Rotation',90);
        % % %                 set(gcf,'units','normalized','outerposition',[0 0 1 1]);
        % % %                 saveas(figure(2),['../EEG/', pi_list{pi}, '/', upload_list{upload},'/edf/',days_list{days},'/',EEG_list{EEG_file}(1:end-4),'_plots/','recordSQI.png']);
        % % %                 %pause
        % % %                 end
        
    end
end
