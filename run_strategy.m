clear;
close all hidden;
tic;

% seed
rng(2021);

% Market Model Parameters
% **Clarifications to T, d from Slack Channel
T = 500; % time horizon
d = 50; % assets
eta = 0.0002; % market impact
Mrank = floor(0.25*d); % rank of cov
s0 = 100*ones(d,1); % intial asset prices
    
% cache mus (drift), cs (transaction proportion)
mus = zeros(d,1);
cs = zeros(d,1);

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

% provided code to generate low rank matrix
[U,S,V] = svd( randn(d,d) );
diagM = diag( [ normrnd(0,1,Mrank,1) ; zeros(d-Mrank,1) ] );
M = 5e-3 * U * diagM * V'; % Randomly generated matrix of rank Mrank
mus = 2e-5 * normrnd(0,1,d,1).^2; % drift
cs = 1e-8 * normrnd(0,1,d,1).^2; % market impact; non-negative

% Initialize Simulation Environment
model_params = struct('mu', mus, 'M', M,'c',cs,'eta',eta);
sim_obj = MarketSimulator(T,s0,model_params);
lambda = 1:0.1:10 ; % risk aversion parameter

%% Run Strategy for EDA
sim_obj = one_over_n(sim_obj, lambda(1));
% % for illustration, I added lambda as input variable in one_over_n function
% % it's just a filler now
% % our eventual strategy function should take sim_obj and lambda as inputs
% % and use both
% % i'm using the same variable name for this section and the next
% % so only run one at a time
% cache cumulative returns, daily returns

return_cum = sim_obj.R_hist;
return_daily = sim_obj.r_hist;

% summary stats
return_mean = mean(return_daily);
stds = std(return_daily, 0);
strat_sharpe = sharpe(return_daily,0);
max_drawdown = maxdrawdown(return_cum);

%% Plots for EDA
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
plot(1:T,return_cum);
title('Portfolio Total Return')

% Plot: drawdown profile
drawdown = zeros(T,1);
for i=1:T
   drawdown(i) = return_cum(i) - max(return_cum(1:i));
end
figure('Name', 'Drawdown Profile')
clf()
plot(drawdown)

% %% Plot efficient frontier (for future use) 
% 
% l = size(lambda,2)
% sim_obj_2 = MarketSimulator(T,s0,model_params);
% 
% % Initialize summary stats
% return_mean_series = zeros(l,1);
% std_series = zeros(l,1);
% 
% % Run strategy over grid of lambdas
% for i = 1:l
%     sim_obj_2 = one_over_n(sim_obj_2, lambda(i));
%     return_mean_series(i) = mean(sim_obj_2.r_hist);
%     std_series(i) = std(sim_obj_2.r_hist, 0);
% end
% 
% % Plot efficient frontier
% figure('Name', 'Efficient Frontier')
% scatter(std_series, return_mean_series);
% grid on;
% xlabel("Std Deviation");
% ylabel("Mean Return");
% title('Efficient Frontier')

