clc; clear; close all;
% Loading the open loop narx net and closing it.
load("narx_net_open_v1.mat");
narxnet_closed = closeloop(narx_net_open);

%% Loading test data
mass = 5;
test_data = load("min_jerk_traj.mat");
positions = {};
forces = {};
ts = {};
% for nr=1:4
%     positions{end+1} = getfield(test_data, "Pj"+nr);
%     forces{end+1} = mass*getfield(test_data, "Aj"+nr);
%     ts{end+1} = getfield(test_data, "t"+nr);
% end
%% Loading physical data
for nr=1:4
    data_mj = readtable("../record_trajectory/physical_traj_"+num2str(nr)+".csv");
    positions{end+1} = [data_mj.pos_x'; data_mj.pos_y'; data_mj.pos_z'];
    forces{end+1} = [data_mj.f_x'; data_mj.f_y'; data_mj.f_z'];
    t = 0:1/500:max(size(data_mj.pos_x))/500;
    t = t(1:max(size(data_mj.pos_x)));
    ts{end+1} = t;
end
%%
full_predictions = {};
predictions = {};
ground_truths = {};
errors = {};
for test_nr=1:max(size(positions))
    full_prediction = zeros(max(size(positions{test_nr})),3);
    prediction = zeros(max(size(positions{test_nr})),3);
    ground_truth = zeros(max(size(positions{test_nr})),3);
    error = zeros(max(size(positions{test_nr})),3);
    for axis=1:3
        start_step = 50;
        prev_i = 1;
        for i=start_step:start_step:max(size(positions{test_nr}))
            force = forces{test_nr}(axis, 1:i);
            ground_truth(1:i,axis) = positions{test_nr}(axis, 1:i);
            narx_prediction = narxnet_closed(con2seq(force));
            prediction(prev_i:i,axis) = cell2mat(narx_prediction(prev_i:i));
            prev_i = i;
        end
        full_prediction(:,axis) = cell2mat(narxnet_closed(con2seq(forces{test_nr}(axis, :))));
        error(:,axis) = ground_truth(:,axis) - prediction(:,axis);
    end
    full_predictions{end+1} = full_prediction;
    predictions{end+1} = prediction;
    ground_truths{end+1} = ground_truth;
    errors{end+1} = error;
end

%% Plots
for test_nr=1:max(size(predictions))
    fig = figure('WindowState', 'maximized')
    subplot(3,2,1)
    hold on;
    title("NARX Network Prediction on x-axis")
    plot(ts{test_nr}, predictions{test_nr}(:,1))
    plot(ts{test_nr}, ground_truths{test_nr}(:,1))
    legend(["Prediction", "Ground Truth"], "Location", "best");
    xlabel("Time [s]")
    ylabel("Position [m]")
%     set(gca,'FontSize',30)
    hold off;
    subplot(3,2,3)
    hold on;
    title("NARX Network Prediction on y-axis")
    plot(ts{test_nr}, predictions{test_nr}(:,2))
    plot(ts{test_nr}, ground_truths{test_nr}(:,2))
    legend(["Prediction", "Ground Truth"], "Location", "best");
    xlabel("Time [s]")
    ylabel("Position [m]")
%     set(gca,'FontSize',30)
    hold off;
    subplot(3,2,5)
    hold on;
    title("NARX Network Prediction on z-axis")
    plot(ts{test_nr}, predictions{test_nr}(:,3))
    plot(ts{test_nr}, ground_truths{test_nr}(:,3))
    legend(["Prediction", "Ground Truth"], "Location", "best");
    xlabel("Time [s]")
    ylabel("Position [m]")
%     set(gca,'FontSize',30)
    hold off;

    % Error
    subplot(3,2,2)
    hold on;
    title("NARX Network Prediction Error on x-axis")
    plot(ts{test_nr}, errors{test_nr}(:,1))
    legend("Error", "Location", "best");
    xlabel("Time [s]")
    ylabel("Error [m]")
%     set(gca,'FontSize',30)
    hold off;
    subplot(3,2,4)
    hold on;
    title("NARX Network Prediction Error on y-axis")
    plot(ts{test_nr}, errors{test_nr}(:,2))
    legend("Error", "Location", "best");
    xlabel("Time [s]")
    ylabel("Error [m]")
%     set(gca,'FontSize',30)
    hold off;
    subplot(3,2,6)
    hold on;
    title("NARX Network Prediction Error on z-axis")
    plot(ts{test_nr}, errors{test_nr}(:,3))
    legend("Error", "Location", "best");
    xlabel("Time [s]")
    ylabel("Error [m]")
%     set(gca,'FontSize',30)
    hold off;
    
%     saveFigureAsPDF(fig, "../figures/narx_network_traj_"+num2str(test_nr)+"_prediction_length_"+num2str(start_step))
    saveFigureAsPDF(fig, "../figures/narx_network_physical_traj_"+num2str(test_nr)+"_prediction_length_"+num2str(start_step))
end
close all;
function saveFigureAsPDF(fig, path)
set(fig, 'PaperPosition', [-3.25 0 40 20])
set(fig, 'PaperSize', [33.4 20]);
saveas(fig, path, 'pdf')
end