function [axout,figout] = plot_obv(varargin)
    %% plot_obv
    % plot fig that compare measured state and estimated state
    %
    % input: (t,X,Xest) / obvData / (ax,___) / (___,Xindex)
    % t         array       time array
    % X         array       measured state
    % Xest      array       estimated state
    % Xindex    1D array    order of measurement state
    % 
    % output: [axout,figout]
    % axout     axis        axis out
    % figout    fig         figure out
    %
    % update:2022/02/01
    % Author:Hóng Jyùn Yaò
    
    %% ---extract axes & arg-----------------------------------
    [ax, arg, ~] = check_axes(varargin);
    
    % mode
    argLen = length(arg);
    indIn = false;
    if argLen == 1
        mode = 'obvData';
    elseif argLen == 2
        mode = 'obvData';
        indIn = true;
        Xindex = arg{2};
    elseif argLen == 3
        mode = 'tXXest';
    elseif argLen == 4
        mode = 'tXXest';
        indIn = true;
        Xindex = arg{4};
    end
    
    % arg
    switch mode
        case 'obvData'
            obvData = arg{1};
            t = obvData.t;
            X = obvData.X;
            Xest = obvData.Xest;
        case 'tXXest'
            t = arg{1};
            X = arg{2};
            Xest = arg{3};
    end
    numXest = size(Xest,2);
    
    % have axis ?
    isAxin = ~isempty(ax);
    if ~isAxin
        fig = figure;
        ax = createSubplot(numXest,1);
    end
    hold(ax,'on')
    
    % ind
    if ~indIn
        Xindex = 1:size(X,2);
    end
    
    %% ----main----------------------------------------------
    %% plot
    for i = 1:length(Xindex)
        if ~isAxin
            plot(ax(Xindex(i)),t,X(:,i),'Color','#4DBEEE');
            legendApd(ax(Xindex(i)),['x' num2str(i) '_{measured}'])
        end
    end
    for i = 1:numXest
        if ~isAxin
            plot(ax(i),t,Xest(:,i),'Color','#D95319');
        else
            plot(ax(i),t,Xest(:,i));
        end
        title(ax(i),['x' num2str(i)])
        legendApd(ax(i),['x' num2str(i) '_{est}'])
    end
    
    %% property
    xlabel(ax,'time (sec)')
    grid(ax,'on')
    linkaxes(ax,'x');
    loose_ylim(ax);

    %% return
    if nargout
        axout = ax;
        figout = fig;
    end
    
end

