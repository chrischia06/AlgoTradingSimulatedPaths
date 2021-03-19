Backtesting trading strategies on simulated data in MATLAB

Contributors: [Sandra Ng](https://github.com/sandrangying), [Chris Chia](https://github.com/chrischia06), and [Pearl Yuan](https://github.com/ZiningYuan)

<!-- Cloned from : https://github.com/SIAM-FM21-PC/MathWorks -->

[![.github/workflows/main.yml](https://github.com/chrischia06/AlgoTradingSimulatedPaths/actions/workflows/main.yml/badge.svg)](https://github.com/chrischia06/AlgoTradingSimulatedPaths/actions/workflows/main.yml)

[Timeline of Development](DEVELOPMENT.md)

[Complete List of Literature References](REFERENCES.md)

### Currently Implemented / Work in Progress

+ `one_over_n.m` - one-over-n weighted strategy

**Portfolio Optimisation**

+ `semicovariance.m` - Risk Parity approach using semivariance (as a quadratic optimisation problem)
+ `ridge_shrinkage.m` - Risk Parity approach, adding lambda I to estimated covariance matrix and applying quadratic optimisation	
+ `mean_variance.m` - standard Markowitz Mean-Variance Portfolio Optimisation
+ `mean_correlation.m` - Risk parity approach, using correlation matrix instead of covariance
+ `hierarchial.m` - Hierarchial Risk Parity
+ `pca_optimisation.m` - Construct covariance matrix from PCA factors, and use in quadratic Optimisation
+ `cvar_optimisation.m` - CVaR portfolio optimisation as a linear programming problem
+ `mad_optimisation.m` - MAD portfolio optimisation as a linear programming problem

**Momentum**
+ `current_price_weighted.m` - current price-Weighted Strategy
+ `macd` - allocate weights based on MACD oscillator

**Online**
+ `exp_grad_proj.m` - exponential gradient, projective update
+ `exp_grad_mult.m` - exponential gradient, multiplicative update
+ `exp_grad_max.m` - exponential gradient, expectation maximisation

#### In Progresss / To Add

+ Entropic VaR
+ Conditional Drawdown at Risk

### Code References

Sjöstrand, K., Clemmensen, L., Larsen, R., Einarsson, G., & Ersbøll, B. (2018). SpaSM: A MATLAB Toolbox for Sparse Statistical Modeling. Journal of Statistical Software, 84(10), 1 - 37. doi:http://dx.doi.org/10.18637/jss.v084.i10

+ https://www.jstatsoft.org/article/view/v084i10

Ledoit, O. and Wolf, M.
Quadratic shrinkage for lage covariance matrices.

+ https://www.econ.uzh.ch/en/people/faculty/wolf/publications.html#9

 Asset Allocation - Hierarchical Risk Parity 

+ https://uk.mathworks.com/matlabcentral/fileexchange/70186-asset-allocation-hierarchical-risk-parity

Mean Absolute Deviation
+ https://github.com/FadyShoukry/MIE376-Robust-MAD


### Libraries
+ [Statistics and Machine Learning Toolbox](https://uk.mathworks.com/help/stats/index.html)
+ MFE-Toolbox
+ MATLAB Econometrics Toolbox, Financial Toolbox
+ https://github.com/dcajasn/Riskfolio-Lib
+ https://github.com/microsoft/qlib
+ https://github.com/AI4Finance-LLC/FinRL-Library
+ https://uk.mathworks.com/matlabcentral/fileexchange/9061-risk-and-asset-allocation?s_tid=prof_contriblnk
+ https://hudson-and-thames-portfoliolab.readthedocs-hosted.com/en/latest/utils/risk_metrics.html
+ https://github.com/robertmartin8/PyPortfolioOpt
+ https://cran.r-project.org/web/packages/parma/vignettes/Portfolio_Optimization_in_parma.pdf


