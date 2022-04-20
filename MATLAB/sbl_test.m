% Start variables
n = 30;
N = n;
H_p = N;
H_u = N;

% Hyper parameters
A_tilde = diag(rand(1,N));
beta = rand(1);


%  -------------- Calculations --------------

% Other
phi = 
zeta = -1 + (1+1) * rand(1, N); % Generates a vector in range [-1, 1]

% Omega
Sigma = inv(beta * phi' * phi +  A_tilde);
omega = beta * Sigma * phi' * x_I;

% x_d
x_d = omega * phi + zeta;


