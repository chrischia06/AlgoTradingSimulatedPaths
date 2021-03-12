%%
clear;
close all hidden;

%% Set Strategy Here
% description = "";
description = "PCA optimisation, warmup = 100, rebalancing_freq = 100, k = 5, T = 500 runs, lambda=100";
chosen_strategy = @pca_optimisation;
lambda = 5;
%% Set Parameters

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
    
% pre-generate mus (drift), cs (transaction proportion), Ms (diffusion)
mus = 2e-5 * normrnd(0, 1, N, d).^2; % drift
cs = 1e-8 * normrnd(0, 1, N, d).^2; % market impact; non-negative
Ms = zeros(N, d, d); % diffusion

for i = 1:N
    % provided code to generate low rank matrix
    [U,S,V] = svd( randn(d,d) );
    diagM = diag( [ normrnd(0,1,Mrank,1) ; zeros(d-Mrank,1) ] );
    Ms(i,:,:) = 5e-3 * U * diagM * V'; % Randomly generated matrix of rank Mrank
end

% cache backtest results
strategy_returns  = zeros(N, T);
max_drawdowns  = zeros(N, 1);
max_drawdown_duration = zeros(N, 1);
terminal_rets = zeros(N, 1);

%% backtest on simulated data
tic;

for i = 1:N

    % Initialize Simulation Environment
    model_params = struct('mu', mus(i,:), 'M', reshape(Ms(i,:,:), d, d), 'c',cs(i, :),'eta',eta);
    sim_obj = MarketSimulator(T, s0, model_params);

    % Run strategy on environment
    sim_obj = chosen_strategy(sim_obj, lambda);
        
    % cache returns, maximum drawdown, and max drawdown duration
    strategy_returns(i,:) = sim_obj.r_hist;
    terminal_rets(i) = sim_obj.R_hist(T);
    
    % max drawdown, duration for 1 path
    [max_drawdowns(i), idx] = maxdrawdown(sim_obj.R_hist);
    max_drawdown_duration(i) = idx(2) - idx(1);
end
running_time = toc;

%% Metrics

% Max Drawdowns
figure('Name',"Distribution of Maximum Drawdowns")
histogram(max_drawdowns,100)
grid on;
title('Maximum Drawdown Distribution')

figure('Name',"Distribution of Maximum Drawdown Duration")
histogram(max_drawdown_duration,100)
grid on;
title('Maximum Drawdown Duration Distribution')

% . Efficient Frontier - Return v Std Deviation
figure('Name','Efficient Frontier')
mean_strat = mean(strategy_returns, 2);
stds	 = std(strategy_returns, 0, 2);

% plot(cumsum(mus) ./ (1:(size(mus,1)))')
[vals, idx] = sortrows([mean_strat stds], 2);
best = [];
temp = 0;
for j = 1:length(vals)
    if vals(j, 1) > temp
        temp = vals(j, 1);
        best = [best j];
    end
end
scatter(stds, mean_strat);
hold on;
plot([0 ; vals(best,2)], [0 ; vals(best,1)])
grid on;
xlabel("Std Deviation");
ylabel("Mean Return");
yline(0, 'r--')
title('Monte Carlo Efficient Frontier (1-period returns)')

% Strategy Returns
figure('Name', 'Cumulative Strategy Returns')
plot(cumsum(strategy_returns))
grid on;
title('Cumulative Strategy Returns')

% Distribution of Sharpe Ratio
figure('Name', 'Sharpe Ratio')
histogram(mean_strat ./ stds,100);
grid on;
title('Sharpe Ratio Distribution')

figure('Name', 'R_{T} Distribution')
histogram(terminal_rets - 1, 100)
grid on;
xline(mean(terminal_rets - 1), "r--", mean(terminal_rets - 1))
title('R_{T} Distribution')

mean_sharpe = mean(mean_strat ./ stds);
skew_sharpe = skewness(mean_strat ./ stds);
std_sharpe = std(mean_strat ./ stds);
kurtosis_sharpe = kurtosis(mean_strat ./ stds);
% calmar_ratio = mean_strat ./ max_drawdowns

cumul_rets = sim_obj.R_hist - 1;

% sample moments of Sharpe Distribution

filename = 'logs/' + description + ' ' + string(datetime(now,'ConvertFrom','datenum')) + '.txt';
stats = [mean_sharpe std_sharpe skew_sharpe kurtosis_sharpe ...
 median(max_drawdowns) median(max_drawdown_duration) running_time,...
 mean(terminal_rets - 1), var(terminal_rets)];
% write output results
stats_table = array2table(stats,'VariableNames',{'Mean','Std','Skew', 'Skurtosis',...
                  'Median Max Drawdown','Median Max Drawdown Duration', 'Time',...
                  'Mean RT', 'Var RT'})
writetable(stats_table, filename);
% could add CVaR, VaR


%% diagnosis for a single run of the strat

% Plot simulate d price history
figure('Name','Stock Price Evolution');
plot(1:(T+1),sim_obj.s_hist);
grid on;
title('Stock Price Evolution')

% Plot portfolio weights
figure('Name','Portfolio Weight Evolution');
plot(1:T,sim_obj.w_hist);
grid on;
title('Portfolio Weight Evolution')

% Plot portfolio 1-period returns + mean
figure('Name','Portfolio 1-Period-Return Evolution');
hold on;
plot(1:T,sim_obj.r_hist);
yline(0, 'r-')
hold off;
grid on;
title('Portfolio 1-Period-Return Evolution')

% Plot portfolio cumulative growth
figure('Name','Portfolio Total Return');
plot(1:T,sim_obj.R_hist-1);
grid on;
title('Portfolio Total Return')



% frequently-used : log returns
log_returns = diff(log(sim_obj.s_hist),1,2); %N x T
% running mean - cumsum(log_returns,2) ./ (1:T)
% plot((cumsum(log_returns,2) ./  (1:T))')
% testing convergence of estimates
% convergence of E[R_T]
% plot(cumsum(mean_strat ./ stds)' ./ (1:N))
% convergence of variance Var[R_T]
% plot((cumsum((mean_strat ./ stds) .^ 2)' - (cumsum((mean_strat ./ stds))' / (1:N)) .^2) ./ (1:N))