function [nPOWER_DELTA,nPOWER_THETA,nPOWER_ALPHA,nPOWER_BETA,nPOWER_GAMMA, Total] = Energy_Calculator_normalized(s)
%
%   [nPOWER_DELTA,nPOWER_THETA,nPOWER_ALPHA,nPOWER_BETA,nPOWER_GAMMA, Total] = Energy_Calculator_normalized(s)
%
%   OVERVIEW:   
%       This scripts computes the signal power in various frequency bands
%       using wavelets.
%
%   INPUT:      
%       s - One channel EEG signal
%
%   OUTPUT:
%       nPOWER_DELTA - Normalized Signal power in delta frequency range
%       nPOWER_THETA - Normalized Signal power in theta frequency range
%       nPOWER_ALPHA - Normalized Signal power in alpha frequency range
%       nPOWER_BETA - Normalized Signal power in beta frequency range
%       nPOWER_GAMMA - Normalized Signal power in gamma frequency range
%       Total - The total normalized power. It should be equal to 1. 
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
%       Samaneh Nasiri
%       Modified by: Pradyumna Byappanahalli Suresh
%       Last Modified: January 11th, 2021 
%
%	COPYRIGHT (C) 2021
%   LICENSE:    
%       This software is offered freely and without warranty under 
%       the GNU (v3 or later) public license. See license file for
%       more information

%%

% Remove signal mean
s = s - mean(s);

waveletFunction = 'db4';
[C,L] = wavedec(s,4,waveletFunction);

cD1 = detcoef(C,L,1); %GAMA
cD2 = detcoef(C,L,2); %BETA
cD3= detcoef(C,L,3); %ALPHA
cD4 = detcoef(C,L,4); %THETA
cA4= appcoef(C,L,waveletFunction,4); %DELTA
D1 = wrcoef('d',C,L,waveletFunction,1); %GAMA
D2 = wrcoef('d',C,L,waveletFunction,2); %BETA
D3 = wrcoef('d',C,L,waveletFunction,3); %ALPHA
D4 = wrcoef('d',C,L,waveletFunction,4); %THETA
A4 = wrcoef('a',C,L,waveletFunction,4); %DELTA

nPOWER_DELTA = (sum(A4.^2))/(sum(s.^2));%*fs/length(A4);
nPOWER_THETA = (sum(D4.^2))/(sum(s.^2));%*fs/length(D4);
nPOWER_ALPHA = (sum(D3.^2))/(sum(s.^2));%*fs/length(D3);
nPOWER_BETA = (sum(D2.^2))/(sum(s.^2));%*fs/length(D2);
nPOWER_GAMMA = (sum(D1.^2))/(sum(s.^2));%*fs/length(D1);
Total=nPOWER_DELTA+ nPOWER_THETA+nPOWER_ALPHA+nPOWER_BETA+nPOWER_GAMMA; % Sanity check: Total = 1
end