function sub_plot_phase_portrait(t,Xd,Xp)
    %% plot_phase_portrait
    %
    % input: (t,Xd,Xp)
    % t       1D array    time
    % Xd      1D array    desired state
    % Xp      1D array    plant state
    % 
    % update:2024/06/08
    % Author:Hóng Jyùn Yaò
    
    %% --------------------------------------
    % error
    e1 = Xp(:,1) - Xd(:,1);
    e2 = Xp(:,2) - Xd(:,2);

    % fig
    figure;
    ax = axes;
    hold(ax,'on')

    % plot
    plot3(ax,e1,e2,t);
    view(ax,2)
    zlabel(ax,'time [sec]');

    %% property
    grid(ax,'on');
    title(ax,'phase portrait')
    xlabel(ax,'e1');
    ylabel(ax,'e2');
    axis(ax,'equal');
end




