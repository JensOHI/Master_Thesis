clc; clear; close all;

data = readtable("test.csv");

figure('WindowState', 'maximized')
subplot(3,3,1)
plot(data.pos_x)
title("Position - x-axis");
subplot(3,3,4)
plot(data.pos_y)
title("Position - y-axis");
subplot(3,3,7)
plot(data.pos_z)
title("Position - z-axis");
subplot(3,3,2)
plot(data.f_x)
title("Force - x-axis");
subplot(3,3,5)
plot(data.f_y)
title("Force - y-axis");
subplot(3,3,8)
plot(data.f_z)
title("Force - z-axis");
subplot(3,3,3)
plot(data.ori_x)
title("Orientation - x-axis");
subplot(3,3,6)
plot(data.ori_y)
title("Orientation - y-axis");
subplot(3,3,9)
plot(data.ori_z)
title("Orientation - z-axis");

figure('WindowState', 'maximized')
subplot(3,2,1)
plot(data.q_base)
title("Joint - Base")
subplot(3,2,2)
plot(data.q_shoulder)
title("Joint - Shoulder")
subplot(3,2,3)
plot(data.q_elbow)
title("Joint - Elbow")
subplot(3,2,4)
plot(data.q_wrist1)
title("Joint - Wrist 1")
subplot(3,2,5)
plot(data.q_wrist2)
title("Joint - Wrist 2")
subplot(3,2,6)
plot(data.q_wrist3)
title("Joint - Wrist 3")