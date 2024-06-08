function sub_disp_DSDA(Pssd,DSDA_parm,dt)
    %% sub_disp_DSDA
    % print DSDA infomation
    %
    % input: (Pssd,DSDA_parm,dt)
    % Pssd          structure   discrete time plane with state space representation
    % DSDA_parm     structure   
    %   Lambda      double      bandwidth
    %   phi         double      the boundary of the s
    %   q           double      define ctr convergance time
    %   g           double      define obv convergance time
    %   Eta         double      robust gain
    %   a           double      gain of auxiliary dynamics
    % dt            double      sampling period [sec]
    % 
    % update:2024/06/08
    % Author:Hóng Jyùn Yaò

    %% --------------------------------------
    %% extract
    Lambda = DSDA_parm.Lambda;
    q = DSDA_parm.q;
    g = DSDA_parm.g;
    Eta = DSDA_parm.Eta;
    phi = DSDA_parm.phi;
    m = 1;
    [A,B,~,~] = ssdata(Pssd);

    %% calculate
    K = fliplr( poly(-Lambda*ones(1,1)) );
    Acl = A-B*inv(K*B)*K*A;
    q_constrain = q-Eta/phi;
    g_constrain = K*B*m/g;

    %% find closed loop poles in continuous time
    Tssd = ss(Acl,B,[1 0],[],dt);
    Tss = d2c(Tssd,'tustin');

    %% print
    disp('eig(A-B*inv(K*B)*K*A) = ');   disp(eig(Acl)); % 1999 Discrete-time variable structure controller with a decoupled disturbance compensator
                                                        % equ 16
    disp('poles in continuous time = ');disp(pole(Tss));
    disp('|q-Eta/phi| < 1 ');   disp(abs(q_constrain)); % theorem 1
    disp('|K*B*m/g| < Eta ');   disp(abs(g_constrain)); % theorem 1
end
