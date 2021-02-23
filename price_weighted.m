function simObj = price_weighted(simObj,lambda)
    % Price-weighted porfolio strategy
    if nargin<2
        lambda = 0.1;
    end
    simObj.reset(); % reset simulation environment
    ilambda = 1/lambda;
    warmup = 0;
    rebalancing_freq = 5;
    w_const = 1/ simObj.d *ones(simObj.d, 1);
    for i=1:simObj.T
       if i > warmup && mod(i, rebalancing_freq) ==0
            w_const = simObj.s_cur.^ilambda;
            w_const = w_const./sum(w_const);
       end
        % price weighted portfolio vector
       simObj.step(w_const);
    end
end