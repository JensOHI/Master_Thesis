clc; clear; close all;
rng(5)

Fs = 500;
Ts = 1/Fs;

axis_names = ["x", "y", "z"];
font_size = 20;
% data = load("min_jerk_traj.mat");
nr = '2';
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
%     force_original = 5 * acc(axis,:);
    force_original = f(axis,:);
    velocity_original = vel(axis,:);
    position_original = pos(axis,:);
    t_original = t;

    a = 0; b1=1; b2=5; b3=800;
    x0 = [a + (b1-a).*rand(1), a + (b2-a).*rand(1), a + (b3-a).*rand(1)];

    
    xhats = [];
%     start_step = 500;
    start_step = 100;
    prev_i = 1;
    expected_force = zeros(1,max(size(t_original)));
    if not(all(position_original == zeros(1,max(size(position_original)))))
        for i=start_step:start_step:max(size(position_original))
            force = force_original(1:i);
            position = position_original(1:i);
            xhat = estimate_parameters(force, position, x0, Fs);
            msd_response_tmp = msd_system(position, velocity_original(1:i), xhat(3), xhat(2));
            expected_force(prev_i:i) = msd_response_tmp(prev_i:i);
            x0 = xhat;
            xhats = [xhats;xhat];
            prev_i = i;
        end
    end

    if axis==1
        fig1 = figure('WindowState', 'maximized');
    end
    set(0,'CurrentFigure',fig1);
    subplot(3,1,axis)
    hold on;
    plot(t_original, force_original);
    plot(t_original, expected_force);
    index_list = max(size(t_original))/size(xhats,1):max(size(t_original))/size(xhats,1):max(size(t_original));
    for split=1:size(xhats,1)
        xline(t_original(round(index_list(split))), ':', {"m="+num2str(xhats(split,1)),"b="+num2str(xhats(split,2)), "k="+num2str(xhats(split,3))})
    end
    legend(["Original", "Expected"], "Location", "best"); title(axis_names(axis)+"-axis"); ylabel("Force [N]"); xlabel("Time [s]")
    set(gca,'FontSize',font_size)
    hold off;
    if axis==3
%         saveFigureAsPDF(gcf, "../figures/estimate_impedance_partly_min_jerk_traj_"+nr+"_expected_force")
        saveFigureAsPDF(gcf, "../figures/estimate_impedance_partly_physical_traj_"+nr+"_expected_force")
    end
    
    xhats_tmp = xhats;
    if isempty(xhats)
        xhats_tmp = zeros(max(size(position_original))/start_step,3);
    end

    if axis==1
        fig2 = figure('WindowState', 'maximized');
    end
    set(0,'CurrentFigure',fig2);

    subplot(3,1,1)
    hold on;
    plot(xhats_tmp(:,1), '.', "MarkerSize", 25)
    legend(["x-axis", "y-axis", "z-axis"],"Location","best")
    xlabel("Estimations")
    ylabel("Mass Estimation")
    xlim([0 max(size(xhats_tmp))+0.2])
    max_y_value = max(xhats_tmp(:,1));
    ylim([-max_y_value-1e-4 max_y_value+1e-4])
    title("Estimation of the mass for each "+num2str(start_step)+" samples")
    set(gca,'FontSize',font_size)
    set(gca, 'XTick', 0:max(size(xhats_tmp)))
    hold off;

    subplot(3,1,2)
    hold on;
    plot(xhats_tmp(:,2), '.', "MarkerSize", 25)
    legend(["x-axis", "y-axis", "z-axis"],"Location","best")
    xlabel("Estimations")
    ylabel("Damping Estimation")
    xlim([0 max(size(xhats_tmp))+0.2])
    max_y_value = max(xhats_tmp(:,2));
    ylim([-max_y_value-1e-4 max_y_value+1e-4])
    title("Estimation of the damping for each "+num2str(start_step)+" samples")
    set(gca,'FontSize',font_size)
    set(gca, 'XTick', 0:max(size(xhats_tmp)))
    hold off;

    subplot(3,1,3)
    hold on;
    plot(xhats_tmp(:,3), '.', "MarkerSize", 25)
    legend(["x-axis", "y-axis", "z-axis"],"Location","best")
    xlabel("Estimations")
    ylabel("Spring Estimation")
    xlim([0 max(size(xhats_tmp))+0.2])
    max_y_value = max(xhats_tmp(:,3));
    ylim([-max_y_value-1e-4 max_y_value+1e-4])
    title("Estimation of the spring for each "+num2str(start_step)+" samples")
    set(gca,'FontSize',font_size)
    set(gca, 'XTick', 0:max(size(xhats_tmp)))
    hold off;
    if axis==3
%         saveFigureAsPDF(gcf, "../figures/estimate_impedance_partly_min_jerk_traj_"+nr+"_parameters")
        saveFigureAsPDF(gcf, "../figures/estimate_impedance_partly_physical_traj_"+nr+"_parameters")
    end
end
close all;