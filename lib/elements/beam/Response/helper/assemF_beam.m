% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function F = assemF_beam(fem,opts,iLC)

% add selfweigth if turned on, init forces with zero otherwise
if isfield(opts,'prob') && isfield(opts.prob,'selfweight') && opts.prob.selfweight 
    % Assemble global connectivity matrix
    C = assembleC(fem);   
    F = toVec((opts.prob.g(1:fem.d)*(0.5*(fem.el.eA.*fem.el.eL.*fem.el.erho)'*abs(C(1:fem.d:end,1:fem.d:end))))');
    F = [toMat(F,3),zeros(size(F,1)/3,3)];
    F = toVec(F);
else
    F = zeros(fem.DOF,1);
end

% get DOF of acting forces
idF = id2DOF_beam(fem.LC{iLC}.F(:,1),fem.d);
% take only DOF [1,2,3, , , ] from full 6 DOF vector (only forces, not moments)
idF = idF( toVec( (repmat([1:2*fem.d:size(idF,1)],fem.d,1)+repmat(([1:fem.d]-1)',1,size(idF,1)/(2*fem.d)))' ) ); 
% fill force magnitude to F vector
F(idF) = F(idF) + toVec( fem.LC{iLC}.F(:,2:1+fem.d) .* fem.LC{iLC}.F(:,5) );

% get DOF of acting moments
idM = id2DOF_beam(fem.LC{iLC}.M(:,1),fem.d);
% take only DOFs [ , , ,4,5,6] from full 6 DOF vector (only moments, not forces)
idM = idM( toVec( (repmat([1:2*fem.d:size(idM,1)],fem.d,1)+repmat(([fem.d+1:2*fem.d]-1)',1,size(idM,1)/(2*fem.d)))' ) );  
% fill moment magnitude to F vector
F(idM) = F(idM) + toVec( fem.LC{iLC}.M(:,2:1+fem.d) .* fem.LC{iLC}.M(:,5) );


end