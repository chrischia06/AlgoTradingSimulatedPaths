function simObj = reg(simObj, lambda)
    if nargin < 2
        lambda = 0.5;
    end
    %% Time Series Momentum
    % Use a time series model - Lasso, Ridge, ElasticNet
    % and predict each assets next-step returns, and weight accordingly
    simObj.reset(); % reset simulation environment
    w_const = ones(simObj.d,1)/simObj.d;
    warmup = 50;
    freq = max(simObj.T/ 10, 10);
    % lambda (risk aversion) corresponds with
    % regularisation for Lasso
    for i=1:simObj.T
       if i > warmup && mod(i, freq) == 0 
            w_const = zeros(simObj.d, 1);
            log_returns = diff(log(simObj.s_hist(:,1:i)),1,2);
            % this is effectively a sort of MA(infinity)
            Xs = log_returns(:,1:(i - 2))';
            Xt = log_returns(:,i-1)';
            for j=1:simObj.d
                % predict each next-step return one by one
                y = log_returns(j,2:(i - 1))';
                % model.predict
                [B,FitInfo] = lasso(Xs,y,'Lambda', lambda);
                w_const(j) = Xt * B + FitInfo.Intercept;
            end
            w_const = simObj.s_cur .* exp(w_const);
            w_const = w_const ./ sum(w_const);
       end
       % weight assets by hat(S_{t+1}^{i}) / sum(hat(S_{t + 1}^{i}))
       
       simObj.step(w_const);
    end
end