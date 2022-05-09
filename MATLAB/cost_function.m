function [cost] = cost_function(xhat, H_exp, weight_function, f, Q, R)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    % x = M D1 D2 K1 K2
    
    M = xhat(1);
    D1 = xhat(2);
    D2 = xhat(3);
    K1 = xhat(4);
    K2 = xhat(5);
    
%     data = load('mssdd_sim.mat');

    tf_nume = [M, (D1 + D2), (K1 + K2)];
    tf_deno = [D1 * M, (D1 * D2 + K1 * M), (D2 * K1 + D1 * K2), K1 * K2 + eps];
    
%     xhat;
    H_arm = tf(tf_nume, tf_deno);

    sum = 0;
    for n = 1:length(f)
%         sum = sum + (H_exp(n) - evalfr(H_arm, n/N)).^2;
%         sum = sum + weight_function(n)*(H_exp(n) - evalfr(H_arm, 1i*2*pi*(n/N)))^2;
%         sum = sum + (H_exp(n) - evalfr(H_arm, 1i*2*pi*(n/N)))^2;
%         sum = sum + (H_exp(n) - evalfr(H_arm, 1i*pi*(n/N)))^2;

%         sum = sum + weight_function(n)*(H_exp(n) - evalfr(H_arm, n/N))^2;
%         sum = sum + weight_function(n)*(H_exp(n) - evalfr(H_arm, 1i * 2 * pi * f(n)))^2;
%         sum = sum + (H_exp(n) - evalfr(H_arm, 1i * 2 * pi * f(n)))^2;

%         sum = sum + weight_function(n)*(real(H_exp(n)) - real(evalfr(H_arm, 1i * 2 * pi * f(n))))^2;
%         sum = sum + weight_function(n)*(H_exp(n) - evalfr(H_arm, 1i * 2 * pi * f(n)))^2;
        
        % sum = sum + weight_function(n) * (H_exp(n) - evalfr(H_arm, 1i * 2 * pi * f(n)))^2;
        sum = sum + weight_function(n) * (20 * log10(abs(H_exp(n))) - 20 * log10(abs(evalfr(H_arm, 1i * 2 * pi * f(n)))))^2; % + ...
            % (angle(H_exp(n)) + angle(evalfr(H_arm, 1i * 2 * pi * f(n))))^2;

%         sum = sum + weight_function(n) * (H_exp(n) - evalfr(H_arm, 1i * 2 * pi * f(n)))^2; % + ...
    end
    
%     cost = Q * abs(sum) + R * angle(sum);
%     cost = Q * norm(sum);
%     cost = 10 * log10(abs(sum));
    cost = sum;

%     cost = 0.5 * cost;
%     sum = abs(real(sum));

%     cost = 0;
end

