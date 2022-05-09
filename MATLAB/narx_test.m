clc; clear; close all;

data = load("min_jerk_traj.mat");
mass = 5;
forces = {mass*data.Aj1,mass*data.Aj2,mass*data.Aj3,mass*data.Aj4}';
u_mul = catsamples(con2seq(forces{1}(1,:)), con2seq(forces{1}(2,:)), con2seq(forces{1}(3,:)), con2seq(forces{2}(1,:)), con2seq(forces{2}(2,:)), con2seq(forces{2}(3,:)), con2seq(forces{3}(1,:)), con2seq(forces{2}(2,:)), con2seq(forces{3}(3,:)), con2seq(forces{4}(1,:)), con2seq(forces{4}(2,:)), con2seq(forces{4}(3,:)),'pad');
y_mul = catsamples(con2seq(data.Pj1(1,:)), con2seq(data.Pj1(2,:)), con2seq(data.Pj1(3,:)), con2seq(data.Pj2(1,:)), con2seq(data.Pj2(2,:)), con2seq(data.Pj2(3,:)), con2seq(data.Pj3(1,:)), con2seq(data.Pj3(2,:)), con2seq(data.Pj3(3,:)), con2seq(data.Pj4(1,:)), con2seq(data.Pj4(2,:)), con2seq(data.Pj4(3,:)), 'pad');
% axis = 1;
% u = con2seq(force);
% y = con2seq(position);
% training_length = max(size(position));
% u_train = u(1:training_length);
% y_train = y(1:training_length);

% u_predict = u(training_length+1:end);
% u_predict_range = [1, max(size(data.Aj1))];%[max(size(data.Aj1))+max(size(data.Aj2)), max(size(data.Aj1))+max(size(data.Aj2))+max(size(data.Aj3))]
% u_predict = u(u_predict_range(1):u_predict_range(2));

narx_net_open = narxnet(1:2,1:2,10);
% narx_net_open.divideFcn = '';
% narx_net_open.trainParam.min_grad = 1e-10;
% narx_net_open.trainFcn = 'trainscg';

[Xs,Xi,Ai,Ts] = preparets(narx_net_open,u_mul,{},y_mul);

narx_net_open = train(narx_net_open,Xs,Ts,Xi,Ai);
% view(narx_net_open)
%% 
% [Y,Xf,Af] = narx_net_open(Xs,Xi,Ai);
% perf = perform(narx_net_open,Ts,Y);
narx_net_closed= closeloop(narx_net_open);

% [xc,xic,aic,tc] = preparets(narx_net_closed,forces{1},{},con2seq(data.Pj1));
% y_predictions = narx_net_closed(xc, xic, aic);
y_predictions = narx_net_closed(con2seq(forces{1}(1,:)));
y_predictions_mat = cell2mat(y_predictions);
y = iddata(y_predictions_mat', [], 1/500, "Tstart", 0);
% y1 = iddata(y_predictions_mat(1,:)', [], 1/500, "Tstart", 0);
% y2 = iddata(y_predictions_mat(2,:)', [], 1/500, "Tstart", 0);
% y3 = iddata(y_predictions_mat(3,:)', [], 1/500, "Tstart", 0);
gt = iddata(data.Pj1(1,:)', [], 1/500, "Tstart", 0);
% gt1 = iddata(data.Pj1(1,:)', [], 1/500, "Tstart", 0);
% gt2 = iddata(data.Pj1(2,:)', [], 1/500, "Tstart", 0);
% gt3 = iddata(data.Pj1(3,:)', [], 1/500, "Tstart", 0);
% plot(y1,y2,y3, gt1, gt2, gt3)
% legend(["Prediction - Axis 1","Prediction - Axis 2","Prediction - Axis 3","Ground truth - Axis 1","Ground truth - Axis 2","Ground truth - Axis 3"],"Location", "best")
plot(gt, y)


% y_train_mat = cell2mat(y_train)';
% y_predictions_mat = cell2mat(y_predictions)';
% y_train_iddata = iddata(y_train_mat,[], 1, "Tstart", 0);
% ground_truth_data = cell2mat(y);
% ground_truth = iddata(ground_truth_data(u_predict_range(1):u_predict_range(2))', [], 1, "Tstart", 0);
% y_predictions_iddata = iddata(y_predictions_mat, [], 1, "Tstart", 0);
% plot( ground_truth, y_predictions_iddata)
% legend({"Ground truth", "Prediction"}, "Location", "best")
% plot(cell2mat(y_predictions), '.')