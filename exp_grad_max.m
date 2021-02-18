function [simObj] = exp_grad_max(simObj)
    % https://hudsonthames.org/online-portfolio-selection-momentum/
    % Regularization algorithm: Expectation maximisation

    simObj.reset(); % reset simulation environment
    w_const = ones(simObj.d,1)/simObj.d; % equal weighted portfolio vector
    lr = 0.5; % learning rate; find a way to optimize this
    x_t = ones(simObj.d, simObj.T); % initialize price relative S_t / S_{t-1}

    for i=1:simObj.T
        if i==1
            simObj.step(w_const);
        else
            x_t(:,i) = simObj.s_hist(:, i) ./ simObj.s_hist(:, i-1);
            w_const = w_const .* (lr .* ((x_t(:,i) ./ dot(w_const, x_t(:,i))) - 1) + 1);
            % Rescale weights to sum to 1
            w_const = w_const .* (w_const > 0);
            w_const = w_const / sum(w_const);
            simObj.step(w_const);
        end
    end
end 