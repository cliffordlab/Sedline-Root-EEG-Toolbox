%
%   eegPowerAndAgeCorrelation.m
%
%   OVERVIEW:   
%       This is a wrapper script used to compute eeg Power and plot its
%       correlation with patient age.
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
plotInDb = 0;
%% n Minute Samples

% The file `normalizedEegPowers_10Minutes_ZeroMean.mat` contains two
% structures - allPowers and allAges which are used in the plotting.
load('normalizedEegPowers_10Minutes_ZeroMean','allPowers','allAges');

% Wavelet Based
figure;

% Wavelet - Fp1 - Delta
p = allPowers.waveletBasedDeltaPower_sigFp1;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,1);plot(ageVector, p, 'b*'); ylabel({'Fp1','normalized Power'});title('Delta Power');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Wavelet - Fp1 - Theta
p = allPowers.waveletBasedThetaPower_sigFp1;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,2);plot(ageVector, p, 'b*');title('Theta Power');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Wavelet - Fp1 - Alpha
p = allPowers.waveletBasedAlphaPower_sigFp1;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,3);plot(ageVector, p, 'b*');title('Alpha Power');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Wavelet - Fp1 - Beta
p = allPowers.waveletBasedBetaPower_sigFp1;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,4);plot(ageVector, p, 'b*');title('Beta Power');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Wavelet - Fp1 - Gamma
p = allPowers.waveletBasedGammaPower_sigFp1;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,5);plot(ageVector, p, 'b*');title('Gamma Power');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Wavelet - Fp2 - Delta
p = allPowers.waveletBasedDeltaPower_sigFp2;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,6);plot(ageVector, p, 'b*'); ylabel({'Fp2','normalized Power'});
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Wavelet - Fp2 - Theta
p = allPowers.waveletBasedThetaPower_sigFp2;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,7);plot(ageVector, p, 'b*');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Wavelet - Fp2 - Alpha
p = allPowers.waveletBasedAlphaPower_sigFp2;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,8);plot(ageVector, p, 'b*');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Wavelet - Fp2 - Beta
p = allPowers.waveletBasedBetaPower_sigFp2;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,9);plot(ageVector, p, 'b*');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Wavelet - Fp2 - Gamma
p = allPowers.waveletBasedGammaPower_sigFp2;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,10);plot(ageVector, p, 'b*');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Wavelet - F7 - Delta
p = allPowers.waveletBasedDeltaPower_sigF7;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,11);plot(ageVector, p, 'b*'); ylabel({'F7','normalized Power'});
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Wavelet - F7 - Theta
p = allPowers.waveletBasedThetaPower_sigF7;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,12);plot(ageVector, p, 'b*');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Wavelet - F7 - Alpha
p = allPowers.waveletBasedAlphaPower_sigF7;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,13);plot(ageVector, p, 'b*');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Wavelet - F7 - Beta
p = allPowers.waveletBasedBetaPower_sigF7;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,14);plot(ageVector, p, 'b*');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Wavelet - F7 - Gamma
p = allPowers.waveletBasedGammaPower_sigF7;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,15);plot(ageVector, p, 'b*');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Wavelet - F8 - Delta
p = allPowers.waveletBasedDeltaPower_sigF8;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,16);plot(ageVector, p, 'b*'); ylabel({'F8','normalized Power'});xlabel('Age (years)');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Wavelet - F8 - Theta
p = allPowers.waveletBasedThetaPower_sigF8;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,17);plot(ageVector, p, 'b*');xlabel('Age (years)');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Wavelet - F8 - Alpha
p = allPowers.waveletBasedAlphaPower_sigF8;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,18);plot(ageVector, p, 'b*');xlabel('Age (years)');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Wavelet - F8 - Beta
p = allPowers.waveletBasedBetaPower_sigF8;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,19);plot(ageVector, p, 'b*');xlabel('Age (years)');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Wavelet - F8 - Gamma
p = allPowers.waveletBasedGammaPower_sigF8;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,20);plot(ageVector, p, 'b*');xlabel('Age (years)');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;


% Spectrogram Based
figure;

% Spectrogram - Fp1 - Delta
p = allPowers.spectrogramBasedDeltaPower_sigFp1;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,1);plot(ageVector, p, 'b*'); ylabel({'Fp1','normalized Power'});title('Delta Power');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Spectrogram - Fp1 - Theta
p = allPowers.spectrogramBasedThetaPower_sigFp1;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,2);plot(ageVector, p, 'b*');title('Theta Power');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Spectrogram - Fp1 - Alpha
p = allPowers.spectrogramBasedAlphaPower_sigFp1;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,3);plot(ageVector, p, 'b*');title('Alpha Power');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Spectrogram - Fp1 - Beta
p = allPowers.spectrogramBasedBetaPower_sigFp1;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,4);plot(ageVector, p, 'b*');title('Beta Power');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Spectrogram - Fp1 - Gamma
p = allPowers.spectrogramBasedGammaPower_sigFp1;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,5);plot(ageVector, p, 'b*');title('Gamma Power');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Spectrogram - Fp2 - Delta
p = allPowers.spectrogramBasedDeltaPower_sigFp2;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,6);plot(ageVector, p, 'b*'); ylabel({'Fp2','normalized Power'});
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Spectrogram - Fp2 - Theta
p = allPowers.spectrogramBasedThetaPower_sigFp2;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,7);plot(ageVector, p, 'b*');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Spectrogram - Fp2 - Alpha
p = allPowers.spectrogramBasedAlphaPower_sigFp2;
ageVector = allAges;
%ageVector(p==0) = [];
%p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,8);plot(ageVector, p, 'b*');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Spectrogram - Fp2 - Beta
p = allPowers.spectrogramBasedBetaPower_sigFp2;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,9);plot(ageVector, p, 'b*');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Spectrogram - Fp2 - Gamma
p = allPowers.spectrogramBasedGammaPower_sigFp2;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,10);plot(ageVector, p, 'b*');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Spectrogram - F7 - Delta
p = allPowers.spectrogramBasedDeltaPower_sigF7;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,11);plot(ageVector, p, 'b*'); ylabel({'F7','normalized Power'});
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Spectrogram - F7 - Theta
p = allPowers.spectrogramBasedThetaPower_sigF7;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,12);plot(ageVector, p, 'b*');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Spectrogram - F7 - Alpha
p = allPowers.spectrogramBasedAlphaPower_sigF7;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,13);plot(ageVector, p, 'b*');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Spectrogram - F7 - Beta
p = allPowers.spectrogramBasedBetaPower_sigF7;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,14);plot(ageVector, p, 'b*');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Spectrogram - F7 - Gamma
p = allPowers.spectrogramBasedGammaPower_sigF7;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,15);plot(ageVector, p, 'b*');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Spectrogram - F8 - Delta
p = allPowers.spectrogramBasedDeltaPower_sigF8;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,16);plot(ageVector, p, 'b*'); ylabel({'F8','normalized Power'});xlabel('Age (years)');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Spectrogram - F8 - Theta
p = allPowers.spectrogramBasedThetaPower_sigF8;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,17);plot(ageVector, p, 'b*');xlabel('Age (years)');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Spectrogram - F8 - Alpha
p = allPowers.spectrogramBasedAlphaPower_sigF8;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,18);plot(ageVector, p, 'b*');xlabel('Age (years)');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Spectrogram - F8 - Beta
p = allPowers.spectrogramBasedBetaPower_sigF8;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,19);plot(ageVector, p, 'b*');xlabel('Age (years)');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;

% Spectrogram - F8 - Gamma
p = allPowers.spectrogramBasedGammaPower_sigF8;
ageVector = allAges;
ageVector(p==0) = [];
p(p==0) = [];
if(plotInDb)
    p = 10*log10(p);
end
subplot(4,5,20);plot(ageVector, p, 'b*');xlabel('Age (years)');
[sortedAgeVector, indices] = sort(ageVector);
sortedPower = p(indices);
c = polyfit(sortedAgeVector,sortedPower',1);
y_est = polyval(c, sortedAgeVector);
hold on; plot(sortedAgeVector, y_est, 'r', 'LineWidth',3);hold off;
%mtit('Normalized EEG Power vs Age')
disp('Done');