function xhat = estimate_parmeters(force, position, x0, Fs)

window_segments = [];
noverlap = [];

frange = 0.5:0.1:20;
[H_exp, f] = tfestimate(force, position, window_segments, noverlap, frange, Fs, ...
    'Estimator', 'H1');
N = length(H_exp);

[weight_function, ~] = mscohere(force, position, window_segments, noverlap, frange, Fs);

Q = 1;
R = 0;
func = @(x) cost_function(x, H_exp, weight_function, f, Q, R);

bound = 3;

nonlcon_fun = @(x) nonlcon(x, H_exp, f, bound);
% nonlcon = nonlcon_fun;
A = [];
b = [];
Aeq = [];
beq = [];

lb = zeros(5, 1);
ub = [2; 20; 10; 1000; 500] * 1000;
% ub = [5, 20, 20, 50, 50];


options = optimoptions('fmincon','Algorithm','sqp',...
    'StepTolerance', 1e-8, ...
    'OptimalityTolerance', 1e-8, ...
    'ConstraintTolerance', 1e-2, ...
    'MaxFunctionEvaluations', 1e6, ...
    'TypicalX', ub, ...
    'ScaleProblem', true, ...
    'FiniteDifferenceType', 'central');

[xhat, fval] = fmincon(func, x0, A, b, Aeq, beq, lb, ub, nonlcon_fun, options);
end