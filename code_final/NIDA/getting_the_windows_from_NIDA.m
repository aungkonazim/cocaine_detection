clc;
close all;
clear all;
study_name = {'NIDA'};
k = 1;
for k1=1:length(study_name)
        p = 46;       
        for i=1:p
            window = {};
            for j=1:100
                 if exist(['D:\Data\' char(study_name(k1)) '\40_merge\' 'p' num2str(i,'%02d') '_s' num2str(j,'%02d') '.mat' ], 'file')== 2
                   load (['D:\Data\' char(study_name(k1)) '\40_merge\' 'p' num2str(i,'%02d') '_s' num2str(j,'%02d') '.mat' ]);
                   for l=1:length(C.rr.window.p1_ind60)
                        window.activation.sample{k} = C.rr.avg60.sample(C.rr.window.p1_ind60(l):C.rr.window.v1_ind60(l));
                        window.activation.timestamp{k} = C.rr.avg60.timestamp(C.rr.window.p1_ind60(l):C.rr.window.v1_ind60(l));
                        index = intersect(find(C.acl.activity.timestamp >= window.activation.timestamp{k}(1)),find(C.acl.activity.timestamp <= window.activation.timestamp{k}(end)));
                        activity_labels = C.acl.activity.sample(index);
                        window.activation.activity{k} =  mode(activity_labels);
                        window.recovery.sample{k} = C.rr.avg60.sample(C.rr.window.v1_ind60(l):C.rr.window.p2_ind60(l));
                        window.recovery.timestamp{k} = C.rr.avg60.timestamp(C.rr.window.v1_ind60(l):C.rr.window.p2_ind60(l));
                        index = intersect(find(C.acl.activity.timestamp >= window.recovery.timestamp{k}(1)),find(C.acl.activity.timestamp <= window.recovery.timestamp{k}(end)));
                        activity_labels = C.acl.activity.sample(index);
                        window.recovery.activity{k} =  mode(activity_labels);
                        window.label(k) = C.rr.window.dose(l);
                        window.baseline(k) = prctile(C.rr.avg60.sample,95);
                        k=k+1;
                    end
                 end                
            end
            save(['C:\Users\aungkon\Desktop\jhu\code\code_final\NIDA\data\' 'p' num2str(i,'%02d') 'windowNIDA.mat'],'window');
            clear window;
            k=1;
        end
end