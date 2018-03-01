clc;
close all;
clear all;
study_name = {'NIDA'};
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final\accel_code');
load('C:\Users\aungkon\Desktop\jhu\code\code_final\NIDA\derived_mat_files\accel_coeffs_median_final.mat');
taud = 26.5938;
outlier_array = [];
theta_label = [];
subject_array =[];
feature =[];
win = 1;
for k=1:length(study_name)
    p = 5;
    for i=1:p
        load(['C:\Users\aungkon\Desktop\jhu\code\code_final\NIDA\data\p' num2str(i,'%02d') 'window' char(study_name(k)) '.mat']);
        for j=1:length(window.label)
                 x=window.recovery.timestamp{j};
                 y=window.recovery.sample{j};
                 if (x(end)-x(1))/60000 > 1 && length(unique(y)) > 20
                     minimum_index = find(y==min(y));
                     x = x(minimum_index:end);
                     y = y(minimum_index:end);
                    outlier=detect_outlier(y/1000,x);
                     x=(x-x(1))./60000;
                     outlier_array = [outlier_array,length(find(outlier==0))*100/length(y)];
                     if x(end) > 7  && max(y)-min(y) > 150 && length(find(outlier==0)) >= .66*length(y)
                         if window.baseline(j) < .75* max(y)
                             rr = y;
                             window.baseline(j) = prctile(y,95);
                             y = window.baseline(j)-y;
                             else
                             rr = y;
                             y = window.baseline(j) - y;
                         end
                    tau  = accel_parameter.tau{k}(i);
                    [estimated_sample] = fit_cocaine(x',y',tau,taud);
                    [fitresult, gof] = fit_monowar(x, y./y(1));
                    estimated_sample_act = y(1)*exp(-1*(1/tau)*x);
                    theta = sum((window.baseline(j)-estimated_sample').^2)/sum((window.baseline(j)-estimated_sample_act).^2);
                      [e1,taud_est,e] = get_taud(x,y,tau);
                      [P,f]=HeartRateLomb(rr,1:length(rr));
  
%                           figure1  = figure;
%                        h =  plot(x,window.baseline(j)-y,x,window.baseline(j)-estimated_sample,x,window.baseline(j)-estimated_sample_act,'LineWidth',2);
%                        legend( h, 'Original Cocaine Recovery Signal','Cocaine Recovery Fit','Activity Recovery Fit','Location', 'NorthEast' );
%                             saveas(gcf,['C:\Users\aungkon\Desktop\jhu\code\code_final\NIDA\derived_figure_files\cocaine\' num2str(pic) '.jpg'])
%                         pause(1);
%                         close(figure1)
                                    theta_label(win) = 0;
                                    if window.label(j) >= 10
                                            theta_label(win) = 1;
                                    end
                                    subject_array = [subject_array,10*k+i];
                                                                
                                    
                                    feature(win,1) = median(diff(rr)); %median of difference
                                    feature(win,2) = theta; %theta
                                    feature(win,3) = x(end); %duration
                                    feature(win,4) = taud_est ; %taud est
                                    feature(win,5) = fitresult.a; %taur
                                    feature(win,6) = sum((window.baseline(j)-estimated_sample').^2); %nuumerator
                                    feature(win,7) = sum((window.baseline(j)-estimated_sample_act).^2); %denominator
                                    feature(win,8) = double(var(rr)); % variance
                                    feature(win,9) = double(HeartRateLFHF(P,f));
                                    feature(win,10) = double(HeartRatePower34(P,f));
                                    feature(win,11) = double(HeartRatePower23(P,f));
                                    feature(win,12) = double(HeartRatePower12(P,f));
                                    feature(win,13) = double(0.5*(prctile(rr,75)-prctile(rr,0.25)));
                                    feature(win,14) = double(prctile(rr,80));
                                    feature(win,15) = double(prctile(rr,20));
                                    feature(win,16) = max(y)-min(y);
                                    feature(win,17) = window.activation.activity{j}(1);
                                    win = win + 1;
%                            figure1  = figure;
%                        h =  plot(x,window.baseline(j)-y,x,window.baseline(j)-estimated_sample,x,window.baseline(j)-estimated_sample_act,'LineWidth',2);
%                        legend( h, 'Original Activity Recovery Signal','Cocaine Recovery Fit','Activity Recovery Fit','Location', 'NorthEast' );
%                         saveas(gcf,['C:\Users\aungkon\Desktop\jhu\code\code_final\NIDA\derived_figure_files\activity\' num2str(pic1) '.jpg'])
%                         close(figure1)
%                         pic1 = pic1+1;
                     end  
                 end                
            end
        
        
    end
end
label = theta_label;
subject = subject_array;
save(['C:\Users\aungkon\Desktop\jhu\code\code_final_1\data_NIDA\feature1.mat'],'feature','label','subject');
