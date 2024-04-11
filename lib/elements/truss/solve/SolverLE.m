% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [fem]=SolverLE(fem,opts)
%% FE Analysis
% deactivate warning
warning('off','MATLAB:nearlySingularMatrix');
warning('off','MATLAB:singularMatrix');

% initialize force and displacement
fem.sol.F = nan(fem.DOF,fem.nLC);
fem.sol.u = nan(fem.DOF,fem.nLC);

% solve for all load cases
for iLC = 1:fem.nLC
    % Assemble Boundary Conditions
    [F,u,idpDOF,idfDOF] = assemBC(fem,opts,iLC);

    % Solve
    [u,F] = solveKuF(fem.truss.Km,F,u,idfDOF,idpDOF);
    
    % Store the primary solution
    fem.sol.F(:,iLC)      = F;
    fem.sol.u(:,iLC)      = u;
end

% process results
[fem] = postProcessFEM(fem,opts);
      
end


%% Solve System of Equations
function [u,F] = solveKuF(Km,F,u,idfDOF,idpDOF)
    % Displacements
    u(idfDOF,:) = mldivide(Km(idfDOF,idfDOF),F(idfDOF)-Km(idfDOF,idpDOF)*u(idpDOF,:));
    
    % Reactions
    F(idpDOF,:) = Km(idpDOF,idfDOF)*u(idfDOF,:)+Km(idpDOF,idpDOF)*u(idpDOF,:);
    
    % check if Km is in a bad condition
    Kmcond = condest(Km(idfDOF,idfDOF));
    if Kmcond >= 1e12
        fprintf(2,'Warning: Matrix is close to singular or badly scaled. Results may be inaccurate. CONDEST =  %.4e.\n', Kmcond);
    end
end


%% Process Results
function [fem] = postProcessFEM(fem,opts)
    % Member forces
    fem.sol.q  = -fem.el.eE.*fem.el.eA./fem.el.eL.*fem.truss.A'*fem.sol.u; 
    
    % Member stress
    fem.sol.S  = fem.sol.q ./ fem.el.eA;
    
    % Critical Load - Euler Buckling
    if isfield(opts,'prob') && isfield(opts.prob,'buckling') && opts.prob.buckling
        switch opts.prob.shape
            case 'circle'
                % critical euler load
                fem.sol.qbu  = pi * fem.el.eE .* fem.el.eA.^2 ./ (4*fem.el.eL.^2);
                % buckling indicator (1: intact / 0: buckled)
                fem.sol.idbu = fem.sol.q  < fem.sol.qbu;
            otherwise
                warning(['Buckling for cross section shape "',opts.prob.shape,'" not implemented.'])
        end
    end
    
    % Strain
    fem.sol.eEpsilon  = fem.sol.S ./fem.el.eE;
    
    % Displacement
    fem.sol.eDelta  = fem.sol.eEpsilon.*fem.el.eL;
end


