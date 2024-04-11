% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [fem] = assembleData(p,b,F,C,varargin)
% Assembles data into a fem-struct

%% Initialize  
fem.d=0; % dimension
fem.n=0; % number of points
fem.m=0; % number of bars
fem.DOF=0; % number of DOF
fem.nLC=0; % number of loads
fem.nBC=0; % number of boundary conditions

%% Nodes
% coordinates
fem.p = p;

% problem dimension
if size(fem.p,2)==2
    fem.d = 2;
else
    fem.d = 3;
end

% number of points
fem.n = size(fem.p,1);

% number of DOF
fem.DOF = fem.n*fem.d;


%% Elements
% bars 
fem.b = b;

% number of bars
fem.m = size(fem.b,1);

% template vector for bar area
fem.el.eA = nan(fem.m,1);

% add E and A if provided
if ~isempty(varargin)
    % set A
    fem.el.eE = varargin{1};
    % set E
    fem.el.eA = varargin{2};
    % set rho
    fem.el.erho = varargin{3};
end


%% Loads and constraints
% number of loads
[nLoads,F] = count_cell(F);
fem.nLC  = nLoads;

% number of constraints
[nCons,C]  = count_cell(C);
fem.nBC  = nCons;

% for each load, evaluate metrics
for i=1:nLoads
    % current load
    loads = F{i};

    % masks determining the load type
    idF = loads(:,2)==1; % Type 1: Forces
    idM = loads(:,2)==2; % Type 2: Moments
    idU = loads(:,2)==3; % Type 3: Displacments
    idR = loads(:,2)==4; % Type 4: Rotations

    % number of loads of each type
    fem.LC{i}.nF = sum(idF);
    fem.LC{i}.nM = sum(idM);
    fem.LC{i}.nU = sum(idU);
    fem.LC{i}.nR = sum(idR);

    % split load in types
    fem.LC{i}.F = loads(idF,[1,3:end]);
    fem.LC{i}.M = loads(idM,[1,3:end]);
    fem.LC{i}.U = loads(idU,[1,3:end]);
    fem.LC{i}.R = loads(idR,[1,3:end]);
end

% for each constraint, evaluate metrics
for i=1:nCons
    % current constraint
    const = C{i};

    % padd constraint with zeros
    if size(const,2) == 4 && fem.d == 3
        const = [const zeros(size(const,1),3)];
    end
    if size(const,2) == 4 && fem.d == 2
        const = [const(:,1:3) zeros(size(const,1),3) const(:,4)];
    end
    if size(const,2) == 3
        const = [const zeros(size(const,1),4)];
    end

    % number of constraints of each type
    if ~isempty(const)
        fem.BC{i}.nC    = size(const,1); % total number
        fem.BC{i}.nDisp = sum(sum(const(:,2:4))); % displacement constraints
        fem.BC{i}.nRot  = sum(sum(const(:,5:7))); % rotation constraints
        fem.BC{i}.const = const; % contraint 
    else
        fem.BC{i}.nC    = 0; % total number
        fem.BC{i}.nDisp = 0; % displacement constraints
        fem.BC{i}.nRot  = 0; % rotation constraints
        fem.BC{i}.const = const; % contraint 
    end
end
end

% count number of cells OR transform input to cell if single input given
function [n,cinp] = count_cell(inp)
    if iscell(inp)
        n = length(inp); 
        cinp = inp;
    else
        cinp{1} = inp;
        n = 1;
    end
end