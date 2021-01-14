function matchPatientIDtoSurgeryInfo(patientFile, surgeryFile, comorbidityFile, weightFile, medicineFile, surgeryTableFile, sqiFilteredSurgeryTableFile, primarySurgicalProcedureFile, comorbiditiesFile)
%
%   matchPatientIDtoSurgeryInfo(patientFile, surgeryFile, comorbidityFile, weightFile, medicineFile, surgeryTableFile, sqiFilteredSurgeryTableFile, primarySurgicalProcedureFile, comorbiditiesFile)
%
%   OVERVIEW:   
%       This script matches patient ID to the corresponding surgery
%       information. Further, the script computes statistics of various
%       patient & surgery information
%
%   INPUT:      
%       patientFile - Excel file with patient ID information.
%       surgeryFile - Excel file with surgery information.
%       comorbidityFile - Excel file with comorbidity information.
%       weightFile - Excel file with patient weight information.
%       medicineFile - Excel file with patient drug information.
%       surgeryTableFile - Full path name for the excel file created by 
%                          this script after aggregating various patient 
%                          information.
%       sqiFilteredSurgeryTableFile - Full path name for the excel file 
%                                     created by this script that contains 
%                                     aggregated patient information that 
%                                     was filtered using eSQI and total 
%                                     signal length.
%       primarySurgicalProcedureFile - Full path name for the text file 
%                                      created by this script that contains 
%                                      primary surgical procedures 
%                                      performed on the patients. 
%       comorbiditiesFile - Full path name for the text file created by 
%                           this script that contains comorbidity 
%                           information corresponding to all the patients. 
%
%   OUTPUT:
%       NONE
%
%   DEPENDENCIES & LIBRARIES:
%       https://github.com/cliffordlab/Sedline-Root-EEG-Toolbox
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

surgeryTable = [];

% matchSurgeryToEeg.xlsx
tPatientInfo = readtable(patientFile);
patientIDs = tPatientInfo.patientIDs;
phyStartDateTimes = tPatientInfo.PhysicalLocationStartTimestamp;
phyEndDateTimes = tPatientInfo.PhysicalLocationEndTimestamp;
phyDates = phyStartDateTimes;
phyDates.Hour = 0;phyDates.Minute = 0;phyDates.Second = 0;
phyDates.Format = 'dd-MMM-yyyy';

% EUOSH Surgery Cases by EMPI.csv
tSurgeryInfo = readtable(surgeryFile);
surgeryDates = datetime(tSurgeryInfo.AnesthesiaStartTimestamp) + calyears(2000);
surgeryDates.Hour = 0;surgeryDates.Minute = 0;surgeryDates.Second = 0;
surgeryDates.Format = 'dd-MMM-yyyy';
surgeryPatients = tSurgeryInfo.Patient;
surgeryPatients = cellfun(@str2double,surgeryPatients);

% EUOSH_EEG_Comorbidities.csv
tComorbidites = readtable(comorbidityFile);
comorbidityPatients = tComorbidites.PatientEMPINbr;
comorbidityDates = tComorbidites.ServiceDayAscendingDateDisplay + calyears(2000);
comorbidityDates.Hour = 0;comorbidityDates.Minute = 0;comorbidityDates.Second = 0;
comorbidityDates.Format = 'dd-MMM-yyyy';
comorbidities = tComorbidites.ICD_10DiagnosisDESC;

% EUOSH_EEG_Weight.csv
tWeights = readtable(weightFile);
weightEncounters = tWeights.Encounter;
weightEncounters = cellfun(@str2double,weightEncounters);
weights = tWeights.TextResult;
weights = cellfun(@str2double,weights);
weightsUnits = tWeights.StructuredResultType;
poundLocs = find(contains(weightsUnits,'Weight in Pounds'));
weights(poundLocs) = weights(poundLocs) * 0.453592;

% EUOSH_EEG_MedAdmin.csv
tMedicine = readtable(medicineFile);
medicinePatients = tMedicine.Patient;
medicines = tMedicine.OrderedItem;
medicineDates = datetime(tMedicine.ServiceTimestamp);
medicineDates.Hour = 0;medicineDates.Minute = 0;medicineDates.Second = 0;
medicineDates.Format = 'dd-MMM-yyyy';
medicineDosage = tMedicine.Dosage;
medicineDosageUnits = tMedicine.UnitMeasure;
medicineDosageUnits(find(contains(medicineDosageUnits,'Micrograms/Hour'))) = {'Micrograms'};
medicineDosageUnits(find(contains(medicineDosageUnits,'Milliliter'))) = {'Milligram'};

for ii = 1:length(patientIDs)
    clc;
    
    % matchSurgeryToEeg.xlsx
    patientID = patientIDs(ii);
    currentDate = phyDates(ii);
    
    % EUOSH Surgery Cases by EMPI.csv
    patientMatchRows = find(surgeryPatients == patientID);
    dateMatchRows = find(surgeryDates == currentDate);
    
    rowNumbers = intersect(patientMatchRows, dateMatchRows);
    
    % EUOSH_EEG_Comorbidities.csv
    patientMatchRows = find(comorbidityPatients == patientID);
    dateBeforeRows = find(comorbidityDates <= currentDate);
    dateAfterRows = find(comorbidityDates > currentDate);
    
    dateBeforeRows = intersect(patientMatchRows, dateBeforeRows);
    dateAfterRows = intersect(patientMatchRows, dateAfterRows);
    comorbiditiesBefore = {''};
    comorbiditiesAfter = {''};
    
    for jj = 1:length(dateBeforeRows)
       comorbiditiesBefore = {[comorbiditiesBefore{1}, comorbidities{dateBeforeRows(jj)}, ';']};
    end
    
    for jj = 1:length(dateAfterRows)
       comorbiditiesAfter = {[comorbiditiesAfter{1}, comorbidities{dateAfterRows(jj)}, ';']};
    end
    
    % EUOSH_EEG_MedAdmin.csv
    patientMatchRows = find(medicinePatients == patientID);
    dateMatchRows = find(medicineDates == currentDate);
    
    medicineRowNumbers = intersect(patientMatchRows, dateMatchRows);
    
    fentaNYL = 0;
    midazolam = 0;
    propofol = 0;
    
    for jj = 1:length(medicineRowNumbers)
        dosageValue = medicineDosage(medicineRowNumbers(jj));
        if (strcmp(medicineDosageUnits{medicineRowNumbers(jj)}, 'Milligram'))
            dosageValue = dosageValue * 1000;
        end
        
        if (strcmp(medicines{medicineRowNumbers(jj)}, 'fentaNYL'))
            fentaNYL = fentaNYL + dosageValue;
        elseif (strcmp(medicines{medicineRowNumbers(jj)}, 'midazolam'))
            midazolam = midazolam + dosageValue;
        else
            propofol = propofol + dosageValue;
        end
    end
    
    for jj = 1:length(rowNumbers)
        
        tRow = tSurgeryInfo(rowNumbers(jj),:);
        
        % matchSurgeryToEeg.xlsx
        tRow.eegFileNames = tPatientInfo.eegFileList(ii);
        tRow.orNumbers = tPatientInfo.orNumbers(ii);
        tRow.PhysicalLocationStartTimestamp = tPatientInfo.PhysicalLocationStartTimestamp(ii);
        tRow.PhysicalLocationEndTimestamp = tPatientInfo.PhysicalLocationEndTimestamp(ii);
        tRow.eegStartTimestamp = tPatientInfo.eegStartDateTime(ii);
        %if (tPatientInfo.eegStartTimestamp(ii) > tPatientInfo.PhysicalLocationStartTimestamp(ii))
        %    tRow.eegStartTimestamp = tPatientInfo.eegStartTimestamp(ii);
        %else
        %    tRow.eegStartTimestamp =  tPatientInfo.PhysicalLocationStartTimestamp(ii);
        %end
        tRow.eegEndTimestamp = tPatientInfo.eegEndDateTime(ii);
        %if (tPatientInfo.eegEndTimestamp(ii) < tPatientInfo.PhysicalLocationEndTimestamp(ii))
        %    tRow.eegEndTimestamp = tPatientInfo.eegEndTimestamp(ii);
        %else
        %    tRow.eegEndTimestamp = tPatientInfo.PhysicalLocationEndTimestamp(ii);
        %end

        % EUOSH_EEG_Comorbidities.csv
        tRow.comorbiditiesBefore = comorbiditiesBefore;
        tRow.comorbiditiesAfter = comorbiditiesAfter;
        
        % Weights
        encounter = str2double(tRow.Encounter{1});
        weightRows = find(weightEncounters  == encounter);
        allunits = weightsUnits(weightRows);
        tRow.weight = mean(weights(weightRows));
        tRow.weightUnits = {sprintf('%s;',allunits{:})};
        
        % EUOSH_EEG_MedAdmin.csv
        tRow.fentaNYL = fentaNYL;
        tRow.midazolam = midazolam;
        tRow.propofol = propofol;
        
        surgeryTable = [surgeryTable;tRow];
    end
    
end
% filename = [repoRootFolder, 'data/patientInfo/SurgeryTable.xlsx']; 
filename = surgeryTableFile;
writetable(surgeryTable,filename,'Sheet',1);
%%

% surgeryFile = [repoRootFolder, 'data/patientInfo/sqiFilteredSurgeryTable.xlsx']; 
surgeryFile = sqiFilteredSurgeryTableFile;
surgeryTable = readtable(surgeryFile);

% Gender:
gender = surgeryTable.Gender;
femaleLocs = find(contains(gender, 'Female'));
maleLocs = find(contains(gender, 'Male'));
nFemales = length(femaleLocs);
nMales = length(maleLocs);

% Age stats:
patientDob = datetime(surgeryTable.PatientBirthDate);
allVals = floor(years(datetime('now') - patientDob));
femaleVals = allVals(femaleLocs);
maleVals = allVals(maleLocs);

AgesStats.female.mean = nanmean(femaleVals);
AgesStats.female.std = nanstd(femaleVals);
AgesStats.female.variance = nanvar(femaleVals);
AgesStats.female.skewness = skewness(femaleVals);
AgesStats.female.kurt = kurtosis(femaleVals);
AgesStats.female.min = min(femaleVals);
AgesStats.female.max = max(femaleVals);
AgesStats.female.med = nanmedian(femaleVals);
AgesStats.female.prctile25 = prctile(femaleVals,25);
AgesStats.female.prctile75 = prctile(femaleVals,75);

AgesStats.male.mean = nanmean(maleVals);
AgesStats.male.std = nanstd(maleVals);
AgesStats.male.variance = nanvar(maleVals);
AgesStats.male.skewness = skewness(maleVals);
AgesStats.male.kurt = kurtosis(maleVals);
AgesStats.male.min = min(maleVals);
AgesStats.male.max = max(maleVals);
AgesStats.male.med = nanmedian(maleVals);
AgesStats.male.prctile25 = prctile(maleVals,25);
AgesStats.male.prctile75 = prctile(maleVals,75);

AgesStats.all.mean = nanmean(allVals);
AgesStats.all.std = nanstd(allVals);
AgesStats.all.variance = nanvar(allVals);
AgesStats.all.skewness = skewness(allVals);
AgesStats.all.kurt = kurtosis(allVals);
AgesStats.all.min = min(allVals);
AgesStats.all.max = max(allVals);
AgesStats.all.med = nanmedian(allVals);
AgesStats.all.prctile25 = prctile(allVals,25);
AgesStats.all.prctile75 = prctile(allVals,75);

% Patient in Room Duration:
startTime = datetime(surgeryTable.PatientIn_RoomTimestamp) + calyears(2000);
endTime = datetime(surgeryTable.PatientOut_of_RoomTimestamp) + calyears(2000);
allVals = minutes(endTime - startTime);
femaleVals = allVals(femaleLocs);
maleVals = allVals(maleLocs);

InRoomDurationStats.female.mean = nanmean(femaleVals);
InRoomDurationStats.female.std = nanstd(femaleVals);
InRoomDurationStats.female.variance = nanvar(femaleVals);
InRoomDurationStats.female.skewness = skewness(femaleVals);
InRoomDurationStats.female.kurt = kurtosis(femaleVals);
InRoomDurationStats.female.min = min(femaleVals);
InRoomDurationStats.female.max = max(femaleVals);
InRoomDurationStats.female.med = nanmedian(femaleVals);
InRoomDurationStats.female.prctile25 = prctile(femaleVals,25);
InRoomDurationStats.female.prctile75 = prctile(femaleVals,75);

InRoomDurationStats.male.mean = nanmean(maleVals);
InRoomDurationStats.male.std = nanstd(maleVals);
InRoomDurationStats.male.variance = nanvar(maleVals);
InRoomDurationStats.male.skewness = skewness(maleVals);
InRoomDurationStats.male.kurt = kurtosis(maleVals);
InRoomDurationStats.male.min = min(maleVals);
InRoomDurationStats.male.max = max(maleVals);
InRoomDurationStats.male.med = nanmedian(maleVals);
InRoomDurationStats.male.prctile25 = prctile(maleVals,25);
InRoomDurationStats.male.prctile75 = prctile(maleVals,75);

InRoomDurationStats.all.mean = nanmean(allVals);
InRoomDurationStats.all.std = nanstd(allVals);
InRoomDurationStats.all.variance = nanvar(allVals);
InRoomDurationStats.all.skewness = skewness(allVals);
InRoomDurationStats.all.kurt = kurtosis(allVals);
InRoomDurationStats.all.min = min(allVals);
InRoomDurationStats.all.max = max(allVals);
InRoomDurationStats.all.med = nanmedian(allVals);
InRoomDurationStats.all.prctile25 = prctile(allVals,25);
InRoomDurationStats.all.prctile75 = prctile(allVals,75);

% EEG Duration:
startTime =  surgeryTable.eegStartTimestamp;
endTime =  surgeryTable.eegEndTimestamp;
allVals = minutes(endTime - startTime);
femaleVals = allVals(femaleLocs);
maleVals = allVals(maleLocs);

eegDurationStats.female.mean = nanmean(femaleVals);
eegDurationStats.female.std = nanstd(femaleVals);
eegDurationStats.female.variance = nanvar(femaleVals);
eegDurationStats.female.skewness = skewness(femaleVals);
eegDurationStats.female.kurt = kurtosis(femaleVals);
eegDurationStats.female.min = min(femaleVals);
eegDurationStats.female.max = max(femaleVals);
eegDurationStats.female.med = nanmedian(femaleVals);
eegDurationStats.female.prctile25 = prctile(femaleVals,25);
eegDurationStats.female.prctile75 = prctile(femaleVals,75);

eegDurationStats.male.mean = nanmean(maleVals);
eegDurationStats.male.std = nanstd(maleVals);
eegDurationStats.male.variance = nanvar(maleVals);
eegDurationStats.male.skewness = skewness(maleVals);
eegDurationStats.male.kurt = kurtosis(maleVals);
eegDurationStats.male.min = min(maleVals);
eegDurationStats.male.max = max(maleVals);
eegDurationStats.male.med = nanmedian(maleVals);
eegDurationStats.male.prctile25 = prctile(maleVals,25);
eegDurationStats.male.prctile75 = prctile(maleVals,75);

eegDurationStats.all.mean = nanmean(allVals);
eegDurationStats.all.std = nanstd(allVals);
eegDurationStats.all.variance = nanvar(allVals);
eegDurationStats.all.skewness = skewness(allVals);
eegDurationStats.all.kurt = kurtosis(allVals);
eegDurationStats.all.min = min(allVals);
eegDurationStats.all.max = max(allVals);
eegDurationStats.all.med = nanmedian(allVals);
eegDurationStats.all.prctile25 = prctile(allVals,25);
eegDurationStats.all.prctile75 = prctile(allVals,75);

% Anesthasia Duration:
startTime = datetime(surgeryTable.AnesthesiaStartTimestamp);
endTime = datetime(surgeryTable.AnesthesiaStopTimestamp);
allVals = minutes(endTime - startTime);
femaleVals = allVals(femaleLocs);
maleVals = allVals(maleLocs);

AnesthasiaDurationStats.female.mean = nanmean(femaleVals);
AnesthasiaDurationStats.female.std = nanstd(femaleVals);
AnesthasiaDurationStats.female.variance = nanvar(femaleVals);
AnesthasiaDurationStats.female.skewness = skewness(femaleVals);
AnesthasiaDurationStats.female.kurt = kurtosis(femaleVals);
AnesthasiaDurationStats.female.min = min(femaleVals);
AnesthasiaDurationStats.female.max = max(femaleVals);
AnesthasiaDurationStats.female.med = nanmedian(femaleVals);
AnesthasiaDurationStats.female.prctile25 = prctile(femaleVals,25);
AnesthasiaDurationStats.female.prctile75 = prctile(femaleVals,75);

AnesthasiaDurationStats.male.mean = nanmean(maleVals);
AnesthasiaDurationStats.male.std = nanstd(maleVals);
AnesthasiaDurationStats.male.variance = nanvar(maleVals);
AnesthasiaDurationStats.male.skewness = skewness(maleVals);
AnesthasiaDurationStats.male.kurt = kurtosis(maleVals);
AnesthasiaDurationStats.male.min = min(maleVals);
AnesthasiaDurationStats.male.max = max(maleVals);
AnesthasiaDurationStats.male.med = nanmedian(maleVals);
AnesthasiaDurationStats.male.prctile25 = prctile(maleVals,25);
AnesthasiaDurationStats.male.prctile75 = prctile(maleVals,75);

AnesthasiaDurationStats.all.mean = nanmean(allVals);
AnesthasiaDurationStats.all.std = nanstd(allVals);
AnesthasiaDurationStats.all.variance = nanvar(allVals);
AnesthasiaDurationStats.all.skewness = skewness(allVals);
AnesthasiaDurationStats.all.kurt = kurtosis(allVals);
AnesthasiaDurationStats.all.min = min(allVals);
AnesthasiaDurationStats.all.max = max(allVals);
AnesthasiaDurationStats.all.med = nanmedian(allVals);
AnesthasiaDurationStats.all.prctile25 = prctile(allVals,25);
AnesthasiaDurationStats.all.prctile75 = prctile(allVals,75);

% Surgery Duration:
startTime = datetime(surgeryTable.SurgeryStartTimestamp);
endTime = datetime(surgeryTable.SurgeryStopTimestamp);
allVals = minutes(endTime - startTime);
femaleVals = allVals(femaleLocs);
maleVals = allVals(maleLocs);

SurgeryDurationStats.female.mean = nanmean(femaleVals);
SurgeryDurationStats.female.std = nanstd(femaleVals);
SurgeryDurationStats.female.variance = nanvar(femaleVals);
SurgeryDurationStats.female.skewness = skewness(femaleVals);
SurgeryDurationStats.female.kurt = kurtosis(femaleVals);
SurgeryDurationStats.female.min = min(femaleVals);
SurgeryDurationStats.female.max = max(femaleVals);
SurgeryDurationStats.female.med = nanmedian(femaleVals);
SurgeryDurationStats.female.prctile25 = prctile(femaleVals,25);
SurgeryDurationStats.female.prctile75 = prctile(femaleVals,75);

SurgeryDurationStats.male.mean = nanmean(maleVals);
SurgeryDurationStats.male.std = nanstd(maleVals);
SurgeryDurationStats.male.variance = nanvar(maleVals);
SurgeryDurationStats.male.skewness = skewness(maleVals);
SurgeryDurationStats.male.kurt = kurtosis(maleVals);
SurgeryDurationStats.male.min = min(maleVals);
SurgeryDurationStats.male.max = max(maleVals);
SurgeryDurationStats.male.med = nanmedian(maleVals);
SurgeryDurationStats.male.prctile25 = prctile(maleVals,25);
SurgeryDurationStats.male.prctile75 = prctile(maleVals,75);

SurgeryDurationStats.all.mean = nanmean(allVals);
SurgeryDurationStats.all.std = nanstd(allVals);
SurgeryDurationStats.all.variance = nanvar(allVals);
SurgeryDurationStats.all.skewness = skewness(allVals);
SurgeryDurationStats.all.kurt = kurtosis(allVals);
SurgeryDurationStats.all.min = min(allVals);
SurgeryDurationStats.all.max = max(allVals);
SurgeryDurationStats.all.med = nanmedian(allVals);
SurgeryDurationStats.all.prctile25 = prctile(allVals,25);
SurgeryDurationStats.all.prctile75 = prctile(allVals,75);

% ASA Duration:
allVals = surgeryTable.ASAClass;
allVals(find(contains(allVals,'Not Recorded'))) = {'nan'};
allVals = cellfun(@str2double,allVals);
femaleVals = allVals(femaleLocs);
maleVals = allVals(maleLocs);

asa.female.mean = nanmean(femaleVals);
asa.female.std = nanstd(femaleVals);
asa.female.variance = nanvar(femaleVals);
asa.female.skewness = skewness(femaleVals);
asa.female.kurt = kurtosis(femaleVals);
asa.female.min = min(femaleVals);
asa.female.max = max(femaleVals);
asa.female.med = nanmedian(femaleVals);
asa.female.prctile25 = prctile(femaleVals,25);
asa.female.prctile75 = prctile(femaleVals,75);

asa.male.mean = nanmean(maleVals);
asa.male.std = nanstd(maleVals);
asa.male.variance = nanvar(maleVals);
asa.male.skewness = skewness(maleVals);
asa.male.kurt = kurtosis(maleVals);
asa.male.min = min(maleVals);
asa.male.max = max(maleVals);
asa.male.med = nanmedian(maleVals);
asa.male.prctile25 = prctile(maleVals,25);
asa.male.prctile75 = prctile(maleVals,75);

asa.all.mean = nanmean(allVals);
asa.all.std = nanstd(allVals);
asa.all.variance = nanvar(allVals);
asa.all.skewness = skewness(allVals);
asa.all.kurt = kurtosis(allVals);
asa.all.min = min(allVals);
asa.all.max = max(allVals);
asa.all.med = nanmedian(allVals);
asa.all.prctile25 = prctile(allVals,25);
asa.all.prctile75 = prctile(allVals,75);

% Weight stats:
allVals = surgeryTable.weight;
femaleVals = allVals(femaleLocs);
maleVals= allVals(maleLocs);

WeightsStats.female.mean = nanmean(femaleVals);
WeightsStats.female.std = nanstd(femaleVals);
WeightsStats.female.variance = nanvar(femaleVals);
WeightsStats.female.skewness = skewness(femaleVals);
WeightsStats.female.kurt = kurtosis(femaleVals);
WeightsStats.female.min = min(femaleVals);
WeightsStats.female.max = max(femaleVals);
WeightsStats.female.med = nanmedian(femaleVals);
WeightsStats.female.prctile25 = prctile(femaleVals,25);
WeightsStats.female.prctile75 = prctile(femaleVals,75);

WeightsStats.male.mean = nanmean(maleVals);
WeightsStats.male.std = nanstd(maleVals);
WeightsStats.male.variance = nanvar(maleVals);
WeightsStats.male.skewness = skewness(maleVals);
WeightsStats.male.kurt = kurtosis(maleVals);
WeightsStats.male.min = min(maleVals);
WeightsStats.male.max = max(maleVals);
WeightsStats.male.med = nanmedian(maleVals);
WeightsStats.male.prctile25 = prctile(maleVals,25);
WeightsStats.male.prctile75 = prctile(maleVals,75);

WeightsStats.all.mean = nanmean(allVals);
WeightsStats.all.std = nanstd(allVals);
WeightsStats.all.variance = nanvar(allVals);
WeightsStats.all.skewness = skewness(allVals);
WeightsStats.all.kurt = kurtosis(allVals);
WeightsStats.all.min = min(allVals);
WeightsStats.all.max = max(allVals);
WeightsStats.all.med = nanmedian(allVals);
WeightsStats.all.prctile25 = prctile(allVals,25);
WeightsStats.all.prctile75 = prctile(allVals,75);

%% Wordclouds

% Primary Surgical procedure:
% fileID = fopen([repoRootFolder, 'data/patientInfo/primarySurgicalProcedure.txt'],'w');
fileID = fopen(primarySurgicalProcedureFile, 'w');
primarySurgicalProcedure = surgeryTable.PrimarySurgicalProcedure;
for ii = 1:length(primarySurgicalProcedure)
    if (strcmp(primarySurgicalProcedure{ii},'Not Recorded'))
        continue;
    end
    fprintf(fileID,"%s\n",primarySurgicalProcedure{ii});
end
fclose(fileID);

% Comorbidities:
% fileID = fopen([repoRootFolder, 'data/patientInfo/comorbidities.txt'],'w');
fileID = fopen(comorbiditiesFile,'w');
comorbidities = surgeryTable.comorbiditiesBefore;
comorbidities = [comorbidities; surgeryTable.comorbiditiesAfter];
for ii = 1:length(comorbidities)
    currentComorbidities = split(comorbidities{ii},';');
    currentComorbidities = currentComorbidities(1:end-1);
    for jj = 1:length(currentComorbidities)
        currentComorbidity = currentComorbidities{jj};
        if (strcmp(currentComorbidity,'Not Recorded'))
            continue;
        end
        fprintf(fileID,"%s\n",currentComorbidity);
    end
end

fclose(fileID);

%%

