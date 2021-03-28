function simObj = cvar_optimisation(simObj,lambda, warmup, frequency)
    % Price-weighted porfolio strategy
    if nargin<2
        lambda = 0.5;
    end
    simObj.reset(); % reset simulation environment
    options = optimset('Display','Off');
    warning('off');
    min_weight_per_asset    = 0.00; % default
    max_weight_per_asset    = 1.00; % default
    beta = 0.99; % 1 - CVaR level
    for i=1:simObj.T
        if i < warmup
            w_const = ones(simObj.d,1)/simObj.d;
        elseif mod(i, frequency) == 0
            rets = diff(log(simObj.s_hist(:,1:i)),1,2);
            f = [zeros(1, simObj.d) 1 zeros(1, i - 1) + ((1/(1 - beta)) * (1 / (i - 1)))];
            A = zeros(i - 1, simObj.d + i);
            A(1:end,1:simObj.d) = -rets';
            A(1:end,simObj.d+1) = -1;
            A(1:end,simObj.d+2:end) = -eye(i - 1);
            b = zeros(i-1,1);
            lb = zeros(1+i+simObj.d,1);
            ub = zeros(1+i+simObj.d,1);
            lb(1:simObj.d)     = min_weight_per_asset;
            ub(1:simObj.d)     = max_weight_per_asset;
            ub(simObj.d+1)     = inf;
            ub(simObj.d+2:end) = inf;
            Aeq = zeros(1,simObj.d + i);
            % constrain sum of weights to be 1
            Aeq(1:simObj.d) = 1;
            beq = [1];
            w_const = linprog(f, A, b, Aeq, beq, lb, ub, options);
            w_const = w_const(1:simObj.d);
        end
        simObj.step(w_const);
    end
end