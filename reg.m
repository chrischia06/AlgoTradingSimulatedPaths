function simObj = cvar(simObj)
    simObj.reset(); % reset simulation environment
    for i=1:simObj.T
       if i <= 30
            w_const = ones(simObj.d,1)/simObj.d;
        else
            mu_hats = mean(diff(log(simObj.s_hist(:,1:i)),1,2),2);
            w_const = mu_hats .* (mu_hats > 0); 
            w_const = w_const ./ sum(w_const);
       end
       simObj.step(w_const);
    end
end