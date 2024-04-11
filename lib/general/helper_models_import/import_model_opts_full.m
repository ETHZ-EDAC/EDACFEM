% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [opts] = import_model_opts_full(fo,fem)
% Import full options from txt-files
% Requires: 06_prob_set.txt, 07_slv_set.txt

%% Job ID
% Measure current date and time 
t = datetime;
% assemble unique job ID
jobId = sprintf('%4d%02d%02d_%02d%02d%02d', year(t), month(t), day(t), hour(t), minute(t), round(second(t))); 


%% Options
% retrieve options
opts = readOptions(fo,fem);
% insert jobID
opts.jobId = jobId;


end