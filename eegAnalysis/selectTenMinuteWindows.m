function selectTenMinuteWindows(mDataPath, combinedEEGTable)
%
%   selectTenMinuteWindows(mDataPath, combinedEEGTable)
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

% Process each mat-file via a for loop
for ii = 1:length(eegFileNames)
 
    % Load the mat-file
    load([mDataPath, eegFileNames{ii}]);
    fs = 100; %Hz
    age = allAges(ii); 
    startSample = startSamples(ii);
    startSample = str2double(startSample{1});
% % %     if startSample == 0
% % %         continue;
% % %     end
    
    endSample = startSample + fs*10*60;
    
    
    
    % Plot
    figure(1);
    ax(1) = subplot(411);plot(eeg(1,:));title([eegFileNames{ii}, '; Age = ', num2str(age)],'Interpreter', 'none');ylabel('Fp1');
    ax(2) = subplot(412);plot(eeg(2,:));ylabel('Fp2');
    ax(3) = subplot(413);plot(eeg(3,:));ylabel('F7');
    ax(4) = subplot(414);plot(eeg(4,:));ylabel('F8');
    linkaxes(ax, 'x');
    pause
% %     
% %     figure(2);
% %     ax(1) = subplot(411);plot((1/fs:1/fs:length(eeg)/fs)/3600,eeg(1,:));title([eegFileNames{ii}, '; Age = ', num2str(age)],'Interpreter', 'none');ylabel('Fp1');
% %     ax(2) = subplot(412);plot((1/fs:1/fs:length(eeg)/fs)/3600,eeg(2,:));ylabel('Fp2');
% %     ax(3) = subplot(413);plot((1/fs:1/fs:length(eeg)/fs)/3600,eeg(3,:));ylabel('F7');
% %     ax(4) = subplot(414);plot((1/fs:1/fs:length(eeg)/fs)/3600,eeg(4,:));ylabel('F8');
% %     linkaxes(ax, 'x');    

    % Plot
% % %     figure(1);
% % %     ax(1) = subplot(411);plot(eeg(2,:));ylabel('Fp2');title([eegFileNames{ii}, '; Age = ', num2str(age)],'Interpreter', 'none');
% % %     ax(2) = subplot(412);plot(startSample:endSample, eeg(2,startSample:endSample));ylabel('Fp2');
% % %     ax(3) = subplot(413);plot(eeg(3,:));ylabel('F7');
% % %     ax(4) = subplot(414);plot(startSample:endSample, eeg(3,startSample:endSample));ylabel('F7');
% % %     linkaxes(ax);
% % %     xlim([0, size(eeg,2)]);
% % %     disp(eegFileNames{ii});
% % %     pause
% % %     clc;

end

disp('Done');