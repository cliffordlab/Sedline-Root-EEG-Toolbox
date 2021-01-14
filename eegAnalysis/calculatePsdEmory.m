function [PSD, nPSD, F]=calculatePsdEmory(EEG,fs, NFFT, win_len, shift)
%
%   [PSD, nPSD, F]=calculatePsdEmory(EEG,fs, NFFT, win_len, shift)
%
%   OVERVIEW:   
%       calculates PSD with default settings using pwelch
%
%   INPUT:      
%       EEG - EEG vector
%       fs - Sample Rate
%       NFFT - No. of Fourier Points; affects frequency resolution should  
%              be 128, 256, or 512
%       win_len - window length, the PSD is calculated on
%       shift - seconds the window is shifted.
%
%   OUTPUT:
%       PSD - Power Spectral Density
%       nPSD - Normalized Power Spectral Density
%       F - Frequencies
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
%       Modified by: Pradyumna Byappanahalli Suresha
%       Last Modified: January 14th, 2021 
%
%	COPYRIGHT (C) 2021
%   LICENSE:    
%       This software may be modified and distributed under the terms
%       of the BSD 3-Clause license. See the LICENSE file in this repo for 
%       details.
%
%%
no_of_blocks=floor((length(EEG)/fs-win_len)/shift);

% Define result matrices;

PSD=nan((NFFT/2)+1,no_of_blocks); %buffer if artifact detected
nPSD=PSD;

for a=1:no_of_blocks
    start=(a-1)*fs*shift+1;
    stop=start+win_len*fs-1;
    if sum(isnan(EEG(start:stop)))==0
        [PSD(:,a),F] = pwelch(EEG(start:stop),[],[],NFFT,fs,'onesided');
        nPSD(:,a)=PSD(:,a)/sum(PSD(:,a)); 
    end    
    clear start stop
end    
    