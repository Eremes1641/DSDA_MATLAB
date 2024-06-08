function sub_plot_ctr(t,Xd,X,u)
    %% plot_ctr
    % plot Xd, X, u in one figure
    % 
    % input: [t,Xd,X,u]
    % t         1D double           time
    % y         1D double           y
    % yd        1D double           desired y
    % u         1D double           input
    % 
    % update:2024/06/08
    % Author:Hóng Jyùn Yaò
    
    %% --------------------------------------
    %% extract
    x1 = X(:,1);
    x2 = X(:,2);
    x1d = Xd(:,1);
    x2d = Xd(:,2);

    %% plot
    % fig
    figure;
    ax = sub_createSubplot(3,1);
    ax_x1 = ax(1);
    ax_x2 = ax(2);
    ax_u = ax(3);
    hold(ax,'on')

    % plot
    plot(ax_x1,t,x1d)
    plot(ax_x1,t,x1)
    plot(ax_x2,t,x2d)
    plot(ax_x2,t,x2)
    plot(ax_u,t,u)

    % 
    sub_loose_ylim(ax)
    title(ax(1),'x1')
    title(ax(2),'x2')
    title(ax(3),'u')
    legend(ax(1),{'x1d','x1'})
    legend(ax(2),{'x2d','x2'})
    xlabel(ax,'time (sec)')
    linkaxes(ax,'x')
    grid(ax,'on')
end
