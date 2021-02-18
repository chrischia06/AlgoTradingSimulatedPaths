function simObj = classification(simObj, lambda)
    if nargin < 2
        lambda = 0.5;
    end
    %% Time Series Momentum
    % Use Logistic Regression to predict Y_{t + 1} > 0 for each asset
    % Weight accordingly based on wP(Y_{t + 1} > 0)
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
                y = log_returns(j,2:(i - 1))' > 0;
                % model.predict
                Mdl = fitclinear(Xs, y, 'ScoreTransform','logit', 'Lambda', lambda);
                [~, posterior] = predict(Mdl, Xt);
                w_const(j) = posterior(:,2);
                
            end
            w_const = w_const ./ sum(w_const);
       end       
       simObj.step(w_const);
    end
end