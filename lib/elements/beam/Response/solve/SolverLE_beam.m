% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [fem]=SolverLE_beam(fem,opts)
%% FE Analysis 
% initialize fem.sol to fit the number of load cases
fem.sol = cell(1,fem.nLC);

% Assemble stifness matrix
[fem.beam.Km, fem.beam.Tg] = assemKm_beam(fem,opts);

% solve for each load case
for iLC = 1:fem.nLC
    % initialize empty vectors for F and u
    fem.sol{iLC}.F = nan(fem.DOF,1);
    fem.sol{iLC}.u = nan(fem.DOF,1);

    % Assemble Boundary Conditions
    [F,u,idpDOF,idfDOF] = assemBC_beam(fem,opts,iLC);

    % solve for u and F
    [u,F] = solveKuF_beam(fem.beam.Km,F,u,idfDOF,idpDOF);
    
    % Store the primary solution
    fem.sol{iLC}.F(:,1)      = F;
    fem.sol{iLC}.u(:,1)      = u;        
end

end 


