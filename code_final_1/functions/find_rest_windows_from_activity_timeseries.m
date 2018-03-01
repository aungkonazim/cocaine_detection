function [ window_collection ] = find_rest_windows_from_activity_timeseries( timestamp,sample)
% finds the rest windows from a activity timeseries
%  timestamp is given in 1 hz
x=timestamp/1000; %convert to second 
y=sample;
minute=120; %at least consecutive 2 minutes of rest period before we say its rest heart rate 
i=minute+1; 
n=1;
window_collection={};
window_collection{n} =[x(1)*1000,x(10)*1000]; 
n=n+1;
while i<=length(y)
            if isempty(find(y(i-minute:i),1))
                    ind = find(y(i:end)==1);
                    if ~isempty(ind) && ind(1) > 60 % minimum length of rest windows = 1 minute
                        window_collection{n} =[x(i)*1000,x(i+ind(1)-2)*1000];
                        n=n+1;
                        i=i+ind(1);
                    end
            end
            i=i+1;
end
    window_collection{n} =[x(end-10)*1000,x(end)*1000]; 
end

