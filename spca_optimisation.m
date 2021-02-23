function simObj = spca_optimisation(simObj, lambda)
% Risk aversion optimisation using sparse PCs
% Using https://www.jstatsoft.org/article/view/v084i10 for sparse PCA
    if nargin < 2
        lambda = 0.5;
    end
    simObj.reset(); % reset simulation environment
    options = optimset('Display','Off');
    warmup = 100;
    k=1; % no. of sparse PCs
    stop = floor(lambda * simObj.d/20); % no. of non-zero variables in PC 
    % key is to find optimal way to set stop as a function of lambda
    
    for i = 1:simObj.T
        if i < warmup
            w_const = ones(simObj.d,1)/simObj.d;
        else
            rets = diff(log(simObj.s_hist(:,1:i)),1,2);
            B = spca(rets',[],k, inf, -stop); % sparse loading vectors
            pcs = B' * rets; 
            errors = rets - B * pcs;
            Omega = diag(mean(errors.^2, 2)); 
            estim_cov = B * (pcs * pcs') * B' + Omega;
            rets_mean = mean(rets, 2)';
            size(rets_mean)
            % H (cov), f (expected returns), A , b (Ax < b),
            % Aeq, beq (Aeq x = beq), m lb, ub (lb < x < ub), x0
            % the optimisation problem is
            % argmin_{w} 0.5 w^{T}Hw + f w , Aw = b
            % so f = -2E[R] / lambda
            w_const = quadprog(estim_cov, -2 * rets_mean, [],[],...
                ones(1, simObj.d), 1,...
                zeros(1, simObj.d), ones(1, simObj.d),...
                w_const, options);
        end
        simObj.step(w_const);
    end
end