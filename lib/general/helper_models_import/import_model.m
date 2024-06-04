% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [fem,opts,time] = import_model(fo,importMethod,switchOutputMode,varargin)
% add switchVerbose to the opts struct
opts.OutputMode = switchOutputMode;

% progress report
if strcmp(opts.OutputMode,'verbose')
    fprintf('Reading from folder: ');
    fprintf('<a href="matlab: winopen(''%s'')">%s</a>\n\n',fo,fo);
end

% initialize time measurement for print
time = measureTime([],'importModel'); 

%% Import Model
% import depending on method
switch importMethod
    % import from scripts
    % material, problem and solver settings imported later from .txt files
    case 'script_full'
        % check if 'pb_script' is available and run
        runPBscript;
        % check if 'BC_script' is available and run
        runBCscript;
        % assemble metrics
        fem = assembleData(p,b,F,C);
        % import material file 
        fem = importMatfile(fo,fem);
        % import options
        opts = import_model_opts_full(fo,fem);

    % import from scripts
    % material, problem and solver settings imported from script
    case 'script_simplified'
        % check if 'pb_script' is available and run
        runPBscript;
        % check if 'BC_script' is available and run
        runBCscript;
        % check if 'EAel_script' is available and run
        runEAelscript; 
        % assemble metrics
        fem = assembleData(p,b,F,C,E,A,r);
        % import options
        opts = import_model_opts_simplified(fo,fem,elemType,elemSubtype);

    % import from pbFC-struct provided as varargin
    case 'pbFC'
        % extract data
        p = varargin{1}.p;
        b = varargin{1}.b;
        F = varargin{1}.F;
        C = varargin{1}.C;   
        E = varargin{1}.E;
        A = varargin{1}.A;
        r = varargin{1}.rho;
        elemType = varargin{1}.elemType;
        elemSubtype = varargin{1}.elemSubtype;
        % assemble metrics
        fem = assembleData(p,b,F,C,E,A,r);
        % import options
        opts = import_model_opts_simplified(fo,fem,elemType,elemSubtype);
end

% add switchVerbose to the opts struct
opts.OutputMode = switchOutputMode;

%% Feasibility Check
[fem,opts] = checkInitProblem(fem,opts);

%% Element Specific Settings
% properties for beam structure
if strcmp(opts.slv.elemType,'beam')
    [fem,opts] = setParamsBeamFEM(fem,opts);
end

%% Display
if strcmp(opts.OutputMode,'verbose')
    % model setup time
    time = measureTime(time,'importModel','print');

    % display model statistics
    fprintf('\n');
    fprintf('--------------------------\n ');
    fprintf('Model Statistics:\n')
    fprintf('\t# of Nodes:      %d\n',fem.n);
    fprintf('\t# of Members:    %d\n',fem.m);
    fprintf('\t# of Load Cases: %d\n',fem.nLC);
    fprintf('--------------------------\n ');
    fprintf('\n');
else
    % model setup time
    time = measureTime(time,'importModel');
end

end