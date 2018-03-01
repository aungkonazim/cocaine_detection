clc;
close all;
clear all;
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final\accel_code');
load('C:\Users\aungkon\Desktop\jhu\code\code_final\NIDA\derived_mat_files\accel_windows_with_parameters.mat');
study_name = {'NIDA'};
accel_parameter = {};
for k=1:length(study_name)
        p=46;
        for i=1:p
          tau2 = [];
          tau1 = [];
          stdarr = [];
          nrmsarr = [];
          index1 =[];
          for j=1:length(accel_windows.monowar_tau2{k}{i})
              if ~isempty(accel_windows.monowar_tau1{k}{i}{j})
                   tau1 = [tau1,accel_windows.monowar_tau1{k}{i}{j}(1)];
                   tau2 = [tau2,accel_windows.monowar_tau2{k}{i}{j}(1)];
                   stdarr = [stdarr,accel_windows.standard_deviation{k}{i}(j) ];
                   nrmsarr = [nrmsarr,accel_windows.normalized_rms{k}{i}(j)];
                   index1 = [index1,j];
              end 
         end
          index = find(stdarr > prctile(stdarr,20) & nrmsarr < prctile(nrmsarr,60));
          tau1  = tau1(index);
          tau2 = tau2 (index);
          index1 =index1(index);
          length(index);
%           for l=1:length(index)
%                
%                   figure1 = figure;
%                   plot(accel_windows.timestamp{k}{i}{index1(l)},accel_windows.sample{k}{i}{index1(l)})
%                   pause(1);
%                   close(figure1);
%               
%           end
          accel_parameter.tau1{k}(i) = mean(tau1(~isnan(tau1)));
          accel_parameter.tau2{k}(i) = mean(tau2(~isnan(tau2)));
           
          tau = [];
          stdarr = [];
          rsqarr = [];
          index1 =[];
          for j=1:length(accel_windows.monowar_tau_no_tau1{k}{i})
              if ~isempty(accel_windows.monowar_tau_no_tau1{k}{i}{j})
                   tau = [tau,accel_windows.monowar_tau_no_tau1{k}{i}{j}(1)];
                   stdarr = [stdarr,accel_windows.standard_deviation{k}{i}(j) ];
                   rsqarr = [rsqarr,accel_windows.gof_no_tau1{k}{i}{j}(1).adjrsquare];
                   index1 = [index1,j];
              end 
         end
          index = find(stdarr > prctile(stdarr,20) & rsqarr > .6);
          tau = tau(index);
          index1 = index1(index);
          length(index1)
%           for l=1:length(index)
%                
%                   figure1 = figure;
%                   plot(accel_windows.timestamp{k}{i}{index1(l)},accel_windows.sample{k}{i}{index1(l)})
%                   pause(.5);
%                   close(figure1);
%               
%           end
          accel_parameter.tau{k}(i) = median(tau(~isnan(tau)));
          
           end
end
 save('C:\Users\aungkon\Desktop\jhu\code\code_final\NIDA\derived_mat_files\accel_coeffs_median_final.mat','accel_parameter');