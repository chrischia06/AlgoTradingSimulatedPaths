%%
clear;
close all hidden;

%%% Set Strategy Here
% description = "";
description = "Semivariance";

filename = ('logs/frontier/' + description + ' ' +...
            string(datetime(now,'ConvertFrom','datenum')));
        
warmup = 100;
frequency = 50;
% lower_bound = 0;
% upper_bound = 1;
chosen_strategy = @semicovariance;
hyperparams = sprintf("warmup = %d, frequency = %d", warmup, frequency);
lambda_grid = [1.25 1.5 1.75 2.25 2.5 3.75]';
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
skew_strat =skewness(terminal_rets, [],2);
kurt_strat = kurtosis(terminal_rets, [], 2);
loss_values = mean_strat - lambda_grid .* var_strat;

% efficient frontier
[vals, idx] = sortrows([mean_strat std_strat], 2);
best = [];
temp = 0;
for j = 1:length(vals)
    if vals(j) > temp
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


loss_values_table = array2table([lambda_grid  loss_values mean_strat std_strat skew_strat kurt_strat],...
                          'VariableNames', {'Lambda', 'Loss','E[R]','Std[R]','Skew[R]', 'Kurt[R]'})
writetable(loss_values_table, filename + '.txt');
latex(vpa([lambda_grid loss_values], 4))

%% MERGE TABLES
% t1 = readtable("logs/frontier/Semivariance 29-Mar-2021 11:09:15.txt")
% t2 = readtable("logs/frontier/Semivariance 29-Mar-2021 12:51:28.txt")
% t3 = readtable("logs/frontier/Semivariance 29-Mar-2021 14:43:13.txt")
% t_final = sortrows([t1 ; t2; t3])
% 
% [vals, idx] = sortrows([t_final.E_R_ t_final.Std_R_], 2);
% best = [];
% temp = 0;
% for j = 1:length(vals)
%     if vals(j) > temp
%         temp = vals(j, 1);
%         best = [best j];
%     end
% end
% 
% figure()
% scatter(t_final.Std_R_, t_final.E_R_);
% hold on;
% plot(vals(best,2), vals(best,1))
% grid on;
% xlabel("Std Deviation");
% ylabel("Mean Return");
% % yline(0, 'r--')
% title('Monte Carlo Efficient Frontier')
% saveas(gcf,filename + '-Efficient-Frontier.png')
% 
% 
% 
% figure()                   
% plot(t_final.Lambda, t_final.Loss)
% grid on;
% xlabel('Lambda');
% ylabel('Quadratic Utility');
% title('Quadratic Utility Lambda');
% saveas(gcf,filename + '-Utility-Curve.png')
% 
% figure('Name', 'Mean[R], Std[R] against Lambda')
% yyaxis left
% plot(t_final.Lambda, t_final.E_R_)
% grid on;
% ylabel('E[R | lambda]')
% yyaxis right
% plot(t_final.Lambda, t_final.Std_R_)
% ylabel('Std[R | lambda]')
% title('Mean[R], Std[R] against Lambda')
% saveas(gcf,filename + '-Mean-Std.png')
