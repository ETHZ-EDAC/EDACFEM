% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [fem,opts] = setParamsBeamFEM(fem,opts)

%% Feasibility
% check if 'nu' is set correctly for beam-FEM-analysis
if ~isfield(fem.el,'nu')
    % set to default
   fem.el.nu = repmat(0.3,fem.m,1);
   % report if verbose
   if strcmp(opts.OutputMode,'verbose')
    fprintf('No Poissons ratio specified. It will be set to nu=0.3 for all members.\n\n');
   end
end


%% Material parameters
% Shear module
fem.el.eG = fem.el.eE./(2*(1+fem.el.nu));   

% element length
fem.el.eL   = elLength(fem.p,fem.b); 

%% Geometric parameters, assuming circular cross-section
% Moment of inertia (pi*d^4/64)
fem.el.eIy = fem.el.eA.^2/(4*pi);       

% Moment of inertia
fem.el.eIz = fem.el.eIy;   

% J
fem.el.eJ = fem.el.eIy + fem.el.eIz;

end

