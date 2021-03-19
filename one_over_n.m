function simObj = one_over_n(simObj, lambda)
    if nargin < 2
        lambda = 0.5;
    end
    simObj = simObj.reset(); % reset simulation environment
    w_const = ones(simObj.d,1)/simObj.d; % equal weighted portfolio vector
    for i=1:simObj.T
        w_const = simObj.s_cur;
        w_const = w_const / sum(w_const);
       simObj = simObj.step(w_const);
    end
end