% Loading robot models.
franka_robot = loadrobot("frankaEmikaPanda");
ur10_robot = loadrobot("universalUR10");

writeAsFunction(franka_robot, "franka_robot_for_codegen");
writeAsFunction(ur10_robot, "ur10_robot_for_codegen");

% PD controller with gravity compensation.
K_p_pd = eye(3);
K_d_pd = eye(3);

% Parameters for estimation of damping.
b_c = 0;
b_ub = 1;
b_lb = -0.5;
pd_x_pdd_min = -7e-3;
pd_x_pdd_max = 7e-3;
sensitivity_measure = 0.95;
k_p = -log((1-sensitivity_measure)/(1+sensitivity_measure))/pd_x_pdd_max;
k_n = -log((1+sensitivity_measure)/(1-sensitivity_measure))/pd_x_pdd_min;


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
