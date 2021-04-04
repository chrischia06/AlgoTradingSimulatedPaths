classdef MarketSimulator < handle
   properties
      d {mustBeInteger,mustBePositive}
      T {mustBeInteger,mustBePositive}
      t {mustBeInteger,mustBeNonnegative}
      r_hist(:,1) {mustBeReal}
      R_hist(:,1) {mustBeReal}
      P_hist(:,1) {mustBeReal}
      r_cur {mustBeReal,mustBeFinite}
      s0(:,1) {mustBeReal,mustBeFinite,mustBeNonnegative}
      s_hist(:,:) {mustBeReal}
      s_cur(:,1) {mustBeReal,mustBeFinite,mustBeNonnegative}
      w_hist(:,:) {mustBeReal}
      w_cur(:,1) {mustBeReal,mustBeFinite,mustBeNonnegative}
      eta {mustBeReal,mustBeFinite,mustBeNonnegative}
   end
   properties (Access = private)
      M(:,:) {mustBeReal,mustBeFinite}
      c(:,1) {mustBeReal,mustBeFinite}
      mu(:,1) {mustBeReal,mustBeFinite}
   end
   methods
      function obj = MarketSimulator(T,s0,paramStruct)
        % Initialize first three values 
        obj.T = T;
        obj.s0 = squeeze(s0)';
        obj.d = size(squeeze(s0),1);
        d = obj.d;
        % Validate Sizes of paramStruct items and assign
        mu = paramStruct.mu;
        c = paramStruct.c;
        M = paramStruct.M;
        if isvector(mu)&&(numel(mu)==d)
            obj.mu = squeeze(mu)';
        else
            error('mu is of incorrect size')
        end
        if isvector(c)&&(numel(mu)==d)
            obj.c = c;
        end
        if ismatrix(M)&&(size(M,1)==d)&&(size(M,2)==d)
            obj.M = M;
        end
        obj.eta = paramStruct.eta;
        % Run a first reset to allocate memory
        obj = obj.reset();
      end
      function obj = reset(obj)
         obj.t=0;
         obj.s_hist = NaN(obj.d,obj.T + 1);
         obj.w_hist = NaN(obj.d,obj.T);
         obj.r_hist = NaN(1,obj.T);
         obj.P_hist = NaN(1,obj.T);
         obj.R_hist = NaN(1,obj.T);
         obj.s_cur = obj.s0;
         obj.s_hist(:,1) = obj.s0;
      end
      function obj = step(obj,w)
          if obj.t>=obj.T
             error("trading period terminated (t=T), no more actions may be taken");
          end
          if size(w,1)~=obj.d
              error('provided weights have incorrect size.');
          end
          if ~obj.isInSimplex(w) 
              % If weights not in simplex, project to simplex
              warning('provided weights lie outside of simplex.');
              w = max(w,0);
              w = w./sum(w);
          end
         % Step Time Forward
         obj.t = obj.t+1;
         % Update weight-related state variables
         obj.w_cur = w;
         obj.w_hist(:,obj.t) = obj.w_cur;
         if obj.t==1
             u_delta = 0; % Updated 3-18-21: change in positions
             obj.P_hist(obj.t)=1;
         else
             obj.P_hist(obj.t)=(1+obj.r_hist(obj.t-1,:)).*obj.P_hist(obj.t-1);
             u_cur = obj.w_cur.*obj.P_hist(obj.t)./obj.s_cur;
             u_last = obj.w_hist(:,obj.t-1).*obj.P_hist(obj.t-1)./obj.s_hist(:,obj.t-1);
             u_delta = u_cur - u_last; % Updated 3-18-21: change in positions
         end
         % Generate stock-price increments and calculate stock return
         xi_cur = normrnd(0,1,obj.d,1);
%          xi_cur = 1 / sqrt(2)  * trnd(4, obj.d, 1);
         s_last = obj.s_cur;
         obj.s_cur = obj.genPriceStep(obj.s_cur,u_delta,xi_cur); % Updated 3-18-21: takes change in positions rather than changes in weights
         obj.s_hist(:,obj.t+1) = obj.s_cur;
         r_s_cur = (obj.s_cur-s_last)./s_last;
         % Calculate new portfolio return
         obj.r_cur = dot(obj.w_cur,r_s_cur) - obj.eta*norm(u_delta,1); % Updated 3-18-21: takes change in positions rather than changes in weights
         obj.r_hist(obj.t,:) = obj.r_cur;
         obj.R_hist(obj.t,:) = obj.getTotalReturn(obj.r_hist);
      end
      function p = getState(obj)
          % Return state struct
          p = struct('t',obj.t, ...
                     's_cur',obj.s_cur, ...
                     'w_cur',obj.w_cur, ...
                     'r_cur',obj.r_cur, ...,
                     'cum_ret',obj.getTotalReturn(obj.r_hist));
      end
      function ret = getTotalReturn(~,r_vec)
          % Compute total return
          retVec = r_vec(~isnan(r_vec))+1.0;
          retVec = max(retVec,0.0);
          ret = prod(retVec);
      end
      function r = isInSimplex(~,w)
         if all(w>=0)&&(sum(w)-1<1e7*eps)
             r = true;
         else
             r = false;
         end
      end
   end
   methods (Access = private) % log stock price dynamics under market impact
       function snew = genPriceStep(obj,s,du,xi) % 3-18-21: Changed to accept du
           S = log(s);
           dS = obj.mu + obj.mktImpact(du) + obj.M * xi;
           snew = exp(S + dS);
       end
       function imp = mktImpact(obj,du) %kappa function % 3-18-21: Changed to accept du
           imp = obj.c .* sign(du) .* sqrt(abs(du));
       end
   end
end
