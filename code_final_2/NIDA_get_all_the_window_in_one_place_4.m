clc;
close all;clear all;
study_name = {'NIDA'};
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final_1\functions\');
count = 1;
count1 = 1;
windows = {};
for k=1:length(study_name)
       p = 46;
       for i=1:p
           load(['C:\Users\aungkon\Desktop\jhu\code\code_final_2\data_NIDA\windows\p' num2str(i,'%02d') 'window' char(study_name(k)) '.mat']);
           if ~isempty(window) 
               for j=1:length(window.label)
                   if window.is_cocaine(j)==1
                         x=window.recovery.timestamp{j};
                         y=window.recovery.sample{j};
                         minimum_index = find(y==min(y));
                         x = x(minimum_index:end);
                         y = y(minimum_index:end);
                         B = prctile(y,99);
                         x_final = x;
                         y_final = y;
                         duration = (x(end)-x(1))/60000;
                         if ~isempty(y_final)  && max(y_final)-min(y_final)>130 && ...
                                 length(find(diff(y)==0))/length(y) < .1 && duration > 5 &&...
                                    window.activation.activity{j}(1) == 0 
                             
                                 windows.timestamp{count} =  x_final;
                                 windows.sample{count} =  y_final;
                                 windows.study(count) = k;
                                 windows.participant(count) = i;
                                 windows.activity(count) = window.recovery.activity{j};
                                 windows.act_sample{count} = window.activation.sample{j};
                                 windows.baseline(count) = B;
                                 windows.label(count) = window.label(j);
                                  if windows.label(count) > 10
                                       windows.label(count) = 1;
                                       count1 = count1+1;
%                                       figure1 = figure;
%                                       plot(x_final,y_final);
%                                       pause(1)
%                                       close(figure1)
                                  end

                                  count =count +1;
                            end
                        end
                   end
               end          
        end
end
count = count-count1;
save(['C:\Users\aungkon\Desktop\jhu\code\code_final_2\data_NIDA\window_store.mat'],'windows');