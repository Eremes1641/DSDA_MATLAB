function sub_plot_obv(t,d,dest)
    %% plot_obv
    %
    % input: (t,d,dest)
    % t         array       time array
    % d         array       true disturbance
    % dest      array       estimated disturbance
    % 
    % update:2024/06/08
    % Author:Hóng Jyùn Yaò
    
    %% --------------------------------------
    % fig
    figure;
    ax = axes;
    hold(ax,'on')

    % plot
    plot(ax,t,d)
    plot(ax,t,dest)
    
    %% property
    title(ax,'disturbance observer')
    xlabel(ax,'time (sec)')
    legend(ax,{'d','d_{est}'})
    grid(ax,'on')
    linkaxes(ax,'x');
    sub_loose_ylim(ax);
end

