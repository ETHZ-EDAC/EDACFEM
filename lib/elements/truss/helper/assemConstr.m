% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [idBC] = assemConstr(fem,opts,iLC)

% Get the corresponding Constraint set
if fem.nBC == 1
    iBC = 1;
else
    iBC = iLC;
end

% DOF IDs of constraints
idBC = id2DOF(fem.BC{iBC}.const(:,1),fem.d);

% remove entries where assigned BC is zero
idBC = idBC( toVec(fem.BC{iBC}.const(:,2:1+fem.d))==1 );

end