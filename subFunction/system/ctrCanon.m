function sysCtr = ctrCanon(sysIn)
    %% control canonical form
    % convert to control canonical form
    %
    % input: sysIn
    % sysIn     TF          system in
    %
    % output: sysCtr
    % sysCtr    SS          control canonical form out
    %
    % update:2021/06/05
    % Author:Hóng Jyùn Yaò
    
    %% --------------------------------------
    sysSSobv = canon(sysIn, 'companion');
    
    A = sysSSobv.A';
    B = sysSSobv.C';
    C = sysSSobv.B';
    D = sysSSobv.D;
    sysCtr = ss(A,B,C,D);
end

