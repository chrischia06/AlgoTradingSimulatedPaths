% Entropic VaR
% Based on https://arxiv.org/ftp/arxiv/papers/1708/1708.05713.pdf

N = 100 % number of samples
p = ones(N, 1)/N % probability of each realization
k = simObj.d % number of risk factors; start by using no. of assets
rebalancing_periods = 1 % this will probably be a function of lambda
warmup = 50 % warmup is not necessary for now actually...

% Generate N market simulators
for i=1:N
    simObj_i = MarketSimulator(T,s0,model_params); 
    %whats the correct syntax to create a new variable simObj_i each time? 
end

w_const = ones(simObj.d,1)/simObj.d; % initialize portfolio weights

% At each time step, obtain the vector of risk factors R_s
% (i'th row of R_s: risk factors for the i'th sample)
% apply PD algorithm to R_s to obtain optimal portfolio weights w*
% for all N samples, simObj_i.step(w*)

for j=1:simObj_i.T
    if j < warmup  
        for i=1:N
            simObj_i.step(w_constant)
        end
    elseif mod(j-warmup, rebalancing_periods) == 0
        R_s = zeros(N, k) % initialize (here, k = no. of assets)
        for i=1:N
            R_s(:,i) = simObj_i.r_hist(end);
        end 
        w_const = PD_algorithm(R_s, p) % Use PD algorithm to optimise weights
        % need to write the PD algorithm? or find a package?
        for i=1:N
            simobj_i.step(w_const)
        end 
    end
end

function w = PD_algorithm(R_s, p) 
    %????????
end