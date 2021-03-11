function simObj = mean_correlation(simObj, lambda)
    simObj.reset(); % reset simulation environment
    %% general
    % mean variance / minimum variance portfolio
    % rebalanced every t periods
    %% Risk Measures
    % Sample Covariance Matrix - results in high weights being assigned to few assets
    % also fails as the covariance matrix is singular
    % Correlation Matrix instead of cov - corr(rets','Type','Pearson')
    % EWMA version of Cov.
    % semicovariance - cov(rets .* (rets < mean(rets, 2)))
    %% robust covariance measures
    % Ledoit Wolf
    % Minimum Covariance Determinant - robustcov
    % Newey-West covariance estimation - covnw
    % Graphical Lasso?
    %% Incorporating mean; Black-Litterman
    % Should estimated mean return be incorporated at all?
    %% Univariate 
    % CVaR
    %% multivariate volatility models
    % ccc_mvgarch, dcc, rarch, gogarch, PCA/Factor
    % Don't really seem to work
    %%
    if nargin < 2
        lambda = 0.5;
    end
    rebalancing_periods = max(simObj.T / 5, 10);
    options = optimset('Display', 'off',...
                       'Algorithm','interior-point-convex');
    max_weight = 1;
    min_weight = 0;
%     max_weight = 1.1 / simObj.d ;
%     min_weight = 0.9 / simObj.d * 
    warmup = 100;
    
    % min 0.5 w^{T}Hw + f^{t} w , Aw <= . b, Aeqw = beq, lb<= w <= ub
    for i=1:simObj.T
        if i < warmup
            w_const = ones(simObj.d,1)/simObj.d;
        else
            if mod(i, rebalancing_periods) == 0
                rets = diff(log(simObj.s_hist(:,1:i)),1,2);
                rets = rets - mean(rets,2);
                mean_rets = mean(rets,2);
                % H, f, A, b, Aeq, beq, lb, ub
                w_const = quadprog(corr(rets'), -1/ (2 * lambda) * mean_rets, [], [],...
                               ones(1, simObj.d), 1,...
                               min_weight * ones(1,simObj.d),...
                               max_weight * ones(1,simObj.d),w_const, options);
            end
        end
       simObj.step(w_const);
    end
end