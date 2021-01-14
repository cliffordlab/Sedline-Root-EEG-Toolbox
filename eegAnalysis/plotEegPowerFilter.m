%
%   plotEegPowerFilter.m
%
%   OVERVIEW:   
%       Plot the bandpass filters corresponding to:
%       - Delta
%       - Theta
%       - Alpha
%       - Beta
%       - Gamma
%       powerbands.
%
%   INPUT:      
%       NONE
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

set(groot,'defaultLineLineWidth',2.0)
% Plot filters
delta = [0.5,3.5];
theta = [3.5,7.5];
alpha = [7.5,12.5];
beta = [12.5,29.5];
gamma = 29.5;

fs = 100;
[dA, dB] = cheby2(4,40,delta/(fs/2)); %DELTA
[tA, tB] = cheby2(8,40,theta/(fs/2)); %THETA
[aA, aB] = cheby2(10,40,alpha/(fs/2)); %ALPHA
[bA, bB] = cheby2(20,40,beta/(fs/2)); %BETA
[gA, gB] = cheby2(20,40,gamma/(fs/2), 'high'); %GAMMA

figure;freqz(dA,dB);
%%
hold on;plot([0.02,0.02],[-100,20],'r');
hold on;plot([0.06,0.06],[-100,20],'r');
xticks([0,0.02,0.06,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]);
xticklabels([0,0.02,0.06,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]*50);
xlabel('Frequency (Hz)');
title('Filter to extract Delta Power [1-3Hz]');

%%
hold on;plot([0.02,0.02],[-300,300],'r');
hold on;plot([0.06,0.06],[-300,300],'r');
xticks([0,0.02,0.06,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]);
xticklabels([0,0.02,0.06,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]*50);
xlabel('Frequency (Hz)');

figure;freqz(tA,tB);
%%
hold on;plot([4/50,4/50],[-100,20],'r');
hold on;plot([7/50,7/50],[-100,20],'r');
xticks([0,0.08,0.1,0.14,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]);
xticklabels([0,0.08,0.1,0.14,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]*50);
xlabel('Frequency (Hz)');
title('Filter to extract Theta Power [4-7Hz]');

%%
hold on;plot([4/50,4/50],[-1500,500],'r');
hold on;plot([7/50,7/50],[-1500,500],'r');
xticks([0,0.08,0.1,0.14,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]);
xticklabels([0,0.08,0.1,0.14,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]*50);
xlabel('Frequency (Hz)');

figure;freqz(aA,aB);
%%
hold on;plot([8/50,8/50],[-150,50],'r');
hold on;plot([12/50,12/50],[-150,50],'r');
xticks([0,0.1,0.16,0.2,0.24,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]);
xticklabels([0,0.1,0.16,0.2,0.24,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]*50);
xlabel('Frequency (Hz)');
title('Filter to extract Alpha Power [8-12Hz]');


%%
hold on;plot([8/50,8/50],[-1000,500],'r');
hold on;plot([12/50,12/50],[-1000,500],'r');
xticks([0,0.1,0.16,0.2,0.24,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]);
xticklabels([0,0.1,0.16,0.2,0.24,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1]*50);
xlabel('Frequency (Hz)');

figure;freqz(bA,bB);
%%
hold on;plot([13/50,13/50],[-100,20],'r');
hold on;plot([29/50,29/50],[-100,20],'r');
xticks([0,0.1,0.2,0.26,0.3,0.4,0.5,0.58,0.6,0.7,0.8,0.9,1]);
xticklabels([0,0.1,0.2,0.26,0.3,0.4,0.5,0.58,0.6,0.7,0.8,0.9,1]*50);
xlabel('Frequency (Hz)');
title('Filter to extract Beta Power [13-29Hz]');

%%
hold on;plot([13/50,13/50],[-600,600],'r');
hold on;plot([29/50,29/50],[-600,600],'r');
xticks([0,0.1,0.2,0.26,0.3,0.4,0.5,0.58,0.6,0.7,0.8,0.9,1]);
xticklabels([0,0.1,0.2,0.26,0.3,0.4,0.5,0.58,0.6,0.7,0.8,0.9,1]*50);
xlabel('Frequency (Hz)');

figure;freqz(gA,gB);
%%
hold on;plot([30/50,30/50],[-100,20],'r');
hold on;plot([1,1],[-100,20],'r');
xticks([0,0.1,0.2,0.3,0.4,0.5,0.6,0.62,0.7,0.8,0.9,1]);
xticklabels([0,0.1,0.2,0.3,0.4,0.5,0.6,0.62,0.7,0.8,0.9,1]*50);
xlabel('Frequency (Hz)');
title('Filter to extract Gamma Power [30-50Hz]');

%%
hold on;plot([31/50,31/50],[-200,600],'r');
hold on;plot([1,1],[-200,600],'r');
xticks([0,0.1,0.2,0.3,0.4,0.5,0.6,0.62,0.7,0.8,0.9,1]);
xticklabels([0,0.1,0.2,0.3,0.4,0.5,0.6,0.62,0.7,0.8,0.9,1]*50);
xlabel('Frequency (Hz)');
