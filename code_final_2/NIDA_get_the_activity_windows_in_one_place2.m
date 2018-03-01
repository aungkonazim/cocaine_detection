close all;
clear all;
study_name = {'NIDA'};
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final_1\functions\')
activity_windows = {};
m=1;
for k=1:length(study_name)
       p =46; 
       for i=1:p
           count =1;
           load(['C:\Users\aungkon\Desktop\jhu\code\code_final_2\data_NIDA\windows\' 'p' num2str(i,'%02d') 'windowNIDA.mat']);
%            act_ts = window.activity.activity_timestamp_of_day;
%            act_sample = window.activity.activity_sample_of_day;
           act_x = window.activity.timestamp_of_day;
           act_y = window.activity.sample_of_day;
           act_y1 = sqrt(act_y(1,:).^2+act_y(2,:).^2+act_y(3,:).^2);
           act_y = act_y1 > prctile(act_y1,80);
           for k1=1:length(window.is_cocaine)
               if window.is_cocaine(k1) == 0 && window.activation.activity{k1}(1)==1 && window.label(k1)==0
                    x = window.recovery.timestamp{k1};
                    y = window.recovery.sample{k1};
                    index = find(act_x>x(1) - 2*60*1000 & act_x<x(1) + 20*60*1000);
                    temp_act_y = act_y(:,index);
                    temp_act_x = act_x(:,index);
                    [st] = find_int(temp_act_x,temp_act_y,0);
                    if st ~=0
                        x = x(find(x>st-15*1000));
                        y = y(find(x>st-15*1000));
                        if ~isempty(y)
                            minimum_index = find(y(2:end)==min(y));
                             x = x(minimum_index:end);
                             y = y(minimum_index:end);
                            
    %                             figure1 = figure;
    %                             plot(x,y./max(y),temp_act_x,temp_act_y,'*');
    %                             ylim([(min(y)/max(y))-.02,1])
    %                             pause(1);
    %                             close(figure1);
                             if length(y)>100
                                t = findchangepts(y,'Statistic','linear');
                                y = y(1:t(1));
                                x = x(1:t(1));
                                if length(y)>100 && length(find(diff(y)==0))/length(y) < .2 && max(y)-min(y) > 100
%                                     figure1 =figure
%                                     plot(x,y)
%                                     pause(1)
%                                     close(figure1)
                                    activity_windows.timestamp{k}{i}{count} = x;
                                    activity_windows.sample{k}{i}{count} = y;
                                    activity_windows.baseline{k}{i}{count} = window.baseline(k1);
                                    count =count + 1;
                                    m=m+1;
                                end
                            end
                        end
                    end
               end
           end
       end
end
save(['C:\Users\aungkon\Desktop\jhu\code\code_final_2\data_NIDA\activity_windows.mat'],'activity_windows');