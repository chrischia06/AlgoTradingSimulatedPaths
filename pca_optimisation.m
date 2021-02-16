function simObj = pca_optimisation(simObj)
    simObj.reset(); % reset simulation environment
    rebalancing_periods = max(simObj.T / 5, 10);
    options = optimset('Display', 'off');
    for i=1:simObj.T
        if i <= rebalancing_periods
            w_const = ones(simObj.d,1)/simObj.d;
        else
            if mod(i, rebalancing_periods) == 0
                rets = diff(log(simObj.s_hist(:,1:i)),1,2);
                [ws, pcs] =pca(rets');
                errors = rets' - (pcs(:,1:2) * ws(1:2,:));
                Omega = diag(mean(errors.^2));
                estim_cov = ws(1:2,:)' * (pcs(:,1:2)' * pcs(:,1:2)) * ws(1:2,:) + Omega;
                % H (cov), f (expected returns), A , b (Ax < b),
                % Aeq, beq (Aeq x = beq), m lb, ub (lb < x < ub), x0
                w_const = quadprog(estim_cov, [], [], [],...
                               ones(1, simObj.d), 1,...
                               zeros(1, simObj.d),...
                               ones(1, simObj.d),w_const, options);
            end
        end
       simObj.step(w_const);
    end
end