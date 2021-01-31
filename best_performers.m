function simObj = best_performers(simObj)
    simObj.reset(); % reset simulation environment
    % mean_returns weighted
    rebalancing_period = max(simObj.T / 10, 30);
    w_const = ones(simObj.d, 1) / simObj.d;
    lookback = rebalancing_period;
    n_best = simObj.d * 0.75;
    for i=1:simObj.T
        if mod(i,rebalancing_period) == 0
            returns = simObj.s_cur / simObj.s_hist(:,(i-lookback + 1));
            [~, idx] = sort(returns);
            w_const = zeros(simObj.d, 1);
            w_const(idx((simObj.d-n_best + 1):simObj.d)) = 1/n_best;
        end
       simObj.step(w_const);
    end
end