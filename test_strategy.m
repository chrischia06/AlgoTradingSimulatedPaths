function simObj = test_strategy(simObj)
    simObj.reset(); % reset simulation environment
    for i=1:simObj.T
      w = get_strategy_weights(...) % your strategy should return the weights
      simObj.step(w);
end