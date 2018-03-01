clc;
close all;
clear all;
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final\accel_code');
load('C:\Users\aungkon\Desktop\jhu\code\derived_mat_files\accel_windows.mat');
study_name = {'JHU','NIDAc'};
for k=1:length(study_name)
        if length(char(study_name(k)))<=3
            p=3;
        else
            p=7;
        end
        
        for i=1:p
            window_collection_timestamp = accel_windows.timestamp{k}{i};
            window_collection_sample = accel_windows.sample{k}{i};
            for j=1:length(window_collection_sample)
                y = 60000*(window_collection_sample{j}.^-1);
                peak_hr = y(1);
                y1 = y/y(1);
                x1 = (window_collection_timestamp{j}-window_collection_timestamp{j}(1))/60000;
                [fitresult1, gof1] = fit_monowar(x1, y1);
                if gof1.adjrsquare >= .5
                    accel_windows.monowar_tau{k}{i}{j} = 1/fitresult1.a;
                    accel_windows.monowar_gof{k}{i}{j} = gof1;
                    estimated_sample = peak_hr*exp(-1*fitresult1.a*x1);
                    estimated_sample = 60000*estimated_sample.^-1;
                    accel_windows.fitted_model_sample{k}{i}{j} = estimated_sample;
                end
            end
        end
end
save('C:\Users\aungkon\Desktop\jhu\code\derived_mat_files\accel_windows_with_parameters.mat','accel_windows');