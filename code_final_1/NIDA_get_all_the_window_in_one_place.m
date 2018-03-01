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
           load(['C:\Users\aungkon\Desktop\jhu\code\code_final_1\data_NIDA\windows\p' num2str(i,'%02d') 'window' char(study_name(k)) '.mat']);
           if ~isempty(window) && length(unique(window.label)) > 1
           for j=1:length(window.label) 
                       x=window.recovery.timestamp{j};
                         y=window.recovery.sample{j};
                         actx = window.activity.timestamp{j};
                         acty = window.activity.sample{j};
                         minimum_index = find(y==min(y));
                         x = x(minimum_index:end);
                         y = y(minimum_index:end);
                        B = window.baseline(j);
                         if  length(y) > 100 && ~isempty(acty)
                              acty1 = acty( find(actx<=x(1)));
                              acty2 = acty( find(actx>=x(1)));
                              acty3 = [acty1,acty2];
                              x_final = x;
                              y_final = y;
                             if ~isempty(y_final)  && B-y_final(1) > 200 && length(find(diff(y)==0))/length(y) < .1 && length(y) > 450 && mode(acty1) == 0 ...
                                 && mode(acty3)==0
%                                  && length(find(diff(y)==0))/length(y) < .1 && length(y) > 450 && mode(acty1) == 0 && mode(acty2)==0
                                       windows.timestamp{count} =  x_final;
                                      windows.sample{count} =  y_final;
                                      windows.study(count) = k;
                                      windows.participant(count) = i;
                                      windows.activity(count) = window.recovery.activity{j};
                                      windows.act_sample{count} = window.activation.sample{j};
                                      windows.baseline(count) = B;
                                      windows.label(count) = window.label(j);
                                       if windows.label(count) > 0
                                           windows.label(count) = 1;
                                           count1 = count1+1;
                                       end
%                                         figure1 = figure;
%                                            plot(x_final,y_final);
%                                            pause(1)
%                                            close(figure1)
                                      count =count +1;
                              end
                         end
                   end
               end          
        end
end
save(['C:\Users\aungkon\Desktop\jhu\code\code_final_1\data_NIDA\window_store.mat'],'windows');