function [st] = find_int(x,y,st)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
index = find(y==1);
x = x(index);
interval = [0,diff(x)];
for k=2:length(interval)
    if interval(k)>60000
        st =x(k-1);
        break;
    end
end
end

