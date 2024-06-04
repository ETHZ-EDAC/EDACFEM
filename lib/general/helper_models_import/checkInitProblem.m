% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [fem,opts] = checkInitProblem(fem,opts)
%% Material - Check size of fields
% load fields
matprops = fields(fem.el);

% check each field
for i=1:length(matprops)
    % if field has length 1 - repeat entry
    if length(fem.el.(matprops{i})) == 1
        fem.el.(matprops{i}) = repmat(fem.el.(matprops{i}),fem.m,1);

    % if field has length fem.m - do nothing
    elseif length(fem.el.(matprops{i})) == fem.m
        % do nothing

    % otherwise - throw error
    else
        error('Wrong size of the following Material property!\n\t %s: Length: %d\n\t Must be either 1 or %d',matprops{i},length(fem.el.(matprops{i})),fem.m)
    end
end
    

%% Loads - Check size
% check all loads
for i=1:fem.nLC
    % throw error if load has wrong size
    if size(fem.LC{i}.F,2) ~= 5
        error(['Wrong amount of Columns in the prescribed force in load case ',num2str(i),'!'])
    end
    if size(fem.LC{i}.U,2) ~= 5
        error(['Wrong amount of Columns in the prescribed displacement in load case ',num2str(i),'!'])
    end
end

% check if number of BC is 1 or number of loads
if fem.nLC~=fem.nBC && fem.nB~=1
    error(['Number of boundary cases has to be one or number of load cases (nBC: ',num2str(fem.nBC),' / nLC: ',num2str(fem.nLC),')'])
end


%% Problem Default options
% set default options
defaultProp = {  'selfweight',false;...                 
                 'A0',pi;...
                 'g',[0,0,-9.81e6]';...
                 'shape','circle';...                 
                 'buckling',0  };


% add default options if they are not given yet
AssumedDefault = [];
for i=1:size(defaultProp,1)
    if ~isfield(opts.prob,defaultProp{i,1})
        opts.prob.(defaultProp{i,1}) = defaultProp{i,2};
        AssumedDefault = [AssumedDefault,defaultProp{i,1},', '];
    end
end
if strcmp(opts.OutputMode,'verbose')
    if ~isempty(AssumedDefault)
        fprintf(['Default values assumed for: ',AssumedDefault(1:end-2),'\n\n']);
    end
end

%% Problem Settings - Check size of fields
% check A0
if length(opts.prob.A0) == 1
    % if field has length 1 - repeat entry
    opts.prob.A0 = repmat(opts.prob.A0,fem.m,1);
elseif length(opts.prob.A0) == fem.m
    % if field has length fem.m - do nothing
else
    % otherwise - throw error
    error('Wrong size of the following Material property!\n\t %s: Length: %d\n\t Must be either 1 or %d',matprops{i},length(fem.el.(matprops{i})),fem.m)
end
% load in fem struct if not loaded already
if isnan(sum(fem.el.eA))
    fem.el.eA = opts.prob.A0;
end


%% Properties - Check selfweight properties
% only check if selfweight is activated
if opts.prob.selfweight       
    % make g a column vector
    if size(opts.prob.g,2) ~=1
        opts.prob.g = opts.prob.g';
    end

    % make g a vector
    if length(opts.prob.g) ==1
        opts.prob.g = [0;0;opts.prob.g];
        warning('The gravitation direction is not defiend. It is set to the negative z-direction');
    end

    % throw warning if g is not 9.81
    if norm(opts.prob.g) ~= 9.81e6
        warning('The gravitational force vector is not standard. \n\t The current value is g=%f',norm(opts.prob.g));
    end
     
    % throw warning if g points in z direction for a 2D problem
    if fem.d~=3 && length(prob.g)==3 && opts.prob.g(3)~=0
        warning('The Problem is 2d! The third dimension of the gravitational force vector will be discarded.');
        opts.prob.g = opts.prob.g(1:2);
    end
         
    % Info about g
    g=opts.prob.g;
    if strcmp(opts.OutputMode,'verbose')
        switch fem.d
            case 2
                fprintf('Gravitation is turned on.\n\t Direction: [%.1f,%.1f] Magnitude: %.2f\n',g(1)./norm(g),g(2)./norm(g),norm(g));
            case 3
                fprintf('Gravitation is turned on.\n\t Direction: [%.1f,%.1f,%.1f] Magnitude: %.2f\n',g(1)./norm(g),g(2)./norm(g),g(3)./norm(g),norm(g));
        end
    end

end 


%% Element Type
% check if valid element type is provided, set to 'truss' if not
if isfield(opts.slv,'elemType') && ~ismember(opts.slv.elemType,{'truss','beam'})
    error(['Element type is set to "',opts.slv.elemType,'". Only "truss" and "beam" are valid element types.']);
elseif ~isfield(opts.slv,'elemType')
    warning(['No element type provided. Set to default (truss).']);
    opts.slv.elemType = 'truss';
end

% check if valid element subtype is provided. Set to default if not
switch opts.slv.elemType
    case 'truss'
        if isfield(opts.slv,'elemSubtype') && ~ismember(opts.slv.elemSubtype,{'linear'})
            warning('No or invalid element subtype given. Assumed subtype "linear" (default).')
            opts.slv.elemSubtype = 'linear';
        end        

    case 'beam'
        if isfield(opts.slv,'elemSubtype') && ~ismember(opts.slv.elemSubtype,{'eulerbernoulli','timoshenko'})
            warning('No or invalid element subtype given. Assumed subtype "eulerbernoulli" (default).')
            opts.slv.elemSubtype = 'eulerbernoulli';
        end      
end

%% Duplicate Nodes
% check if duplicate nodes are present in p
nodes = fem.p;
%find unique nodes and compare, if not equal display warning
nodesunique = unique(nodes,'rows');
if size(nodes,1) ~= size(nodesunique,1)
    duplicateNodes = size(nodes,1) - size(nodesunique,1);
    warning('Duplicate nodes detected in p during problem import. \n\t Number of duplicate nodes: %i \n',duplicateNodes);
end
%% Duplicate Bars
% check if duplicate bars are present in b
bars = fem.b;
%find unique bars and compare, if not equal display warning
b_sorted=sort(bars,2);
barsunique = unique(b_sorted,'rows');
if size(bars,1) ~= size(barsunique,1)
    duplicateBars = size(bars,1) - size(barsunique,1);
    warning('Duplicate bars detected in b during problem import. \n\t Number of duplicate bars: %i \n',duplicateBars);
end

end