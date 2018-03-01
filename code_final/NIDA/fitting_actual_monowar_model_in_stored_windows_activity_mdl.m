clc;
close all;
clear all;
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final\accel_code');
load('C:\Users\aungkon\Desktop\jhu\code\code_final\NIDA\derived_mat_files\accel_windows.mat');
study_name = {'NIDA'};
for k=1:length(study_name)
        p=46;  
        for i=1:p
            window_collection_timestamp = accel_windows.timestamp{k}{i};
            window_collection_sample = accel_windows.sample{k}{i};
            baseline_collection = accel_windows.baseline{k}{i};
            
            for j=1:length(window_collection_sample)
                if length(unique(window_collection_sample{j})) > 10
                    y = window_collection_sample{j};
                    peak_rr = y(1);
    %                 y1 = y/y(1);

                    x1 = (window_collection_timestamp{j}-window_collection_timestamp{j}(1))/60000;
                    b  = regress(log(y)',[ones(length(y),1), x1']);
                    estimated_sample = exp(b(1) + b(2)*x1);
                    accel_windows.monowar_tau2{k}{i}{j} = 1/b(2);
                     accel_windows.monowar_tau1{k}{i}{j} = b(1);
                     accel_windows.estimated_sample{k}{i}{j} = estimated_sample;
                     accel_windows.standard_deviation{k}{i}(j) = std(y);
                     accel_windows.normalized_rms{k}{i}(j) = calNMSE(window_collection_sample{j},estimated_sample);



                    [fitresult, gof] = fit_monowar(x1, y./y(1));
                    estimated_sample = y(1)*exp(-1*(1/fitresult.a)*x1);
                    accel_windows.monowar_tau_no_tau1{k}{i}{j} = fitresult.a;
                     accel_windows.estimated_sample_no_tau1{k}{i}{j} = estimated_sample;
                     accel_windows.normalized_rms_no_tau1{k}{i}(j) = calNMSE(window_collection_sample{j},estimated_sample);
                     accel_windows.gof_no_tau1{k}{i}{j} = gof;   

%                      figure1 = figure;
%                     plot(x1,baseline_collection{j}-estimated_sample,x1,baseline_collection{j} - window_collection_sample{j});
%                      title(accel_windows.normalized_rms_no_tau1{k}{i}(j));
%                     pause(.2);
%                     close(figure1);
                end
            end
        end
end
save('C:\Users\aungkon\Desktop\jhu\code\code_final\NIDA\derived_mat_files\accel_windows_with_parameters.mat','accel_windows');