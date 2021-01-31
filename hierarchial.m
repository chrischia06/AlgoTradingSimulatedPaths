function simObj = hierarchial(simObj)
    % Cluster stocks together by return?
    % assign weight to each cluster
    % assign weight to each asset in cluster
    w_const = ones(simObj.d,1)/simObj.d; % equal weighted portfolio vector
    simObj = simObj.reset(); % reset simulation environment
    W = 5;
    freq = 10;
    for i=1:simObj.T
        if mod(i, freq) == 0
            ma10 = mean(simObj.s_hist(:,(i - W + 1):i), 2);
            w_const = simObj.s_cur ./ ma10;
            w_const = w_const ./ sum(w_const);
            simObj = simObj.step(w_const);
        else
            simObj = simObj.step(w_const);
        end
    end
end