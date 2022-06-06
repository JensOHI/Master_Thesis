% Minimum Jerk
data_mj = load("min_jerk_traj.mat");
nr = "1";
position_mj = getfield(data_mj, "Pj"+nr);
mass_used_for_force = 1;
force_mj = mass_used_for_force * getfield(data_mj, "Aj"+nr);

% data_mj = readtable("../record_trajectory/physical_traj_1.csv");
% position_mj = [data_mj.pos_x'; data_mj.pos_y'; data_mj.pos_z'];
% force_mj = [data_mj.f_x'; data_mj.f_y'; data_mj.f_z'];

% ARX model
minimum_data_length_arx = 50;
prediction_length_arx = 50;
arx_model_file_name_predictions = "arx_model_physical_traj_"+nr+"_prediction_length_"+prediction_length_arx+"_predictions"
arx_model_file_name_error = "arx_model_file_name_physical_traj_"+nr+"_prediction_length_"+prediction_length_arx+"_error"

% Stiffness Estimation
samples_per_se = 1000;

% Loading robot models.
franka_robot = loadrobot("frankaEmikaPanda");
ur10_robot = loadrobot("universalUR10", "DataFormat", "row");
ur10_robot.Gravity = [0 0 -9.82];

ik = inverseKinematics('RigidBodyTree',ur10_robot);
[configSoln,solnInfo] = ik('tool0',[eul2rotm([pi/2 0 0], "xyz"), position_mj(:,1);0 0 0 1],[0.25 0.25 0.25 1 1 1],ur10_robot.homeConfiguration);


% writeAsFunction(franka_robot, "franka_robot_for_codegen");
% writeAsFunction(ur10_robot, "ur10_robot_for_codegen");

samples_per_second = 500;
stop_time = max(size(position_mj))/samples_per_second;

% PD controller with gravity compensation.
% K_p_pd = eye(6)*75;
K_p_pd = diag([80, 80, 30, 20, 16, 8])*5;
% k_u = [2000, 500, 0, 0, 0, 0];
% K_p_pd = diag(k_u);
% K_d_pd = eye(6)*0.6;
pd_margin = 55;
K_d_pd = diag([10+pd_margin*1.5, 10+pd_margin*1.5, 9+pd_margin*1.3, 3+pd_margin*0.5, 2.5+pd_margin*0.25, 2])*0.25;
% K_d_pd = diag([0.10 * k_u * 0.8, 0.10 * k_u * 0.7, 0.10 * k_u * 0.22, 0.10 * k_u * 0.035, 0.10 * k_u * 0.024, 0.10 * k_u * 0.037]);


% Parameters for estimation of damping.
b_c = 0;
b_ub = 60;
b_lb = -20;
pd_x_pdd_min = -7e-3;
pd_x_pdd_max = 7e-3;
sensitivity_measure = 0.95;
k_p = -log((1-sensitivity_measure)/(1+sensitivity_measure))/pd_x_pdd_max;
k_n = -log((1+sensitivity_measure)/(1-sensitivity_measure))/pd_x_pdd_min;


% Human Intention Predictor 
n = 30; N = n; H_p = N; H_u = N; q = 1;
number_of_dictionary_functions = 5;

a = 10e-4;
b = 10e-4;
c = 10e-4;
d = 10e-4;
A_tilde = diag(gamrnd(a, b, [1, N]));
beta = gamrnd(c,d);
while beta <= 1e-100 % Making sure that beta is not zero
    beta = gamrnd(c, d);
end

% NARX Network
prediction_length_narx_network = 50;
narx_network_file_name_predictions = "narx_network_file_name_traj_"+nr+"_prediction_length_"+prediction_length_narx_network+"_predictions.mat"
narx_network_file_name_error = "narx_network_file_name_traj_"+nr+"_prediction_length_"+prediction_length_narx_network+"_error.mat"

% Admittance controller: Mass, stiffness and damping matries.
K = 0;

dr = 1;

kpx = 15;
kpy = 15;
kpz = 15;

mpx = 3;
mpy = 3;
mpz = 3;

kox = 7;
koy = 7;
koz = 7;

mox = 1.5;
moy = 1.5;
moz = 1.5;


K_o = ...
  [kox 0 0;
   0 koy 0;
   0 0 koz];

K_p = ...
  [kpx 0 0;
   0 kpy 0;
   0 0 kpz];

M_o = ...
  [mox 0 0;
   0 moy 0;
   0 0 moz];

M_p = ...
  [mpx 0 0;
   0 mpy 0;
   0 0 mpz];

D_o = ...
  [ (2*sqrt(mox*kox))*dr 0 0;
   0 (2*sqrt(moy*koy))*dr 0;
   0 0 (2*sqrt(moz*koz))*dr];

D_p = ...
  [(2*sqrt(mpx*kpx))*dr 0 0;
   0 (2*sqrt(mpy*kpy))*dr 0;
   0 0 (2*sqrt(mpz*kpz))*dr];



