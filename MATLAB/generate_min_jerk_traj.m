% This script is for generating different kinds of minimum jerk
% trajectories.
clc; clear; close all;

v0=[0,0,0];
vf=[0,0,0];
a0=[0,0,0];   
af=[0,0,0];
% 
% times = [{[0 5]},
%          {[0 2]},
%          {[0 4 8 12]},
%          {[0 7 13]},
%          ];
% positions = [{[-0.25 0 0.25; 0.25 0 0.40]},
%              {[-0.25 0 0.25; 0.25 0 0.40]},
%              {[0 0 0; 2 0 0; 1 sqrt(3) 0; 0 0 0]},
%              {[-0.4 0.1 0.5; -0.1 -0.35 0.2; 0.3 0.05 0.7]},
%             ];

positions = {};
times = {};
lower_bound = -0.5;
upper_bound = 0.5;
for i=1:500
    r = randi([2, 5]);

    % Generate waypoints
    points_axis = [];
    for axis=1:3
        points = [];
        for waypoints=1:r
            points = [points, (upper_bound-lower_bound).*rand(1,1) + lower_bound];
        end
        points_axis = [points_axis;points];
    end
    positions{end+1} = points_axis';

    % Generate time frame
    time = [0];
    for time_waypoints=2:r
        time = [time, randi([time(end)+1, time(end)+7])];
    end
    times{end+1} = time;
end



times_size = size(times);
positions_size = size(positions);

assert(times_size(1) == positions_size(1), "Times and Position sizes dont match")

for i=1:positions_size(2)
%     close all;
    i
    [t,Cj,PPj,VVj,AAj,POSj,VELj,ACCj,Pj,Vj,Aj] = MinimumJerkGenerator(cell2mat(times(i)),cell2mat(positions(i)),v0,vf,a0,af, false);
    struct_save.("Pj"+num2str(i)) = Pj(:,1:end-1);
    struct_save.("Vj"+num2str(i)) = Vj(:,1:end-1);
    struct_save.("Aj"+num2str(i)) = Aj(:,1:end-1);
    struct_save.("t"+num2str(i)) = t(:,1:end-1);
end
save("data_set_of_random_min_jerk_traj_500_v2.mat", "-struct", "struct_save")