function fitPlot(dates, YMatrix1, res1)
figure1 = gcf;


axes1 = axes('Parent',figure1,...
    'Position',[0.13 0.583837209302326 0.775 0.341162790697674]);
box(axes1,'on');
hold(axes1,'all');


plot1 = plot(dates, YMatrix1,'Parent',axes1);
set(plot1(1),'DisplayName','Actual');
set(plot1(2),'LineStyle','-','Color',[1 0 0],'DisplayName','Model');


title('Data & Model Prediction');

subplot1 = subplot(2,1,2,'Parent',figure1,'YGrid','on');
box(subplot1,'on');
hold(subplot1,'all');
title('Residuals');


plot(dates, res1,'Parent',subplot1,'DisplayName','res');

legend(axes1,'show');

linkaxes([axes1 subplot1], 'x');
dynamicDateTicks([axes1 subplot1], 'linked');