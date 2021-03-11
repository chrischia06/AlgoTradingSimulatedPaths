function simObj = macd(simObj, lambda)
    % Define MACD based
    simObj = simObj.reset(); % reset simulation environment
    w_const = ones(simObj.d,1)/simObj.d; % equal weighted portfolio vector
    warmup = 50;
    short = 10;
    long = 50;
    std_period = 50;
    freq = 1;
    for i=1:simObj.T
        if mod(i, freq) == 0 && i > warmup
            short_ma= mean(simObj.s_hist(:,(i - short + 1):i), 2);
            long_ma = mean(simObj.s_hist(:,(i - long + 1):i), 2);
            std_stat = std(simObj.s_hist(:,(i - std_period + 1):i), 0, 2);
            w_const = exp((short_ma - long_ma) / std_stat) .^ (1/lambda);
%             w_const = w_const ./ sum(w_const);
            w_const = w_const / sum(w_const);
            simObj = simObj.step(w_const);
        else
            simObj = simObj.step(w_const);
        end
    end
end