function [POWER_DELTA,POWER_THETA,POWER_ALPHA,POWER_BETA,POWER_GAMMA] = spectrogramBasedEnergyCalculator(s,fs)
%
%   [POWER_DELTA,POWER_THETA,POWER_ALPHA,POWER_BETA,POWER_GAMMA] = spectrogramBasedEnergyCalculator(s,fs)
%
%   OVERVIEW:   
%       This scripts computes the signal power in various frequency bands
%       using Spectrogram.
%
%   INPUT:      
%       s - One channel EEG signal 
%       fs - Signal sampling frequency
%
%   OUTPUT:
%       POWER_DELTA - Signal power in delta frequency range
%       POWER_THETA - Signal power in theta frequency range
%       POWER_ALPHA - Signal power in alpha frequency range
%       POWER_BETA - Signal power in beta frequency range
%       POWER_GAMMA - Signal power in gamma frequency range
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

delta = [0.5,3.5]; %Hz
theta = [3.5,7.5]; %Hz
alpha = [7.5,12.5]; %Hz
beta = [12.5,29.5]; %Hz
gamma = 29.5; %Hz

[dB, dA] = cheby2(4,40,delta/(fs/2)); %DELTA
[tB, tA] = cheby2(8,40,theta/(fs/2)); %THETA
[aB, aA] = cheby2(10,40,alpha/(fs/2)); %ALPHA
[bB, bA] = cheby2(20,40,beta/(fs/2)); %BETA
[gB, gA] = cheby2(20,40,gamma/(fs/2), 'high'); %GAMMA

% Remove signal mean
s = s - mean(s);

sDelta = filtfilt(dB, dA, s); %DELTA
sTheta = filtfilt(tB, tA, s); %THETA
sAlpha = filtfilt(aB, aA, s); %ALPHA
sBeta = filtfilt(bB, bA, s); %BETA
sGamma = filtfilt(gB, gA, s); %GAMMA

POWER_DELTA = sum(sDelta.^2)/sum(s.^2);
POWER_THETA = sum(sTheta.^2)/sum(s.^2);
POWER_ALPHA = sum(sAlpha.^2)/sum(s.^2);
POWER_BETA = sum(sBeta.^2)/sum(s.^2);
POWER_GAMMA = sum(sGamma.^2)/sum(s.^2);
Total=POWER_DELTA+ POWER_THETA+POWER_ALPHA+POWER_BETA+POWER_GAMMA; % Sanity check. Total = 1.

% % % POWER_DELTA = sum(sDelta.^2);
% % % POWER_THETA = sum(sTheta.^2);
% % % POWER_ALPHA = sum(sAlpha.^2);
% % % POWER_BETA = sum(sBeta.^2);
% % % POWER_GAMMA = sum(sGamma.^2);
% % % Total=POWER_DELTA+ POWER_THETA+POWER_ALPHA+POWER_BETA+POWER_GAMMA;
% % % 
% % % POWER_DELTA = POWER_DELTA/Total;
% % % POWER_THETA = POWER_THETA/Total;
% % % POWER_ALPHA = POWER_ALPHA/Total;
% % % POWER_BETA = POWER_BETA/Total;
% % % POWER_GAMMA = POWER_GAMMA/Total;
end