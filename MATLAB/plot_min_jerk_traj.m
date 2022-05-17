clc; clear; close all;

data = load("data_set_of_random_min_jerk_traj.mat");

% nr = "4";
nr = randi([1 100]);
pos_name = "Pj"+num2str(nr);
vel_name = "Vj"+num2str(nr);
acc_name = "Aj"+num2str(nr);
t_name = "t"+num2str(nr);
pos = getfield(data, pos_name);
vel = getfield(data, vel_name);
acc = getfield(data, acc_name);
t = getfield(data, t_name);

axis_title = ["x-axis", "y-axis", "z-axis"];
margin = 0.1;
% Position
figure('WindowState', 'maximized')
hold on;
for i=1:3
subplot(3,1,i)
plot(t, pos(i,:))
title("Position - " + axis_title(i))
ylabel("Position [m]")
xlabel("Time [s]")
ylim([min(pos(i,:))-margin, max(pos(i,:))+margin])
% set(gca,'FontSize',30)
end
hold off;
% saveFigureAsPDF(gcf, '../figures/min_jerk_pos_'+nr);


% Velocity
% figure('WindowState', 'maximized')
% hold on;
% for i=1:3
% subplot(3,1,i)
% plot(t, vel(i,:))
% title("Velocity - " + axis_title(i))
% ylabel("Velocity [m/s]")
% xlabel("Time [s]")
% ylim([min(vel(i,:))-margin, max(vel(i,:))+margin])
% set(gca,'FontSize',30)
% end
% hold off;
% saveFigureAsPDF(gcf, '../figures/min_jerk_vel_'+nr);

% Acceleration
figure('WindowState', 'maximized')
hold on;
for i=1:3
subplot(3,1,i)
plot(t, acc(i,:))
title("Acceleration - " + axis_title(i))
ylabel("Acceleration [m/s^2]")
xlabel("Time [s]")
ylim([min(acc(i,:))-margin, max(acc(i,:))+margin])
% set(gca,'FontSize',30)
end
hold off;
% saveFigureAsPDF(gcf, '../figures/min_jerk_acc_'+nr);

% close all;

function saveFigureAsPDF(fig, path)
set(fig, 'PaperPosition', [-3.25 0 40 20])
set(fig, 'PaperSize', [33.4 20]);
saveas(fig, path, 'pdf')
end
