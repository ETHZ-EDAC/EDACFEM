% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [fem]=SolverLE(fem,opts)
%% FE Analysis
% deactivate warning
warning('off','MATLAB:nearlySingularMatrix');
warning('off','MATLAB:singularMatrix');

% initialize fem.sol to fit the number of load cases
fem.sol = cell(1,fem.nLC);

% solve for all load cases
for iLC = 1:fem.nLC
    % initialize force and displacement
    fem.sol{iLC}.F = nan(fem.DOF,1);
    fem.sol{iLC}.u = nan(fem.DOF,1);

    % Assemble Boundary Conditions
    [F,u,idpDOF,idfDOF] = assemBC(fem,opts,iLC);

    % Solve
    [u,F] = solveKuF(fem.truss.Km,F,u,idfDOF,idpDOF);
    
    % Store the primary solution
    fem.sol{iLC}.F(:,1)      = F;
    fem.sol{iLC}.u(:,1)      = u;
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
    for iLC = 1:fem.nLC
        % Member forces
        fem.sol{iLC}.q  = -fem.el.eE.*fem.el.eA./fem.el.eL.*fem.truss.A'*fem.sol{iLC}.u; 
        
        % Member stress
        fem.sol{iLC}.S  = fem.sol{iLC}.q ./ fem.el.eA;
        
        % Critical Load - Euler Buckling
        if isfield(opts,'prob') && isfield(opts.prob,'buckling') && opts.prob.buckling
            switch opts.prob.shape
                case 'circle'
                    % critical euler load
                    fem.sol{iLC}.qbu  = pi * fem.el.eE .* fem.el.eA.^2 ./ (4*fem.el.eL.^2);
                    % buckling indicator (1: intact / 0: buckled)
                    fem.sol{iLC}.idbu = fem.sol{iLC}.q  < fem.sol{iLC}.qbu;
                otherwise
                    warning(['Buckling for cross section shape "',opts.prob.shape,'" not implemented.'])
            end
        end
        
        % Strain
        fem.sol{iLC}.eEpsilon  = fem.sol{iLC}.S ./fem.el.eE;
        
        % Displacement
        fem.sol{iLC}.eDelta  = fem.sol{iLC}.eEpsilon.*fem.el.eL;
    end
end


