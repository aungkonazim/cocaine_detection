clc;
close all;
clear all;
pic = 1;
pic1 = 1;
study_name = {'NIDA'};
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final\accel_code');
load('C:\Users\aungkon\Desktop\jhu\code\code_final\NIDA\derived_mat_files\accel_coeffs_median_final.mat');
taud = 26.5938;
range_array = [];
theta_array = [];
theta_label = [];
duration_array =[];
subject_array =[];
taud_array = [];
taur_array = [];
f1_array = [];
f2_array = [];
var_array = [];
LFHF_array = [];
Power34_array = [];
Power23_array = [];
Power12_array =[];
mean_array = [];
median_array = [];
QD_array = [];
PR80_array = [];
PR20_array = [];
activity_array = [];
outlier_array = [];
diff_median_array = [];
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
                      if window.label(j) > 1 
                                    
%                           figure1  = figure;
%                        h =  plot(x,window.baseline(j)-y,x,window.baseline(j)-estimated_sample,x,window.baseline(j)-estimated_sample_act,'LineWidth',2);
%                        legend( h, 'Original Cocaine Recovery Signal','Cocaine Recovery Fit','Activity Recovery Fit','Location', 'NorthEast' );
%                         saveas(gcf,['C:\Users\aungkon\Desktop\jhu\code\code_final\NIDA\derived_figure_files\cocaine\' num2str(pic) '.jpg'])
%                         close(figure1)
%                         pic = pic+1;
%                                if ~isempty(window.decision{j})
                                    diff_median_array = [diff_median_array,median(diff(rr))];
                                   theta_array = [theta_array,theta]; 
                                    theta_label = [theta_label,1];
                                    duration_array = [duration_array,x(end)];
                                    taud_array = [taud_array,taud_est];
                                    subject_array = [subject_array,10*k+i];
                                    taur_array = [taur_array,fitresult.a];
                                    f1_array = [f1_array,sum((window.baseline(j)-estimated_sample').^2)];
                                    f2_array = [f2_array,sum((window.baseline(j)-estimated_sample_act).^2)];
                                    var_array = [var_array,double(var(rr))];
                                    LFHF_array = [LFHF_array,double(HeartRateLFHF(P,f))];
                                    Power34_array = [Power34_array,double(HeartRatePower34(P,f))];
                                    Power23_array = [Power23_array,double(HeartRatePower23(P,f))];
                                    Power12_array =[Power12_array,double(HeartRatePower12(P,f))];
                                    mean_array = [mean_array, double(mean(rr))];
                                    median_array = [median_array,double(median(rr))];
                                    QD_array = [QD_array,double(0.5*(prctile(rr,75)-prctile(rr,0.25)))];
                                    PR80_array = [PR80_array,double(prctile(rr,80))];
                                    PR20_array = [PR20_array,double(prctile(rr,20))];
                                    range_array = [range_array,max(y)-min(y)];
                                    activity_array = [activity_array,window.activation.activity{j}(1)];
%                                 end
                            
                      end
                      if window.label(j) == 0 
%                            figure1  = figure;
%                        h =  plot(x,window.baseline(j)-y,x,window.baseline(j)-estimated_sample,x,window.baseline(j)-estimated_sample_act,'LineWidth',2);
%                        legend( h, 'Original Activity Recovery Signal','Cocaine Recovery Fit','Activity Recovery Fit','Location', 'NorthEast' );
%                         saveas(gcf,['C:\Users\aungkon\Desktop\jhu\code\code_final\NIDA\derived_figure_files\activity\' num2str(pic1) '.jpg'])
%                         close(figure1)
%                         pic1 = pic1+1;
                            diff_median_array = [diff_median_array,median(diff(rr))];
                          range_array = [range_array,max(y)-min(y)];
                          theta_label = [theta_label,0];
                          theta_array = [theta_array,theta]; 
                          duration_array = [duration_array,x(end)];
                          taud_array = [taud_array,taud_est];
                          taur_array = [taur_array,fitresult.a];
                          subject_array = [subject_array,10*k+i];
                          f1_array = [f1_array,sum((window.baseline(j)-estimated_sample').^2)];
                          f2_array = [f2_array,sum((window.baseline(j)-estimated_sample_act).^2)];
                          var_array = [var_array,double(var(rr))];
                          LFHF_array = [LFHF_array,double(HeartRateLFHF(P,f))];
                          Power34_array = [Power34_array,double(HeartRatePower34(P,f))];
                           Power23_array = [Power23_array,double(HeartRatePower23(P,f))];
                           Power12_array =[Power12_array,double(HeartRatePower12(P,f))];
                           mean_array = [mean_array, double(mean(rr))];
                           median_array = [median_array,double(median(rr))];
                           QD_array = [QD_array,double(0.5*(prctile(rr,75)-prctile(rr,0.25)))];
                            PR80_array = [PR80_array,double(prctile(rr,80))];
                            PR20_array = [PR20_array,double(prctile(rr,20))];
                           activity_array = [activity_array,window.activation.activity{j}(1)];
                      end
                     
                     end  
                 end                
            end
        
        
    end
end
save('all_features_in_NIDA.mat','theta_array','theta_label','duration_array','subject_array','taud_array','taur_array','f1_array','f2_array','var_array','LFHF_array','Power34_array',...
 'Power23_array','diff_median_array','Power12_array','mean_array','median_array','QD_array','PR80_array','PR20_array','activity_array','range_array');

a = theta_array(find(theta_label == 0));
b = theta_array(find(theta_label == 1));
b(end:length(a)) = nan;
c = [a',b'];
figure,boxplot(c);
