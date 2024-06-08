function u_out = sub_dz(u,ulim)
    %% deadzone contribution
    %
    % input: (u,ulim)
    % u     double  input
    % ulim  double  deadzone boundary
    %
    % output: u_out
    % u_out double  output
    %
    % update:2022/04/03
    % Author:Hóng Jyùn Yaò
    
    %% --------------------------------------
    u_out = ulim*sub_sat(u,ulim) - u;
end

