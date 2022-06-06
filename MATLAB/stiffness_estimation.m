clc; clear; close all;
rng(5)

Fs = 500;
Ts = 1/Fs;

axis_names = ["x", "y", "z"];
font_size = 20;
% data = load("min_jerk_traj.mat");
nr = '4';
data = readtable("../record_trajectory/physical_traj_"+nr+".csv");
% pos = getfield(data, "Pj"+nr);
% vel = getfield(data, "Vj"+nr);
% acc = getfield(data, "Aj"+nr);
% t = getfield(data, "t"+nr);
pos = [data.pos_x'; data.pos_y'; data.pos_z'];
vel = [[0;0;0], diff(pos, 1, 2)];
f = [data.f_x'; data.f_y'; data.f_z'];
t = 0:1/500:max(size(data.pos_x))/500;
t = t(1:max(size(data.pos_x)));
for axis=1:3
% force_original = 5 * acc(axis,:);
force_original = f(axis,:);
velocity_original = vel(axis,:);
position_original = pos(axis,:);
t_original = t;


% x0 = [0.3118;
%     9.7407;
%     9.8793;
%   124.7035;
%   124.7080];
% x0 = [0.3; 3; 6; 400; 100];
a = 0; b1=1; b2=5; b3=800;
x0 = [a + (b1-a).*rand(1), a + (b2-a).*rand(1), a + (b3-a).*rand(1)];

xhats = [];
start_step = 500;
prev_i = 1;
expected_force = zeros(1,max(size(t_original)));
% for i=start_step:start_step:max(size(position_original))
%     force = force_original(prev_i:i);
%     position = position_original(prev_i:i);
%     xhat = estimate_parameters(force, position, x0, Fs);
%     expected_force(prev_i:i) = msd_system(position, velocity_original(prev_i:i), xhat(4), xhat(2));
%     x0 = xhat;
%     xhats = [xhats;xhat'];
% %     prev_i = i;
% end
if not(all(position_original == zeros(1,max(size(position_original)))))

xhat = estimate_parameters(force_original, position_original, x0, Fs)
xhats = xhat'

%% Validate for a mass-spring-damper system
expected_force = msd_system(position_original, velocity_original, xhats(3), xhats(2));
if axis==1
fig1 = figure('WindowState', 'maximized');
end
end
set(0,'CurrentFigure',fig1);
% subplot(3,1,1)
% hold on;
% plot(t_original, xhats(3)*position_original);
% legend("k*p", "Location", "best")
% hold off;
% subplot(3,1,2)
% hold on;
% plot(t_original, xhats(2)*velocity_original);
% legend("b*v", "Location", "best")
% hold off;
% subplot(3,1,3)
if isempty(xhats)
    m_tmp = "NaN"; b_tmp = "NaN"; k_tmp = "NaN";
else
    m_tmp = num2str(xhats(1)); b_tmp = num2str(xhats(2)); k_tmp = num2str(xhats(3));
end
subplot(3,1,axis)
hold on;
plot(t_original, force_original);
plot(t_original, expected_force);
legend(["Original", "Expected"], "Location", "best")
title(axis_names(axis)+"-axis - Mass="+m_tmp+", Damping="+b_tmp+", Spring="+k_tmp)
ylabel("Force [N]")
xlabel("Time [s]")
set(gca,'FontSize',font_size)
hold off;
if axis==3
%     saveFigureAsPDF(gcf, "../figures/estimate_impedance_min_jerk_traj_"+nr+"_expected_force")
    saveFigureAsPDF(gcf, "../figures/estimate_impedance_physical_traj_"+nr+"_expected_force")
end

%%
if axis==1
fig2 = figure('WindowState', 'maximized');
end
set(0,'CurrentFigure',fig2);
subplot(2,3,axis)
plot(t_original, position_original)
title(axis_names(axis)+"-axis - Position")
ylabel("Position [m]")
xlabel("Time [s]")
set(gca,'FontSize',font_size)
subplot(2,3,axis+3)
plot(t_original, force_original)
title(axis_names(axis)+"-axis - Force")
ylabel("Force [N]")
xlabel("Time [s]")
set(gca,'FontSize',font_size)
if axis==3
%     saveFigureAsPDF(gcf, "../figures/estimate_impedance_min_jerk_traj_"+nr+"_positons_and_forces")
    saveFigureAsPDF(gcf, "../figures/estimate_impedance_physical_traj_"+nr+"_positons_and_forces")
end
end
close all;
M = iddata(xhats(:,1),[],1/500);
D1 = iddata(xhats(:,2),[],1/500);
K1 = iddata(xhats(:,3),[],1/500);
figure('WindowState', 'maximized')
subplot(311)
plot(M, 'k--')
title("Mass")
subplot(312)
plot(D1, 'k--')
title("D1")
subplot(313)
plot(K1, 'k--')
title("K1")
% legend(["M", "D1","D2","K1","K2"],"Location","best")
