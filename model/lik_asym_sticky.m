function lik = lik_asym_sticky(x,data)
    
    % Likelihood function for "Six Learning Rate" model for Dorfman, et al., 2019
    % Q-learning on two-armed bandit with separate
    % learning rates for positive and negative outcomes in different
    % conditions (i.e., 6 learning rate model).
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
    % Sam Gershman
    
    % parameters
    b = x(1);           % inverse temperature
    lr_pos_adv = x(2);  % learning rate (positive outcome / adversarial condition)
    lr_neg_adv = x(3);  % learning rate (negative outcome / adversarial condition)
    lr_pos_ben = x(4);  % learning rate (positive outcome / benevolent condition)
    lr_neg_ben = x(5);  % learning rate (negative outcome / benevolent condition)
    lr_pos_rnd = x(6);  % learning rate (positive outcome / random condition)
    lr_neg_rnd = x(7);  % learning rate (negative outcome / random condition)
    sticky = x(8);      % stickiness
    
    % initialization
    lik = 0;             % log-likelihood
    
    for n = 1:data.N
        
        if n==1 || data.block(n)~=data.block(n-1)
            v = zeros(1,2)+0.5;  % initial values
            u = zeros(1,2);
            
            switch data.cond(n)
                case 1
                    lr = [lr_pos_adv lr_neg_adv];
                case 2
                    lr = [lr_pos_ben lr_neg_ben];
                case 3
                    lr = [lr_pos_rnd lr_neg_rnd];
            end
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