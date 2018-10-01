function plot_results(fig,results,data)
    
    if nargin < 2; load results; end
    if nargin < 3; data = load_data; end
    
    % accurate subjects
    for s=1:length(data); acc(s) = mean(data(s).acc); end
    ix = acc>0.6;
    
    switch fig
        
        case 'learning_rates'
            results = results(2);
            [se,mu] = wse(results.x(ix,2:7));
            barerrorbar(reshape(mu,2,3)',reshape(se,2,3)')
            set(gca,'FontSize',25,'XTickLabel',{'Adversarial' 'Benevolent' 'Random'},'YLim',[0 1]);
            ylabel('Learning rate','FontSize',25);
            legend({'Pos' 'Neg'},'FontSize',25);
            set(gcf,'Position',[200 200 800 400])
            
        case 'all_learning_rates'
            subplot(2,2,[1 2])
            plot_results('learning_rates',results,data)
            subplot(2,2,3)
            plot_results('asymmetry2',results,data)
            subplot(2,2,4)
            plot_results('rational_learning_rate',results,data)
            
            
        case 'asymmetry'
            x = results(2).x(:,2:end);
            %d = [x(:,1)-x(:,2) x(:,3)-x(:,4) x(:,5)-x(:,6)];
            d = [x(:,1)./(x(:,1)+x(:,2)) x(:,3)./(x(:,3)+x(:,4)) x(:,5)./(x(:,5)+x(:,6))];
            d = d(ix,:);
            [se,mu] = wse(d);
            barerrorbar(mu',se')
            set(gca,'FontSize',25,'XTickLabel',{'Adversarial' 'Benevolent' 'Random'},'YLim',[0.3 0.7],'XLim',[0.5 3.5]);
            ylabel('Relative learning rate','FontSize',25);
            hold on;
            plot(get(gca,'XLim'),[0.5 0.5],'--r','LineWidth',3);
            set(gcf,'Position',[200 200 650 400])
            [~,p] = ttest(d(:,1),d(:,2))
            [~,p] = ttest(d(:,1),d(:,3))
            [~,p] = ttest(d(:,2),d(:,3))
            [~,p] = ttest(d,0.5)
            stats = rmanova1(d)
            
           
        case 'rational_learning_rate'
            results = results(3);
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
            
            
         case 'rational_learning_rate_nonrel' %if you want non-rel learning rates
            results = results(5);
            for s = 1:length(results.latents)
                lr = results.latents(s).lr;
                for cond = 1:3
                    for j = 1:2
                        if j==1; r = 1; else r = 0; end
                        y(s,cond,j) = mean(lr(data(s).cond==cond & data(s).r==r));
                    end
                end
            end

            d=y(:,1:3,:) %if you want all 3 conditions (so not the relative learning rates)
            [se,mu] = wse(d(:,:));
            se = reshape(se,2,3);
            mu = reshape(mu,2,3);
             barerrorbar(mu',se')
            set(gca,'FontSize',25,'XTickLabel',{'Adversarial' 'Benevolent' 'Random'},'YLim',[0 0.25]);
            ylabel('Rational learning rate','FontSize',25);
            legend({'Pos' 'Neg'},'FontSize',25,'Location','North');
            set(gcf,'Position',[200 200 650 400])
            
        case 'latent_guess'
            results = results(2);
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
            
        case 'latent_guess_corr'
            results = results(2);
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
            
        case 'latent_guess_lr'
            for s=1:length(data)
                ix = data(s).latent_guess==1;
                lr = results(end).latents(s).lr;
                b(s,:) = [mean(lr(ix)) mean(lr(~ix))];
            end
            [se,mu] = wse(b);
            barerrorbar(mu',se');
            set(gca,'FontSize',25,'XTIckLabel',{'Intervention' 'No Intervention'});
            ylabel('Learning rate','FontSize',25);
            [~,p,~,stat] = ttest(b(:,1),b(:,2));
            disp(['t(',num2str(stat.df),') = ',num2str(stat.tstat),', p = ',num2str(p)]);
            
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