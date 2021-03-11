## Development

**30/01/2021**
+ Tried a Mean-Variance (or quadratic optimisation) does not work as the covariance matrix is singular (given it is low rank). Tested constraining weights, but this makes it similar to the 1/N approach. Tested using Correlation Matrix instead of covariance (produces an error that the Hessian for the quadratic optimisation problem is not symmetric which is strange)
+ Tried a PCA weighted approach, which performs poorly. Tested using factor 1 (possibly a market factor?),  factor2, and - factor2 (possibly market neutral factors). Both underperform the 1/N approach.


**31/01/2021**
+ Time Series Momentum - OLS Regression isn't possible, nor its multivariate equivalent (`mvregress` in MATLAB) given the covariance matrix is singular. Possible workarounds - use Ridge Regression, Deep Learning, Trees?
+ Looked into online portfolio selection articles from Hudson and Thames, which is in turn based on [Li, Hoi (2012), Online Portfolio Selection: A Survey](https://arxiv.org/pdf/1212.2129.pdf)
+ Tried using Hierarchial Risk Parity using code from the [MATLAB website](https://uk.mathworks.com/matlabcentral/fileexchange/70186-asset-allocation-hierarchical-risk-parity). This is the best performing strategy so far, in terms of Mean Sharpe.

**04/02/2021**
+ Meeting to discuss approach. Sandra suggested restricing simulations to `N = 1`, and then varying risk-aversion parameter lambda.

**06/02/2021**
+ Testing Lasso based momentum

**16/02/2021**
+ Tried CVaR based portfolio optimisation based on : [this](https://pyportfolioopt.readthedocs.io/en/latest/EfficientFrontier.html?highlight=CVaR#id4), and [this](https://github.com/portfolio-optimization-hx/portfolio_optimization), which are in turn based on the paper: [Rockafellar, R.; Uryasev, D. (2001). Optimization of conditional value-at-risk](https://pyportfolioopt.readthedocs.io/en/latest/EfficientFrontier.html?highlight=CVaR&fbclid=IwAR01aak1B8ai-FcvZJVm3Y4eGFboIqaRi50MgQO_pJ9ynTZId3X4URG9Yxg#id4)
+ Added working PCA-based portfolio optimisation

**22/02/2021: Summarised comments from Albina**

+ The stock price model will never generate stocks with trend reversal
+ On this model, cVaR optimisation identifies stocks with negative price trend and takes their weights to 0. Has the potential to be volatile -- may not necessarily maximise our quadratic utility function
+ Two contradicting considerations:
	+ Varying lambda is about diversification; higher lambda --> should invest in greater number of stocks
	+ Square root market impact function --> should invest in smaller number of stocks. Given two highly correlated stocks, should only invest in one of them. In particular, if lambda is high, we might also want to also invest in stocks with negative drift
+ She would try: PCA but use lasso regression to restrict the number of stocks included in the PC1, then do standard Markowitz on the representative assets
+ Alternative (extension): quadratic utility function is first order of power utility function. Power utility --> solve via dynamic programming is faster solution than Markowitz (by Mark Davis from Imperial)

**23/02/2021**

+ Slight refactor of codebase