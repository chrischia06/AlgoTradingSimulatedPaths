clear;
close all hidden;
tic;

% seed
rng(2021);

% number of runs
N = 1000;

% Market Model Parameters
T = 250; % time horizon
d = 20; % assets
eta = 0.0002; % market impact
Mrank = floor(0.25*d); % rank of cov
s0 = 100*ones(d,1); % intial asset prices

mus = zeros(N, d);
cs = zeros(N, d);

% cache backtestresults
strategy_returns  = zeros(N, T);
max_drawdowns  = zeros(T, 1);


% backtest on simulated dataa
for i = 1:N
    
    [U,S,V] = svd( randn(d,d) );
    diagM = diag( [ normrnd(0,1,Mrank,1) ; zeros(d-Mrank,1) ] );
    M = 5e-3 * U * diagM * V'; % Randomly generated matrix of rank Mrank
    mus(i, :) = 2e-5 * normrnd(0,1,d,1).^2; %drift
    cs(i, :) = 1e-8 * normrnd(0,1,d,1).^2; % market impact

    % Initialize Simulation Environment
    model_params = struct('mu', mus(i,:), 'M', M,'c',cs(i, :),'eta',eta);
    sim_obj = MarketSimulator(T,s0,model_params);

    % Run strategy on environment
    sim_obj = momentum(sim_obj);
    strategy_returns(i,:) = sim_obj.r_hist;
    max_drawdowns(i) = maxdrawdown(1 + sim_obj.r_hist);
end

% Max Drawdowns
figure('Name',"Distribution of Maximum Drawdowns")
histogram(max_drawdowns,100)
title('Maximum Drawdown Distribution')

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
title('Sharpe Ratio Distribution')

[mean_sharpe skew_sharpe std_sharpe kurtosis_sharpe]
toc

%% diagnosis for a single run of the strat

% Plot simulated price history
figure('Name','Stock Price Evoltuion');
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
figure('Name','Portfolio Comulative Growth');
clf();
plot(1:T,sim_obj.R_hist-1);
title('Portfolio Cumulative Growth')