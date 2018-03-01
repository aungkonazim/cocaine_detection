clc;
close all;
clear all;
study_name = {'JHU','NIDAc'};
addpath('\\Client\C$\Users\aungkon\Desktop\jhu\code\code_final_1\functions\');
load('\\Client\C$\Users\aungkon\Desktop\jhu\code\code_final_1\data\cocaine_parameter.mat');
load('\\Client\C$\Users\aungkon\Desktop\jhu\code\code_final_1\data\activity_parameter.mat');
load('\\Client\C$\Users\aungkon\Desktop\jhu\code\code_final_1\data\window_store.mat');
% feature = zeros(length(windows.label),8);
taud = cocaine_parameter.global_value
label = [];
for m=1:length(windows.label)
    x = windows.timestamp{m};
    y = windows.sample{m};
    k = windows.study(m);
    i = windows.participant(m);
    B = prctile(y,99);
    if windows.label(m) <= 10
        label = [label,0];
    else
        label = [label,1];
    end
    [P,f]=HeartRateLomb(y,1:length(y));
    
    taur = activity_parameter{k}{i};
    x_temp = (x-x(1))/60000 + 1;
    y_temp = B - y;
    range = max(y_temp) - min(y_temp);
    mi = min(y_temp);
    act_fit = taur(1)*exp(-taur(2)*x_temp)*range+mi;
    y_temp = y_temp - act_fit;
    y_cell{1} = y_temp;
    x_cell{1} = x_temp;
    mdl_cell{1} = @(beta,x) (((beta(1)/(taur(2)-taud))*exp(-x*taud))-((beta(1)/(taur(2)-taud))*exp(-x*taur(2))));
    beta0 = [1];
    [beta,r,J,Sigma,mse,errorparam,robustw] = nlinmultifit(x_cell, y_cell, mdl_cell, beta0);
    y_temp = (((beta(1)/(taur(2)-taud))*exp(-x_temp*taud))-((beta(1)/(taur(2)-taud))*exp(-x_temp*taur(2)))) + act_fit;
    y_cocaine_fit = B - y_temp;
    act_fit = B - act_fit;    
    feature(m,1) = double(median(diff(y)));   % median of difference
    feature(m,2) = double(prctile(diff(y),80)); % 80th percentile of difference
    feature(m,3) = double(prctile(diff(y),20)); % 20th percentile of difference
    feature(m,4) = double(median(y)/B);   % ratio of median of the window and baseline
    feature(m,5) = double(prctile(y,95) - prctile(y,5));   %range of the window  
    feature(m,6) = double(iqr(y)) ; %inter quartile range of y
    feature(m,7) = double(skewness(B-y)); %skewness of B-y
    feature(m,8) = double(kurtosis(B-y)); %kurtosis of B-y
    feature(m,9) = double(HeartRateLFHF(P,f)); % ratio of low freq and high freq energy
    feature(m,10) = double(HeartRatePower34(P,f)); % high freqency energy
    feature(m,11) = double(HeartRatePower23(P,f)); % medium frequency energy
    feature(m,12) = double(HeartRatePower12(P,f)); % low frequency energy
    feature(m,13) = double(var(y)); %variance;
    feature(m,14) = double((x(end)-x(1))/60000); % duration
%     feature(m,15) = double(sum((y-y_cocaine_fit).^2)); %L2 norm of cocaine fit and the window
%     feature(m,16) = double(sum((y-act_fit).^2)); %L2 norm of activity fit
%     feature(m,17) = feature(m,15)/feature(m,16); % ratio of L2 norm
end
save(['\\Client\C$\Users\aungkon\Desktop\jhu\code\code_final_1\data\feature.mat'],'feature','label');