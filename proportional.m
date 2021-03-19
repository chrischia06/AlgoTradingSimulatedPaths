function simObj = proportional(simObj, lambda)
    w_const = ones(simObj.d,1)/simObj.d; % equal weighted portfolio vector
    simObj = simObj.reset(); % reset simulation environment
    for i=1:simObj.T
       simObj = simObj.step(w_const);
    end
end