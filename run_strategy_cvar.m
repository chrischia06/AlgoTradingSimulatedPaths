clear;
close all hidden;
%% Model and Simulator Initialization 

% Initialize Model Parameters
T = 250;
d = 50;
eta = 0.0002;

Mrank = floor(0.25*d);
[U,S,V] = svd( randn(d,d) );
diagM = diag( [ normrnd(0,1,Mrank,1) ; zeros(d-Mrank,1) ] );
M = 5e-3 * U * diagM * V'; % Randomly generated matrix of rank Mrank

mu = 2e-5 * normrnd(0,1,d,1).^2;
c = 1e-8 * normrnd(0,1,d,1).^2;
s0 = 100*ones(d,1);

% Initialize Simulation Environment
model_params = struct('mu',mu,'M',M,'c',c,'eta',eta);
sim_obj = MarketSimulator(T,s0,model_params);

%% Visualization of a Single Simulation for a Strategy

% Run strategy on environment
sim_obj = cvar_optimisation(sim_obj);

% Plot simulated price history
figure('Name','Portfolio Weight Evolution');
clf();
plot(1:(T+1),sim_obj.s_hist);
grid on;
title('Stock Price Evolution')

% Plot portfolio weights
figure('Name','Portfolio Weight Evolution');
clf();
plot(1:T,sim_obj.w_hist);
grid on;
title('Portfolio Weight Evolution')

% Plot portfolio 1-period returns + mean
figure('Name','Portfolio 1-Period-Return Evolution');
clf();
hold on;
plot(1:T,sim_obj.r_hist);
plot(1:T,ones(1,T) * mean(sim_obj.r_hist))
hold off;
grid on;
title('Portfolio 1-Period-Return Evolution')

% Plot portfolio cumulative growth
figure('Name','Portfolio Total Return');
clf();
plot(1:T,sim_obj.R_hist-1);
grid on;
title('Portfolio Total Return')


%% Computing the Target Objective for a Strategy

% nsims = 30;
% lambda = 0.5:0.5:5;
% 
% loss_value = zeros(1, size(lambda,2));
% 
% tic;
% 
% stds = zeros(1, size(lambda,2));
% mean_strat = zeros(1, size(lambda,2));
% 
% for i = 1:size(lambda,2)
%     cumret_array = zeros(nsims,1);
%     for k=1:nsims
%         % Store each simulation's result in array
%         sim_obj = cvar_optimisation(sim_obj,lambda(i));
%         cumret_array(k) = sim_obj.R_hist(end);
%     end
%     stds(i) = std(cumret_array);
%     mean_strat(i) = mean(cumret_array);
%     loss_value(i) = mean(cumret_array) - 0.5*lambda(i)*var(cumret_array);
% end
% 
% figure('Name','Efficient Frontier')
% scatter(stds, mean_strat);
% grid on;
% xlabel("Std Deviation");
% ylabel("Mean Return");
% ylim([1, 1.005])
% 
% 
% running_time = toc;
% 
% loss_values = array2table(loss_value, 'VariableNames', string(lambda))

%% How do the results vary with Beta? 
% nsims = 30;
% beta = 0.5:0.05:0.95;
% 
% stds = zeros(1, size(beta,2));
% mean_strat = zeros(1, size(beta,2));
% 
% tic;
% for i = 1:size(beta,2)
%     cumret_array = zeros(nsims,1);
%     for k=1:nsims
%         % Store each simulation's result in array
%         sim_obj = cvar_optimisation(sim_obj,beta(i));
%         cumret_array(k) = sim_obj.R_hist(end);
%     end
%     stds(i) = std(cumret_array);
%     mean_strat(i) = mean(cumret_array);
% end
% running_time = toc;
% 
% array2table([stds; mean_strat], 'VariableNames', string(beta), 'RowNames', {'Std', 'Mean Return'})
% 
% 
% figure('Name', 'Stds vs Beta')
% plot(beta, stds)
% xlabel('Beta')
% ylabel('Stds')
% 
% figure('Name', 'Mean Return vs Beta')
% plot(beta, mean_strat)
% xlabel('Beta')
% ylabel('Mean Return')

%% How do the results vary with rebalancing frequency?
% nsims = 50;
% rebalancing_periods = 5:5:50;
% 
% tic;
% for i = 1:size(rebalancing_periods,2)
%     cumret_array = zeros(nsims,1);
%     for k=1:nsims
%         % Store each simulation's result in array
%         sim_obj = cvar_optimisation(sim_obj,rebalancing_periods(i));
%         cumret_array(k) = sim_obj.R_hist(end);
%     end
%     stds(i) = std(cumret_array);
%     mean_strat(i) = mean(cumret_array);
% end
% running_time = toc;
% 
% array2table([stds; mean_strat], ...
% 'VariableNames', string(rebalancing_periods),...
%  'RowNames', {'Std', 'Mean Return'})
% 
% figure('Name', 'Stds vs Rebalancing Frequency')
% plot(rebalancing_periods, stds)
% xlabel('Rebalancing Frequency')
% ylabel('Stds')
% 
% figure('Name', 'Mean Return vs Rebalancing Frequency')
% plot(rebalancing_periods, mean_strat)
% xlabel('Rebalancing Frequency')
% ylabel('Mean Return')