function simObj = pca_optimisation(simObj, lambda)
    if nargin < 2
        lambda = 0.5;
    end
    % Use PCA as a factor model to construct a covariance matrix
    % then use mean-variance (Quadratic) optimisation
    simObj.reset(); % reset simulation environment
    rebalancing_periods = max(simObj.T / 5, 10);
    options = optimset('Display', 'off');
    warmup = 100;
    k = 5; % number of factors
    for i=1:simObj.T
        if i < warmup
            w_const = ones(simObj.d,1)/simObj.d;
        else
            if mod(i, rebalancing_periods) == 0
                rets = diff(log(simObj.s_hist(:,1:i)),1,2);
                [ws, pcs] =pca(rets');
                errors = rets' - (pcs(:,1:k) * ws(1:k,:));
                Omega = diag(mean(errors.^2));
                estim_cov = ws(1:k,:)' * (pcs(:,1:k)' * pcs(:,1:k)) * ws(1:k,:) + Omega;
                % H (cov), f (expected returns), A , b (Ax < b),
                % Aeq, beq (Aeq x = beq), m lb, ub (lb < x < ub), x0
                % max E[R] - lambda Var[R_t] = max 1/ 2lambda [] - 1/2
                % Var[R_t];min 1/2 Var[R_t] - 1/2lambda mean_rets
                mean_rets = mean(rets, 2);
                w_const = quadprog(estim_cov, -1/(2 * lambda) * mean_rets, [], [],...
                               ones(1, simObj.d), 1,...
                               zeros(1, simObj.d),...
                               ones(1, simObj.d),w_const, options);
            end
        end
       simObj.step(w_const);
    end
end