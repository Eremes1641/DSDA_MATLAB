%% Discrete-Time Sliding Mode Control with Disturbance Compensation & Auxiliary state
% This is a simple example for DSDA.
% The plant is a DC motor with 12V input saturation.
% The homemade experiment video for controlling a DC motor can be found at https://youtu.be/Sfkhd4Sizgk?si=DKroc5hYjogs-vGs
% 
% Comments:
% Pros:
%   1. anti-windup for input saturation
%   2. seperately design control bandwidth and disturbance observer
%   3. state tracking
%   4. has a robust gain to suppress known disturbance
% 
% Cons:
%   1. too much parameter for tuning. (Lambda, q, g, a, Eta, phi)
%    -- It is reasonable to set a = 0.97 as the default value
%    -- and rewrite phi as a position boundary in the stationary case.
%    -- Eta could be set to 0 as a default value or defined from system identification.
%    -- However, ordinary people may only comprehend the concept of bandwidth.
%    -- Other parameters are out of their imagination.
%    -- Or, need a extra effort to design a tuning process for user.
%   2. q, g are without unit.
%    -- It means that if the sampling frequency is changed, the convergence time also changes.
%    -- It's also a bit difficult to tune.
% 
% 
% Reference:
% [1] 
% Ji-Seok Han, Tae-Il Kim, Tae-Ho Oh, Sang-Hoon Lee and Dong-Il “Dan” Cho, 
% "Effective Disturbance Compensation Method Under Control Saturation in Discrete-Time Sliding Mode Control," 
% in IEEE Transactions on Industrial Electronics, vol. 67, no. 7, pp. 5696-5707, July 2020, doi: 10.1109/TIE.2019.2931213.
% 
% [2]
% Yongsoon Eun, Jung-Ho Kim, Kwangsoo Kim, Dong-Il Cho
% "Discrete-time variable structure controller with a decoupled disturbance compensator and its application to a CNC servomechanism." 
% IEEE Transactions on Control Systems Technology 7.4 (1999): 414-423.


%% 
clear; clc; close all;

%% declare
% time
dt = 0.001;     % sampling period [sec]
t = 0:dt:1.5;	% time [sec]

% Plant
a = 4.22;
b = 34;
Pzpk = zpk([],[0 -a],b);
Pss = sub_ctrCanon(Pzpk);
Pssd = c2d(Pss,dt);
IC = [0 0]';    % initial condition. [x1 x2]

% DSDA parameter
DSDA_parm.Lambda = 50;  % bandwidth [rad/s]
                        % slope of sliding surface
                        % (described near equ 3)

DSDA_parm.phi = 10;     % the boundary of the s or sigma
                        % (described near equ 4)

DSDA_parm.q = 0.9;      % 0 <= q <= 1, gain of reaching speed to the sliding surface
                        % (described near equ 4)
                        % comment:
                        % If q is larger, speed will be slower
                        % If q is smaller, speed will be faster, but it might cause chattering.

DSDA_parm.g = 0.1;      % 0 <  g <  1, disturbance observer gain.
                        % (remark 1 and remark5)
                        % comment:
                        % If g is larger, convergence will be faster, but it might cause chattering.

DSDA_parm.Eta = 0.01;   % robust gain 
                        % comment:
                        % If Eta is larger, more disturbance will be suppressed, but it might cause chattering.
                        % Eta should be designed based on the known disturbance boundary.

DSDA_parm.a = 0.97;     % gain of auxiliary dynamics for input saturation
                        % (remark 2, remark 7 and fig 6)
                        % comment:
                        % If a is larger, position convergence will be slower when transitioning from input saturation to non-saturation
                        % If a is smaller, position tracking will experience overshoot.

bound = sub_s_boundary(Pssd,DSDA_parm); % bound will be smaller than phi. 
                                        % (Theorem 2 and equ 33)

%% simulation
simOut = sim_DSDA(t,Pssd,DSDA_parm);

% extract data
t = simOut.t;       % time [sec]
X = simOut.X;       % state [x1, x2]
Xd = simOut.Xd;     % desired state [x1, x2]
d = simOut.d;       % disturbance
dest = simOut.dest; % estimated disturbance
s = simOut.s;
u = simOut.u;       % non-saturated input effort
u_act = simOut.u_act;   % saturated input effort
x1 = X(:,1);        % position
x1d = Xd(:,1);      % desired position
phi = DSDA_parm.phi;% the boundary of the s or sigma

%% plot
sub_plot_ctr(t,Xd,X,u_act)      % plot control performance
sub_plot_phase_portrait(t,Xd,X) % plot phase portrait
sub_plot_obv(t,d,dest);         % plot obvserver performance
sub_plot_s(t,s,phi)             % plot the s and the boundary
sub_plot_s(t,s,bound)         % plot the s and the boundary

%% disp
sub_disp_DSDA(Pssd,DSDA_parm,dt);





%% function
function simOut = sim_DSDA(t,Pssd,DSDA_parm)
    %% declare
    % signal
    amp = 1;
    freq = 1;
    offset = 1;
    % input saturation
    ulim = 12;

    %% desired signal
    [x1dTemp, x2dTemp, ~] = sub_Xd_signal(t,amp,freq,offset);

    %% extract
    Lambda = DSDA_parm.Lambda;
    q = DSDA_parm.q;
    g = DSDA_parm.g;
    Eta = DSDA_parm.Eta;
    phi = DSDA_parm.phi;
    a = DSDA_parm.a;
    [A,B,~,~] = ssdata(Pssd);

    %% gain
    K = fliplr( poly(-Lambda*ones(1,1)) );  % G (near equ3)

    %% initialize
    lenT = length(t)-1;
    XTemp = zeros(lenT,2);
    dTemp = zeros(lenT,1);
    destTemp = zeros(lenT,1);
    sTemp = zeros(lenT,1);
    XdTemp = zeros(lenT,2);
    uTemp = zeros(lenT,1);
    u_actTemp = zeros(lenT,1);
    zTemp = zeros(lenT,1);

    %% run
    for k = 2:lenT
        %% state
        tk = t(k);
        x1d = x1dTemp(k);
        x2d = x2dTemp(k);
        x1d_next = x1dTemp(k+1);
        x2d_next = x2dTemp(k+1);
        X = XTemp(k,:)';
        dest_pre = destTemp(k-1);
        s_pre = sTemp(k-1);
        u_pre = uTemp(k-1);
        z_pre = zTemp(k-1);

        %% desired
        Xd = [x1d x2d]';
        Xd_next = [x1d_next x2d_next]';

        %% Auxiliary state
        Delta_u_pre = sub_dz(u_pre,ulim);   % equ 5
        z = a*z_pre - K*B*Delta_u_pre;      % equ 16

        %% DSVC + DDC
        E = X - Xd;
        s = K*E + z;    % equ 17
        dest = dest_pre + (K*B)\g*(s - q*s_pre + Eta*sub_sat(s_pre,phi));   % equ 19
        u = -dest + (K*B)\(K*Xd_next - K*A*X - a*z + q*s - Eta*sub_sat(s,phi)); % equ 18

        %% disturbance
        if tk > 0.5 && tk <= 1
            d = 4;
        elseif tk > 1 && tk <= 1.5
            d = 0;
        else
            d = 0;
        end

        %% Plant
        u_act = ulim*sub_sat(u,ulim);
        XDt = A*X + B*(u_act + d);

        %% save data
        XTemp(k+1,:) = XDt';
        XdTemp(k,:) = Xd';
        dTemp(k) = d;
        destTemp(k) = dest;
        sTemp(k) = s;
        uTemp(k) = u;
        u_actTemp(k) = u_act;
        zTemp(k) = z;
    end

    % return
    simOut.t = t(1:end-1)';
    simOut.u = uTemp;
    simOut.u_act = u_actTemp;
    simOut.X = XTemp(1:end-1,:);
    simOut.Xd = XdTemp;
    simOut.d = dTemp;
    simOut.dest = destTemp;
    simOut.s = sTemp;
    simOut.z = zTemp;
end
