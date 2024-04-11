% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function opts = readOptions(fo,fem)
% file path
opts.fo = fo;

% problem name
nameProblem = strsplit(fo,filesep);
opts.nameProblem = nameProblem{end};

% Problem Settings
opts.prob = importParamFile([fo,strcat(filesep,'06_prob_set.txt')]);

% Eval required fields
opts = evalField(fem,opts,'s');
opts = evalField(fem,opts,'A0');
opts = evalField(fem,opts,'dir_nominal_lateral');

% Solver Settings
opts.slv = importParamFile([fo,strcat(filesep,'07_slv_set.txt')]);

end



% tranform non-numerical fields to numerical fields
function opts = evalField(fem,opts,name)
    % check if field exists and if field is not numeric
    if isfield(opts.prob,name) && ~isnumeric(opts.prob.(name))
        % evaluate field
        opts.prob.(name) = eval(opts.prob.(name));
    end

end
