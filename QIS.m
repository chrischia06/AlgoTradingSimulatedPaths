function sigmahat=QIS(Y,k)          % sigmahat:covariance matrix; Y:raw data
%%% EXTRACT sample eigenvalues sorted in ascending order and eigenvectors %%%
[N,p]=size(Y);                      % sample size and matrix dimension
if (nargin<2)||isnan(k)||isempty(k) % default setting
   Y=Y-repmat(mean(Y),[N 1]);       % demean the raw data matrix
   k=1;                             % subtract one degree of freedom
end
n=N-k;                              % adjust effective sample size
c=p/n;                              % concentration ratio
sample=(Y'*Y)./n;                  % sample covariance matrix
[u,lambda]=eig(sample,'vector');    % spectral decomposition
[lambda,isort]=sort(lambda);        % sort eigenvalues in ascending order
u=u(:,isort);                       % eigenvectors follow their eigenvalues
%%% COMPUTE Quadratic-Inverse Shrinkage estimator of the covariance matrix %%%
h=min(c^2,1/c^2)^0.35/p^0.35;             % smoothing parameter
invlambda=1./lambda(max(1,p-n+1):p);      % inverse of (non-null) eigenvalues
Lj=repmat(invlambda,[1 min(p,n)])';       % like  1/lambda_j
Lj_i=Lj-Lj';                          % like (1/lambda_j)-(1/lambda_i)
theta=mean(Lj.*Lj_i./(Lj_i.^2+h^2.*Lj.^2),2);     % smoothed Stein shrinker
Htheta=mean(Lj.*(h.*Lj)./(Lj_i.^2+h^2.*Lj.^2),2); % its conjugate
Atheta2=theta.^2+Htheta.^2;                      % its squared amplitude
if p<=n % case where sample covariance matrix is not singular
   delta=1./((1-c)^2*invlambda+2*c*(1-c)*invlambda.*theta ...
      +c^2*invlambda.*Atheta2);           % optimally shrunk eigenvalues
else % case where sample covariance matrix is singular
   delta0=1./((c-1)*mean(invlambda));     % shrinkage of null eigenvalues
   delta=[repmat(delta0,[p-n 1]);1./(invlambda.*Atheta2)];
end
deltaQIS=delta.*(sum(lambda)/sum(delta)); % preserve trace
sigmahat=u*diag(deltaQIS)*u';             % reconstruct covariance matrix