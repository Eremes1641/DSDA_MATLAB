function [x1d, x2d, x3d] = sub_Xd_signal(t,amp,freq,offset)
    %% Xd_signal
    % generate desired signal
    %
    % input: (t,amp,freq)
    % t     1D double   time span
    % amp   double      amplitude
    % freq  double      frequency
    %
    % output: [x1d, x2d, x3d]
    % x1d   1D double   
    % x2d   1D double   
    % x3d   1D double   
    % 
    % update:2024/05/25
    % Author:Hóng Jyùn Yaò

    %% --------------------------------------
    x1d = offset + amp*sin(2*pi*freq*t);
    x2d = 2*pi*freq*amp*cos(2*pi*freq*t);
    x3d = -(2*pi*freq)^2*amp*sin(2*pi*freq*t);
end
