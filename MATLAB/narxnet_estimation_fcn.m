function prediction = narxnet_estimation_fcn(forces, prediction_length)
narx_data = load("narx_net_open.mat");
narxnet_closed = closeloop(narx_data.narx_net_open);
prediction_tmp = cell2mat(narxnet_closed(con2seq(forces)));
prediction = prediction_tmp(end-prediction_length+1:end);
end