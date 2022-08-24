function lik = lik_asym0_sticky(x,data)
    
    % Likelihood function for the Two Learning Rate model for Dorfman, et al., 2019
    % Q-learning on two-armed bandit with separate
    % learning rates for positive and negative outcomes.
    %
    % USAGE: lik = lik_asym_sticky(x,data)
    %
    % INPUTS:
    %   x - parameters:
    %       x(1) - inverse temperature
    %       x(2:7) - learning rates
    %       x(8) - stickiness
    %   data - structure with the following fields
    %          .c - [N x 1] choices
    %          .r - [N x 1] rewards
    %
    % OUTPUTS:
    %   lik - log-likelihood
    %
    % Sam Gershman, June 2017
    
    % parameters
    b = x(1);           % inverse temperature
    lr_pos = x(2);  % learning rate (positive outcome)
    lr_neg = x(3);  % learning rate (negative outcome)
    sticky = x(4);      % stickiness
    
    % initialization
    lik = 0;             % log-likelihood
    lr = [lr_pos lr_neg];
    
    for n = 1:data.N
        
        if n==1 || data.block(n)~=data.block(n-1)
            v = zeros(1,2)+0.5;  % initial values
            u = zeros(1,2);
        end
        
        c = data.c(n);
        r = data.r(n);
        q = b*v + sticky*u;
        u = zeros(1,2); u(c) = 1;
        lik = lik + q(c) - logsumexp(q,2);
        rpe = r-v(c);
        if r == 1
            v(c) = v(c) + lr(1)*rpe;
        else
            v(c) = v(c) + lr(2)*rpe;
        end
        
    end