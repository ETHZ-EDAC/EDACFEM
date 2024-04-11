% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [fem] = importMatfile(fo,fem)
% filename
fid = [fo,strcat(filesep,'05_mat.txt')];

% check if material file exists
if exist(fid,'file') 
    % read material parameter (E Smax rho)
    [mat,type] = readInpTXTFile([fo,strcat(filesep,'05_mat.txt')]);

    % load material parameter to struct 
    for i=1:length(type)
        fem.el.(['e',type{i}]) = mat(mat(:,i)~=0,i);
    end

% throw error message if file does not exist
else
    error(['Material file (',fid,') does not exist. Please add the file to the corresponding folder.'])
end


end
