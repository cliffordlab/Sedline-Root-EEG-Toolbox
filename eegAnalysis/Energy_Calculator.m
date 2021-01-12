function [POWER_DELTA,POWER_THETA,POWER_ALPHA,POWER_BETA,POWER_GAMMA] = Energy_Calculator(s,fs)
%
%   [POWER_DELTA,POWER_THETA,POWER_ALPHA,POWER_BETA,POWER_GAMMA] = Energy_Calculator(s,fs)
%
%   OVERVIEW:   
%       This scripts computes the signal power in various frequency bands
%       using wavelets.
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

POWER_DELTA = (sum(A4.^2))*fs/length(A4);
POWER_THETA = (sum(D4.^2))*fs/length(D4);
POWER_ALPHA = (sum(D3.^2))*fs/length(D3);
POWER_BETA = (sum(D2.^2))*fs/length(D2);
POWER_GAMMA = (sum(D1.^2))*fs/length(D1);
%Total=POWER_DELTA+ POWER_THETA+POWER_ALPHA+POWER_BETA+POWER_GAMA;

end