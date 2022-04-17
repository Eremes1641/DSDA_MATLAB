function [axOut,figOut] = plot_phase_portrait(varargin)
    %% plot_phase_portrait
    %
    % input: (Xd,Xp) / (x1d,Xp)
    %        (t,Xd,Xp) / (t,x1d,Xp)
    %        (ax,___) / (___,dim)
    % t       1D array    time
    % Xd      1D array    desired state
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
    argu = [{ax} arg{:}];
    
    %% plot
    dim = plot_phase_portrait0(argu{:});
    
    %% property
    grid(ax,'on');
    title(ax,'phase portrait')
    xlabel(ax,['e' num2str(dim(1))]);
    ylabel(ax,['e' num2str(dim(2))]);
    axis(ax,'equal');
    
    %% return
    if nargout
        axOut = ax;
        figOut = fig;
    end
end

%% plot function
function dim = plot_phase_portrait0(varargin)
    %% extract
    ax = varargin{1};
    if length(varargin) == 3
        % (ax,Xd,Xp)
        Xd = varargin{2};
        Xp = varargin{3};
        dim = [1 2];
    elseif length(varargin) == 4
        % (ax,Xd,Xp,dim) or (ax,t,Xd,Xp)
        if length(varargin{4}) == 2
            % (ax,Xd,Xp,dim)
            Xd = varargin{2};
            Xp = varargin{3};
            dim = varargin{4};
        else
            % (ax,t,Xd,Xp)
            t = varargin{2};
            Xd = varargin{3};
            Xp = varargin{4};
            dim = [1 2];
        end
    elseif length(varargin) == 5
        % (ax,t,Xd,Xp,dim)
        t = varargin{2};
        Xd = varargin{3};
        Xp = varargin{4};
        dim = varargin{5};
    end
    
    %% initialize Xd
    if size(Xd,2) == 1
        Mzero = zeros(length(Xd),max(dim)-1);
        Xd = [Xd Mzero];
    end
    
    %% plot
    e1 = Xp(:,dim(1)) - Xd(:,dim(1));
    e2 = Xp(:,dim(2)) - Xd(:,dim(2));
    %     e1 = Xd(:,dim(1)) - Xp(:,dim(1));
    %     e2 = Xd(:,dim(2)) - Xp(:,dim(2));
    
    if exist('t')
        plot3(ax,e1,e2,t);
        view(ax,2)
        zlabel(ax,'time [sec]');
    else
        plot(ax,e1,e2);
    end
end




