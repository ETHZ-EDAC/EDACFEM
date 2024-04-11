% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
% try executing the file 'BC_script'
try
    % filepath
    BCfn = fullfile(fo,'BC_script.m');

    % run script
    run(BCfn);

% exeption handling if 'BC_script' throws error
catch
    % 'BC_script' does not exist => create 'BC_file' and write instructions
    if ~exist(BCfn,'file')
        % open file
        fileID = fopen(BCfn, 'wt');

        % load name of problem
        [~,model_name,~]=fileparts(fo);

        % write instructions to file
        fprintf(fileID, '%% This file creates the Boundary Condition for the Model %s\n',model_name);
        fprintf(fileID, '%%\n');
        fprintf(fileID, '%% use p for points and b for bars\n');
        fprintf(fileID, '%% use find(p(:,1)==500 & p(:,2)==0 & p(:,3)==0);\n');
        fprintf(fileID, '%% use pts=GetFaceNodes(face_id,model,e);\n');
        fprintf(fileID, '%% ');
        fprintf(fileID, '%% generate F and C for Force table and constraint table\n');
        fprintf(fileID, '%% F: [id type dirX dirY dirZ magnitude]\n');
        fprintf(fileID, '%%     type = 1:force,2:moment, 3:displacemnt, 4:rotation\n');
        fprintf(fileID, '%% ');
        fprintf(fileID, '%% C: [id togX togY togZ togAlpha togBeta togGamma]\n');
        fprintf(fileID, '%% \n');
        fprintf(fileID, '%% each load case go''s into its own cell!\n');
              
        % Close the file.
        fclose(fileID);
        
        % Open the file in the editor.
        edit(BCfn);
        
        % throw error
        error('Error  No BC file exists for the model. Please create the script for defining the BCs!');
    
    % 'BC_script' exists => throw error and open file 
    else
        % Open the file in the editor.
        edit(BCfn);

        % error message
        error('Error in executing the BC script!');
    end    
end