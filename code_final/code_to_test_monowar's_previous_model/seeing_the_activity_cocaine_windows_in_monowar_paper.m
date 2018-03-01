clc;
close all;
clear all;
study_name = {'JHU','NIDAc'};
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final\accel_code');
pic =1;
for k=1:length(study_name)-1
    if length(char(study_name(k)))<=3
        p=3;
    else
        p=7;
    end
    for i=1:p
         load(['C:\Users\aungkon\Desktop\jhu\data\windows\' char(study_name(k)) '\p' num2str(i,'%02d') 'window' char(study_name(k)) '.mat']);
         for j=1:length(window.label)
             if window.label(j) < 1 && window.activation.activity{j}(1) == 1 && window.recovery.activity{j}(1) == 0
                 x=window.activation.timestamp{j};
                 y=window.activation.sample{j};
                 x1 = window.recovery.timestamp{j};
                 y1 = window.recovery.sample{j};
                 y2 = window.baseline(j)-y1;
                 x2 = (x1-x1(1))/60000;
                 [fitresult, gof] = fit_monowar(x2, y2./y2(1));
                 estimated_sample =abs(y2(1)*exp(-1*(1/fitresult.a).*x2));
                figure1 = figure;
                 hold on;
%                  plot(x1,y2);
%                  plot(x1,estimated_sample);
%                  h1 = plot((x-x(1))/60000,y,(x1-x(1))/60000,y1,(x1-x(1))/60000,window.baseline(j)-estimated_sample,'LineWidth',2);
%                  legend(h1,'Activation Window','Recovery Window','Fitted Recovery Model')
                 h1 = plot((x-x(1))/60000,y,(x1-x(1))/60000,y1,(x1-x(1))/60000,ones(size(x1))*window.baseline(j),'LineWidth',2);
                 legend(h1,'Activation Window','Recovery Window','Baseline','Location','SouthEast')
                 ylabel('RR Interval')
                 xlabel('Time in minutes')
            
%                  set( gca , 'Visible' , 'off' );
                 saveas(gcf,['C:\Users\aungkon\Desktop\jhu\code\derived_figure_files\foremre\' num2str(pic) '.jpg']);
                 pic = pic+1;
                 pause(1);
                 close(figure1);
             end
         end
         %          window.decision = {};
%          for j=1:length(window.label) 
%              
%              if window.label(j) > 1 && window.activation.activity{j} == 0 
%                  x=window.recovery.timestamp{j};
%                  y=window.recovery.sample{j};
%                  minimum_index = find(y==min(y));
%                  x = x(minimum_index:end);
%                  y = y(minimum_index:end);
%                  if ~isempty(y) && ((x(end)-x(1))/60000) >= 3
%                      tau  = accel_parameter.tau{k}(i);
%                      x=(x-x(1))./60000;
%                      y = window.baseline(j) - y;
% %                      y = smooth(y,100)';
%                       [estimated_sample,taud,mse] = get_taud(x(1:end),y(1:end),tau); 
%                       prompt = 'What is the decision on this window?';
%                       decision = input(prompt);
%                       if decision == 0                          
%                           window.decision{j} = window.label(j);
%                           taud_array = [taud_array,taud];
%                           nmsearr = [nmsearr, mse];
%                       end
% 
%                      
%                  end
%              end
%          end
%          window.decision
%          save(['C:\Users\aungkon\Desktop\jhu\data\windows\' char(study_name(k)) '\p' num2str(i,'%02d') 'window' char(study_name(k)) '.mat'],'window');
    end
end
% accel_parameter.taud = median(taud_array);
% save('C:\Users\aungkon\Desktop\jhu\code\derived_mat_files\accel_coeffs_median_final.mat','accel_parameter');