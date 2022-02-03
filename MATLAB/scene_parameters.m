franka_robot = loadrobot("frankaEmikaPanda");
writeAsFunction(franka_robot, "franka_robot_for_codegen")
ur10_robot = loadrobot("universalUR10");


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
