function simObj = current_price_weighted(simObj, lambda)
    if nargin < 2
        lambda = 0.5;
    end
    simObj.reset(); % reset simulation environment
    % this is essentially the diversity-weighted portfolio
    % Fernholz, R. 1999
    % if p < 0, then we weight small caps more (mean reversion)
    % and p > 0, large caps more (momentum)
    % so need a function f: lambda -> optimal p
    for i=1:simObj.T
       cap = simObj.s_cur ./ sum(simObj.s_cur); % price weighted portfolio vector
       w_const = cap .^ (1 / lambda);
       w_const = w_const ./ sum(w_const);
       simObj.step(w_const);
    end
end