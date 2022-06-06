function [c, ceq] = nonlcon(xhat, H_exp, f, bound) %,...
%        const_3Hz, const_5Hz, const_10Hz, const_15Hz, const_20Hz)
%NONLCON Summary of this function goes here
%   Detailed explanation goes here
    % x = M D1 D2 K1 K2
    
    M = xhat(1);
    D1 = xhat(2);
%     D2 = xhat(3);
    K1 = xhat(3);
%     K2 = xhat(5);
    
%     tf_nume = [M, (D1 + D2), (K1 + K2)];
%     tf_deno = [D1 * M, (D1 * D2 + K1 * M), (D2 * K1 + D1 * K2), K1 * K2 + eps];
    tf_nume = [1];
    tf_deno = [M, D1, K1 + eps];

    H_arm = tf(tf_nume, tf_deno);
    
    c = [];
%     ceq = [];
      
    for i=1:length(f)
        mag_i_exp = 20 * log10(abs(H_exp(i)));
        mag_i_arm = 20 * log10(abs(evalfr(H_arm, 1i * 2 * pi * f(i))));
        
%         ceq = [ceq; 
%             mag_i_exp - mag_i_arm];
        c = [c;
            -mag_i_exp + mag_i_arm - bound;
             mag_i_exp - mag_i_arm - bound;
            ];
    end
    
    ceq = 0;
end

