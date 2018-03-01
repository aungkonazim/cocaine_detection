clc;
close all;
clear all;
load('C:\Users\aungkon\Desktop\jhu\JHU\40_merge\p01_s03.mat');
x=C.acl.activity.timestamp/1000;
y=C.acl.activity.sample;
minute=120;
i=minute+1;
index=[];
while i<=length(y)
    if isempty(find(y(i-minute:i),1))
        ind = find(y(i:end)==1);
        if ~isempty(ind)
            index=[index,i:i+ind(1)-2];
        end
        i=i+ind(1);
    end
    i=i+1;
end
figure,plot(x,y+1,x(index),y(index)+2,'*');
ylim([0,2])