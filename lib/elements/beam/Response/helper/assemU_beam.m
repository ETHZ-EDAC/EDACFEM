% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [u,idU] = assemU_beam(fem,opts,iLC)

% init displacement vector with zeros
u = zeros(fem.DOF,1); 

% DOF of target displacements
idU = id2DOF_beam(fem.LC{iLC}.U(:,1),fem.d);
% take only DOFs [1,2,3, , , ] from full 6 DOF vector (only prescribed disp., not rot.)
idU = idU( toVec( (repmat([1:2*fem.d:size(idU,1)],fem.d,1)+repmat(([1:fem.d]-1)',1,size(idU,1)/(2*fem.d)))' ) ); 
% set prescribed displacements at idU of displacement vector
u(idU) = u(idU) + toVec(fem.LC{iLC}.U(:,2:1+fem.d) .* fem.LC{iLC}.U(:,5)); 

% DOF of target rotations
idR = id2DOF_beam(fem.LC{iLC}.R(:,1),fem.d);
% take only DOFs [ , , ,4,5,6] from full 6 DOF vector (only prescribed rot., not disp.)
idR = idR( toVec( (repmat([1:2*fem.d:size(idR,1)],fem.d,1)+repmat(([fem.d+1:2*fem.d]-1)',1,size(idR,1)/(2*fem.d)))' ) ); 
% set prescribed rotations at idR of displacement vector
u(idR) = u(idR) + toVec(fem.LC{iLC}.R(:,2:1+fem.d) .* fem.LC{iLC}.R(:,5)); 

% assemble prescribed deformation
idU = [idU;idR];

% remove all entrys with zero displacement or rotation
idU(u(idU)==0) = []; 

end