clc;
close all;
clear all;
study_name = {'JHU','NIDAc'};
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final_1\functions\')
load('C:\Users\aungkon\Desktop\jhu\code\code_final_1\data\activity_windows.mat')
activity_parameter ={};
for k=1:length(study_name)
        if length(char(study_name(k)))<=3
            p=3;
        else
            p=7;
        end
       for i=1:p
           y_cell = {};
           x_cell = {};
           mdl_cell = {};
           range =[];
           mi =[];
           baseline =[];
           for j=1:length(activity_windows.timestamp{k}{i})
               x = activity_windows.timestamp{k}{i}{j};
               y = activity_windows.sample{k}{i}{j};
               baseline(j) = prctile(y,99);
               y = baseline(j) - y;
               ma(j) = y(1);
               y = y./ma(j);
%                range =[range,max(y)-min(y)];
%                mi(j) = min(y);
%                y = (y-mi(j))/range(j);
               
               x = (x - x(1))/60000 ;
%                figure1 = figure;
%                plot(x,y);
%                pause(.5);
%                close(figure1);
               y_cell{j} = y;
               x_cell{j} = x;
               mdl_cell{j} = @(beta,x) exp(-x*beta(1));
           end
           beta0 = [1];
           [beta,r,J,Sigma,mse,errorparam,robustw] = nlinmultifit(x_cell, y_cell, mdl_cell, beta0);
           ci = nlparci(beta,r,'Jacobian',J);
           figure1 = figure;
           hold all;
           box on;
           for j=1:length(y_cell)
               y = y_cell{j}*ma(j);
               x = x_cell{j};
               plot(x, baseline(j)-y);
               [ypred1,delta1] = nlpredci(mdl_cell{j},x,beta,r,'covar',Sigma);
               plot(x,baseline(j)-(ypred1*ma(j)),'Color','blue');
               plot(x,baseline(j)- ((ypred1+delta1)*ma(j)),'Color','blue','LineStyle',':');
               plot(x,baseline(j)-((ypred1-delta1)*ma(j)),'Color','blue','LineStyle',':');
           end
            pause(3);
            close(figure1)
           activity_parameter{k}{i} = beta;
       end
end
save(['C:\Users\aungkon\Desktop\jhu\code\code_final_1\data\activity_parameter.mat'],'activity_parameter');