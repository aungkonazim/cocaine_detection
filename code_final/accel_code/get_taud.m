function [estimated_sample,taud,mse] = get_taud(t,y,tau)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final\accel_code');
F = @(x,xdata) y(1)*exp(-1*(1/tau)*xdata) - x(2)*exp(-1*(1/tau)*xdata) + x(2)*exp(-1*x(1)*xdata);
x0 = [(.0282),(1/tau-.0282)]
Fsumsquares = @(z)sum((F(z,t) - y).^2)+sum(z);
opts = optimoptions('fminunc','MaxFunEvals',600,'MaxIterations',2000);
[xunc,ressquared,eflag,outputu] = fminunc(Fsumsquares,x0,opts);
%  figure2 = figure;
mse = calNMSE(y,F(xunc,t));
%  h=plot(t,F(xunc,t),t,y,'LineWidth',1);
%  legend( h, 'Cocaine Recovery Fit','Cocaine Recovery Window','Location', 'NorthEast' );
% title(['Length= ' num2str(t(end)) ' minutes']);
% xlabel minutes
%  ylabel 'rr interval(ms)'
%  ylim([y(end) y(1)]);
%  grid on
%  fig = gcf;
% fig.InvertHardcopy = 'off';
taud = 1/xunc(1);
%  pause(1)
%  close(figure2)
estimated_sample = F(xunc,t);
end

