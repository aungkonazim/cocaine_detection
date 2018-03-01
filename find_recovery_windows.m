function [window_collection] = find_recovery_windows(timestamp,sample)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
window_collection = {};
x=timestamp;
y=sample;
index = [];
n = 1;
minute= 60;
for i=2:length(y)
    if y(i)==0 && y(i-1)==1
        k=1;
        while k <= minute && i-k >=1 && i+k <= length(y) && y(i-k) == 1 && y(i+k)==0
            k=k+1;
        end
        if k == minute+1
            while i+k <= length(y) && y(i+k)==0 && k<=10*minute  
                k=k+1;
            end
            window_collection{n} = [x(i)*1000, x(i+k-1)*1000];
            n=n+1;
            index = [index, i:i+k-1];
        end
        i=i+k;
    end
        
end
% figure; hold on;
% plot(x,y,'g')
% plot(x(index),y(index)+1,'*r')

