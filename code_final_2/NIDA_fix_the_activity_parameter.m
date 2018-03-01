clc;
close all;
clear all;
load('C:\Users\aungkon\Desktop\jhu\code\code_final_2\data_NIDA\activity_parameter.mat');
u1 = [];
% u2 = [];
for i=1:length(activity_parameter{1})
    if length(activity_parameter{1}{i}) > 0
        u1 = [u1, activity_parameter{1}{i}(1)];
%         u2 = [u2, activity_parameter{1}{i}(2)];
    end    
end

for i=1:length(activity_parameter{1})
    if length(activity_parameter{1}{i}) == 0
        activity_parameter{1}{i}(1) = median(u1);
%         activity_parameter{1}{i}(2) = median(u2);
        
    end    
end
save(['C:\Users\aungkon\Desktop\jhu\code\code_final_2\data_NIDA\activity_parameter.mat'],'activity_parameter');