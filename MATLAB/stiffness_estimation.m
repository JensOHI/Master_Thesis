clc; clear; close all;
rng(5)

Fs = 500;
Ts = 1/Fs;

data = load("min_jerk_traj.mat");

force_original = 5 * data.Aj4(1,:);
position_original = data.Pj4(1,:);

x0 = [0.3118;
    9.7407;
    9.8793;
  124.7035;
  124.7080];
xhats = [];
start_step = 100;
prev_i = 1;
for i=start_step:start_step:max(size(position_original))
    force = force_original(prev_i:i);
    position = position_original(prev_i:i);
    xhat = estimate_parmeters(force, position, x0, Fs)
    x0 = xhat;
    xhats = [xhats;xhat'];
    prev_i = i;
end
xhats
%%
figure(1)
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
figure(2)
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
