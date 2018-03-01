clc;
close all;
clear all;
study_name = {'JHU','NIDAc'};
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final\accel_code')
baseline = {};
for k=1:length(study_name)
        if length(char(study_name(k)))<=3
            p=3;
        else
            p=7;
        end
        
        for i=1:p
            baseline_rr = [];
            baseline_timestamp = [];
            for j=1:22
                if exist(['C:\Users\aungkon\Desktop\jhu\' char(study_name(k)) '\40_merge\' 'p' num2str(i,'%02d') '_s' num2str(j,'%02d') '.mat' ], 'file')== 2
                   load (['C:\Users\aungkon\Desktop\jhu\' char(study_name(k)) '\40_merge\' 'p' num2str(i,'%02d') '_s' num2str(j,'%02d') '.mat' ]);
                   window_collection = find_rest_windows(C.acl.activity.timestamp/(1000),C.acl.activity.sample); 
                   x=C.rr.avg60.timestamp;
                   y=C.rr.avg60.sample;
                   window_timestamp = [];
                   window_sample =[];
                       for m=1:length(window_collection)
                           start_t = window_collection{m}(1);
                           end_t = window_collection{m}(2);
                           cocaine_present = 0;
                           for o=1:length(C.rr.window.dose)
                                   if C.rr.window.dose(o)>=10
                                       time = C.rr.avg60.timestamp(C.rr.window.v1_ind60(o):C.rr.window.p2_ind60(o));
                                       if ~isempty(length(find(time==start_t))) || ~isempty(length(find(time==start_t)))
                                            cocaine_present = 1;
                                            break;
                                       end
                                   end
                           end
                           if cocaine_present == 0
                                  index = find(x<=end_t & x>=start_t);
                                  if ~isempty(index)
                                     window_timestamp = [window_timestamp, x(index)];
                                     window_sample = [window_sample, y(index)];
                                 end
                           end
                       end
                      resampled_rr=[];
                      if ~isempty(window_sample)
                           resampled_rr = interp1(window_timestamp,window_sample,x);
                           baseline_rr=[baseline_rr,resampled_rr];
                           baseline_timestamp = [baseline_timestamp,x];
                      end
                                      
                end
            end
            baseline.timestamp{k}{i} = baseline_timestamp;
            baseline.rest_hr{k}{i} = baseline_rr;
        end
end
save('C:\Users\aungkon\Desktop\jhu\code\derived_mat_files\rest_heart_rate.mat','baseline');



