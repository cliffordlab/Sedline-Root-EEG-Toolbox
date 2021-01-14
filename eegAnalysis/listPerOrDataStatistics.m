function listPerOrDataStatistics(surgeryFile)
%
%   listPerOrDataStatistics(surgeryFile)
%
%   OVERVIEW:   
%       This scripts computes an prints the number of surgeries performed 
%       and the number of patients treated in each OR for whom we have EEG 
%       signal        
%
%   INPUT:      
%       surgeryFile - xlsx file with surgery info which can be read as a
%                     table and has the following fields
%                               - orNumbers: The OR number  
%                               - Patient: Patient ID
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
% List of mat-files to process
% surgeryFile = [repoRootFolder, 'data/patientInfo/SurgeryTable.xlsx']; 
surgeryTable = readtable(surgeryFile);
orNumbers = surgeryTable.orNumbers;
patientIds = surgeryTable.Patient;

% OR 1
orNumber1Locations = find(orNumbers == 1);
patientIds1 = patientIds(orNumber1Locations);
uPatientIds1 = unique(patientIds1);

% OR 2
orNumber2Locations = find(orNumbers == 2);
patientIds2 = patientIds(orNumber2Locations);
uPatientIds2 = unique(patientIds2);

% OR 3
orNumber3Locations = find(orNumbers == 3);
patientIds3 = patientIds(orNumber3Locations);
uPatientIds3 = unique(patientIds3);

% OR 4
orNumber4Locations = find(orNumbers == 4);
patientIds4 = patientIds(orNumber4Locations);
uPatientIds4 = unique(patientIds4);

% OR 5
orNumber5Locations = find(orNumbers == 5);
patientIds5 = patientIds(orNumber5Locations);
uPatientIds5 = unique(patientIds5);

% OR 6
orNumber6Locations = find(orNumbers == 6);
patientIds6 = patientIds(orNumber6Locations);
uPatientIds6 = unique(patientIds6);

% OR 7
orNumber7Locations = find(orNumbers == 7);
patientIds7 = patientIds(orNumber7Locations);
uPatientIds7 = unique(patientIds7);

% OR 8
orNumber8Locations = find(orNumbers == 8);
patientIds8 = patientIds(orNumber8Locations);
uPatientIds8 = unique(patientIds8);

[length(orNumber1Locations), length(orNumber2Locations), length(orNumber3Locations), length(orNumber4Locations)...
    length(orNumber5Locations), length(orNumber6Locations), length(orNumber7Locations), length(orNumber8Locations)]'

[length(uPatientIds1), length(uPatientIds2), length(uPatientIds3), length(uPatientIds4),...
    length(uPatientIds5), length(uPatientIds6), length(uPatientIds7), length(uPatientIds8)]'