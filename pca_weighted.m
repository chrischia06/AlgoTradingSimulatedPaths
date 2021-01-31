function simObj = pca_weighted(simObj)
    % 1. select one of the k principal components as the asset weights
    % build a covariance matrix based on k principal components?
    w_const = ones(simObj.d,1)/simObj.d; % equal weighted portfolio vector
    simObj = simObj.reset(); % reset simulation environment
    rebalancing_periods = max(simObj.T / 5, 10);
    for i=1:simObj.T
        if mod(i, rebalancing_periods) == 0
            rets = diff(log(simObj.s_hist(:,1:i)),1,2);
            [weights, ~] = pca(rets');
            weights = weights';
            weights = weights(:,2);
            weights = -weights .* (weights < 0);
            w_const = weights ./ sum(weights);
            simObj = simObj.step(w_const);
        else
            simObj = simObj.step(w_const);
        end
    end
end