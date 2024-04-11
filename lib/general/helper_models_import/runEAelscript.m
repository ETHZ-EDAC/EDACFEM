% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
% try executing the file 'EAel_script'
try
    % filepath
    EAelfn = fullfile(fo,'EAel_script.m');

    % run script
    run(EAelfn);

% exeption handling if 'EAel_script' throws error
catch
    % 'EAel_script' does not exist => create 'BC_file' and write instructions
    if ~exist(EAelfn,'file')
        % open file
        fileID = fopen(EAelfn, 'wt');

        % load name of problem
        [~,model_name,~]=fileparts(fo);

        % write instructions to file
        fprintf(fileID, '%% This file creates the E, A, and the element type for the Model %s\n',model_name);
        fprintf(fileID, '\n\n\n\n\n\n\n\n\n\n\n');
        
        % Close the file.
        fclose(fileID);
        
        % Open the file in the editor.
        edit(EAelfn);
        
        % throw error
        error('Error  No EAel file exists for the model. Please create the script for defining E, A, elemType!');

    % 'EAel_script' exists => throw error and open file 
    else
        % Open the file in the editor.
        edit(EAelfn);

        % error message
        error('Error in executing the EAel script!');
    end    
end