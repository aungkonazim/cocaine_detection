clc;
clc;
close all;
clear all;
study_name = {'JHU','NIDAc'};
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final_1\functions\');
load('C:\Users\aungkon\Desktop\jhu\code\code_final_1\data\activity_parameter.mat');
load('C:\Users\aungkon\Desktop\jhu\code\code_final_1\data\cocaine_windows.mat');
x_cell = {};
y_cell = {};
mdl_cell = {};
beta0 =[];
beta0(1) = 0;
act_fit_cell = {};
mi =[];
B =[];
range =[];
for m=1:length(cocaine_windows.timestamp)
    k = cocaine_windows.study{m};
    i = cocaine_windows.participant{m};
    x = cocaine_windows.timestamp{m};
    y = cocaine_windows.sample{m};
    taur{m} = activity_parameter{k}{i};
    B(m) = prctile(y,99);
    x_temp = (x-x(1))/60000;
    y_temp = B(m) - y;
%     range(m) = max(y_temp) - min(y_temp);
%     mi(m) = min(y_temp);
    ma(m) = y_temp(1);
    act_fit = ma(m)*exp(-taur{m}(1)*x_temp);
    act_fit_cell{m} = act_fit;
    y_temp2 = y_temp - act_fit;
    y_cell{m} = y_temp2;
    x_cell{m} = x_temp;
    mdl_cell{m} = @(beta,x) (((beta(m+1))*exp(-x*beta(1)))-((beta(m+1))*exp(-x*taur{m}())));
    beta0(m+1) = 1;
end
[beta,r,J,Sigma,mse,errorparam,robustw] = nlinmultifit(x_cell, y_cell, mdl_cell, beta0);
ci = nlparci(beta,r,'Jacobian',J);
%     figure1 = figure;
%     plot(x_temp,y_temp,x_temp,(taur{m}(1)*exp(-taur{m}(2)*x_temp))*range(m)+mi(m));
%     pause(1);
%     close(figure1);
cocaine_parameter = {};
cocaine_parameter.global_value = beta(1);
figure1 = figure;
hold all;
box on;
for m=1:length(y_cell)
   y = y_cell{m} + act_fit_cell{m};
   x = x_cell{m};
   plot(x,B(m) - y);
   [ypred1,delta1] = nlpredci(mdl_cell{m},x,beta,r,'covar',Sigma);
   plot(x,B(m)-(ypred1+act_fit_cell{m}),'Color','blue');
%    plot(x,baseline(j)- ((ypred1+delta1)*range(j)+mi(j)),'Color','blue','LineStyle',':');
%    plot(x,baseline(j)-((ypred1-delta1)*range(j)+mi(j)),'Color','blue','LineStyle',':');
end
ylim([500,1100])
pause(3);
close(figure1)
save(['C:\Users\aungkon\Desktop\jhu\code\code_final_1\data\cocaine_parameter.mat'],'cocaine_parameter');