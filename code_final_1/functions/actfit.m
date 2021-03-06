function [fitresult, gof] = actfit(x_final, y_final)
%CREATEFIT1(X_FINAL,Y_FINAL)
%  Create a fit.
%
%  Data for 'untitled fit 1' fit:
%      X Input : x_final
%      Y Output: y_final
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 07-Jan-2018 16:23:43


%% Fit: 'untitled fit 1'.
[xData, yData] = prepareCurveData( x_final, y_final );

% Set up fittype and options.
ft = fittype( '-b*x', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = 1;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( fitresult, xData, yData );
% legend( h, 'y_final vs. x_final', 'untitled fit 1', 'Location', 'NorthEast' );
% % Label axes
% xlabel x_final
% ylabel y_final
% grid on


