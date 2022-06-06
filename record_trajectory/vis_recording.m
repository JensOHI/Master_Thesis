clc; clear; close all;
nr = "1";
data = readtable("physical_traj_"+nr+".csv");
t = 0:1/500:max(size(data.pos_x))/500;
t = t(1:max(size(data.pos_x)));

figure('WindowState', 'maximized')
subplot(3,2,1)
plot(t, data.pos_x)
title("Position - x-axis");
xlabel("Time [s]")
ylabel("Position [m]")
subplot(3,2,3)
plot(t, data.pos_y)
title("Position - y-axis");
xlabel("Time [s]")
ylabel("Position [m]")
subplot(3,2,5)
plot(t, data.pos_z)
title("Position - z-axis");
xlabel("Time [s]")
ylabel("Position [m]")
subplot(3,2,2)
plot(t, data.f_x)
title("Force - x-axis");
xlabel("Time [s]")
ylabel("Force [N]")
subplot(3,2,4)
plot(t, data.f_y)
title("Force - y-axis");
xlabel("Time [s]")
ylabel("Force [N]")
subplot(3,2,6)
plot(t, data.f_z)
title("Force - z-axis");
xlabel("Time [s]")
ylabel("Force [N]")

% set(findobj(gcf,'type','axes'), "FontSize", 30)
% sgtitle("Physical Trajectory "+nr, "FontSize", 50)
% saveFigureAsPDF(gcf, "../figures/physical_trajectory_"+nr)
% close all;
% subplot(3,3,3)
% plot(data.ori_x)
% title("Orientation - x-axis");
% subplot(3,3,6)
% plot(data.ori_y)
% title("Orientation - y-axis");
% subplot(3,3,9)
% plot(data.ori_z)
% title("Orientation - z-axis");
% 
% figure('WindowState', 'maximized')
% subplot(3,2,1)
% plot(data.q_base)
% title("Joint - Base")
% subplot(3,2,2)
% plot(data.q_shoulder)
% title("Joint - Shoulder")
% subplot(3,2,3)
% plot(data.q_elbow)
% title("Joint - Elbow")
% subplot(3,2,4)
% plot(data.q_wrist1)
% title("Joint - Wrist 1")
% subplot(3,2,5)
% plot(data.q_wrist2)
% title("Joint - Wrist 2")
% subplot(3,2,6)
% plot(data.q_wrist3)
% title("Joint - Wrist 3")


function saveFigureAsPDF(fig, path)
set(fig, 'PaperPosition', [-3.25 0 40 20])
set(fig, 'PaperSize', [33.4 20]);
saveas(fig, path, 'pdf')
end