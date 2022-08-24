function [results, bms_results] = fit_models(experiment,results,models)
    
    % Fit RL models using MFIT.
    %
    % USAGE: [results, bms_results] = fit_models(data)
    %
    % EXAMPLE: [results, bms_results] = fit_models(1) %for exp 1
    %
    % INPUTS:
    %   data - [S x 1] structure array of data for S subjects
    %
    % OUTPUTS:
    %   results - [M x 1] model fits
    %   bms_results - Bayesian model selection results
    %
    % Sam Gershman
    
    if experiment == 1 %exp1
        filename = 'exp1_data.csv'; 
        likfuns = {'lik_asym0_sticky' 'lik_asym_sticky' 'lik_free_pz' 'lik_rational'};
    elseif experiment == 2 %exp 2
        filename = 'exp2_data.csv';
        likfuns = {'lik_asym_sticky' 'lik_free_pz' 'lik_rational4' 'lik_rational_adaptive6'};
    end
    data = load_data(filename);
    
    if nargin < 3; models = 1:length(likfuns); end
    
    for mi = 1:length(models)
        m = models(mi);
        disp(['... fitting model ',num2str(m)]);
        
        switch likfuns{m} %define parmameters/bounds for each model function
           
            case 'lik_asym0_sticky' %2LR
                param(1) = struct('name','invtemp','logpdf',@(x) log(gampdf(x,4.82,0.88)),'lb',1e-3,'ub',20);
                param(2) = struct('name','lr_pos','logpdf',@(x) 0,'lb',0,'ub',1);
                param(3) = struct('name','lr_neg','logpdf',@(x) 0,'lb',0,'ub',1);
                param(4) = struct('name','sticky','logpdf',@(x) 0,'lb',-5,'ub',5);
                
            case 'lik_asym_sticky' %6LR + sticky
                param(1) = struct('name','invtemp','logpdf',@(x) log(gampdf(x,4.82,0.88)),'lb',1e-3,'ub',20);
                param(2) = struct('name','lr_pos_adv','logpdf',@(x) 0,'lb',0,'ub',1);
                param(3) = struct('name','lr_neg_adv','logpdf',@(x) 0,'lb',0,'ub',1);
                param(4) = struct('name','lr_pos_ben','logpdf',@(x) 0,'lb',0,'ub',1);
                param(5) = struct('name','lr_neg_ben','logpdf',@(x) 0,'lb',0,'ub',1);
                param(6) = struct('name','lr_pos_rnd','logpdf',@(x) 0,'lb',0,'ub',1);
                param(7) = struct('name','lr_neg_rnd','logpdf',@(x) 0,'lb',0,'ub',1);
                param(8) = struct('name','sticky','logpdf',@(x) 0,'lb',-5,'ub',5);
            
            case 'lik_rational' %empirical bayesian for exp1
                param(1) = struct('name','invtemp','logpdf',@(x) log(gampdf(x,4.82,0.88)),'lb',1e-3,'ub',20);
                param(2) = struct('name','sticky','logpdf',@(x) 0,'lb',-5,'ub',5);
                likfuns{m} = 'lik_rational';    
               
            case 'lik_rational4' %empirical bayesian for exp2
                param(1) = struct('name','invtemp','logpdf',@(x) log(gampdf(x,4.82,0.88)),'lb',1e-3,'ub',20);
                param(2) = struct('name','sticky','logpdf',@(x) 0,'lb',-5,'ub',5);
                likfuns{m} = 'lik_rational4';
                
            case 'lik_free_pz' %fixed bayesian
                param(1) = struct('name','invtemp','logpdf',@(x) log(gampdf(x,4.82,0.88)),'lb',1e-3,'ub',20);
                param(2) = struct('name','sticky','logpdf',@(x) 0,'lb',-5,'ub',5);
                param(3) = struct('name','pz','logpdf',@(x) 0.001,'lb',0.999,'ub',1);
                likfuns{m} = 'lik_free_pz';    
                                
            case 'lik_rational_adaptive6' %adaptive bayesian
                param(1) = struct('name','invtemp','logpdf',@(x) log(gampdf(x,4.82,0.88)),'lb',1e-3,'ub',20);
                param(2) = struct('name','sticky','logpdf',@(x) 0,'lb',-5,'ub',5);
                param(3) = struct('name','alpha','logpdf',@(x) 0,'lb',0.1,'ub',30);
                param(4) = struct('name','beta','logpdf',@(x) 0,'lb',0.1,'ub',30);
                likfuns{m} = 'lik_rational_adaptive6';       
                
        end
        
        fun = str2func(likfuns{m});
        results(m) = mfit_optimize(fun,param,data);
        clear param
    end
    
    % Bayesian model selection
    if nargout > 1
        bms_results = mfit_bms(results,1);  % use BIC, because asym_sticky Hessian seems to be degenerate
    end