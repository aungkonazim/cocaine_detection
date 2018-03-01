
index = find(real_ecg == min(real_ecg));
t = x(index(1):end);
y = 60000./real_ecg(index(1):end);
taur = 1/coeff.monowar{k}(i);
hr_peak = y(1);

% axis([0 2 -0.5 6])
% hold on
figure,
hold on
plot(t,60000./y,'ro')
title('Data points');
F = @(x,xdata) hr_peak*exp(-taur*xdata) - (taur*x(1)/(x(1)-taur))*exp(-taur*xdata) + (taur*x(1)/(x(1)-taur))*exp(-x(1)*xdata/100);
x0 = [100];
% [x,resnorm,~,exitflag,output] = lsqcurvefit(F,x0,t,y);
% plot(t,F(x,t),'^')


Fsumsquares = @(z)sum((F(z,t) - y).^2);
opts = optimoptions('fminunc','Algorithm','quasi-newton');
[xunc,ressquared,eflag,outputu] = fminunc(Fsumsquares,x0,opts);
plot(t,60000./F(xunc,t),'*')

hold off