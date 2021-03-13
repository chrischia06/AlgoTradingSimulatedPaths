function [simObj] = follow_leader(simObj, lambda, warmup, frequency)
    % calculates the weights that would have had the best returns
    if nargin < 2
        lambda = 0.5;
        warmup = 50;
        frequency = 50;
    end
    if nargin < 3
        warmup = 50;
        frequency = 50;
    end
    options = optimset('Display', 'off',...
                       'Algorithm','interior-point');
    simObj.reset(); % reset simulation environment
    min_weights = zeros(simObj.d, 1);
    max_weights = ones(simObj.d, 1);
    w_const = ones(simObj.d, 1) / simObj.d;
    function y = log_rets(x, history, t, lambda)
        price_changes = history(:, 2:t) ./ history(:, 1:t-1);
        y = -sum(log(sum(x .* price_changes))) + lambda/2 * dot(x, x);
    end
    for i=1:simObj.T
        % fun , x0, A, b, Aeq, beq, lb, ub, nonlcon, options
        if mod(i, frequency) == 0
            log_rets2 = @(x)log_rets(x, simObj.s_hist, i, lambda);
            w_const = fmincon(log_rets2, w_const, [],[], ones(1, simObj.d), 1,...
                        min_weights, max_weights, [], options);
            w_const = w_const / sum(w_const);
        end
        
        simObj.step(w_const);
    end
end 