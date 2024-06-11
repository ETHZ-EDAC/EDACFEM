% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [Kg,Tg] = assemKm_beam(fem,opts)

%% Initialize
% retrieve variables
% DOF = fem.DOF;
noWorkers = opts.slv.noWorkers;
p = fem.p;
b = fem.b;
    
% initialize parameters for parallel processing
dat = struct('m',[],'i',[],'chunk',[]);
x = 0;
n = size(p,1)*6;
chunk = [];

%% Assemble K
% split calculation in threads
for c = 1:noWorkers
    if c == 1 
        dat(c).m = size(p,1)*6/noWorkers-mod(size(p,1)*6/noWorkers,6);
        x = dat(1).m/6;
        i = (b(:,1)<=x|b(:,2)<=x);
    elseif c == noWorkers
        dat(c).m = size(p,1)*6-dat(1).m*(c-1);
        i = (b(:,1)>(c-1)*x|b(:,2)>(c-1)*x);
    else
        dat(c).m = dat(1).m;
        i =( b(:,1)>(c-1)*x&b(:,1)<=c*x|b(:,2)>(c-1)*x&b(:,2)<=c*x);
    end
    
    dat(c).i = i;

    % calculate chunk
    dat(c).chunk = parfeval( gcp(),@Kg_chunkB, 2, p, b(i,:),...
        fem.el.eE(i), fem.el.eA(i), fem.el.eIy(i), fem.el.eIz(i),...
        fem.el.eG(i), fem.el.eJ(i), fem.el.eL(i), dat(c).m, n,...
        (c-1)*dat(1).m+1, opts.slv.elemSubtype);

    % assemble chunks
    chunk = [chunk;(dat(c).chunk)];
end

% full stiffness matrix
[Kg,Tg] = fetchOutputs(chunk);

end

