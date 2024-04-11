% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [idBC] = assemConstr_beam(fem,opts,iLC)

% Get the corresponding Constraint set
if fem.nBC == 1
    iBC = 1;
else
    iBC = iLC;
end

% check if current constraint set is empty
if ~isempty(fem.BC{iBC}.const)
    % retrieve DOF of BC
    idBC = id2DOF_beam(fem.BC{iBC}.const(:,1),fem.d);
    % remove entries where assigned BC is zero
    idBC = idBC( toVec(fem.BC{iBC}.const(:,2:1+2*fem.d))==1 );
else
    % empty idBC
    idBC = [];
end

end