clc;
close all;
clear all;
study_name = {'JHU','NIDAc'};
load('baseline.mat')
load('coeff.mat')
b=1;
for k=1:length(study_name)
    if length(char(study_name(k)))<=3
        p=3;
    else
        p=7;
    end
    
    for i=1:p
        taur_array=[];
        load(['C:\Users\aungkon\Desktop\jhu\data\activity\' char(study_name(k)) '\p' num2str(i,'%02d') 'activitywindows.mat']);
        load(['C:\Users\aungkon\Desktop\jhu\data\windows\' char(study_name(k)) '\p' num2str(i,'%02d') 'window' char(study_name(k)) '.mat']);
        window_timestamp = act_windows.baseline_timestamp;
        resampled_rr = act_windows.baseline_rr;
        yy=1;
        for j=1:length(window.label)
            if window.label(j)> 1 && window.activation.activity{j} == 0
            x=window.recovery.timestamp{j};
            y=window.recovery.sample{j};
            hr_rest = prctile(y,98);
            [int_x,int_y] = intersections(x,y,x,ones(1,length(x))*hr_rest,1);
            if ~isempty(int_x)
            maximum_index = find(x >= int_x(1));
           maximum_index = maximum_index(1);
           y = y(1:maximum_index);
           x = x(1:maximum_index);
           taur  = coeff.monowar{k}(i);
                x=(x-x(1))./60000;
                 taur_array(yy) = x(end);
                 yy=yy+1;
                y=60000./y;
                [F,taud] = get_taud(x,y,1/taur,b); 
    %             [fitresult, gof] = fit_monowar(x, y/y(1));

                figure2=figure;
                h=plot(x,60000./y,x,60000./(y(1)*exp(-1*(1/taur)*x)),'LineWidth',1)
                legend( h, 'Cocaine Recovery Window','Activity Recovery Fit with TauR','Location', 'NorthEast' );
                ylim([500,1000])
                title([num2str(x(end)) ' minutes'])
                xlabel minutes
                ylabel 'rr interval(ms)'
%                 set(gca,'color','m')
                fig=gcf;
                fig.InvertHardcopy = 'off';
                saveas(gca,['C:\Users\aungkon\Desktop\jhu\pics_activity_fit\' num2str(b) '.jpg']);
                pause(.5)
                close(figure2)
                b=b+1;
            else
                disp('not working');
            end
            end
            
        end
            coc_len{k}(i) = mean(taur_array);
    end
end
