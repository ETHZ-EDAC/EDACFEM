% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [u,idU] = assemU(fem,opts,iLC)

% init displacement vector with zeros
u = zeros(fem.DOF,1); 

% DOF IDs of prescribed displacements
idU = id2DOF(fem.LC{iLC}.U(:,1),fem.d);

% set prescribed displacements at idU of displacement vector
u(idU) = u(idU) + toVec(fem.LC{iLC}.U(:,2:1+fem.d) .* fem.LC{iLC}.U(:,5));

% remove all entrys where zero displacement is prescribed
idU(u(idU)==0) = []; 

end