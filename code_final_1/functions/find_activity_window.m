function [ y_final,x_final ] = find_activity_window(x,y,c)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x_final =[];
y_final =[];
B = prctile(y,99);
y_temp = B - y;
y_temp = y_temp + max(y_temp);
x_temp = x - x(1) + 1;
y_temp = abs(log(y_temp./y_temp(1)));
ind = find(y_temp==max(y_temp));
if ~isempty(ind) && length(x(1:ind(1))) > 300
    x_final = x(1:ind(1));
    y_final = y(1:ind(1));
    x = x_final;
    y = y_final;
    [pks,locs] = findpeaks(max(y)-y);
    temp = 0;
    for i=1:length(locs)
        if abs(y(locs(i))-y(1)) < c
            if locs(i)>1
            temp = locs(i);
            break;
            end
        end
    end
if temp ~= 0
    y = y(1:end-1);
    x = x(1:end-1);
    y_temp = B - y;
    y_temp = y_temp + max(y_temp);
    x_temp = x - x(1) + 1;
    y_temp = abs(log(y_temp./y_temp(1)));
    ind = find(y_temp==max(y_temp));
    if ~isempty(ind)
        x_final = x(1:ind(1));
        y_final = y(1:ind(1));
    end
end
end
end
