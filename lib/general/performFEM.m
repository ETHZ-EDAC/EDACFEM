% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function fem = performFEM(fem,opts)
% progress report
fprintf(['Perform FE calculation "',opts.nameProblem,'" ... '])

% call script depending on the element type
switch opts.slv.elemType    
    case 'truss'
        fem = runTrussFEM(fem,opts);     
    case 'beam'
        fem = runBeamFEM(fem,opts);        
end

% progress report
fprintf('DONE\n\n')
end