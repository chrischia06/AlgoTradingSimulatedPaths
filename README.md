Backtesting trading strategies on simulated data in MATLAB

Contributors: [Sandra Ng](https://github.com/sandrangying), [Pearl Yuan](https://github.com/ZiningYuan) and [Chris Chia](https://github.com/chrischia06)

<!-- Cloned from : https://github.com/SIAM-FM21-PC/MathWorks -->

### Code References

Sjöstrand, K., Clemmensen, L., Larsen, R., Einarsson, G., & Ersbøll, B. (2018). SpaSM: A MATLAB Toolbox for Sparse Statistical Modeling. Journal of Statistical Software, 84(10), 1 - 37. doi:http://dx.doi.org/10.18637/jss.v084.i10

+ https://www.jstatsoft.org/article/view/v084i10

Ledoit, O. and Wolf, M.
Quadratic shrinkage for lage covariance matrices.

+ https://www.econ.uzh.ch/en/people/faculty/wolf/publications.html#9

 Asset Allocation - Hierarchical Risk Parity 

+ https://uk.mathworks.com/matlabcentral/fileexchange/70186-asset-allocation-hierarchical-risk-parity


### Experiments

We can broadly characterise potential strategies into the following kinds.
 
+ 'Simple' Momentum. Define some metric for momentum (Z-Score, MA), and assign weights based on this. This is in a sense 'model-free' momentum. Example: `momentum.m`
+ Time Series/Model-based Momentum: Use Gaussian Processes, Deep Neural Networks to forecast returns, and weight accordingly.
+ Risk-parity based Portfolio Optimisation. Portfolio optimisation with other risk measures than just the covariance matrix. Example: `mean_variance.m`. Another example is *Hierarchial Risk Parity* , which involves clustering - group together the assets, then assign weights to the groups (and then the assets in each group). Example:  `hierarchial.m`

+ Reinforcement Learning


### Questions

+ What are some potential strategies to use? (examine literature)
+ How to do Online Portfolio Optimisation?
+ How can we evaluate the strategy beyond mean, variance, Sharpe - choice of metric - and in this simulated setting?


## List of Readings

### Multiple Topics
+ [Advances in Financial Machine Learning, Marcos Lopez De Prado (2018)](https://www.amazon.co.uk/Advances-Financial-Machine-Learning-Marcos/dp/1119482089) - Chapter 13, 14, 16
+ [Machine Learning for Asset Managers, Marcos Lopez De Prado (2020)](https://www.amazon.co.uk/Machine-Learning-Managers-Elements-Quantitative/dp/1108792898)
+ [MFE Financial Econometrics Notes, Kevin Sheppard (2020)](https://www.kevinsheppard.com/teaching/mfe/notes/)
+ [Machine Learning for Factor Investing](http://www.mlfactor.com/backtest.html) - Chapter 5 (Penalised Regression), 12 (Portfolio Backtesting)

#### Backtesting and Synthetic Data
+ https://reasonabledeviations.com/notes/adv_fin_ml/

+ Advances in Financial Machine Learning: Chapter 18 -  metrics, Chapter 5? - Hierarchial Risk parity

+ [Towards Data Science Article about backtesting on synthetic data](https://towardsdatascience.com/ai-in-finance-how-to-finally-start-to-believe-your-backtests-2-3-adfd13da20ec),  and their [code](https://github.com/Rachnog/Advanced-Deep-Trading/blob/master/proba_backtest/Stochastic%20Simulations.ipynb)

+ Machine Learning in Finance, Halperin, Dixon, Bilokon (2020)



#### Portfolio Optimisation, Online Portfolio Optimisation

+ Ideas from [PyPortfolioOpt](https://github.com/robertmartin8/PyPortfolioOpt); choice of risk measure - [Exponentially weighted sample covariance](https://reasonabledeviations.com/2018/08/15/exponential-covariance/)

+ Hudson and Thames articles: [Momentum](https://hudsonthames.org/online-portfolio-selection-momentum/) - , [Introduction](https://hudsonthames.org/introducing-online-portfolio-selection/) - Buy and Hold, Best performer, Constant Weights, [Pattern Matching](https://hudsonthames.org/online-portfolio-selection-pattern-matching/) - [Mean Reversion](https://hudsonthames.org/online-portfolio-selection-mean-reversion/)

+ Daniel Palomar's teaching materials [Portfolio Optimisation with R](https://www.danielppalomar.com/mafs5310---portfolio-optimization-with-r-fall-2020-21.html), [Convex Optimisation](https://www.danielppalomar.com/elec5470---convex-optimization-fall-2020-21.html) 

+ [Risk Parity Portfolio tutorial](https://www.youtube.com/watch?v=xb1Xxf5LQks)

+ [Universal Portfolios, Cover (1996)](http://web.mit.edu/6.454/www/www_fall_2001/shaas/universal_portfolios.pdf) and a [PHD's Blogpost](https://andrewcharlesjones.github.io/posts/2020/01/universalportfolios/)

+ Introduction to Online Convex Optimization https://arxiv.org/pdf/1909.05207.pdf

+ Genetic Algorithms https://github.com/tradytics/eiten/blob/master/strategies/genetic_algo_strategy.py

+ [Online Portfolio Selection: A Survey, Li, Hoi (2012)](https://arxiv.org/pdf/1212.2129.pdf)

+ [Adaptive Bayesian Optimisation for Online Portfolio Selection (2015)](https://www.robots.ox.ac.uk/~sjrob/Pubs/NyikosaOsborneRobertsNipsBayesopt2015.pdf)

+ [Portfolio Allocation for Bayesian Optimization](https://www.cs.ubc.ca/~nando/papers/uaiBayesOpt.pdf)

+ [Portfolio AllocationFrom QP to ML Optimization Algorithms (2019)](http://www.thierry-roncalli.com/download/QP-ML-Portfolio-Optimization.pdf)

+ [C. Yin , R. Perchet & F. Soupé (2021): A practical guide to robust portfolio optimization, Quantitative Finance (2021)](https://www.tandfonline.com/doi/pdf/10.1080/14697688.2020.1849780?needAccess=true)
	+ Uncertainty in the estimates of mean returns.

+ [Performance-based regularizationinmean-CVaR portfolio optimization (2018)](https://arxiv.org/pdf/1111.2091.pdf)

+ [Portfolio construction through handcrafting: motivating, article (2018)](https://qoppac.blogspot.com/2018/12/portfolio-construction-through.html)

#### Using Machine Learning
+ https://discovery.ucl.ac.uk/id/eprint/1474136/1/PhDThesis_ToyinAwoye.pdf

+ https://github.com/AnnaSkarpalezou/Portfolio-Optimization-using-Machine-Learning

+ Prediction-Based Portfolio Optimization Models Using Deep Neural Networks https://ieeexplore.ieee.org/document/9121212

+ ADVANCED METHODS IN PORTFOLIOOPTIMIZATION FOR TRADING STRATEGIES ANDSMART BETA (PHD Thesis) https://www.imperial.ac.uk/media/imperial-college/faculty-of-natural-sciences/department-of-mathematics/math-finance/DELABORIEDELABATUT_JASON_01419438.pdf

+ Intelligent Portfolio Construction:Machine-Learning enabled Mean-VarianceOptimization https://www.imperial.ac.uk/media/imperial-college/faculty-of-natural-sciences/department-of-mathematics/math-finance/Ghali_Tadlaoui_01427211.pdf

+ Deep Learning for Portfolio Optimization https://arxiv.org/abs/2005.13665

+ Machine Learning OptimizationAlgorithms & Portfolio Allocation http://www.thierry-roncalli.com/download/Machine_Learning_Optimization.pdf

+ Machine Learning and Portfolio Optimization http://www.optimization-online.org/DB_FILE/2014/11/4625.pdf

+ Recipe For Quantitative Trading With Machine Learning (2020)

#### Stochastic Portfolio Theory
+ Stochastic Portfolio Theory:A Machine Learning Perspective: https://arxiv.org/pdf/1605.02654.pdf
+ https://quantdare.com/stochastic-portfolio-theory-revisited/
+ Fernholz, R., Karatzas, I. https://www.math.columbia.edu/~ik/FernKarSPT.pdf

#### Hierarchial Risk Parity related
+ The Hierarchical Equal Risk Contribution Portfolio https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3237540

+ Hierarchical Clustering Based Asset Allocation https://papers.ssrn.com/sol3/papers.cfm?abstract_id=2840729

#### Covariance Estimation
+ [MFE Toolbox Documentation](https://www.kevinsheppard.com/files/code/matlab/mfe-toolbox-documentation.pdf)

+ A Robust Estimator of the Efficient Frontier https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3469961

+ Financial Applications of Random Matrix Theory: Old Laces and New Pieces https://arxiv.org/abs/physics/0507111

+ Estimation of Theory-Implied Correlation Matrices https://papers.ssrn.com/sol3/papers.cfm?abstract_id=3484152

+ Random Matrix TheoryandCovariance Estimation http://faculty.baruch.cuny.edu/jgatheral/randommatrixcovariance2008.pdf

#### Rank Deficient Matrices

+ Using SVD to select a linearly independent set of columns http://bwlewis.github.io/GLM/svdss.html


### Libraries
+ [Statistics and Machine Learning Toolbox](https://uk.mathworks.com/help/stats/index.html)
+ MFE-Toolbox
+ MATLAB Econometrics Toolbox, Financial Toolbox

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
