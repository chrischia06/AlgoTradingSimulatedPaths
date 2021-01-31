function simObj = momentum(simObj)
    % Define momentum score
    % e.g. normalised return
    % Assign asset weight = momentum score / sum momentum score
    simObj = simObj.reset(); % reset simulation environment
    w_const = ones(simObj.d,1)/simObj.d; % equal weighted portfolio vector
    W = 10;
    freq = 30;
    min_weight = 0.5 * (1/simObj.d);
    max_weight = 1.5 * (1/simObj.d);
    weights = min_weight + (max_weight - min_weight) * ((1:simObj.d) / simObj.d);
    for i=1:simObj.T
        if mod(i, freq) == 0 && i > W
            ma10 = mean(simObj.s_hist(:,(i - W + 1):i), 2);
            w_const = simObj.s_cur ./ ma10;
%             w_const = w_const ./ sum(w_const);
            [~,idx] = sort(w_const);
            w_const = weights(idx)';
            w_const = w_const / sum(w_const);
            simObj = simObj.step(w_const);
        else
            simObj = simObj.step(w_const);
        end
    end
end