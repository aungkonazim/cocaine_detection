clc;
close all;
clear all;
study_name = {'JHU','NIDAc'};
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final\accel_code')
accel_windows = {};
for k=1:length(study_name)
        if length(char(study_name(k)))<=3
            p=3;
        else
            p=7;
        end
        
        for i=1:p
            m1 = 1;
            for j=1:22
                if exist(['C:\Users\aungkon\Desktop\jhu\' char(study_name(k)) '\40_merge\' 'p' num2str(i,'%02d') '_s' num2str(j,'%02d') '.mat' ], 'file')== 2
                   load (['C:\Users\aungkon\Desktop\jhu\' char(study_name(k)) '\40_merge\' 'p' num2str(i,'%02d') '_s' num2str(j,'%02d') '.mat' ]);
                   window_collection = find_recovery_windows(C.acl.activity.timestamp/(1000),C.acl.activity.sample);
                   x=C.rr.avg60.timestamp;
                   y=C.rr.avg60.sample;
                   baseline = prctile(y,95);
                   for m=1:length(window_collection)
                        start_t = window_collection{m}(1);
                        end_t = window_collection{m}(2);
                        index = find(x<=end_t & x>=start_t);
                        window_timestamp = x(index);
                        window_sample = y(index);
                        if ~isempty(index)
                            minimum_index = find(window_sample==min(window_sample));
                            minimum_index = minimum_index(1);
                            window_sample = window_sample(minimum_index:end);
                            window_timestamp = window_timestamp(minimum_index:end);
                            if ~isempty(window_sample) && ((window_timestamp(end)-window_timestamp(1))/60000) >= 3
                                t = findchangepts(smooth(window_sample,100),'Statistic','linear');
                                window_timestamp = window_timestamp(1:t(1));
                                window_sample = window_sample(1:t(1));
                                if ~isempty(window_sample) && ((window_timestamp(end)-window_timestamp(1))/60000) >= 1
                                    accel_windows.timestamp{k}{i}{m1} = window_timestamp;
                                    accel_windows.sample{k}{i}{m1} = baseline.*ones(size(window_sample)) - window_sample;
                                    accel_windows.real_sample{k}{i}{m1} = window_sample;
                                    figure1  = figure;
                                    plot((window_timestamp-window_timestamp(1))/60000,baseline.*ones(size(window_sample)) - window_sample);
                                    pause(1);
                                    close(figure1);
                                    accel_windows.baseline{k}{i}{m1} = baseline; 
                                    m1 = m1 + 1;
                                end
                            end
                        end
                   end
                   
                end
            end            
        end
end
% save('C:\Users\aungkon\Desktop\jhu\code\derived_mat_files\accel_windows.mat','accel_windows');