clc;
close all;
clear all;
study_name = {'NIDA'};
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final_1\functions\')
activity_windows = {};
m = 1;
for k=1:length(study_name)
       p =46; 
       for i=1:p
           window = {};
           for j=1:50
              if exist(['E:\Data\' char(study_name(k)) '\40_merge\' 'p' num2str(i,'%02d') '_s' num2str(j,'%02d') '.mat' ], 'file')== 2
                   if exist(['E:\Data\' char(study_name(k)) '\rip_peak_valley\' 'p' num2str(i,'%02d') '_s' num2str(j,'%02d') '_pv.mat' ], 'file')== 2                     
                       load (['E:\Data\' char(study_name(k)) '\rip_peak_valley\' 'p' num2str(i,'%02d') '_s' num2str(j,'%02d') '_pv.mat' ]);
                       load (['E:\Data\' char(study_name(k)) '\40_merge\' 'p' num2str(i,'%02d') '_s' num2str(j,'%02d') '.mat' ]);
                       for l=1:length(C.rr.window.p1_ind60)
                            window.activation.sample{m} = C.rr.avg60.sample(C.rr.window.p1_ind60(l):C.rr.window.v1_ind60(l));
                        window.activation.timestamp{m} = C.rr.avg60.timestamp(C.rr.window.p1_ind60(l):C.rr.window.v1_ind60(l));
                        index = intersect(find(C.acl.activity.timestamp >= window.activation.timestamp{m}(1)),find(C.acl.activity.timestamp <= window.activation.timestamp{m}(end)));
                        activity_labels = C.acl.activity.sample(index);
                        window.activation.activity{m} =  mode(activity_labels);
                        window.recovery.sample{m} = C.rr.avg60.sample(C.rr.window.v1_ind60(l):C.rr.window.p2_ind60(l));
                        window.recovery.timestamp{m} = C.rr.avg60.timestamp(C.rr.window.v1_ind60(l):C.rr.window.p2_ind60(l));
                        index = intersect(find(C.acl.activity.timestamp >= window.recovery.timestamp{m}(1)),find(C.acl.activity.timestamp <= window.recovery.timestamp{m}(end)));
                        activity_labels = C.acl.activity.sample(index);
                        window.recovery.activity{m} =  mode(activity_labels);
                        window.label(m) = C.rr.window.dose(l);
                        window.baseline(m) = prctile(C.rr.avg60.sample,95);
                        window.activity.sample{m} = C.acl.activity.sample(find(C.acl.activity.timestamp>=window.activation.timestamp{m}(1) & ...
                                                                                                        C.acl.activity.timestamp<=window.recovery.timestamp{m}(end))) ;
                        
                        window.activity.timestamp{m} = C.acl.activity.timestamp(find(C.acl.activity.timestamp>=window.activation.timestamp{m}(1) & ...
                                                                                                        C.acl.activity.timestamp<=window.recovery.timestamp{m}(end))) ;
                        
                        m=m+1;
                    end
                   end
              end
           end
           save(['C:\Users\aungkon\Desktop\jhu\code\code_final_1\data_NIDA\windows\' 'p' num2str(i,'%02d') 'windowNIDA.mat'],'window');
           clear window;
           m=1;
       end
end