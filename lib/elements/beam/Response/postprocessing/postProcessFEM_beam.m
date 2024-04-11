% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function fem = postProcessFEM_beam(fem,opts,u,F)

% load variables
noWorkers = opts.slv.noWorkers;
b = fem.b;
p = fem.p;

% Get elemental response
chunk=[];
for c=1:noWorkers 
    if c == 1
        dat(1).m = size(b,1)/noWorkers-mod(size(b,1)/noWorkers,noWorkers);
        x = size(b,1)/noWorkers-mod(size(b,1)/noWorkers,noWorkers);
        i = ismember((1:size(b,1))',((c-1)*x+1:c*x)');
    elseif c==noWorkers
        dat(c).m = size(b,1)-(c-1)*x;
        i = ismember((1:size(b,1))',((c-1)*x+1:size(b,1))');
    else
        dat(c).m = dat(1).m;
        i = ismember((1:size(b,1))',((c-1)*x+1:c*x)');
    end
    dat(c).i=i;
    dat(c).chunk = parfeval( gcp(), @Local_Beam, 1, fem.p, b(i,:), fem.el.eE(i), fem.el.eA(i), fem.el.eIy(i), fem.el.eIz(i), fem.el.eG(i), fem.el.eJ(i), fem.el.eL(i), u, opts );
    chunk = [chunk;(dat(c).chunk)];
end
%                                   1 2  3  4  5     6     7   8  9  10    11   12      13  14-25
rprt=fetchOutputs(chunk); % rprt = [N Qy Qz Tt Mymax Mzmax Sx Sy Sz S1_eq S2_eq T_eq S_mises  u'  ]; response in element

% split outputs
fem.sol.N = rprt(:,1);
fem.sol.Qy = rprt(:,2);
fem.sol.Qz = rprt(:,3);
fem.sol.Tt = rprt(:,4);
fem.sol.Mymax = rprt(:,5);
fem.sol.Mzmax = rprt(:,6);
fem.sol.Sx = rprt(:,7);
fem.sol.Sy = rprt(:,8);
fem.sol.Sz = rprt(:,9);
fem.sol.S1_eq = rprt(:,10);
fem.sol.S2_eq = rprt(:,11);
fem.sol.T_eq = rprt(:,12);
fem.sol.Smises = rprt(:,13);

end


