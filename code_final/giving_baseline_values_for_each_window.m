clc;
close all;
clear all;
study_name = {'JHU','NIDAc'};
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final\accel_code');
for k=1:length(study_name)
    if length(char(study_name(k)))<=3
        p=3;
    else
        p=7;
    end
    for i=1:p
        hr = {};
        for j=1:32
                if exist(['C:\Users\aungkon\Desktop\jhu\' char(study_name(k)) '\40_merge\' 'p' num2str(i,'%02d') '_s' num2str(j,'%02d') '.mat' ], 'file')== 2
                   load (['C:\Users\aungkon\Desktop\jhu\' char(study_name(k)) '\40_merge\' 'p' num2str(i,'%02d') '_s' num2str(j,'%02d') '.mat' ]);
                   hr.time{j} = [C.rr.avg60.timestamp(1),C.rr.avg60.timestamp(end)];
                   hr.baseline{j} = prctile(C.rr.avg60.sample,95);
                end
        end
          load(['C:\Users\aungkon\Desktop\jhu\data\windows\' char(study_name(k)) '\p' num2str(i,'%02d') 'window' char(study_name(k)) '.mat']);
          for j1=1:length(window.label)
              start_time = window.recovery.timestamp{j1}(1);
              end_time = window.recovery.timestamp{j1}(end);
              for j=1:length(hr.time)
                  if ~isempty(hr.time{j})
                      if start_time >= hr.time{j}(1) && start_time <= hr.time{j}(end) && end_time >= hr.time{j}(1) && end_time <= hr.time{j}(end)
                          window.baseline(j1) = hr.baseline{j};
                          window.session(j1) = j;
                          break
                      end
                  end
              end
          end
          save(['C:\Users\aungkon\Desktop\jhu\data\windows\' char(study_name(k)) '\p' num2str(i,'%02d') 'window' char(study_name(k)) '.mat'],'window');
    end
end