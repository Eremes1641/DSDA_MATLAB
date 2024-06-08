function bound = sub_s_boundary(Pssd,DSDA_parm)
    %% sub_s_boundary
    % get s boundary
    %
    % input: (Pssd,DSDA_parm)
    % Pssd          structure   discrete time plane with state space representation
    % DSDA_parm     structure   
    %   Lambda      double      bandwidth
    %   phi         double      the boundary of the s
    %   q           double      define ctr convergance time
    %   g           double      define obv convergance time
    %   Eta         double      robust gain
    %   a           double      gain of auxiliary dynamics
    % 
    % update:2024/05/25
    % Author:Hóng Jyùn Yaò

    %% --------------------------------------
    %% extract
    Lambda = DSDA_parm.Lambda;
    q = DSDA_parm.q;  % 0 <= q <= 1
    g = DSDA_parm.g;  % 0 <  g <  1
    Eta = DSDA_parm.Eta;
    phi = DSDA_parm.phi;
    m = 1;

    %% calculate
    K = fliplr( poly(-Lambda*ones(1,1)) );
    [A,B,~,~] = ssdata(Pssd);
    bound = (K*B*m) / (1-q+Eta/phi)/g; % Theorem 2
end
