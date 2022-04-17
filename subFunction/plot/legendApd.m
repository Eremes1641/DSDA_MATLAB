function legendApd(ax,string)
    %% legendApd
    % append legend
    %
    % input: (ax,string)
    % ax     	axes        axes in
    % string    char / cell string in
    %
    % update:2022/02/01
    % Author:Hóng Jyùn Yaò
    
    %% --------------------------------------
    if ~iscell(string)
        string = {string};
    end
    
    for i = 1:length(ax)
        axTemp = ax(i);
        if ~isempty(axTemp.Legend)
            numLeg = length(axTemp.Legend.String);
            numStr = length(string);
            axTemp.Legend.String(numLeg-numStr+1:end) = string;
        else
            legend(axTemp,string);
        end
    end
end