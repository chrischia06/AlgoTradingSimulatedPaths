function simObj = current_price_weighted(simObj)
    simObj.reset(); % reset simulation environment
    for i=1:simObj.T
       w_const = simObj.s_cur ./ sum(simObj.s_cur); % price weighted portfolio vector
       simObj.step(w_const);
    end
end