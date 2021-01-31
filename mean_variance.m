function simObj = mean_variance(simObj)
    simObj.reset(); % reset simulation environment
    % mean variance portfolio
    % using sample covariance
    % rebalanced every x periods
    % this fails as the covariance matrix is singular
    % results in high weights being assigned to few assets
    % corr
    % cov
    rebalancing_periods = max(simObj.T / 5, 10);
    options = optimset('Display', 'off');
    for i=1:simObj.T
        if i <= rebalancing_periods
            w_const = ones(simObj.d,1)/simObj.d;
        else
            if mod(i, rebalancing_periods) == 0
                rets = diff(log(simObj.s_hist(:,1:i)),1,2);
                w_const = quadprog(corr(rets','Type','Pearson'), mean(rets,2), [], [],...
                               ones(1, simObj.d), 1,...
                               0.5/ simObj.d * ones(1,simObj.d),...
                               1.5 / simObj.d * ones(1,simObj.d),w_const, options);
            end
        end
       simObj.step(w_const);
    end
end