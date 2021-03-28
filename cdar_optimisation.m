function simObj = cdar_optimisation(simObj,lambda, warmup, frequency)
    % conditional drawdown at risk
    % from https://github.com/Siberia-yuan/CDaR-Portfolio/blob/master/CDaRPortfolio.m
    % https://uk.mathworks.com/matlabcentral/answers/231144-how-to-implement-conditional-drawdown-at-risk-with-linear-programming
    if nargin<2
        lambda = 0.5;
    end
   
    simObj.reset(); % reset simulation environment
    options = optimset('Display','Off');
    warning('off');
    min_weight_per_asset    = 0.00; % default
    max_weight_per_asset    = 1.00; % default
    constrain = 0.15;
    for i=1:simObj.T
        if i < warmup
            w_const = ones(simObj.d,1)/simObj.d;
        elseif mod(i, frequency) == 0
            cumuSum=zeros(i,simObj.d);
            records=zeros(1,simObj.d);
            rets = diff(log(simObj.s_hist(:,1:i)),1,2)';
            [m,n] = size(rets);   
            for j=1:m
                for k=1:n
                    records(k)=records(k)+rets(j,k);
                    cumuSum(j,k)=cumuSum(j,k)+records(k);
                end
            end
            meanPort=-mean(rets);
            target=[meanPort zeros(1,1+m)];
            %target=[meanPort];
            A=[];
            b=[];

            %x<=1 number is n
            for i_0=1:n
                A=[A;[zeros(1,i_0-1) 1 zeros(1,n+1+m-i_0)]];
                %A=[A;[zeros(1,i_0-1) 1 zeros(1,n-i_0)]];
            end
            b=[b ones(1,n)];

            %-x<=0 number is n
            for i_1=1:n
                A=[A;[zeros(1,i_1-1) -1 zeros(1,n+1+m-i_1)]];
                %A=[A;[zeros(1,i_1-1) -1 zeros(1,n-i_1)]];
            end
            b=[b zeros(1,n)];

            %sum X=1
            %sum X<=1
            A=[A;[ones(1,n) zeros(1,1+m)]];
            %A=[A;[ones(1,n)]];
            b=[b 1];
            %sum -X<=-1
            A=[A;[-1*ones(1,n) zeros(1,1+m)]];
            %A=[A;[-1*ones(1,n)]];
            b=[b -1];

            % %u0=0
            % %u0<=0;
            % %-u0<=0;
            % 
            A=[A;[zeros(1,n) 1 zeros(1,m)]];
            A=[A;[zeros(1,n) -1 zeros(1,m)]];
            b=[b 0];
            b=[b 0];


            %uk-1-uk<=0

            for i_2=1:m
                A=[A;[zeros(1,n+i_2-1) 1 -1 zeros(1,m-i_2)]];
            end
            b=[b zeros(1,m)];

            %ykx-uk<=0

            for i_3=1:m
                temp=[];
                for i_4=1:n
                    temp=[temp cumuSum(i_3,i_4)];
                end
                A=[A;[temp zeros(1,i_3) -1 zeros(1,m-i_3)]];
            end
            b=[b zeros(1,m)];

            % %uk-ykx<=constrain

            for i_5=1:m
                temp1=[];
                for i_6=1:n
                    temp1=[temp1 -1*cumuSum(i_5,i_6)];
                end
                A=[A;[temp1 zeros(1,i_5) 1 zeros(1,m-i_5)]];       
            end

            b=[b constrain*ones(1,m)];
            [x,~]=linprog(target,A,b);
            w_const = x(1:n);
            w_const = w_const / sum(w_const);
        end
        simObj.step(w_const);
    end
end