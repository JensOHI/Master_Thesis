% This script is for generating different kinds of minimum jerk
% trajectories.
clc; clear; close all;

v0=[0,0,0];
vf=[0,0,0];
a0=[0,0,0];   
af=[0,0,0];

times = [{[0 5]},
         {[0 2]},
         {[0 4 8 12]},
         {[0 7 13]},
         ];
positions = [{[-0.25 0 0.25; 0.25 0 0.40]},
             {[-0.25 0 0.25; 0.25 0 0.40]},
             {[0 0 0; 2 0 0; 1 sqrt(3) 0; 0 0 0]},
             {[-0.4 0.1 0.5; -0.1 -0.35 0.2; 0.3 0.05 0.7]},
            ];

times_size = size(times);
positions_size = size(positions);

assert(times_size(1) == positions_size(1), "Times and Position sizes dont match")

for i=1:positions_size(1)
    [t,Cj,PPj,VVj,AAj,POSj,VELj,ACCj,Pj,Vj,Aj] = MinimumJerkGenerator(cell2mat(times(i)),cell2mat(positions(i)),v0,vf,a0,af, false);
    struct_save.("Pj"+num2str(i)) = Pj(:,1:end-1);
    struct_save.("Vj"+num2str(i)) = Vj(:,1:end-1);
    struct_save.("Aj"+num2str(i)) = Aj(:,1:end-1);
    save("min_jerk_traj.mat", "-struct", "struct_save")
end