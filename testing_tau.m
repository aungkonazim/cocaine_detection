clc;
close all;
clear all;
study_name = {'JHU','NIDAc'};
m=1;
tau_bar = [];
coeff = {};
for k=1:length(study_name)
    if length(char(study_name(k)))<=3
        p=3;
    else
        p=7;
    end
    for i=1:p
        tau = [];
        tau1= [];
        tau2 = [];
        n=1;
        n1 = 1;
        load(['C:\Users\aungkon\Desktop\jhu\data\activity\' char(study_name(k)) '\p' num2str(i,'%02d') 'activitywindows.mat']);
        for j = 1:length(act_windows.timestamp)
            if act_windows.hillol_gof{j}.adjrsquare >= .8 && act_windows.hillol_tau{j} <= 100 
                tau(n) = act_windows.hillol_tau{j};
                n=n+1;
            end
        end
        tau_bar(m,1) = mean(tau);
        tau_bar(m,2) = std(tau);
        tau_bar(m,3) = n-1;
        
        for j = 1:length(act_windows.timestamp)
            if act_windows.monowar_gof{j}.adjrsquare >= .8 && act_windows.monowar_tau{j} <= 100 
                tau1(n1) = act_windows.monowar_tau{j};
                x = act_windows.timestamp{j};
                x=(x-x(1))/60000;
                tau2(n1) = x(end);
%                 figure1 = figure;
%                 plot(act_windows.timestamp{j},act_windows.sample{j});
                n1=n1+1;
%                 pause(1);
%                 close(figure1);
                
            end
        end
        tau_bar(m,4) = mean(tau1);
        tau_bar(m,5) = std(tau1);
        tau_bar(m,6) = n1-1;
        tau_bar(m,7) = mean(tau2);
        m=m+1;
        coeff.hillol{k}(i) = mean(tau);
        
        coeff.monowar{k}(i) = mean(tau1);
    end
end

sum(tau_bar(:,3))
sum(tau_bar(:,6))
