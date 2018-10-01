function saveFigurePdf(figHandle, savename)
    
    % saveFigurePdf(figHandle, savename)
    
    figure(figHandle)
    set(gcf, 'windowstyle', 'normal')
    set(gcf, 'paperpositionmode', 'auto')
    %set(gcf, 'Renderer', 'opengl');
    
    pp = get(gcf, 'paperposition');
    wp = pp(3);
    hp = pp(4)+0.3;
    set(gcf, 'papersize', [wp hp])
    saveas(gcf, savename, 'pdf')