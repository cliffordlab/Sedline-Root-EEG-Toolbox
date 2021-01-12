function  DataPresentMatrixAnalysis(DataPresentFile, TotalUsefulDataCollectedFile)
%
%   DataPresentMatrixAnalysis(DataPresentFile, TotalUsefulDataCollectedFile)
%
%   OVERVIEW:   
%       Read data from matlab containers to matrices
%
%   INPUT:      
%       DataPresentFile - A matrix with info as to if EEG data was present
%                         on a given date
%       TotalUsefulDataCollectedFile - Consists of
%                                      'Tot_useful_data_collected' and
%                                      'Lost_data'
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
%       Last Modified: January 11th, 2021 
%
%	COPYRIGHT (C) 2021
%   LICENSE:    
%       This software is offered freely and without warranty under 
%       the GNU (v3 or later) public license. See license file for
%       more information

%%

load(DataPresentFile); % load dataPresent
load(TotalUsefulDataCollectedFile); % load Tot_useful_data_collected.mat

days = cell2mat(keys(dataPresent)');
days = days(:,1:end-4);

dateVector = datetime(days,'InputFormat','yyyyMMdd');
t1 = min(dateVector);
t2 = max(dateVector);
dateVector = (t1:t2)';

formatOut = 'yyyymmdd';
daysVector = datestr(dateVector,formatOut);
dataPresentMatrix = zeros(8,length(daysVector));
for ii = 1:length(daysVector)
    for jj = 1:8
        if(isKey(dataPresent,[daysVector(ii,:),'_OR',num2str(jj)]))
            dataPresentMatrix(jj,ii) = dataPresent...
                ([daysVector(ii,:),'_OR',num2str(jj)]);
        end
    end
end
Tot_mat = zeros(8,length(daysVector));
Lost_mat = zeros(8,length(daysVector));
for ii = 1:length(daysVector)
    for jj = 1:8
        if(isKey(dataPresent,[daysVector(ii,:),'_OR',num2str(jj)]))
            Tot_mat(jj,ii) = Tot_useful_data_collected...
                ([daysVector(ii,:),'_OR',num2str(jj)]);
            Lost_mat(jj,ii) = Lost_data...
                ([daysVector(ii,:),'_OR',num2str(jj)]);
        end
    end
end