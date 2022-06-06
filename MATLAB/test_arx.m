% data_length = 50;
% yfs = Pj_mj(1,1:data_length)';
% for i=data_length:5:500-5
%     test_data = iddata(yfs, forces_mj(1,1:i)', 1/500);
%     test_sys = arx(test_data, [2 1 1]);
%     future_inputs = forces_mj(1,i:i+5-1)';
%     future_prediction_length = max(size(future_inputs));
%     yf = forecast(test_sys, test_data, future_prediction_length, future_inputs);
%     yfs = [yfs;yf.y];
% end
% figure(1)
% hold on
% plot(yfs)
% plot(Pj_mj(1,:))
% legend("Prediction", "Ground truth")
clc; clear; close all;
% data = load("min_jerk_traj.mat");
% Pj_mj = data.Pj1;
% forces_mj = 5*data.Aj1;
nr = 1;
data = readtable("../record_trajectory/physical_traj_"+num2str(nr)+".csv");
Pj_mj = [data.pos_x'; data.pos_y'; data.pos_z'];
forces_mj = [data.f_x'; data.f_y'; data.f_z'];
data_length = 20;
prediction_length = 20;
for axis=1:3
    test_data = iddata(Pj_mj(axis, 1:data_length)', forces_mj(axis, 1:data_length)', 1/500);
    yf_sds = zeros(data_length,1);
    for i=data_length:prediction_length:max(size(Pj_mj))-prediction_length
        
        
        test_sys = arx(test_data, [5 1 1]);
        future_inputs = forces_mj(axis,i:i+prediction_length)';
        future_prediction_length = max(size(future_inputs));
        [yf,x0,sysf,yf_sd,x,x_sd] = forecast(test_sys, test_data, future_prediction_length, future_inputs);
        test_data = iddata([test_data.y; yf.y], [test_data.u; forces_mj(axis, i:i+prediction_length)'], 1/500);
        yf_sds = [yf_sds;yf_sd];
    end
    yf = test_data;
    yf_sd = yf_sds;
    UpperBound = iddata(yf.OutputData+3*yf_sd,[],yf.Ts,'Tstart',yf.Tstart);
    LowerBound = iddata(yf.OutputData-3*yf_sd,[],yf.Ts,'Tstart',yf.Tstart);
    prediction = iddata(yf.OutputData, [], yf.Ts, 'Tstart', yf.Tstart);
    ground_truth = iddata(Pj_mj(axis,1:end-1)', [], 1/500, 'Tstart', 0);
    
    subplot(3,3,axis)
    plot(ground_truth, prediction, UpperBound, "k--", LowerBound, "k--")
    legend({'Ground truth','Forecasted','Upper Bound - 3 sd', 'Lower Bound - 3 sd'},'Location','best')
    subplot(3,3,axis+3)
    plot(ground_truth.y - prediction.y(1:max(size(ground_truth.y))))
    legend({'Tracking Error'},'Location','best')
    subplot(3,3,axis+6)
    plot(forces_mj(axis,1:end))
    legend({"Force"}, "Location", "best")

end