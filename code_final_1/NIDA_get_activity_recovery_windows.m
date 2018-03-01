clc;
close all;
clear all;
study_name = {'NIDA'};
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final_1\functions\')
activity_windows = {};
for k=1:length(study_name)
       p = 46; 
       for i=1:p
            count = 1;
            for j=1:50
                if exist(['E:\Data\' char(study_name(k)) '\40_merge\' 'p' num2str(i,'%02d') '_s' num2str(j,'%02d') '.mat' ], 'file')== 2
                           load (['E:\Data\' char(study_name(k)) '\40_merge\' 'p' num2str(i,'%02d') '_s' num2str(j,'%02d') '.mat' ]);
                           if C.is_cocaine==0
                           window_collection = find_recovery_windows(C.acl.activity.timestamp/(1000),C.acl.activity.sample);
                           x=C.rr.avg60.timestamp;
                           y=C.rr.avg60.sample;
                           for m=1:length(window_collection)
                                start_t = window_collection{m}(1);
                                end_t = window_collection{m}(2);
                                index = find(x<=end_t & x>=start_t);
                                if ~isempty(index)
                                    window_timestamp = x(index);
                                    window_sample = y(index);
                                    minimum_index = find(window_sample==min(window_sample));
                                    minimum_index = minimum_index(1);
                                    window_sample = window_sample(minimum_index:end);
                                    window_timestamp = window_timestamp(minimum_index:end);
                                    B = prctile(window_sample,99);
                                    window_sample_temp =  B - window_sample;
                                    window_sample_temp = window_sample_temp + max(window_sample_temp);
                                    window_timestamp_temp = window_timestamp - window_timestamp(1) + 1;
                                    window_sample_temp = abs(log(window_sample_temp./window_sample_temp(1)));
                                    ind = find(window_sample_temp==max(window_sample_temp));
                                    if ~isempty(ind)
                                        window_timestamp = window_timestamp(1:ind(1));
                                        window_sample = window_sample(1:ind(1));
                                       if ~isempty(window_sample) && length(window_timestamp) > 50 && length(unique(window_sample))>20 && B - window_sample(1) > 100 && skewness(B-window_sample) > .1 
                                            window_sample_temp = B - window_sample;
                                            range =  max(window_sample_temp) - min(window_sample_temp);
                                            mi = min(window_sample_temp);
                                            window_sample_temp = (window_sample_temp - mi) / range;
                                            window_timestamp_temp = (window_timestamp - window_timestamp(1))/60000 + 1;
                                            [fitresult,gof] = createFit(window_timestamp_temp,window_sample_temp);
                                             if gof.adjrsquare > .7
        %                                             figure1 = figure;
        %                                             hold on;
        %                                             plot(window_timestamp_temp,B-(fitresult(window_timestamp_temp)*range+mi));
        %                                             plot(window_timestamp_temp,B-(window_sample_temp*range+mi));
        %                                             pause(1);
        %                                             close(figure1);
                                                    activity_windows.timestamp{k}{i}{count} = window_timestamp;
                                                    activity_windows.sample{k}{i}{count} = window_sample;
                                                    activity_windows.fitresult_a{k}{i}{count} = fitresult.a;
                                                    activity_windows.fitresult_b{k}{i}{count} = fitresult.b;
                                                    activity_windows.adjrsq{k}{i}{count} = gof.adjrsquare;
                                                    activity_windows.timestamp_fit{k}{i}{count} = window_timestamp_temp;
                                                    activity_windows.sample_fit{k}{i}{count} = B-(fitresult(window_timestamp_temp)*range+mi);
                                                    count = count + 1;
                                                 end
                                            end
                                    end
                                end
                           end
                       end
                end
            end
        end
end
save(['C:\Users\aungkon\Desktop\jhu\code\code_final_1\data_NIDA\activity_windows.mat'],'activity_windows');