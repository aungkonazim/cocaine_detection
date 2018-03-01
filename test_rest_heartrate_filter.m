clc;
close all;
clear all;
load('hr.mat');
Fs = 2;        
% Design a 70th order lowpass FIR filter with cutoff frequency of 75 Hz.
x=window_sample';
t=window_timestamp'/1000;
[P,F] = pwelch(x,ones(8192,1),8192/2,8192,Fs,'power');
helperFilterIntroductionPlot1(F,P,[60 60],[-9.365 -9.365],...
  {'Original signal power spectrum', '60 Hz Tone'})
Fp = .5;    % Passband frequency in Hz
Fst = .75; % Stopband frequency in Hz
Ap = 1;      % Passband ripple in dB
Ast = 80;    % Stopband attenuation in dB

% Design the filter
df = designfilt('lowpassiir','PassbandFrequency',Fp,...
                'StopbandFrequency',Fst,'PassbandRipple',Ap,...
                'StopbandAttenuation',Ast,'SampleRate',Fs);

% Analyze the filter response
hfvt = fvtool(df,'Fs',Fs,'FrequencyScale','log',...
  'FrequencyRange','Specify freq. vector','FrequencyVector',F);
% Filter the data and compensate for delay
D = floor(mean(grpdelay(df))); % filter delay
ylp = filter(df,[x; zeros(D,1)]);
ylp = ylp(D+1:end);

close(hfvt)
[Plp,Flp] = pwelch(ylp,ones(8192,1),8192/2,8192,Fs,'power');
helperFilterIntroductionPlot1(F,P,Flp,Plp,...
  {'Original signal','Lowpass filtered signal'})

% Fnorm = .005/(Fs/2);           % Normalized frequency
% df = designfilt('lowpassfir','FilterOrder',70,'CutoffFrequency',Fnorm);
% grpdelay(df,2048,Fs)   % plot group delay
% D = mean(grpdelay(df)) % filter delay in samples
% y = filter(df,[x; zeros(D,1)]); % Append D zeros to the input data
% y = y(D+1:end);                  % Shift data to compensate for delay
% y=smooth(x,60);
figure
plot(t,x,t,ylp,'r','linewidth',1.5);
title('Filtered Waveforms');
xlabel('Time (s)')
legend('Original Noisy Signal','Filtered Signal');
grid on
axis tight