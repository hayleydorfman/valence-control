
% Plotting and (some) analysis functions for Dorfman, et al., 2019
% USAGE: plot_results(casename)
% EXAMPLE: plot_results('learning_rates')


function plot_results(fig,results,data)
    
    if nargin < 2; load results; end
    if nargin < 3; data = load_data; end
    
    % use if you want to subset only accurate subjects
    for s=1:length(data); acc(s) = mean(data(s).acc); end
    ix = acc>0.6;
    
    switch fig
           
        % Figure 2B  (Exp 1)  
        case 'latent_guess'
            results = results(4); %NOTE: this index needs to be changed depending on which experiment/model you want to plot
            for i = 1:2
                for s = 1:length(results.latents)
                    if i ==1
                        p = data(s).latent_guess;
                        T = 'Data';
                    else
                        p = results.latents(s).latent_guess;
                        T = 'Model';
                    end
                    for cond = 1:3
                        for j = 1:2
                            if j==1; r = 1; else r = 0; end
                            y(s,cond,j) = mean(p(data(s).cond==cond & data(s).r==r));
                        end
                    end
                end
                [se,mu] = wse(y(ix,:));
                se = reshape(se,3,2);
                mu = reshape(mu,3,2);
                subplot(2,1,i);
                barerrorbar(mu,se)
                set(gca,'FontSize',25,'XTickLabel',{'Adversarial' 'Benevolent' 'Random'},'YLim',[0 1]);
                ylabel('Intervention probability','FontSize',25);
                if i==1; legend({'Pos' 'Neg'},'FontSize',25,'Location','NorthEast'); end
                title(T,'FontSize',25,'FontWeight','Bold');
            end
            set(gcf,'Position',[200 200 800 600])
            
        % Figure 3 (Exp 1)
        case 'all_learning_rates'
            subplot(2,2,[1 2])
            plot_results('learning_rates',results,data)
            subplot(2,2,3)
            plot_results('asymmetry2',results,data)
            subplot(2,2,4)
            plot_results('rational_learning_rate',results,data)
            
                
        case 'learning_rates'
            results = results(2); %NOTE: this index needs to be changed depending on which experiment/model you want to plot
            [se,mu] = wse(results.x(ix,2:7));
            barerrorbar(reshape(mu,2,3)',reshape(se,2,3)')
            set(gca,'FontSize',25,'XTickLabel',{'Adversarial' 'Benevolent' 'Random'},'YLim',[0 1]);
            ylabel('Learning rate','FontSize',25);
            legend({'Pos' 'Neg'},'FontSize',25);
            set(gcf,'Position',[200 200 800 400])
            
        case 'asymmetry2'
            x = results(2).x(:,2:7); %NOTE: this index needs to be changed depending on which experiment/model you want to plot
            d = [x(:,1)-x(:,5) x(:,2)-x(:,6) x(:,3)-x(:,5) x(:,4)-x(:,6)];
            d = d(ix,:);
            [se,mu] = wse(d);
            se = reshape(se,2,2);
            mu = reshape(mu,2,2);
            barerrorbar(mu',se')
            set(gca,'FontSize',25,'XTickLabel',{'Adversarial' 'Benevolent'}, 'YLim',[-.12,.12]);
            ylabel('Relative Learning Rate','FontSize',25);
            %legend({'Pos' 'Neg'},'FontSize',25,'Location','North');
            set(gcf,'Position',[200 200 650 400])
            [~,p] = ttest(d(:,1),d(:,2))
            [~,p] = ttest(d(:,3),d(:,4))
            [~,p] = ttest(d*[1 -1 -1 1]')
            
            N = size(d,1);
            Y = [d(:,1); d(:,2); d(:,3); d(:,4)];
            S = repmat((1:N)',4,1);
            F1 = [ones(N*2,1); ones(N*2,1)+1];
            F2 = [ones(N,1); ones(N,1)+1; ones(N,1); ones(N,1)+1];
            FACTNAMES = {'Condition' 'Valence'};
            stats = rm_anova2(Y,S,F1,F2,FACTNAMES)
            
           
        case 'rational_learning_rate'
            results = results(4); %NOTE: this index needs to be changed depending on which experiment/model you want to plot
            for s = 1:length(results.latents)
                lr = results.latents(s).lr;
                for cond = 1:3
                    for j = 1:2
                        if j==1; r = 1; else r = 0; end
                        y(s,cond,j) = mean(lr(data(s).cond==cond & data(s).r==r));
                    end
                end
            end
            d = bsxfun(@minus,y(:,1:2,:),y(:,3,:));
            [se,mu] = wse(d(:,:));
            se = reshape(se,2,2);
            mu = reshape(mu,2,2);
            barerrorbar(mu',se')
            %set(gca,'FontSize',25,'XTickLabel',{'Adversarial' 'Benevolent'}, 'YLim',[-.06,.08]);
            set(gca,'FontSize',25,'XTickLabel',{'Adversarial' 'Benevolent'}, 'YLim',[-.075,.075]);
            ylabel('Relative learning rate','FontSize',25);
            %legend({'Pos' 'Neg'},'FontSize',25,'Location','North');
            set(gcf,'Position',[200 200 650 400])
        
            
    
       % Figure 4 (Exp 1 & Exp 2)    
        case 'latent_guess_lr'
            for s=1:length(data)
                ix = data(s).latent_guess==1;
                lr = results(4).latents(s).lr; %NOTE: this index needs to be changed depending on which experiment/model you want to plot
                b(s,:) = [mean(lr(ix)) mean(lr(~ix))];
            end
            [se,mu] = wse(b);
            barerrorbar(mu',se');
            set(gca,'FontSize',25,'XTIckLabel',{'Intervention' 'No Intervention'});
            ylabel('Learning rate','FontSize',25);
            [~,p,~,stat] = ttest(b(:,1),b(:,2));
            disp(['t(',num2str(stat.df),') = ',num2str(stat.tstat),', p = ',num2str(p)]);
            
        %signed ranks correlation
        case 'latent_guess_corr'
            results = results(4); %NOTE: this index needs to be changed depending on which experiment/model you want to plot
            for s=1:length(data)
                p1 = results.latents(s).latent_guess;
                p2 = data(s).latent_guess;
                %r(s,1) = corr(p1,p2);
                if length(unique(p2))>1
                    r(s,1) = pointbiserial(p2,p1);
                else
                    r(s,1) = nan;
                end
            end
            r = r(ix & ~isnan(r)');
            hist(atanh(r));
            colormap summer
            hold on;
            plot([0 0],get(gca,'YLim'),'--r','LineWidth',3);
            set(gca,'FontSize',25);
            xlabel('Fisher-transformed correlations','FontSize',25);
            ylabel('Frequency','FontSize',25);
            median(r)
            p = signrank(r)
        
       %supplement 
        case 'WSLS'
            for s = 1:length(data)
                N = zeros(3,2); p = zeros(3,2);
                for b = 1:max(data(s).block)
                    ix = data(s).block==b;
                    c = data(s).c(ix);
                    stay = c(2:end)==c(1:end-1);
                    cond = data(s).cond(ix); cond = cond(1);
                    r = data(s).r(ix); r = r(1:end-1);
                    N(cond,1) = N(cond,1) + sum(r==1);
                    N(cond,2) = N(cond,2) + sum(r==0);
                    p(cond,1) = p(cond,1) + sum(stay(r==1));
                    p(cond,2) = p(cond,2) + sum(~stay(r==0));
                end
                y(s,:,:) = p./N;
            end
            y = bsxfun(@minus,y(:,1:2,:),y(:,3,:));
            [~,p] = ttest(y(:,:)*[1 -1 -1 1]')
            [se,mu] = wse(y(:,:));
            se = reshape(se,2,2);
            mu = reshape(mu,2,2);
            barerrorbar(mu,se)
            set(gca,'FontSize',25,'XTickLabel',{'Adversarial' 'Benevolent'}, 'YLim',[-.07,.07]);
            ylabel('Relative Probability','FontSize',25);
            legend({'Pos: stay' 'Neg: switch'},'FontSize',25,'Location','NorthEast');
            
           
    end