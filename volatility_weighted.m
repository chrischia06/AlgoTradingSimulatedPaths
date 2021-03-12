function simObj = volatility_weighted(simObj, lambda, warmup)
    simObj.reset(); % reset simulation environment
    % assume covariance matrix is diagonal
    if nargin < 2
        lambda = 0.5;
    end
    if nargin < 3
        warmup = 30;
    end
    options = optimset('Display', 'off',...
                       'Algorithm','interior-point-convex');
                   
    rebalancing_periods = 1;
    % min 0.5 w^{T}Hw + f^{t} w , Aw <= . b, Aeqw = beq, lb<= w <= ub
    for i=1:simObj.T
        if i < warmup
            w_const = ones(simObj.d,1)/simObj.d;
        else
            if mod(i, rebalancing_periods) == 0
                rets = diff(log(simObj.s_hist(:,1:i)),1,2);
                % H, f, A, b, Aeq, beq, lb, ub
                % w E[R] - lambda wCw; 1/2lambdaE[R] - lambda w Cw
                cov = diag(var(rets,0,2)) ;
                w_const = cov \ ones(simObj.d, 1);
                w_const = w_const / sum(w_const);
            end
        end
       simObj.step(w_const);
    end
end