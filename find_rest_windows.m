function [window_collection] = find_rest_windows(timestamp,sample)
x=timestamp;
y=sample;
minute=240;
i=minute+1;
n=1;
window_collection={};
index=[];
while i<=length(y)
    if isempty(find(y(i-minute:i),1))
        ind = find(y(i:end)==1);
        if ~isempty(ind)
            window_collection{n} =[x(i)*1000,x(i+ind(1)-2)*1000];
            index=[index,i:i+ind(1)-2];
            n=n+1;
            i=i+ind(1);
        end
        
    end
    i=i+1;
end


end

