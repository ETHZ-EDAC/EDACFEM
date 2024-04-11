% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
% try executing the file 'pb_script'
try
    % filepath
    pbfn = fullfile(fo,'pb_script.m');

    % run script
    run(pbfn);

% exeption handling if 'pb_script' throws error
catch
    % 'pb_script' does not exist => create 'BC_file' and write instructions
    if ~exist(pbfn,'file')
        % open file
        fileID = fopen(pbfn, 'wt');

        % load name of problem
        [~,model_name,~]=fileparts(fo);

        % write instructions to file
        fprintf(fileID, '%% This file creates the points and bars for the Model %s\n',model_name);
        fprintf(fileID, '%% \n');
        fprintf(fileID, '%% create p for points and b for bars\n');
        fprintf(fileID, '\n\n\n\n\n\n\n\n\n\n\n');
        
        % Close the file.
        fclose(fileID);
        
        % Open the file in the editor.
        edit(pbfn);
        
        % throw error
        error('Error  No BC file exists for the model. Please create the script for defining the BCs!');

    % 'BC_script' exists => throw error and open file 
    else
        % Open the file in the editor.
        edit(pbfn);

        % error message
        error('Error in executing the BC script!');
    end    
end