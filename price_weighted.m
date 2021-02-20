function simObj = price_weighted(simObj,lambda)
    % Price-weighted porfolio strategy
    if nargin<2
        lambda = 0.5;
    end
    simObj.reset(); % reset simulation environment
    ilambda = 1/lambda;
    for i=1:simObj.T
       w_const = simObj.s_cur.^ilambda;
       w_const = w_const./sum(w_const); % price weighted portfolio vector
       simObj.step(w_const);
    end
end