clc; clear; close all;

func =@(x) 10^x;

xvalues = linspace(0,5,10000);
data = []
for i=1:max(size(xvalues))
    data = [data; func(xvalues(i))];
end



figure('WindowState', 'maximized')
hold on;
plot(xvalues, data, 'LineWidth',10)
title("Reachability Concept")
ylabel("Stiffness")
xlabel("Distance to end of reachability")
xticks([0 5])
xticklabels({"r_{d,max}", "r_{d,min}"})
yticks([0 max(data)])
yticklabels({"s_{d,min}", "s_{d,max}"})
legend("Reachability Distance", "Location", "best")
% ylim([1 max(data)])
set(gca,'FontSize',25)
saveFigureAsPDF(gcf, '../figures/reachability_concept'); close all;