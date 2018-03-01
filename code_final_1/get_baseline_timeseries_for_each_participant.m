clc;
close all;
clear all;
study_name = {'JHU','NIDAc'};
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final_1\functions\')
baseline = {};
for k=1:length(study_name)
        if length(char(study_name(k)))<=3
            p=3;
        else
            p=7;
        end
        
        for i=1:p
            baseline.heart_rate_ts_only_rest{k}{i} = [];
            baseline.heart_rate_sample_only_rest{k}{i} = [];
            baseline.heart_rate_ts_whole{k}{i} = [];
             baseline.activity_ts_whole{k}{i} = [];
             baseline.activity_sample_whole{k}{i} = [];
            for j=1:22
                if exist(['C:\Users\aungkon\Desktop\jhu\' char(study_name(k)) '\40_merge\' 'p' num2str(i,'%02d') '_s' num2str(j,'%02d') '.mat' ], 'file')== 2
                   load (['C:\Users\aungkon\Desktop\jhu\' char(study_name(k)) '\40_merge\' 'p' num2str(i,'%02d') '_s' num2str(j,'%02d') '.mat' ]);
                   rest_windows = find_rest_windows_from_activity_timeseries(C.acl.activity.timestamp,C.acl.activity.sample);
                   rr_interval_x = C.rr.avg60.timestamp;
                   rr_interval_y = C.rr.avg60.sample;
                   baseline.heart_rate_ts_whole{k}{i} = [baseline.heart_rate_ts_whole{k}{i},rr_interval_x];
                   baseline.activity_ts_whole{k}{i} = [baseline.activity_ts_whole{k}{i},C.acl.activity.timestamp];
                   baseline.activity_sample_whole{k}{i} = [baseline.activity_sample_whole{k}{i},C.acl.activity.sample];
                   baseline.heart_rate_ts_only_rest_day_wise{k}{i}{j} = [];
                   baseline.heart_rate_sample_only_rest_day_wise{k}{i}{j} = [];
                   baseline.heart_rate_ts_whole_day_wise{k}{i}{j} = rr_interval_x;
                   for m=1:length(rest_windows)
                       start_of_window_ts = rest_windows{m}(1);
                       end_of_window_ts = rest_windows{m}(2);
                       baseline.heart_rate_ts_only_rest_day_wise{k}{i}{j} = [baseline.heart_rate_ts_only_rest_day_wise{k}{i}{j},rr_interval_x(find(rr_interval_x>=start_of_window_ts & rr_interval_x < end_of_window_ts))];
                       baseline.heart_rate_sample_only_rest_day_wise{k}{i}{j} = [baseline.heart_rate_sample_only_rest_day_wise{k}{i}{j},rr_interval_y(find(rr_interval_x>=start_of_window_ts & rr_interval_x < end_of_window_ts))];
                        baseline.heart_rate_ts_only_rest{k}{i} = [baseline.heart_rate_ts_only_rest{k}{i},rr_interval_x(find(rr_interval_x>=start_of_window_ts & rr_interval_x < end_of_window_ts))];
                       baseline.heart_rate_sample_only_rest{k}{i} = [baseline.heart_rate_sample_only_rest{k}{i},rr_interval_y(find(rr_interval_x>=start_of_window_ts & rr_interval_x < end_of_window_ts))];
                   end
                end
            end
        end
end
save('C:\Users\aungkon\Desktop\jhu\code\code_final_1\data\baseline_heart_rate_of_all_participants.mat','baseline');