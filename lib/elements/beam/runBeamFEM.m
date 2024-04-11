% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function fem = runBeamFEM(fem,opts)
%% Parameters
% number of processor cores
opts.slv.noWorkers = feature('numcores'); 

%% Initialize
% Transform problem to 3D for proper assembly of Km
if fem.d == 2
    % change dimension
    fem.d = 3; 
    % add zero z coordinates
    fem.p(:,3) = zeros(size(fem.p(:,1))); 
    warning('A 2D input was provided to the beam solver. Please provide the additional DOF in the nodal coordinates, boundary conditions, and loads.')
end

% Add DOFs for moments and rotations
fem.DOF = fem.n*2*fem.d; 

%% Solve
[fem] = SolverLE_beam(fem,opts); 

%% Output - postprocess elemental response
fem = postProcessFEM_beam(fem,opts,fem.sol.u,fem.sol.F);

end
