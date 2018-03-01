clc;
close all;
clear all;
study_name = {'JHU','NIDAc'};
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final\accel_code');
load('C:\Users\aungkon\Desktop\jhu\code\derived_mat_files\accel_coeffs.mat');
taud_array = [];
mse_array = [];
for k=1:length(study_name)
    if length(char(study_name(k)))<=3
        p=3;
    else
        p=7;
    end
    for i=1:p
         load(['C:\Users\aungkon\Desktop\jhu\data\windows\' char(study_name(k)) '\p' num2str(i,'%02d') 'window' char(study_name(k)) '.mat']);
         if length(window.decision) > 0
             for j=1:length(window.decision)
                 if ~isempty(window.decision{j})  && window.decision{j}(1) == 10 
                    x=window.recovery.timestamp{j};
                    y=window.recovery.sample{j};
                     minimum_index = find(y==min(y));
                     x = x(minimum_index:end);
                    y = smooth(y(minimum_index:end),30);
                    taur  = accel_parameter{k}(i);                    
                    x=(x-x(1))./60000;
                    y1=60000./y;
                     [estimated_sample,taud,mse] = get_taud(x(1:end),y1(1:end)',taur); 
                     taud_array= [taud_array, taud];
                     mse_array = [mse_array, mse];
                    figure1 = figure;
                    plot(x,y,x,estimated_sample,'LineWidth',1);
                    pause(2);
                    close(figure1);
                 end
             end
         end
             
%              if window.label(j) > 10 && window.activation.activity{j} == 0 
%                  x=window.recovery.timestamp{j};
%                  y=window.recovery.sample{j};
%                  minimum_index = find(y==min(y));
%                  x = x(minimum_index:end);
%                  y = smooth(y(minimum_index:end),30);
%                  if ~isempty(y) && ((x(end)-x(1))/60000) >= 3
%                      taur  = accel_parameter{k}(i);
%                      x=(x-x(1))./60000;
%                      y1=60000./y;
%                      [estimated_sample,taud,mse] = get_taud(x(1:end),y1(1:end)',taur); 
%                      taud_array= [taud_array, taud];
%                      mse_array = [mse_array, mse];
%                      figure1 = figure;
%                      plot(x,y,x,estimated_sample,'LineWidth',1);
%                      xlabel minutes
%                     ylabel 'rr interval(ms)'
%                     grid on
%                     fig = gcf;
%                     fig.InvertHardcopy = 'off';
%                      pause(2)
%                      prompt = 'What is the decision on this window?';
%                      decision = input(prompt);
%                      window.decision{j} = decision;
%                      close(figure1);
%                      
%                  end
%              end
         
         end         
end
index = find(mse_array< prctile(mse_array,75));
array_td = taud_array(index);
median(array_td);


