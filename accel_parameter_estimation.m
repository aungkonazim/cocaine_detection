clc;
close all;
clear all;
 load('baseline.mat')
study_name = {'JHU','NIDAc'};
for k=1:length(study_name)
    if length(char(study_name(k)))<=3
        p=3;
    else
        p=7;
    end
    for i=1:p
        act_windows={};
        count= 1;
        n=1;
        n0=1;
        baseline_rr = [];
        baseline_timestamp = [];
        mkdir(['C:\Users\aungkon\Desktop\jhu\pics_model_fit\' char(study_name(k)) '\' num2str(i)]);
         for j=1:22
             if exist(['C:\Users\aungkon\Desktop\jhu\' char(study_name(k)) '\40_merge\' 'p' num2str(i,'%02d') '_s' num2str(j,'%02d') '.mat' ], 'file')== 2
               load (['C:\Users\aungkon\Desktop\jhu\' char(study_name(k)) '\40_merge\' 'p' num2str(i,'%02d') '_s' num2str(j,'%02d') '.mat' ]);
               window_collection = find_rest_windows(C.acl.activity.timestamp/(1000),C.acl.activity.sample);
               x=C.rr.avg60.timestamp;
               y=C.rr.avg60.sample;
               window_timestamp = [];
               window_sample =[];
               for m=1:length(window_collection)
                   start_t = window_collection{m}(1);
                   end_t = window_collection{m}(2);
                   cocaine_present = 0;
                   for o=1:length(C.rr.window.dose)
                       if C.rr.window.dose(o)>=10
                           time = C.rr.avg60.timestamp(C.rr.window.v1_ind60(o):C.rr.window.p2_ind60(o));
                           if ~isempty(length(find(time==start_t))) || ~isempty(length(find(time==start_t)))
                               
                               cocaine_present = 1;
                               break;
                           end
                       end
                   end
                   if cocaine_present == 0
                       index = find(x<=end_t & x>=start_t);
                       if ~isempty(index)
                           window_timestamp = [window_timestamp, x(index)];
%                            window_sample = [window_sample, median(y(index))*ones(1,length(index))];
                         window_sample = [window_sample, y(index)];
                       end
                   end
               end
               resampled_rr=[];
               if ~isempty(window_sample)
                   resampled_rr = interp1(window_timestamp,window_sample,x);
                   baseline_rr=[baseline_rr,resampled_rr];
                   baseline_timestamp = [baseline_timestamp,x];
%                    figure,plot(x,y,'*',x,resampled_rr,window_timestamp,window_sample,window_timestamp,outlier*max(window_sample));
%                    ylim([0,1000]);
               end
               
               window_collection = find_recovery_windows(C.acl.activity.timestamp/(1000),C.acl.activity.sample);
               x=C.rr.avg60.timestamp;
               y=C.rr.avg60.sample;
               for m=1:length(window_collection)
                   start_t = window_collection{m}(1);
                   end_t = window_collection{m}(2);
                   index = find(x<=end_t & x>=start_t);
                   window_timestamp = x(index);
                   window_sample = y(index);
                    if ~isempty(index)
%                    figure2=figure;
%                    eee3=(window_timestamp-window_timestamp(1))/60000;
%                     plot(eee3,window_sample,'r','LineWidth',1)
%                     title([num2str(eee3(end)) ' minutes'])
%                     xlabel minutes
%                     ylabel 'rr interval(ms)'
%                     set(gca,'color','y')
%                     fig=gcf;
%                     fig.InvertHardcopy = 'off';
%                     
%                             saveas(gca,['C:\Users\aungkon\Desktop\jhu\pics_test_3\' char(study_name(k)) '\' num2str(i) '\' num2str(n0) '.jpg']);
%                             n0=n0+1;
%                     close(figure2) 
                   
                    
                       if ~isempty(resampled_rr)
                           index = find(x<window_timestamp(1) & x >= window_timestamp(1)-240000);
                           hr_rest = .98*mean(resampled_rr(index));
                           disp('1')
                       else
                           hr_rest = 60000/H.baseline_hr_mean{k}(i);
                       end
                       [int_x,int_y] = intersections(window_timestamp,window_sample,window_timestamp,ones(1,length(window_timestamp))*hr_rest,1);
                       if ~isempty(int_x)
                       minimum_index = find(window_sample==min(window_sample));
                       minimum_index = minimum_index(1);
                       maximum_index = find(window_timestamp >= int_x(1));
                       maximum_index = maximum_index(1);
                       window_sample = window_sample(minimum_index:maximum_index);
                       window_timestamp = window_timestamp(minimum_index:maximum_index);
                       if ~isempty(window_sample) && ((window_timestamp(end)-window_timestamp(1))/60000) >= .5 
                            act_windows.timestamp{count} = window_timestamp;
                            act_windows.sample{count} = window_sample;
                            act_windows.rest_hr{count} = 60000/hr_rest;
                            rest_hr = 60000/hr_rest;
                            y1 = 60000*(window_sample.^-1);
                            y2 = y1/y1(1);
                            peak_hr = y1(1);
                            disp('2');
                            act_windows.peak_hr{count} = peak_hr; 
                            x1 = (window_timestamp-window_timestamp(1))/60000;
                            [fitresult1, gof1] = fit_monowar(x1, y2);
                            act_windows.monowar_tau{count} = 1/fitresult1.a;
                            act_windows.monowar_gof{count} = gof1; 
                            
                            y3 = (y1-rest_hr)/(peak_hr-rest_hr);
                            [fitresult2, gof2] = fit_monowar(x1, y3);
                            act_windows.hillol_tau{count} = 1/fitresult2.a;
                            act_windows.hillol_gof{count} = gof2;
                            figure2=figure('Name','untitled fit 1');
                            r56 = y1(1)*exp(-1*fitresult1.a*x1);
                            r56 = 60000*r56.^-1;
                            r57 = y2*y1(1);
                            r57 = 60000*r57.^-1;
                            r58 = ((peak_hr-rest_hr)*exp(-1*fitresult2.a*x1))+rest_hr;
                            r58 = 60000*r58.^-1;
                            h = plot(x1,r56,'r',x1,r57,'g',x1,r58,'LineWidth',1);
                            legend( h, 'Recovery Model I','Recovery Window','Recovery Model II', 'Location', 'NorthEast' );
                            title({['Length= ' num2str(x1(end)) ' minutes'],['Tau-I = ' num2str(1/fitresult1.a) ' minutes, Tau-II = ' num2str(1/fitresult2.a) ' minutes']});
                            xlabel minutes
                            ylabel 'rr interval(ms)'
                            grid on
                            fig = gcf;
                            fig.InvertHardcopy = 'off';
                          saveas(gca,['C:\Users\aungkon\Desktop\jhu\pics_model_fit\' char(study_name(k)) '\' num2str(i) '\' num2str(n) '.jpg']);
                            n=n+1;
                            pause(.1);
                            close(figure2);

                            count=count+1;
                      end
                   end
               end
             end
             end
         end
              act_windows.baseline_rr = baseline_rr;
              act_windows.baseline_timestamp = baseline_timestamp;
              save(['C:\Users\aungkon\Desktop\jhu\data\activity\' char(study_name(k)) '\p' num2str(i,'%02d') 'activitywindows.mat'],'act_windows');
   
    end
end
