function simObj = pca_optimisation(simObj, lambda)
    if nargin < 2
        lambda = 0.5;
    end
    % Use PCA as a factor model to construct a covariance matrix
    % then use mean-variance (Quadratic) optimisation
    simObj.reset(); % reset simulation environment
    % rebalance 5 times, or every 10 periods
    rebalancing_periods = max(simObj.T / 5, 10); 
    options = optimset('Display', 'off');
    warmup = 100;
    k = fix(simObj.d / 10); % number of factors
    
    min_weights = zeros(1, simObj.d);
    max_weights = ones(1, simObj.d);
    
    for i=1:simObj.T
        if i < warmup
            w_const = ones(simObj.d,1)/simObj.d;
        else
            if mod(i, rebalancing_periods) == 0
                rets = diff(log(simObj.s_hist(:,1:i)),1,2);
                [ws, pcs] = pca(rets');
                errors = rets' - (pcs(:,1:k) * ws(1:k,:));
                Omega = diag(mean(errors.^2));
                estim_cov = ws(1:k,:)' * (pcs(:,1:k)' * pcs(:,1:k)) * ws(1:k,:) + Omega;
                estim_cov = (estim_cov + estim_cov') / 2; 
                
                % H (cov), f (expected returns), A , b (Ax < b),
                % Aeq, beq (Aeq x = beq), m lb, ub (lb < x < ub), x0
                % max E[R] - lambda Var[R_t] = max 1/ 2lambda [] - 1/2
                % Var[R_t];min 1/2 Var[R_t] - 1/2lambda mean_rets
                mean_rets = mean(rets, 2);
                w_const = quadprog(estim_cov, -1/(2 * lambda) * mean_rets, [], [],...
                               ones(1, simObj.d), 1,...
                               min_weights,...
                               max_weights, w_const, options);
            end
        end
       simObj.step(w_const);
    end
end