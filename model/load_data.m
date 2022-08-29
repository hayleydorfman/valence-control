function data = load_data(fname)
    
% Load data into matlab and format for model fitting
% USAGE: data = load_data(myfilename.csv)

    if nargin < 1; fname = 'exp1_data.csv'; end % change based on the name of your dataframe
    
    f = fopen(fname); y = regexp(fgetl(f),',','split');
    fclose(f);
    
    x = csvread(fname,1);
    
    for i = 1:length(y)
        try
            D.(y{i}) = x(:,i);
        end
    end
    
    subs = unique(D.subject);
    
    for s = 1:length(subs)
        ix = D.subject==subs(s);
        data(s).sub = subs(s);
        data(s).c = D.subj_choice(ix);
        data(s).r = D.feedback(ix);
        data(s).cond = D.condition(ix);
        data(s).block = D.block_num(ix);
        data(s).latent_guess = D.latent_guess(ix);
        data(s).N = length(data(s).c);
        winprob = [D.mine_prob_win_left(ix) D.mine_prob_win_right(ix)];
        for n=1:data(s).N
            [~,k] = max(winprob(n,:));
            if data(s).c(n) == k
                data(s).acc(n) = 1;
            else
                data(s).acc(n) = 0;
            end
        end
        data(s).acc = mean(data(s).acc);
        

    end
    
    ix = [data.acc]>0.6; %use only if you want to remove subjects with accuracy < 60%
    data = data(ix);