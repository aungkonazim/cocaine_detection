clc;
close all;
clear all;
study_name = {'JHU','NIDAc'};
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final_1\functions\');
load('C:\Users\aungkon\Desktop\jhu\code\code_final_1\data\activity_parameter.mat');
cocaine_windows = {};
count = 1;
skew= [];
for k=1:length(study_name)
        if length(char(study_name(k)))<=3
            p=3;
        else
            p=7;
        end
       for i=1:p
           load(['C:\Users\aungkon\Desktop\jhu\data\windows\' char(study_name(k)) '\p' num2str(i,'%02d') 'window' char(study_name(k)) '.mat']);
           for j=1:length(window.label) 
               if window.label(j) > 10 && window.activation.activity{j} == 0
                     x=window.recovery.timestamp{j};
                     y=window.recovery.sample{j};
                     minimum_index = find(y==min(y));
                     x = x(minimum_index:end);
                     y = y(minimum_index:end);
                     
%                      figure1 =figure;
%                      subplot(2,1,1),plot(x,y);
%                      subplot(2,1,2),histogram(y);title(skewness(y));
%                      skew = [skew,skewness(y)];
%                      pause(1);
%                      close(figure1);
                    if ~isempty(y) && (x(end)-x(1))/60000 >= 5 && length(unique(y)) > 20  && y(end) - y(1) > 100 
                        cocaine_windows.timestamp{count} = x;
                        cocaine_windows.sample{count} = y;
                        cocaine_windows.study{count} = k;
                        cocaine_windows.participant{count} = i;
                        count = count + 1;
                        
                            figure1 = figure;
                            subplot(1,2,1),plot(x,y);
                            subplot(1,2,2),histogram(y);title(['kurtosis ' num2str(kurtosis(y))]);
                            pause(.5);
                           
                        
                         saveas(gcf,['C:\Users\aungkon\Desktop\Em\picctures_cocaine_windows\' num2str(count) '.jpg'])
                         close(figure1);
                         skew = [skew,kurtosis(y)];
                    end
               end
           end
       end
end
% save(['C:\Users\aungkon\Desktop\jhu\code\code_final_1\data\cocaine_windows.mat'],'cocaine_windows');