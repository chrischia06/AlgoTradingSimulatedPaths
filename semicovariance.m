function simObj = semicovariance(simObj, lambda, warmup, frequency)
    simObj.reset(); % reset simulation environment
    if nargin < 2
        lambda = 0.5;
        warmup = 100;
        frequency = 100;
    end
    if nargin < 3
        warmup = 100;
        frequency = 100;
    end
    if nargin < 4
        frequency = 100;
    end
    options = optimset('Display', 'off');  
    for i=1:simObj.T
        if i < warmup
            w_const = ones(simObj.d,1)/simObj.d;
            % the portfolio that minimises semicovariance can be formulated
            % as a quadratic programming problem with
            % d + 2 * (t - 1) variables
            % since at time t we have t - 1 returns
            % where x = [w , p, n], weights, 
            % and positive, negative returns of the portfolio
            x = [ones(1, simObj.d)/simObj.d zeros(1, 2 * (i - 1))];
        else
            if mod(i, frequency) == 0
                
                rets = diff(log(simObj.s_hist(:,1:i)),1,2); %d x t
                mean_rets = mean(rets, 2);
                
                B = rets / sqrt(i); % d x t matrix
                % [1^T x w + 0^Tp 0^Tn] = 1
                % [Bx - p + n]
                b_size = size(B); %
                Aeq = [ones(1, simObj.d) zeros(1, 2 * (i - 1));...
                       B' -ones(i - 1, i - 1) ones(i - 1, i - 1)];
                aeq_size = size(Aeq);
                beq = [1; zeros(i - 1, 1)];
                beq_size = size(beq);
                     
                lb = [zeros(1, simObj.d + 2 * (i - 1))]; % d + 2t
                H = [zeros(simObj.d + i - 1, simObj.d + (2 * (i - 1)));...
                     zeros(i - 1, simObj.d + (i - 1)) eye(i - 1, i - 1)];
                f = [-1/(2 * lambda) * mean_rets' zeros(1, 2 * (i - 1))];
                     
                % H, f, A, b, Aeq, beq, lb, ub
                x = quadprog(H, f, [], [],...
                               Aeq, beq,...
                               lb, [], x,options);
                w_const = x(1:simObj.d);
                w_const = w_const / sum(w_const);
            end
        end
       simObj.step(w_const);
    end
end