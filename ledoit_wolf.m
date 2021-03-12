function simObj = ledoit_wolf(simObj, lambda, warmup)
    simObj.reset(); % reset simulation environment
    options = optimset('Display', 'off');

    if nargin < 2
        lambda = 0.5;
        warmup = 100;
    end
    if nargin < 3
        warmup = 100;
    end
    
    rebalancing_periods = max(simObj.T / 5, 10);
    min_weights = zeros(1, simObj.d);
    max_weights = ones(1,simObj.d);
    
    for i=1:simObj.T
        if i < warmup
            w_const = ones(simObj.d,1)/simObj.d;
        else
            if mod(i, rebalancing_periods) == 0
                rets = diff(log(simObj.s_hist(:,1:i)),1,2);
                mean_rets = mean(rets, 2);
                shrinked_cov = QIS(rets');
                shrinked_cov = (shrinked_cov + shrinked_cov') / 2;
                
                % min xHx + fx st to Aeqx = beq, lb <= x <= ub
                % H, f, A, b, Aeq, beq, lb, ub
                
                w_const = quadprog(shrinked_cov, - 1/ (2 * lambda) * mean_rets, [], [],...
                               ones(1, simObj.d), 1,...
                               min_weights,...
                               max_weights, w_const, options);
            end
        end
       simObj.step(w_const);
    end
end