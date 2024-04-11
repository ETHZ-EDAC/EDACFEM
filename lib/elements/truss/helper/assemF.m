% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function F = assemF(fem,opts,iLC)

% gravity vector
if isfield(opts,'prob') && isfield(opts.prob,'selfweight') && opts.prob.selfweight 
    F = toVec((opts.prob.g(1:fem.d)*(0.5*(fem.el.eA.*fem.el.eL.*fem.el.erho)'*abs(fem.truss.C(1:fem.d:end,1:fem.d:end))))');
else
    F = zeros(fem.DOF,1);
end

% DOF IDs of prescribed forces
idF = id2DOF(fem.LC{iLC}.F(:,1),fem.d);

% add prescribed forces to force vector
F(idF) = F(idF) + toVec(fem.LC{iLC}.F(:,2:1+fem.d) .* fem.LC{iLC}.F(:,5));

end