function lags = calcLags(timeInfo,nSamples, fs)
%
%   lags = calcLags(timeInfo,nSamples, fs)
%
%   OVERVIEW:   
%       Create a matlab structure 'lags' consisting lag information
%       corresponding to start and stop times of patient surgery and 
%       patient presence in OR
%
%   INPUT:      
%       timeInfo - A matlab structure containing start and stop time
%                  information corresponding to patient surgery and patient
%                  physical presence in the OR
%       header - EEG header info
%       fs - sampling frequency
%
%   OUTPUT:
%       lags - Matlab structure containing lag information
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

if(~isempty(timeInfo.sStart) && ~isempty(timeInfo.sEnd) && ~isempty(timeInfo.pStart) && ~isempty(timeInfo.pEnd))
    lengthInSeconds = floor(nSamples/fs);
    %eegStartTime = datetime([header.startdate(1:6),'20',header.startdate(7:8),' ',header.starttime],'Inputformat','dd.MM.yyyy HH.mm.ss');
    eegStartTime = timeInfo.eStart;
    surgeryStartTime = datetime(timeInfo.sStart,'Inputformat','MM/dd/yy HH:mm:ss');
    surgeryEndTime = datetime(timeInfo.sEnd,'Inputformat','MM/dd/yy HH:mm:ss');
    phyStartTime = datetime(timeInfo.pStart,'Inputformat','MM/dd/yyyy HH:mm:ss');
    phyEndTime = datetime(timeInfo.pEnd,'Inputformat','MM/dd/yyyy HH:mm:ss');
    aneStartTime = datetime(timeInfo.aStart,'Inputformat','MM/dd/yyyy HH:mm:ss');
    aneEndTime = datetime(timeInfo.aEnd,'Inputformat','MM/dd/yyyy HH:mm:ss');    
    
    lags.surgeryStartLag = seconds(surgeryStartTime - eegStartTime);
    lags.surgeryEndLag = seconds(surgeryEndTime - eegStartTime) - lengthInSeconds;
    lags.phyStartLag = seconds(phyStartTime - eegStartTime);
    lags.phyEndLag = seconds(phyEndTime - eegStartTime) - lengthInSeconds;
    lags.aneStartLag = seconds(aneStartTime - eegStartTime);
    lags.aneEndLag = seconds(aneEndTime - eegStartTime) - lengthInSeconds;
else
    lags.surgeryStartlag = [];
    lags.surgeryEndlag = [];
    lags.phyStartLag = [];
    lags.phyEndLag = [];
    lags.aneStartLag = [];
    lags.aneEndLag = [];
end