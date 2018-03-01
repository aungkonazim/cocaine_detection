clc;
close all;
clear all;
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final\accel_code');
load('C:\Users\aungkon\Desktop\jhu\code\derived_mat_files\accel_coeffs_median_final.mat');
taud = accel_parameter.taud;
theta_array = [];
theta_label = [];
study = [2900]
for i=1:length(study)
    load(['C:\Users\aungkon\Desktop\jhu-pilot\' num2str(study(i)) '\window.mat'])
    for j=1:length(window.baseline)
        x=window.recovery.timestamp{j};
        y=window.recovery.sample{j};
        if (x(end)-x(1))/60000 > 1 && length(unique(y)) > 10
            minimum_index = find(y==min(y));
            x = x(minimum_index:end);
            y = y(minimum_index:end);
            x=(x-x(1))./60000;
            if x(end) > 5 && max(y) - min(y) > 150
                figure1 = figure;
                plot(x,y);
                pause(.5);
                close(figure1);
            end
        end
    end        
end