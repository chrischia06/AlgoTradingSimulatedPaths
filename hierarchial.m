function simObj = hierarchial(simObj)
    % Cluster stocks together by return?
    % assign weight to each cluster
    % assign weight to each asset in cluster
    % https://uk.mathworks.com/help/stats/cluster-analysis.html
    % https://colab.research.google.com/drive/1IpYLBmVwAnL1g_99o5BIhcZ9V6_Ij0j7
    % https://uk.mathworks.com/help/stats/hierarchical-clustering-12.htm
    % https://uk.mathworks.com/matlabcentral/fileexchange/70186-asset-allocation-hierarchical-risk-parity
    simObj = simObj.reset(); % reset simulation environment
     % equal weighted portfolio vector
    freq = 30;
    warmup = 30;
    for i=1:simObj.T
        if i < warmup
            w_const = ones(simObj.d,1)/simObj.d;
        else
            if mod(i, freq) == 0
                rets = diff(log(simObj.s_hist(:,1:i)),1,2);
                assetCovar = corr(rets');
                wgtHRP = allocByBisectHRP(assetCovar);
                w_const = wgtHRP;
                w_const = w_const ./ sum(w_const);
            end
        end
        simObj = simObj.step(w_const)   ;
    end
end