function [F,taud] = get_taud(t,y,taur)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
hr_peak = y(1);
F = @(x,xdata) hr_peak*exp(-1*(1/taur)*xdata) - x(2)*exp(-1*(1/taur)*xdata) + x(2)*exp(-1*x(1)*xdata);
x0 = [1,1];
Fsumsquares = @(z)sum((F(z,t) - y).^2);
opts = optimoptions('fminunc','MaxFunEvals',5000,'MaxIterations',2000);
[xunc,ressquared,eflag,outputu] = fminunc(Fsumsquares,x0,opts);
figure2 = figure;
r34= hr_peak*exp(-1*(1/taur)*t);
h=plot(t,60000./F(xunc,t),t,60000./y,'LineWidth',1);
legend( h, 'Cocaine Recovery Fit','Cocaine Recovery Window','Location', 'NorthEast' );
title(['Length= ' num2str(t(end)) ' minutes']);
xlabel minutes
ylabel 'rr interval(ms)'
grid on
fig = gcf;
fig.InvertHardcopy = 'off';
taud = 1/xunc(1);
pause(.1)
close(figure2)
end

