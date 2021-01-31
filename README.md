

Backtesting trading strategies on simulated data in MATLAB

<!-- Cloned from : https://github.com/SIAM-FM21-PC/MathWorks -->

### Experiments
+ Momentum. Define some metric for momentum, and assign weights based on this.
+ Clustering + Momentum. Group together the assets, then assign weights to the groups (and then the assets in each group)
+ Portfolio Optimisation with other risk measures; `mean_variance.m`


### Questions

+ What are some potential strategies to use? (examine literature)
+ How to do Online Portfolio Optimisation?
+ How can we evaluate the strategy beyond mean, variance, Sharpe - choice of metric - and in this simulated setting?


### Topics
+ Backtesting
+ Portfolio Optimisation, Online Portfolio Optimisation
+ Synthetic Data
+ Algorithmic Trading

### Yet to read

+ https://reasonabledeviations.com/notes/adv_fin_ml/

+ Advances in Financial Machine Learning Chapter 18 -  metrics

+ https://towardsdatascience.com/ai-in-finance-how-to-finally-start-to-believe-your-backtests-2-3-adfd13da20ec?gi=64d9d23ca9c4

+ https://github.com/Rachnog/Advanced-Deep-Trading/blob/master/proba_backtest/Stochastic%20Simulations.ipynb

+ http://www.turingfinance.com/random-walks-down-wall-street-stochastic-processes-in-python/

+ https://hudsonthames.org/online-portfolio-selection-momentum/

+ https://hudsonthames.org/introducing-online-portfolio-selection/

+ https://hudsonthames.org/online-portfolio-selection-mean-reversion/

+ https://www.danielppalomar.com/mafs5310---portfolio-optimization-with-r-fall-2020-21.html

+ https://palomar.home.ece.ust.hk/MAFS5310_lectures/slides_backtesting.pdf

+ https://www.danielppalomar.com/teaching.html

+ https://github.com/robertmartin8/PyPortfolioOpt

+ Machine Learning in Finance

+ --Ernie Chan books--

## Development

**30/01/2021**
+ Tried a Mean-Variance (or quadratic optimisation) does not work as the covariance matrix is singular (given it is low rank). Tested constraining weights, but this makes it similar to the 1/N approach. Tested using Correlation Matrix instead of covariance (produces an error that the Hessian for the quadratic optimisation problem is not symmetric which is strange)
+ Tried a PCA weighted approach, which performs poorly. Tested using factor 1 (possibly a market factor?),  factor2, and - factor2 (possibly market neutral factors). Both underperform the 1/N approach.




