clc; clear; close all;

% Mass, damper, damper, spring and spring parameters. Taken from Emil.
M = 0.3;
D1 = 3;
D2 = 6;
K1 = 400;
K2 = 100;
% M = 0.0007; D1 = 0.0073; D2 = 0.0298; K1 = 0.9720; K2 = 15.3955;


% Forces and position data
% data = load("data_set_of_random_min_jerk_traj.mat");
data = load("min_jerk_traj.mat");
nr = 3;

positions = getfield(data, "Pj"+num2str(nr));
forces = M*getfield(data, "Aj"+num2str(nr));

% Sampling time
Fs = 500;
stop_time = max(size(positions))/Fs;