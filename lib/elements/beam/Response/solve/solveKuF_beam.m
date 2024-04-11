% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [u,F] = solveKuF_beam(Km, F, u, idfDOF, idpDOF)

% Solve for displacements:
u(idfDOF,:) = mldivide( Km(idfDOF,idfDOF), F(idfDOF)-Km(idfDOF,idpDOF)*u(idpDOF,:) );

% Solve for reactions:
F(idpDOF,:)=Km(idpDOF,idfDOF)*u(idfDOF,:)+Km(idpDOF,idpDOF)*u(idpDOF,:);

% check if global stiffness matrix is badly conditioned
Kmcond = condest(Km(idfDOF,idfDOF));
if Kmcond >= 1e12
    fprintf(2,'Warning: Matrix is close to singular or badly scaled. Results may be inaccurate. CONDEST =  %.4e.\n', Kmcond);
end


end