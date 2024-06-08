function sub_plot_s(t,s,phi)
    %% plot_s
    %
    % input: (t,s,phi)
    % t       1D array    time
    % s       1D array    s variable
    % phi     1D array    boundary
    % 
    % update:2024/06/08
    % Author:Hóng Jyùn Yaò

    %% --------------------------------------
    % fig
    figure;
    ax = axes;
    hold(ax,'on')

    % plot
    plot(ax,t,s);
    patch(ax,[t(1) t(end) t(end) t(1)],[phi phi -phi -phi],...
        '--k','FaceColor','#4DBEEE','FaceAlpha',0.1)

    % 
    grid(ax,'on')
    title(ax,'s')
    xlabel(ax,'time (sec)')
    legend(ax,{'s','boundary'})
end

