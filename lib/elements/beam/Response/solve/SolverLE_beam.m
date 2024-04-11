% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [fem]=SolverLE_beam(fem,opts)
%% FE Analysis 
% initialize empty vectors for F and u
fem.sol.F = nan(fem.DOF,fem.nLC);
fem.sol.u = nan(fem.DOF,fem.nLC);

% solve for each load case
for iLC = 1:fem.nLC
    % Assemble Boundary Conditions
    [F,u,idpDOF,idfDOF] = assemBC_beam(fem,opts,iLC);
    
    % Assemble stifness matrix
    [fem.beam.Km, fem.beam.Tg] = assemKm_beam(fem,opts);
    
    % solve for u and F
    [u,F] = solveKuF_beam(fem.beam.Km,F,u,idfDOF,idpDOF);
    
    % Store the primary solution
    fem.sol.F(:,iLC)      = F;
    fem.sol.u(:,iLC)      = u;        
end

end 


