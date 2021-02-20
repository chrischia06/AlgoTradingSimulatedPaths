function simObj = mad_optimisation(simObj,lambda)
    % Price-weighted porfolio strategy
    % https://github.com/FadyShoukry/MIE376-Robust-MAD/blob/master/originalMad.m
    if nargin<2
        lambda = 0.5;
    end
    warmup = 50;
    simObj.reset(); % reset simulation environment
    options = optimset('Display','Off');
    warning('off');
    min_weight_per_asset    = 0.00; % default
    max_weight_per_asset    = 1.00; % default
    rebalancing_periods = max(simObj.T / 5, 10);
    for i=1:simObj.T
        if i < warmup
            w_const = ones(simObj.d,1)/simObj.d;
        elseif mod(i, rebalancing_periods) == 0
            rets = diff(log(simObj.s_hist(:,1:i)),1,2)';
            mu = geomean(1 + rets) - 1;
%             mu = zeros(1, simObj.d);
            f = [zeros(simObj.d,1); ones(i - 1,1); ones(i - 1,1)];% [x_i; y_t; z_t]
            Aeq = [rets-repmat(mu,i - 1, 1) -eye(i - 1) eye(i - 1); ones(1, simObj.d) zeros(1, 2 * (i - 1));];% the constraint coefficient of MAD
            beq=[zeros(i - 1, 1); 1;];
            lb =[min_weight_per_asset * ones(simObj.d, 1); zeros(2 * (i - 1),1)];         % the lower bound of the variables
            ub =[max_weight_per_asset * ones(simObj.d, 1); ones(2 * (i - 1), 1) * inf];
            w_const = linprog(f, [], [], Aeq, beq, lb, ub, options);
            w_const = w_const(1:simObj.d);
        end
        simObj.step(w_const);
    end
end