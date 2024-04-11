% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
%% Setting up environment for edacFEM
% set configmode to 'permanent' to permanently set the path variables
% set configmode to 'temp' to set the path for this MATLAB instance only
% set configmode to 'pass' to do no config

if ~exist('configmode','var')
    % if the script is called without first setting the configmode - which
    % can happen when it is used as standalone, e.g. right after 
    % installation or when called in an FE-script without first setting 
    % configmode - the configmode temp is chosen.
    configmode='permanent';
end

switch configmode
    case 'permanent'
        thisFilePath=mfilename('fullpath'); % retrieve current file path
        [thisPath,~,~]=fileparts(thisFilePath); % folder path
        addpath(genpath(thisPath)); % add paths
        savepath % save path
        clear thisFilePath thisPath % delete variables

    case 'temp'
        thisFilePath=mfilename('fullpath'); % retrieve current file path
        [thisPath,~,~]=fileparts(thisFilePath); % folder path
        addpath(genpath(thisPath)); % add paths
        clear thisFilePath thisPath % delete variables

    case 'pass'
        % do nothing
end