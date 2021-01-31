function simObj = pca_weighted(simObj)
    % 1. select one of the k principal components as the asset weights
    % 2. Factor Model: build a covariance matrix based on k principal components?
    % not that effective
    simObj = simObj.reset(); % reset simulation environment
    w_const = ones(simObj.d,1)/simObj.d; % equal weighted portfolio vector
    rebalancing_periods = max(simObj.T / 2, 10);
    for i=1:simObj.T
        if mod(i, rebalancing_periods) == 0
            rets = diff(log(simObj.s_hist(:,1:i)),1,2);
            [weights, ~] = pca(rets(:,1:(i-2))');
            w_const = weights(6,:)';
            [~,idx] = sort(w_const);
            w_const = w_const .* sign(w_const(idx(simObj.d)));
            w_const = w_const .* (w_const > 0);
            w_const = w_const / sum(w_const);
%             factor_cov = weights(1:k,:)' * diag([var(pcs(:,1)) var(pcs(:,2))]) * weights(1:k,:);
%             factor_cov  = factor_cov + diag(diag(cov(excess_rets - pcs(:,1:k) * weights(1:k,:))));
%             weights = weights';
%             weights = weights(:,2);
%             weights = -weights .* (weights < 0);
%             w_const = weights ./ sum(weights);
%             simObj = simObj.step(w_const);
        end
        simObj = simObj.step(w_const);
    end
end