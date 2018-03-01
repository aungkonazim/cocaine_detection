clc;
close all;
clear all;
study_name = {'NIDA'};
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final_1\functions\');
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final\accel_code');
load('C:\Users\aungkon\Desktop\jhu\code\code_final_1\data\cocaine_parameter.mat');
load('C:\Users\aungkon\Desktop\jhu\code\code_final_1\data_NIDA\activity_parameter.mat');
load('C:\Users\aungkon\Desktop\jhu\code\code_final_1\data_NIDA\window_store.mat');
taud = cocaine_parameter.global_value;
label = [];
subject = [];

for m=1:length(windows.label)
    x = windows.timestamp{m};
    y = windows.sample{m};
    ya = windows.act_sample{m};
    k = windows.study(m);
    i = windows.participant(m);
    subject(m) = k*10+i;
    B = windows.baseline(m);
    if windows.label(m) == 0
        label = [label,0];
    else
        label = [label,1];
    end
    [P,f]=HeartRateLomb(y,1:length(y));
    
    taur = activity_parameter{k}{i};
    x_temp = (x-x(1))/60000;
    y_temp = B - y;
    [e1,taud_est,e] = get_taud(x_temp,y_temp,1/taur);
%     range = max(y_temp) - min(y_temp);
%     mi = min(y_temp);
    ma = y_temp(1);
    act_fit = ma*exp(-taur(1)*x_temp);
    y_temp = y_temp - act_fit;
    y_cell{1} = y_temp;
    x_cell{1} = x_temp;
    mdl_cell{1} = @(beta,x) (((beta(1))*exp(-x*taud))-((beta(1))*exp(-x*taur(1))));
    beta0 = [1];
    [beta,r,J,Sigma,mse,errorparam,robustw] = nlinmultifit(x_cell, y_cell, mdl_cell, beta0);
    u = beta(1); 
    [ypred1,delta1] = nlpredci(mdl_cell{1},x_cell{1},beta,r,'covar',Sigma);
    y_temp = ypred1' + act_fit;
    y_cocaine_fit = B - y_temp;
    act_fit = B - act_fit;    
    
    y_act = y(1:200);
    act_fit_act = act_fit(1:200);
    x_act = x_temp(1:200);
    
    y_act_g = B - y_act;
    y_cell{1} = y_act_g/y_act_g(1);
    x_cell{1} = x_act;
    mdl_cell{1} = @(beta,x) exp(-x*beta(1));
    beta0 = [taur];
    [beta,r,J,Sigma,mse,errorparam,robustw] = nlinmultifit(x_cell, y_cell, mdl_cell, beta0);
    taur2 = beta(1);
    
                     
     
    feature(m,1) = double(prctile(diff(y),80)); % 80th percentile of difference
    feature(m,2) = double(prctile(diff(y),20)); % 20th percentile of difference
    feature(m,3) = double(skewness(B-y)); %skewness of B-y
    feature(m,4) = double(kurtosis(B-y)); %kurtosis of B-y
    feature(m,5) = double(HeartRateLFHF(P,f)); % ratio of low freq and high freq energy
    feature(m,6) = double(HeartRatePower34(P,f)); % high freqency energy
    feature(m,7) = double(HeartRatePower23(P,f)); % medium frequency energy
    feature(m,8) = double(HeartRatePower12(P,f)); % low frequency energy
    feature(m,9) = double((x(end)-x(1))/60000); % duration
    feature(m,10) = double(sum((y-y_cocaine_fit).^2)); %L2 norm of cocaine fit and the window
    feature(m,11) = double(sum((y-act_fit).^2)); %L2 norm of activity fit
    feature(m,12) = double(feature(m,10)/feature(m,11)); % ratio of L2 norm
    feature(m,13) = double(sum((y_act-act_fit_act).^2)); %l2 norm of short act fit
    feature(m,14) = double(feature(m,10)/feature(m,13)); % ratio of L2 norm short
    feature(m,15)  = double(taur2/taur); % ratio of estimated taur to real taur
    feature(m,16) = double(B-prctile(ya,99)); % baseline to activation diff
     feature(m,17)  = double(taur2); % ratio of estimated taur to real taur
     feature(m,18)  = double(taur); % ratio of estimated taur to real taur
     feature(m,19)  = double(taud_est); % ratio of estimated taur to real taur
        
 %         if label(m) == 1
%     figure1 = figure;
%     hold on;
%     plot(x,y);
%     plot(x,act_fit);
%     plot(x,y_cocaine_fit);
%     title(label(m));
%     pause(2);
%     close(figure1);
%     end
end
save(['C:\Users\aungkon\Desktop\jhu\code\code_final_1\data_NIDA\feature.mat'],'feature','label','subject');
