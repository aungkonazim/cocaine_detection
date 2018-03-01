function [estimated_sample] = fit_cocaine(t,y,tau,taud)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
addpath('C:\Users\aungkon\Desktop\jhu\code\code_final\accel_code');
F = @(x,xdata) y(1)*exp(-1*(1/tau)*xdata) - x(1)*exp(-1*(1/tau)*xdata) + x(1)*exp(-1*(1/taud)*xdata);
x0 = [(1/tau-1/taud)];
Fsumsquares = @(z)sum((F(z,t) - y).^2)+sum(z.^2);
opts = optimoptions('fminunc','MaxFunEvals',6000,'MaxIterations',20000);
[xunc,ressquared,eflag,outputu] = fminunc(Fsumsquares,x0,opts);
%  figure2 = figure;
%  h=plot(t,F(xunc,t),t,y,'LineWidth',1);
%  legend( h, 'Cocaine Recovery Fit','Cocaine Recovery Window','Location', 'NorthEast' );
% title(['Length= ' num2str(t(end)) ' minutes']);
% xlabel minutes
%  ylabel 'rr interval(ms)'
%  ylim([y(end) y(1)]);
%  grid on
%  fig = gcf;
% fig.InvertHardcopy = 'off';
%  pause(1)
%  close(figure2)
estimated_sample = F(xunc,t);
xunc;
end



