function [results, bms_results] = fit_models(experiment,results,models)
    
    % Fit RL models using MFIT.
    %
    % USAGE: [results, bms_results] = fit_models(data)
    %
    % INPUTS:
    %   data - [S x 1] structure array of data for S subjects
    %
    % OUTPUTS:
    %   results - [M x 1] model fits
    %   bms_results - Bayesian model selection results
    %
    % Sam Gershman
    
    if experiment == 1
        filename = 'exp1_data.csv'; %exp1
        likfuns = {'lik_asym_sticky' 'lik_rational4'};
    elseif experiment == 2 %exp 2
        filename = 'exp2_data.csv';
        likfuns = {'lik_asym_sticky' 'lik_rational4' 'lik_rational_adaptive'};
    end
    data = load_data(filename);
    
    if nargin < 3; models = 1:length(likfuns); end
    
    for mi = 1:length(models)
        m = models(mi);
        disp(['... fitting model ',num2str(m)]);
        
        switch likfuns{m}
            case 'lik_asym'
                param(1) = struct('name','invtemp','logpdf',@(x) log(gampdf(x,4.82,0.88)),'lb',1e-3,'ub',20);
                param(2) = struct('name','lr_pos_adv','logpdf',@(x) 0,'lb',0,'ub',1);
                param(3) = struct('name','lr_neg_adv','logpdf',@(x) 0,'lb',0,'ub',1);
                param(4) = struct('name','lr_pos_ben','logpdf',@(x) 0,'lb',0,'ub',1);
                param(5) = struct('name','lr_neg_ben','logpdf',@(x) 0,'lb',0,'ub',1);
                param(6) = struct('name','lr_pos_rnd','logpdf',@(x) 0,'lb',0,'ub',1);
                param(7) = struct('name','lr_neg_rnd','logpdf',@(x) 0,'lb',0,'ub',1);
                
            case 'lik_asym_sticky'
                param(1) = struct('name','invtemp','logpdf',@(x) log(gampdf(x,4.82,0.88)),'lb',1e-3,'ub',20);
                param(2) = struct('name','lr_pos_adv','logpdf',@(x) 0,'lb',0,'ub',1);
                param(3) = struct('name','lr_neg_adv','logpdf',@(x) 0,'lb',0,'ub',1);
                param(4) = struct('name','lr_pos_ben','logpdf',@(x) 0,'lb',0,'ub',1);
                param(5) = struct('name','lr_neg_ben','logpdf',@(x) 0,'lb',0,'ub',1);
                param(6) = struct('name','lr_pos_rnd','logpdf',@(x) 0,'lb',0,'ub',1);
                param(7) = struct('name','lr_neg_rnd','logpdf',@(x) 0,'lb',0,'ub',1);
                param(8) = struct('name','sticky','logpdf',@(x) 0,'lb',-5,'ub',5);
                
               
            case 'lik_rational4'
                param(1) = struct('name','invtemp','logpdf',@(x) log(gampdf(x,4.82,0.88)),'lb',1e-3,'ub',20);
                param(2) = struct('name','sticky','logpdf',@(x) 0,'lb',-5,'ub',5);
                likfuns{m} = 'lik_rational';
                
            case 'lik_rational_adaptive'
                param(1) = struct('name','invtemp','logpdf',@(x) log(gampdf(x,4.82,0.88)),'lb',1e-3,'ub',20);
                param(2) = struct('name','sticky','logpdf',@(x) 0,'lb',-5,'ub',5);
                %param(3) = struct('name','pz','logpdf',@(x) 0.001,'lb',0.999,'ub',1);
                likfuns{m} = 'lik_rational_adaptive';
                
        end
        
        fun = str2func(likfuns{m});
        results(m) = mfit_optimize(fun,param,data);
        clear param
    end
    
    % Bayesian model selection
    if nargout > 1
        bms_results = mfit_bms(results,1);  % use BIC, because asym_sticky Hessian seems to be degenerate
    end
