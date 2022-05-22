clc; clear; close all;
rng(5)

Fs = 500;
Ts = 1/Fs;

data = load("min_jerk_traj.mat");

force_original = 3 * data.Aj1(1,:);
velocity_original = data.Vj1(1,:);
position_original = data.Pj1(1,:);
t_original = data.t1;

% x0 = [0.3118;
%     9.7407;
%     9.8793;
%   124.7035;
%   124.7080];
% x0 = [0.3; 3; 6; 400; 100];
x0 = [0.3, 3, 400];

xhats = [];
start_step = 500;
prev_i = 1;
% for i=start_step:start_step:max(size(position_original))
%     force = force_original(prev_i:i);
%     position = position_original(prev_i:i);
%     xhat = estimate_parameters(force, position, x0, Fs);
%     x0 = xhat;
%     xhats = [xhats;xhat'];
%     prev_i = i;
% end
xhat = estimate_parameters(force_original, position_original, x0, Fs)
xhats = xhat'

%% Validate for a mass-spring-damper system
expected_force = msd_system(position_original, velocity_original, xhats(3), xhats(2));
figure('WindowState', 'maximized')
hold on;
plot(t_original, force_original);
plot(t_original, expected_force);
legend(["Original", "Expected"], "Location", "best")
hold off;

%%
figure('WindowState', 'maximized')
subplot(211)
plot(position_original)
title("Position")
subplot(212)
plot(force_original)
title("Force")
M = iddata(xhats(:,1),[],1/500);
D1 = iddata(xhats(:,2),[],1/500);
D2 = iddata(xhats(:,3),[],1/500);
K1 = iddata(xhats(:,4),[],1/500);
K2 = iddata(xhats(:,5),[],1/500);
figure('WindowState', 'maximized')
subplot(321)
plot(M, 'k--')
title("Mass")
subplot(322)
plot(D1, 'k--')
title("D1")
subplot(323)
plot(D2, 'k--')
title("D2")
subplot(324)
plot(K1, 'k--')
title("K1")
subplot(325)
plot(K2, 'k--')
title("K2")
% legend(["M", "D1","D2","K1","K2"],"Location","best")
