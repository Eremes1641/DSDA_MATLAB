function output = sat(input,bound)
    %% sat
    %
    % input: (input,bound)
    % input     double      value in
    % bound     double      boundary
    %
    % output: output
    % output    double      value out
    %
    % update:2022/02/22
    % Author:Hóng Jyùn Yaò
    
    %% --------------------------------------
    if nargin < 2
        bound = 1;
    end
    output = input / bound;
    
    if abs(output) > 1
        output = sign(output);
    end
end

