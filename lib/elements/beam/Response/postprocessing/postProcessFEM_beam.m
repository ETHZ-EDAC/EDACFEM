% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function fem = postProcessFEM_beam(fem,opts)

% load variables
noWorkers = opts.slv.noWorkers;
b = fem.b;
p = fem.p;

for iLC = 1:fem.nLC
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
        dat(c).chunk = parfeval( gcp(), @Local_Beam, 1, p, b(i,:), fem.el.eE(i), fem.el.eA(i), fem.el.eIy(i), fem.el.eIz(i), fem.el.eG(i), fem.el.eJ(i), fem.el.eL(i), fem.sol{iLC}.u, opts );
        chunk = [chunk;(dat(c).chunk)];
    end
    %                                   1 2  3  4  5     6     7   8  9  10    11   12      13  14-25
    rprt=fetchOutputs(chunk); % rprt = [N Qy Qz Tt Mymax Mzmax Sx Sy Sz S1_eq S2_eq T_eq S_mises  u'  ]; response in element
    
    % split outputs
    fem.sol{iLC}.N = rprt(:,1);
    fem.sol{iLC}.Qy = rprt(:,2);
    fem.sol{iLC}.Qz = rprt(:,3);
    fem.sol{iLC}.Tt = rprt(:,4);
    fem.sol{iLC}.Mymax = rprt(:,5);
    fem.sol{iLC}.Mzmax = rprt(:,6);
    fem.sol{iLC}.Sx = rprt(:,7);
    fem.sol{iLC}.Sy = rprt(:,8);
    fem.sol{iLC}.Sz = rprt(:,9);
    fem.sol{iLC}.S1eq = rprt(:,10);
    fem.sol{iLC}.S2eq = rprt(:,11);
    fem.sol{iLC}.Teq = rprt(:,12);
    fem.sol{iLC}.Smises = rprt(:,13);

    % Reshape u and F
    fem.sol{iLC}.F = reshape(fem.sol{iLC}.F,[6,fem.n])';
    fem.sol{iLC}.u = reshape(fem.sol{iLC}.u,[6,fem.n])';
end
end


