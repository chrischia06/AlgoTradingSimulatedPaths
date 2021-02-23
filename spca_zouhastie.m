function [SL SD L D paths] = spca_zouhastie(X, Gram, K, lambda2, stop, maxSteps, convergenceCriterion, verbose)

% SPCA  The SPCA algorithm of Zou et. al [1] for computing sparse principal

% components.

%

%    [SL SV L D PATHS] = SPCA(X, GRAM, K, LAMBDA2, STOP) computes sparse

%    principal components of the data in X. X is an n x p matrix where n is

%    the number of observations and p is the number of variables. X should

%    be centered and normalized such that the column means are 0 and the

%    column Euclidean lengths are 1. Gram = X'*X is the p x p Gram matrix.

%    Either X, Gram or both must be supplied. Pass an empty matrix as

%    argument if either X or Gram is missing.

%    K is the desired number of sparse principal components.

%    LAMBDA2 specifies the positive ridge (L2) term coefficient. If LAMBDA2

%    is set to infinity, soft thresholding is used to calculate the

%    components. This is appropriate when p>>n and results in a

%    significantly faster algorithm.

%    STOP is the stopping criterion. If STOP is negative, its absolute

%    (integer) value corresponds to the desired number of non-zero

%    variables. If STOP is positive, it corresponds to an upper bound on

%    the L1-norm of the BETA coefficients. STOP = 0 results in a regular

%    PCA. Supply either a single STOP value, or a vector of K STOP values,

%    one for each component.

%

%    SPCA(X, GRAM, K, LAMBDA2, STOP, MAXSTEPS) sets the maximum number of

%    iterations before the algorithm is terminated. Default is MAXSTEPS =

%    300.

%

%    SPCA(X, GRAM, K, LAMBDA2, STOP, MAXSTEPS, CONVERGENCECRITERION)

%    specifies a threshold on the difference between the sparse loading

%    matrix between iterations. When the difference falls below this

%    threshold the algorithm is said to have converged. Default is

%    CONVERGENCECRITERION = 1e-3.

%

%    SPCA(X, GRAM, K, LAMBDA2, STOP, MAXSTEPS, CONVERGENCECRITERION,

%    VERBOSE) with VERBOSE set to true will turn on display of algorithm

%    information. Default is VERBOSE = false.

%

%    SPCA returns SL, the sparse loading vectors (principal component

%    directions); SV, the variances of each sparse component; L and V, the

%    loadings and variances of regular PCA; and PATHS, a struct containing

%    the loading paths for each component as functions of iteration number.

%

%    Note that if X is omitted, the absolute values of SV cannot be

%    trusted, however, the relative values will still be correct.

%

%    Example

%    -------

%    Compare PCA and SPCA on a data set with three latent components, one

%    step edge, one component with a single centered Gaussian and one

%    component with two Gaussians spread apart.

%

%    % Fix stream of random numbers

%    s1 = RandStream.create('mrg32k3a','Seed', 11);

%    s0 = RandStream.setDefaultStream(s1);

%    % Create synthetic data set

%    n = 1500; p = 500;

%    t = linspace(0, 1, p);

%    pc1 = max(0, (t - 0.5)> 0);

%    pc2 = 0.8*exp(-(t - 0.5).^2/5e-3);

%    pc3 = 0.4*exp(-(t - 0.15).^2/1e-3) + 0.4*exp(-(t - 0.85).^2/1e-3);

%    X = [ones(n/3,1)*pc1 + randn(n/3,p); ones(n/3,1)*pc2 + ...

%      randn(n/3,p); ones(n/3,1)*pc3 + randn(n/3,p)];

%    % PCA and SPCA

%    [U D V] = svd(X, 'econ');

%    d = sqrt(diag(D).^2/n);

%    [SL SD] = spca(X, [], 3, inf, -[250 125 100], 3000, 1e-3, true);

%    figure(1)

%    plot(t, [pc1; pc2; pc3]); axis([0 1 -0.2 1.2]);

%    title('Noiseless data');

%    figure(2);

%    plot(t, X);  axis([0 1 -6 6]);

%    title('Data + noise');

%    figure(3);

%    plot(t, -d(1:3)*ones(1,p).*(V(:,1:3)'));  axis([0 1 -0.2 1.2]);

%    title('PCA');

%    figure(4)

%    plot(t, -sqrt(SD)*ones(1,p).*(SL'));  axis([0 1 -0.2 1.2]);

%    title('SPCA');

%    % Restore random stream

%    RandStream.setDefaultStream(s0);

%

%    References

%    -------

%    [1] H. Zou, T. Hastie, and R. Tibshirani. Sparse Principal Component

%    Analysis. J. Computational and Graphical Stat. 15(2):265-286, 2006.

%    [2] K. Sjöstrand, L.H. Clemmensen, M. Mørup. SpaSM, a Matlab Toolbox

%    for Sparse Analysis and Modeling. Journal of Statistical Software

%    x(x):xxx-xxx, 2010.

 

%% Input checking and initialization

if nargin < 8

  verbose = 0;

end

if nargin < 7

  convergenceCriterion = 1e-3;

end

if nargin < 6

  maxSteps = 300;

end

if nargin < 5

  error('SpaSM:spca', 'Minimum five arguments are required');

end

if nargout == 5

  storepaths = 1;

else

  storepaths = 0;

end

if isempty(X) && isempty(Gram)

  error('SpaSM:spca', 'Must supply a data matrix or a Gram matrix or both.');

end

 

%% SPCA algorithm setup

 

if isempty(X)

  % Infer X from X'*X

  [Vg Dg] = eig(Gram);

  X = Vg*sqrt(abs(Dg))*Vg';

end

 

[n p] = size(X);

 

% Number of sparse loading vectors / principal components

K = min([K p n-1]);

 

% Standard PCA (starting condition for SCPA algorithm)

[U S L] = svd(X, 'econ');

D = diag(S).^2/n; % PCA variances

 

% Replicate STOP value for all components if necessary 

if length(stop) ~= K

  stop = stop(1)*ones(1,K);

end

 

% allocate space for loading paths

if storepaths

  paths(1:K) = struct('loadings', []);

end

 

% setup SPCA matrices A and B

A = L(:,1:K);

B = zeros(p,K);

 

% setup sparse loading vector

SL = zeros(p,K); % B normalized to unit column length

 

step = 0; % current algorithm iteration number

converged = false;

 

%% SPCA loop

while ~converged && step < maxSteps

  step = step + 1;

   

  if verbose && ~mod(step, 10)

    disp(['Iteration ' num2str(step) ', convergence criterion = ' num2str(norm(SL_old - SL))]);

  end

   

  SL_old = SL;

 

  % for each component

  for j = 1:K

    if lambda2 == inf

      % Soft thresholding, calculate beta directly

      if isempty(Gram)

        AXX = (A(:,j)'*X')*X;

      else

        AXX = A(:,j)'*Gram;

      end

      if stop(j) < 0 && -stop(j) < p

        sortedAXX = sort(abs(AXX), 'descend');

        B(:,j) = ( sign(AXX).*max(0, abs(AXX) - sortedAXX(-floor(stop(j)) + 1)) )';

      else

        B(:,j) = ( sign(AXX).*max(0, abs(AXX) - stop(j)) )';

      end

    else

      % Find beta by elastic net regression

      B(:,j) = larsen(X, X*A(:,j), lambda2, stop(j), Gram, false, false);

    end

  end

   

  % Normalize coefficients such that loadings has Euclidean length 1

  B_norm = sqrt(sum(B.^2));

  B_norm(B_norm == 0) = 1;

  SL = B./(ones(p,1)*B_norm);

 

  % converged?

  converged = norm(SL_old - SL) < convergenceCriterion;

   

  % Save loading path data

  if storepaths

    for k = 1:K

      paths(k).loadings = [paths(k).loadings SL(:,k)];

    end

  end

   

  % Update A

  if isempty(Gram)

    [U S V] = svd(X'*(X*B), 'econ');

  else

    [U S V] = svd(Gram*B, 'econ');

  end

  A = U*V';

end

 

%% Order modes such that maximal total explained variance is achieved

SS = X*SL; % sparse scores

SD = zeros(K, 1); % adjusted variances

O = 1:K; % ordering

for k = 1:K

  SS_var = sum(SS.^2)/n; % variances of scores

  [SD(k) max_col] = max(SS_var);

  Sc = SS(:,max_col); % column to factor out

  Sc_norm = Sc'*Sc;

  if Sc_norm > eps,

    O(O == max_col) = O(k);

    O(k) = max_col;

    SS(:,O) = SS(:,O) - Sc*(Sc'*SS(:,O))/Sc_norm; % factor out chosen column

  end

end

SL = SL(:,O); % change order of loadings

 

%% Print information

if verbose

  if p < 20

    fprintf('\n\n --- Sparse loadings ---\n');

    disp(SL)

  end

  fprintf('\n --- Adjusted variances, Variance of regular PCA ---\n');

  disp([SD/sum(D) D(1:K)/sum(D)])

  fprintf('Total: %3.2f%% %3.2f%%', 100*sum(SD/sum(D)), 100*sum(D(1:K)/sum(D)));

  fprintf('\nNumber of nonzero loadings:');

  disp(sum(abs(SL) > 0));

end
