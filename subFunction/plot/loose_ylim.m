function loose_ylim(axIn,scale)
    %% loose_ylim
    % loose y limit
    %
    % input: (axIn,scale)
    % ax        2D  axes    axes in
    % scale     double      0~1
    %
    % update:2021/08/20
    % Author:Hóng Jyùn Yaò
    
    %% --------------------------------------
    % default
    if nargin < 2
        scale = 0.2;
    end
    
    % access all axes
    for k = 1:size(axIn,1)
        for j = 1:size(axIn,2)
            % get line
            ax = axIn(k,j);
            Line = ax.Children;
            numLine = length(Line);
            y = [];
            for i = 1:numLine
                y = [y Line.YData];
            end
            
            % run
            y = reshape(y,[],1);
            minValue = min(y);
            maxValue = max(y);
            if minValue ~= maxValue
                extend = (maxValue-minValue)*scale;
                ylim(ax,[minValue-extend, maxValue+extend]);
            end
        end
    end
end