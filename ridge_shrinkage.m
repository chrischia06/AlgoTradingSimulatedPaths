function simObj = ridge_shrinkage(simObj, lambda, warmup, frequency)
    simObj.reset(); % reset simulation environment
    if nargin < 2
        lambda = 0.5;
    end
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
    %% multivariate volatility models
    % ccc_mvgarch, dcc, rarch, gogarch, PCA/Factor
    % Don't really seem to work
    %%
    options = optimset('Display', 'off');
    min_weight = 0.9 / simObj.d;
    max_weight = 1.1 / simObj.d;
    min_weight = 0;
    max_weight = 1;
    for i=1:simObj.T
        if i < warmup
            w_const = ones(simObj.d,1)/simObj.d;
        else
            if mod(i, frequency) == 0
                rets = diff(log(simObj.s_hist(:,1:i)),1,2)';
%                 rets = rets - mean(rets,2);
                shrinked_cov = cov(rets) + 2 * lambda * diag(ones(simObj.d, 1));
                % H, f, A, b, Aeq, beq, lb, ub
                w_const = quadprog(shrinked_cov, [], [], [],...
                               ones(1, simObj.d), 1,...
                               min_weight * ones(1,simObj.d),...
                               max_weight * ones(1,simObj.d),w_const, options);
            end
        end
       simObj.step(w_const);
    end
end