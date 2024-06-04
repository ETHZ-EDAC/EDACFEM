% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function fem = performFEM(fem,opts)
if strcmp(opts.OutputMode,'verbose')
    % progress report
    fprintf(['Perform FE calculation "',opts.nameProblem,'" ... '])
end

% call script depending on the element type
switch opts.slv.elemType    
    case 'truss'
        fem = runTrussFEM(fem,opts);     
    case 'beam'
        fem = runBeamFEM(fem,opts);        
end

if strcmp(opts.OutputMode,'verbose')
    % progress report
    fprintf('DONE\n\n')
end
end