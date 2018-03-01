clc;
close all;
clear all;
study_name = {'JHU','NIDAc'};
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final_1\functions\')
load('C:\Users\aungkon\Desktop\jhu\code\code_final_1\data\baseline_heart_rate_of_all_participants.mat')
for k=1:length(study_name)
        if length(char(study_name(k)))<=3
            p=3;
        else
            p=7;
        end
        for i=1:p
            c = 1;
            for j=1:length(baseline.heart_rate_ts_only_rest_day_wise{k}{i})
                x = baseline.heart_rate_ts_only_rest_day_wise{k}{i}{j};
                y = baseline.heart_rate_sample_only_rest_day_wise{k}{i}{j};
                x1 = baseline.heart_rate_ts_whole_day_wise{k}{i}{j};
                if ~isempty(x) && length(x) >10
                    x1 = (x1 - x(1))/1000;
                    x = (x-x(1))/1000;
                    ft = fittype( 'sin4' );
                    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
                    [fitresult, gof] = fit( x' ,y', ft, opts );
                    figure1 = figure;
                    plot(fitresult,x,y);
                    ylim([300,1100])
                    pause(1)
                    close(figure1);
                    baseline.heart_rate_sample_whole_day_wise{k}{i}{j} = fitresult(x1);
                end
           end
     end
end
save('C:\Users\aungkon\Desktop\jhu\code\code_final_1\data\baseline_heart_rate_of_all_participants_interpolated.mat','baseline');