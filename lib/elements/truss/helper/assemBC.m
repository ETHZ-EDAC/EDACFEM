% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [F,u,idpDOF,idfDOF] = assemBC(fem,opts,iLC)

% Assemble Force Vector
F = assemF(fem,opts,iLC);

% Assemble prescribed Displacement Vector
[u,idU] = assemU(fem,opts,iLC);

% Assemble Boundaries
idBC = assemConstr(fem,opts,iLC);

% Prescribed DoF -- check consistency for multiple LCs
idpDOF = unique([idU;idBC]); % sort and make unique

% Free DoF
idfDOF = setdiff(1:fem.DOF,idpDOF)';

end