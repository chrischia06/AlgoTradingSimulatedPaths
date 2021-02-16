clear;
close all hidden;
tic;

% seed
rng(2021);

% number of runs
N = 500;

% Market Model Parameters
% **Clarifications to T, d from Slack Channel
T = 500; % time horizon
d = 50; % assets
eta = 0.0002; % market impact
Mrank = floor(0.25*d); % rank of cov
s0 = 100*ones(d,1); % intial asset prices
    
% cache mus (drift), cs (transaction proportion)
mus = zeros(N, d);
cs = zeros(N, d);

% cache backtest results
strategy_returns  = zeros(N, T);
max_drawdowns  = zeros(N, 1);
max_drawdown_duration = zeros(N, 1);

% efficient frontier plot
% current = mean_strat(1);
% path = [1];
% temp = sortrows([stds mean_strat]);
% for i=1:N
%     if temp(i,2) > current
%         current = temp(i, 2);
%         path = [path ; i];
%     end
% end

% backtest on simulated data
for i = 1:N
    % provided code to generate low rank matrix
    [U,S,V] = svd( randn(d,d) );
    diagM = diag( [ normrnd(0,1,Mrank,1) ; zeros(d-Mrank,1) ] );
    M = 5e-3 * U * diagM * V'; % Randomly generated matrix of rank Mrank
    mus(i, :) = 2e-5 * normrnd(0,1,d,1).^2; % drift
    cs(i, :) = 1e-8 * normrnd(0,1,d,1).^2; % market impact; non-negative

    % Initialize Simulation Environment
    model_params = struct('mu', mus(i,:), 'M', M,'c',cs(i, :),'eta',eta);
    sim_obj = MarketSimulator(T,s0,model_params);

    % Run strategy on environment
    sim_obj = pca_optimisation(sim_obj);
    
    % cache returns, maximum drawdown, and max drawdown duration
    strategy_returns(i,:) = sim_obj.r_hist;
    
    % max drawdown, duration for 1 path
    [max_drawdowns(i), idx] = maxdrawdown(sim_obj.R_hist);
    max_drawdown_duration(i) = idx(2) - idx(1);
end

% Max Drawdowns
figure('Name',"Distribution of Maximum Drawdowns")
histogram(max_drawdowns,100)
title('Maximum Drawdown Distribution')

figure('Name',"Distribution of Maximum Drawdown Duration")
histogram(max_drawdown_duration,100)
title('Maximum Drawdown Duration Distribution')

% . Efficient Frontier - Return v Std Deviation
figure('Name','Efficient Frontier')
mean_strat = mean(strategy_returns, 2);
% plot(cumsum(mus) ./ (1:(size(mus,1)))')
stds = std(strategy_returns, 0, 2);
scatter(stds, mean_strat);
grid on;
xlabel("Std Deviation");
ylabel("Mean Return");
title('Monte Carlo Efficient Frontier')

% Strategy Returns
figure('Name', 'Cumulative Strategy Returns')
plot(cumsum(strategy_returns))
title('Cumulative Strategy Returns')

% Distribution of Sharpe Ratio
figure('Name', 'Sharpe Ratio')
histogram(mean_strat ./ stds,100);
mean_sharpe = mean(mean_strat ./ stds);
skew_sharpe = skewness(mean_strat ./ stds);
std_sharpe = std(mean_strat ./ stds);
kurtosis_sharpe = kurtosis(mean_strat ./ stds);
% calmar_ratio = mean_strat ./ max_drawdowns
title('Sharpe Ratio Distribution')

% sample moments of Sharpe Distribution
[mean_sharpe std_sharpe skew_sharpe kurtosis_sharpe median(max_drawdowns)]
toc

%% diagnosis for a single run of the strat

% Plot simulated price history
figure('Name','Stock Price Evolution');
clf();
plot(1:(T+1),sim_obj.s_hist);
title('Stock Price Evolution')

% Plot portfolio weights
figure('Name','Portfolio Weight Evolution');
clf();
plot(1:T,sim_obj.w_hist);
title('Portfolio Weight Evolution')

% Plot portfolio 1-period returns + mean
figure('Name','Portfolio 1-Period-Return Evolution');
clf();
hold on;
plot(1:T,sim_obj.r_hist);
plot(1:T,ones(1,T) * mean(sim_obj.r_hist))
hold off;
title('Portfolio 1-Period-Return Evolution')

% Plot portfolio cumulative growth
figure('Name','Portfolio Total Return');
clf();
plot(1:T,sim_obj.R_hist-1);
title('Portfolio Total Return')

% frequently-used : log returns
% log_returns = diff(log(sim_obj.s_hist),1,2);