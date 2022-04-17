function [axOut,figOut] = plot_s(varargin)
    %% plot_s
    %
    % input: (t,s) / (t,s,phi) / (ax,___)
    % t       1D array    time
    % s       1D array    s variable
    % phi     1D array    boundary
    %
    % output: [axOut,figOut]
    % axOut     axes      axes out
    % figOut    fig       figure out
    %
    % update:2022/02/18
    % Author:Hóng Jyùn Yaò

    %% ---extract axes & arg-----------------------------------
    [ax, arg, ~] = check_axes(varargin);

    % have axis ?
    if isempty(ax)
        fig = figure;
        ax = axes;
    end
    hold(ax,'on')

    % arg
    args = [{ax},arg(:)'];

    %% plot
    plot_s0(args{:})

    %% property
    grid(ax,'on');
    title(ax,'s variable')
    xlabel(ax,'time (sec)');
    ylabel(ax,'s');

    %% return
    if nargout
        axOut = ax;
        figOut = fig;
    end
end


function plot_s0(varargin)
    if nargin == 3
        ax = varargin{1};
        t = varargin{2};
        s = varargin{3};
        plot(ax,t,s);

    elseif nargin == 4
        ax = varargin{1};
        t = varargin{2};
        s = varargin{3};
        phi = varargin{4};
        if length(phi) == 1
            phi = phi*ones(length(t),1);
        end

        plot(ax,t,s);
        patch(ax,[t(:); flipud(t(:))]',...
            [phi; flipud(-phi)]',...
            '--k','FaceColor','#4DBEEE','FaceAlpha',0.1)
        legendApd(ax,{'s','boundary'})
    end
end


