% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [F,u,idpDOF,idfDOF] = assemBC_beam(fem,opts,iLC)

% Assemble Force Vector
F = assemF_beam(fem,opts,iLC);

% Assemble prescribed Displacement Vector
[u,idU] = assemU_beam(fem,opts,iLC);

% Assemble Boundaries
idBC = assemConstr_beam(fem,opts,iLC);

% sort and make unique
idpDOF = unique([idU;idBC]); 

% Free DoF
idfDOF = setdiff(1:fem.DOF,idpDOF)';

end