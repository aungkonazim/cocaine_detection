clc;
close all;
clear all;
study_name = {'JHU','NIDAc'};
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final\accel_code');
load('C:\Users\aungkon\Desktop\jhu\code\derived_mat_files\accel_coeffs_median_final.mat');
load('C:\Users\aungkon\Desktop\jhu\code\derived_mat_files\rest_heart_rate.mat');
taud_array = [];
nmsearr = []
for k=1:length(study_name)
    if length(char(study_name(k)))<=3
        p=3;
    else
        p=7;
    end
    for i=1:p
         load(['C:\Users\aungkon\Desktop\jhu\data\windows\' char(study_name(k)) '\p' num2str(i,'%02d') 'window' char(study_name(k)) '.mat']);
         window.decision = {};
         for j=1:length(window.label) 
             
             if window.label(j) > 1 && window.activation.activity{j} == 0 
                 x=window.recovery.timestamp{j};
                 y=window.recovery.sample{j};
                 minimum_index = find(y==min(y));
                 x = x(minimum_index:end);
                 y = y(minimum_index:end);
                 if ~isempty(y) && ((x(end)-x(1))/60000) >= 3
                     tau  = accel_parameter.tau{k}(i);
                     x=(x-x(1))./60000;
                     y = window.baseline(j) - y;
%                      y = smooth(y,100)';
                      [estimated_sample,taud,mse] = get_taud(x(1:end),y(1:end),tau); 
                      prompt = 'What is the decision on this window?';
                      decision = input(prompt);
                      if decision == 0                          
                          window.decision{j} = window.label(j);
                          taud_array = [taud_array,taud];
                          nmsearr = [nmsearr, mse];
                      end

                     
                 end
             end
         end
         window.decision
         save(['C:\Users\aungkon\Desktop\jhu\data\windows\' char(study_name(k)) '\p' num2str(i,'%02d') 'window' char(study_name(k)) '.mat'],'window');
    end
end
accel_parameter.taud = median(taud_array);
save('C:\Users\aungkon\Desktop\jhu\code\derived_mat_files\accel_coeffs_median_final.mat','accel_parameter');