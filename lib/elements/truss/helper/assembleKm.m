% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [Km,BKm] = assembleKm(fem)

% truss member stiffness in diagonal matrix form
BKm = sparse(1:fem.m,1:fem.m,fem.el.eA.*fem.el.eE./fem.el.eL,fem.m,fem.m);

% global stiffness matrix
% based on the direct stiffness method
Km = fem.truss.A*BKm*fem.truss.A.';

end




