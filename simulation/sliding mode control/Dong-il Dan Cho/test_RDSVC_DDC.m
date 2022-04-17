clear; clc; close all;

%% declare
% sim
dt = 0.002;
t = 0:dt:1.5;	% ragne of time
IC = [0 0]';

% Plant
a = 5;
b = 20;
Pzpk = zpk([],[0 -a],a*b);
Pss = ctrCanon(Pzpk);
Pssd = c2d(Pss,dt);

% DSVC
DSVC_DDC_parm.Lambda = 5;   % bandwidth
DSVC_DDC_parm.phi = 0.4;    % the boundary of the s
DSVC_DDC_parm.q = 0.8;      % 0 <= q <= 1, define ctr convergance time
DSVC_DDC_parm.g = 0.5;      % 0 <  g <  1, define obv convergance time
DSVC_DDC_parm.r = 0.3;      % r < min(1-g,q)
DSVC_DDC_parm.Eta = 0.41;   % robust gain
bound = getBound(Pssd,DSVC_DDC_parm);

%% sim
simOut = sim_DSVC_DDC(t,Pssd,DSVC_DDC_parm);

% extract data
t = simOut.t;
X = simOut.X;
Xd = simOut.Xd;
d = simOut.d;
dest = simOut.dest;
s = simOut.s;
u = simOut.u;
x1 = X(:,1);
x1d = Xd(:,1);
phi = DSVC_DDC_parm.phi;

%% plot
plot_ctr(t,Xd,X,u)        % plot control performance
plot_s(t,s,bound)         % plot the s and the boundary
% plot_phase_portrait(t,Xd,X) % plot phase portrait
ax_obv = plot_obv(t,d,dest);% plot obvserver performance
title(ax_obv,'disturbance')
legend(ax_obv,{'d','d_{est}'})

%% disp
disp_DSVC_DDC(Pssd,DSVC_DDC_parm);



%% function
function simOut = sim_DSVC_DDC(time,Pssd,DSVC_DDC_parm)
    %% extract
    Lambda = DSVC_DDC_parm.Lambda;
    q = DSVC_DDC_parm.q;  % 0 <= q <= 1
    g = DSVC_DDC_parm.g;  % 0 <  g <  1
    r = DSVC_DDC_parm.r;  % 
    Eta = DSVC_DDC_parm.Eta;
    phi = DSVC_DDC_parm.phi;

    K = fliplr( poly(-Lambda*ones(1,1)) );

    %% initialize
    lenT = length(time)-1;
    XTemp = zeros(lenT,2);
    dTemp = zeros(lenT,1);
    destTemp = zeros(lenT,1);
    sTemp = zeros(lenT,1);
    XdTemp = zeros(lenT,2);
    uTemp = zeros(lenT,1);

    %% run
    for k = 2:lenT
        %% state
        t = time(k);
        t_next = time(k+1);
        X = XTemp(k,:)';
        dest_pre = destTemp(k-1);
        s_pre = sTemp(k-1);

        %% extract
        [A,B,~,~] = ssdata(Pssd);

        %% desired
        w = 1;
        [x1d, x2d] = Xd_signal(t,w);
        [x1d_next, x2d_next] = Xd_signal(t_next,w);
        Xd = [x1d x2d]';
        Xd_next = [x1d_next x2d_next]';

        %% DSVC + DDC
        E = X - Xd;
        s = K*E + r*s_pre;

        dest = dest_pre + (K*B)\g*(s - q*s_pre + Eta*sat(s_pre,phi));
        u = -dest + (K*B)\(K*Xd_next - K*A*X + (q-r)*s - Eta*sat(s,phi));

        %% Plant
        if t > 0.5 && t <= 1
            d = 1;
        else
            d = 0;
        end
        XDt = A*X + B*(u + d);

        %% save data
        XTemp(k+1,:) = XDt';
        XdTemp(k,:) = Xd';
        dTemp(k) = d;
        destTemp(k) = dest;
        sTemp(k) = s;
        uTemp(k) = u;
    end

    % return
    simOut.t = time(1:end-1)';
    simOut.u = uTemp;
    simOut.X = XTemp(1:end-1,:);
    simOut.Xd = XdTemp;
    simOut.d = dTemp;
    simOut.dest = destTemp;
    simOut.s = sTemp;
end

function [x1d, x2d, x3d] = Xd_signal(t,w)
    x1d = 2 + sin(2*pi*w*t);
    x2d = 2*pi*w*cos(2*pi*w*t);
    x3d = -(2*pi*w)^2*sin(2*pi*w*t);
end

function disp_DSVC_DDC(Pssd,DSVC_DDC_parm)
    %% extract
    Lambda = DSVC_DDC_parm.Lambda;
    q = DSVC_DDC_parm.q;  % 0 <= q <= 1
    g = DSVC_DDC_parm.g;  % 0 <  g <  1
    r = DSVC_DDC_parm.r;  % r < min(1-g,q)
    Eta = DSVC_DDC_parm.Eta;
    phi = DSVC_DDC_parm.phi;
    m = 1;

    K = fliplr( poly(-Lambda*ones(1,1)) );
    [A,B,~,~] = ssdata(Pssd);

    Acl = A-B*inv(K*B)*K*A;
    q_constrain = q-Eta/phi;
    g_constrain = K*B*m/g;

    disp('eig(A-B*inv(K*B)*K*A) = ');   disp(eig(Acl));
    disp('|q-Eta/phi| < 1 ');   disp(abs(q_constrain));
    disp('|K*B*m/g| < Eta ');
    disp('|K*B*m/g| = ');       disp(abs(g_constrain));
    disp('Eta = ');             disp(Eta);
    disp('r < min(1-g,q)');
    disp('r = ');               disp(r);
    disp('min(1-g,q) = ');      disp(min([1-g q]));
end


function bound = getBound(Pssd,DSVC_DDC_parm)
    %% extract
    Lambda = DSVC_DDC_parm.Lambda;
    q = DSVC_DDC_parm.q;  % 0 <= q <= 1
    g = DSVC_DDC_parm.g;  % 0 <  g <  1
    Eta = DSVC_DDC_parm.Eta;
    phi = DSVC_DDC_parm.phi;
    m = 1;

    K = fliplr( poly(-Lambda*ones(1,1)) );
    [A,B,~,~] = ssdata(Pssd);

    bound = (abs(K*B)*m) / (1-q+Eta/phi)/g;


end

