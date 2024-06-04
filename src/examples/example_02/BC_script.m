% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
%% Boundary conditions and loads
%  Define boundary conditions and loads
%   
%   C: constraints, i.e. DOFs that are constrained
%   F: external loads/moments and prescribed displacements/rotations
%   
%   Trusses:
%   C: [id togX togY]                                   -- 2D
%   C: [id togX togY togZ]                              -- 3D
%   F: [id type dirX dirY 0 magnitude];                 -- 2D
%   F: [id type dirX dirY dirZ magnitude];              -- 3D
%   type = 1:force, [], 3:displacement, []

%   Beams:
%   C: [id togX togY togZ togAlpha togBeta togGamma]    -- 3D
%   F: [id type dirX dirY dirZ magnitude];              -- 3D
%   type = 1:force, 2:moment, 3:displacement, 4:rotation
%
%   !!! Magnitude of load/displacement can either be presribed in 
%   "magnitude" or directly in e.g. dirX!!!
 

%% Find node sets

% nodes at x=0
id_x0 = find( p(:,1)==0 );

% nodes at x=xmax and y=0
id_load = find( p(:,1)==max(p(:,1)) & p(:,2)==0 );

% node closest to x=50, y=10 and z=30
[~,id_prescribed_displacement] = min(vecnorm(p - [50,10,30],2,2));

%% Apply BCs

% ----- select sets of nodes to which BCs are applied 
idFixAll  = [id_x0];
idFixX    = [];
idFixY    = [];
idFixZ    = [];


% ----- create BCs
c1 = [idFixAll repmat([1 1 1 1 1 1], size(idFixAll,1), 1)];
c2 = [idFixX repmat([1 0 0 0 0 0], size(idFixX,1), 1)];
c3 = [idFixY repmat([0 1 0 0 0 0], size(idFixY,1), 1)];
c4 = [idFixZ repmat([0 0 1 0 0 0], size(idFixZ,1), 1)];


% ----- Assemble C
C = {[c1;c2;c3;c4],[c1;c2;c3;c4]};


%% Apply loads & displacements

% ----- create loads/displacements

% load of f1=-100 in z-direction
f1 = [id_load repmat([1 0 0 1 -100], size(id_load,1), 1)]; 

% a prescribed displacement of u=5 in y-direction
f2 = [id_prescribed_displacement repmat([3 0 1 0 5], size(id_prescribed_displacement,1), 1)]; 


% ----- Assemble F
F = {[f1;f2],f1};



