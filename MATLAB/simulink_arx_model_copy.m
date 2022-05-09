function [counter_out, predicted_position, prev_positions, prev_forces, prediction_forces] = arx_estimator(counter, force, prev_positions, prev_forces, prediction_forces, minimum_data_length_arx, prediction_length_arx, position_mj)
coder.extrinsic("arx")
coder.extrinsic("iddata")
coder.extrinsic("getfield")
coder.extrinsic("forecast")
coder.extrinsic("cell2mat")

if counter <= minimum_data_length_arx
    prev_positions(counter) = position_mj(1,counter);
    prev_forces(counter) = force;
end

if mod(counter, prediction_length_arx) == 0 && counter >= minimum_data_length_arx
    data_obj = iddata(prev_positions(1:counter), prev_forces(1:counter), 1/500);
    system = arx(data_obj, [4 1 1]);
    [yf,x0,sysf,yf_sd,x,x_sd] = forecast(system, data_obj, prediction_length_arx, prediction_forces);
    predictions = cell2mat(getfield(get(yf), "OutputData"));
    
    for i=1:prediction_length_arx
        prev_positions(counter+i) = predictions(i);
        prev_forces(counter+i) = prediction_forces(i);
    end
    prediction_forces(1:prediction_length_arx, 1) = zeros(prediction_length_arx, 1);
else
    prediction_forces(mod(counter, prediction_length_arx)+1) = force;
end
predicted_position = prev_positions(counter);


counter_out = counter + 1;
end