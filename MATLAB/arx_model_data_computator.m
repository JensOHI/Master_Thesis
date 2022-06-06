clc; clear; close all;

predictions = [20, 50, 75, 100, 150];
folder = "arx_model_data/";
max_error = zeros(4,max(size(predictions)),3);
max_error_abs = zeros(4,max(size(predictions)),3);
end_error = zeros(4,max(size(predictions)),3);
mean_error = zeros(4,max(size(predictions)),3);
for traj_nr=1:4
    for prediction_index=1:max(size(predictions))
        prediction_length = predictions(prediction_index);
        path = folder+"arx_min_jerk_traj_"+traj_nr+"_prediction_length_"+prediction_length+"_error.mat";
        data = load(path);
        data = reshape(data.error.data,3,max(size(data.error.data)));
        
        for axis=1:3
            max_error(traj_nr, prediction_index, axis) = max(data(axis,:));
            [~,ii] = max(abs(data(axis,:)));
            max_error_abs(traj_nr, prediction_index, axis) = max(data(axis,ii));
            end_error(traj_nr, prediction_index, axis) = data(axis,end);
            mean_error(traj_nr, prediction_index, axis) = mean(data(axis,:));
        end
    end

end