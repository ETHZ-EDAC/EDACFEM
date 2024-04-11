% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [ fem ] = runTrussFEM( fem,opts )

% Assemble global connectivity matrix
[fem.truss.C]                = assembleC(fem);   

% Assemble equilibrium matrix, retrieve element length
[fem.truss.A,fem.el.eL]      = assembleA(fem);                

% global stiffness matrix and truss member stiffness
[fem.truss.Km,fem.truss.BKm] = assembleKm(fem);      

% solve system of equations
[fem]                        = SolverLE(fem,opts);                   
    
end

