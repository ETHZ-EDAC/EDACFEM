% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [opts] = import_model_opts_simplified(fo,fem,elemType,elemSubtype)
% Simplified opts struct

%% Job ID
% Measure current date and time 
t = datetime;
% assemble unique job ID
jobId = sprintf('%4d%02d%02d_%02d%02d%02d', year(t), month(t), day(t), hour(t), minute(t), round(second(t))); 

%% Options
% Folder
opts.fo = fo;
% Name
nameProblem = strsplit(fo,'\');
opts.nameProblem = nameProblem{end};
% empty opts.prob template
opts.prob = struct();
% element type
opts.slv.elemType = elemType;
% element subtype
opts.slv.elemSubtype = elemSubtype;
% job ID
opts.jobId = jobId;

end