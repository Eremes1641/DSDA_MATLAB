function [axOut,figOut] = plot_ctr(varargin)
    %% plot_ctr
    % plot Xd, X, u in one figure
    %
    % input: [t,Xd,X,u] / (ax,___)
    % t         1D double           time
    % y         1D double           y
    % yd        1D double           desired y
    % u         1D double           input
    %
    % output: [axOut,figOut]
    % axOut     axes                axes out
    % figOut    fig                 figure out
    %
    % update:2022/03/27
    % Author:Hóng Jyùn Yaò
    
    %% ---extract axes & arg-----------------------------------
    [ax, arg, ~] = check_axes(varargin);
    
    
    % have axis ?
    isAxin = ~isempty(ax);
    if ~isAxin
        fig = figure;
        X = arg{3};
        numX = size(X,2);
        ax = createSubplot(numX+1,1);
        for i = 1:numX
            title(ax(i),['x' num2str(i)])
        end
        title(ax(end),'u')
    end
    hold(ax,'on')

    % merge arg
    argu = [{ax} arg{:}];

    %% plot
    plot_ctr0(argu{:})

    %% return
    if nargout
        axOut = ax;
        figOut = fig;
    end
end


%%
function plot_ctr0(ax,t,Xd,X,u)
    %% plot
    numX = size(X,2);
    for i = 1:numX
        plot(ax(i),t,Xd(:,i),'-.')
        plot(ax(i),t,X(:,i))
        legendApd(ax(i),{['x' num2str(i) 'd'],['x' num2str(i)]})
    end
    plot(ax(numX+1),t,u)
    legendApd(ax(numX+1),'u')

    %% property
    axis tight
    xlabel(ax,'time (sec)')
    grid(ax,'on')
    loose_ylim(ax);
    linkaxes(ax,'x');
end


