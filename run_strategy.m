%%
clear;
close all hidden;

%% Set Strategy Here
% 1. Change Description
% 2. Set hyperparameter variables: warmup, frequency
% 3. Change chosen_strategy
% 4. Set hyperparameter string

description = "Semivariance";
filename = 'logs/' + description + '-' +...
           string(datetime(now,'ConvertFrom','datenum'));

%hyperparams
lambda = 0.1;
    
warmup = 100;
frequency = 50;
% lower_bound = 0;
% upper_bound = 1;
chosen_strategy = @(x)semicovariance(x, lambda, warmup,frequency);
hyperparams = sprintf("warmup = %d, frequency = %d", warmup, frequency);

% number of runs
N = 500;

% frequency = 30;
% warmup = 50;
% chosen_strategy = @(x)one_over_n(x, lambda);
% % hyperparams = "frequency = 30, warmup = 50";
% hyperparams = "frequency = 1";
%% Set Parameters

% seed
rng(2021);

% N = 1; % for testing

% Market Model Parameters
% **Clarifications to T, d from Slack Channel
T = 500; % time horizon
d = 50; % assets
eta = 0.0002; % market impact, 0.2%
Mrank = floor(0.25*d); % rank of cov
s0 = 100*ones(d,1); % intial asset prices
    
% pre-generate mus (drift), cs (transaction proportion), Ms (diffusion)
mus = 2e-5 * normrnd(0, 1, N, d).^2; % drift 0.002%
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
    model_params = struct('mu', mus(i,:), 'M', reshape(Ms(i,:,:), d, d),...
                          'c',cs(i, :),'eta',eta);
    sim_obj = MarketSimulator(T, s0, model_params);

    % Run strategy on environment
    sim_obj = chosen_strategy(sim_obj);
        
    % cache returns, maximum drawdown, and max drawdown duration
    strategy_returns(i,:) = sim_obj.r_hist;
    terminal_rets(i) = sim_obj.R_hist(T);
    
    % max drawdown, duration for 1 path
    [max_drawdowns(i), idx] = maxdrawdown(sim_obj.R_hist);
    max_drawdown_duration(i) = idx(2) - idx(1);
end
running_time = toc;

%% Metrics

% sample moments of Sharpe Distribution
mean_strat = mean(strategy_returns, 2);
std_strat  = std(strategy_returns, 0, 2);

mean_sharpe = mean(mean_strat ./ std_strat);
skew_sharpe = skewness(mean_strat ./ std_strat);
std_sharpe = std(mean_strat ./ std_strat);
kurtosis_sharpe = kurtosis(mean_strat ./ std_strat);
% calmar_ratio = mean_strat ./ max_drawdowns

stats = {mean_sharpe std_sharpe skew_sharpe kurtosis_sharpe ...
 median(max_drawdowns) median(max_drawdown_duration) running_time,...
 mean(terminal_rets - 1), var(terminal_rets) skewness(terminal_rets)...
      kurtosis(terminal_rets) string(datetime(now,'ConvertFrom','datenum')) lambda hyperparams};

  % write output results
stats_table = cell2table(stats,'VariableNames',{'Mean','Std','Skew', 'Kurtosis',...
                  'Median Max Drawdown','Median Max Drawdown Duration', 'Time',...
                  'Mean RT', 'Var RT', 'Skew RT', 'Kurt RT', 'Date', 'Lambda', 'hyperparams'})
writetable(stats_table, filename + '.txt');

%% Plot Monte Carlo Metrics - One period
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
% plot(cumsum(mus) ./ (1:(size(mus,1)))')
[vals, idx] = sortrows([mean_strat std_strat], 2);
best = [];
temp = 0;
for j = 1:length(vals)
    if vals(j, 1) > temp
        temp = vals(j, 1);
        best = [best j];
    end
end

% efficient frontier of mean 1 period returns
figure('Name', 'Efficient Frontier')
scatter(std_strat, mean_strat);
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
histogram(mean_strat ./ std_strat,100);
grid on;
title('Sharpe Ratio Distribution')

%% Plot Monte Carlo Metrics - Terminal

% gives shape of R_{T}
figure('Name', 'R_{T} Distribution')
histogram(terminal_rets - 1, 100)
grid on;
xline(mean(terminal_rets - 1), "r--", mean(terminal_rets - 1))
title('R_{T} Distribution')
saveas(gcf, filename + "-Terminal-Return-Distribution.png")

%% diagnosis for a single run of the strat

% Plot simulate d price history
figure('Name','Stock Price Evolution');
plot(1:(T+1),sim_obj.s_hist);
grid on;
title('Stock Price Evolution')

% Plot portfolio weights
figure('Name','Portfolio Weight Evolution (Proportion)');
plot(1:T,sim_obj.w_hist);
grid on;
title('Portfolio Weight Evolution')

% Plot portfolio proportion
figure('Name','Number of Units');
plot(sim_obj.P_hist .* (sim_obj.w_hist(:,1:T) ./ sim_obj.s_hist(:,1:T))')
grid on;
title('Number of Units in each stock')

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


%% MISC
% frequently-used : log returns
log_returns = diff(log(sim_obj.s_hist),1,2); %N x T
% running mean - cumsum(log_returns,2) ./ (1:T)
% takes > 100 observations to estimate mean
% plot((cumsum(log_returns,2) ./  (1:T))') 
% testing convergence of estimates
% convergence of E[R_T]
% plot(cumsum(mean_strat ./ stds)' ./ (1:N))
% convergence of variance Var[R_T]
% plot((cumsum((mean_strat ./ stds) .^ 2)' - (cumsum((mean_strat ./ stds))' / (1:N)) .^2) ./ (1:N))