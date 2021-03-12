%%
clear;
close all hidden;

%%% Set Strategy Here
% description = "";
description = "Proportionally weighted, warmup = 100, rebalancing_freq = 100, k = 5, T = 500 runs, lambda=100";

filename = ('logs/frontier/' + description + ' ' +...
            string(datetime(now,'ConvertFrom','datenum')));
        
chosen_strategy = @pca_optimisation;
lambda_grid = (0.5:0.25:5)';
N_lambdas = size(lambda_grid, 1);
%%%
%% Define Parameters Here

% seed
rng(2021);

% number of runs
N = 500;
% N = 1; % for testing

% Market Model Parameters
% **Clarifications to T, d from Slack Channel
T = 500; % time horizon
d = 50; % assets
eta = 0.0002; % market impact
Mrank = floor(0.25*d); % rank   of cov
s0 = 100*ones(d,1); % intial asset prices
    
% cache mus (drift), cs (transaction proportion)
mus = 2e-5 * normrnd(0,1,T,d).^2; % drift
cs = 1e-8 * normrnd(0,1,T,d).^2; % market impact; non-negative

terminal_rets = zeros(N_lambdas, N);

% backtest on simulated data
tic;
for lambda_i = 1:N_lambdas
    % cache backtest results
    strategy_returns  = zeros(N, T);
    max_drawdowns  = zeros(N, 1);
    max_drawdown_duration = zeros(N, 1);
    
    for i = 1:N    
        % provided code to generate low rank matrix
        [U,S,V] = svd( randn(d,d) );
        diagM = diag( [ normrnd(0,1,Mrank,1) ; zeros(d-Mrank,1) ] );
        M = 5e-3 * U * diagM * V'; % Randomly generated matrix of rank Mrank    

        % Initialize Simulation Environment
        model_params = struct('mu', mus(i,:), 'M', M,'c',cs(i, :),'eta',eta);
        sim_obj = MarketSimulator(T, s0, model_params);

        % Run strategy on environment
        sim_obj = chosen_strategy(sim_obj, lambda_grid(lambda_i));

        terminal_rets(lambda_i, i) = sim_obj.R_hist(T) - 1;
    end
end
running_time = toc;

mean_strat = mean(terminal_rets, 2);
var_strat = var(terminal_rets,0 ,2);
std_strat = sqrt(var_strat);
loss_values = mean_strat - lambda_grid .* var_strat;

% efficient frontier
[vals, idx] = sortrows([mean_strat std_strat], 2);
best = [];
temp = 0;
for j = 1:length(vals)
    if vals(j, 1) > temp
        temp = vals(j, 1);
        best = [best j];
    end
end
figure()
scatter(std_strat, mean_strat);
hold on;
plot(vals(best,2), vals(best,1))
grid on;
xlabel("Std Deviation");
ylabel("Mean Return");
% yline(0, 'r--')
title('Monte Carlo Efficient Frontier')
saveas(gcf,filename + '-Efficient-Frontier.png')

figure()                   
plot(lambda_grid, loss_values)
grid on;
xlabel('Lambda');
ylabel('Quadratic Utility');
title('Loss against Lambda');
saveas(gcf,filename + '-Utility-Curve.png')


figure('Name', 'Mean[R], Std[R] against Lambda')
yyaxis left
plot(lambda_grid, mean_strat)
grid on;
ylabel('E[R | lambda]')
yyaxis right
plot(lambda_grid, std_strat)
ylabel('Std[R | lambda]')
title('Mean[R], Std[R] against Lambda')
saveas(gcf,filename + '-Mean-Std.png')


loss_values_table = array2table([lambda_grid  loss_values mean_strat std_strat]',...
                          'RowNames', {'Lambda', 'Loss','E[R]','Std[R]'})
writetable(loss_values_table, filename + '.txt');
latex(vpa([lambda_grid loss_values], 4))

