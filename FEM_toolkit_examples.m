% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
%%% EXAMPLES
% this file contains examples for all import methods and element types


%% Config
clc; clear all; close all; % clear workspace
configmode = 'temp'; % config mode - 'permament', 'temp', 'pass'
run config.m % run config


%% Import model

% ===== Method 1: 'script_full' ================================================
%   Use the scripts "pb_script" and "BC_script" in the folder specified 
%   below to generate the lattice, boundary and loading conditions
%   Use the files "05_mat.txt" and "06_prob_set.txt" to
%   set the material properties, the problem settings and solver settings

nameProblem = 'example_01';
fo = [cd,strcat(filesep,'src',filesep,'examples',filesep),nameProblem]; 

switch_importMethod = 'script_full'; %'script_full', 'script_simplified', 'pbFC'
switch_outputMode = 'verbose'; %'verbose', 'silent'
[fem_ex01,opts_ex01,time_ex01] = import_model(fo,switch_importMethod,switch_outputMode);


% ===== Method 2: 'script_simplified' ================================================
%   Use the scripts "pb_script" and "BC_script" in the folder specified 
%   below to generate the lattice, boundary and loading conditions
%   Use the script "EAel_script" to set the material properties, 
%   the problem settings and solver settings

nameProblem = 'example_02';
fo = [cd,strcat(filesep,'src',filesep,'examples',filesep),nameProblem]; 

switch_importMethod = 'script_simplified'; %'script_full', 'script_simplified', 'pbFC'
switch_outputMode = 'verbose'; %'verbose', 'silent'
[fem_ex02,opts_ex02,time_ex02] = import_model(fo,switch_importMethod,switch_outputMode);



% ===== Method 3: 'pbFC' ==================================================
%   Use a struct pbFC that contains the lattice model, boundary and loading
%   conditions as fields pbFC.p, pbFC.b, pbFC.F, pbFC.C and pass it as an
%   additional argument to "import_model". Specify the fields as explained
%   in "pb_script" and "BC_script"

nameProblem = 'example_03';
fo = [cd,strcat(filesep,'src',filesep,'examples',filesep),nameProblem];  

pbFC = load('pbFC_example03').pbFC_example03;

switch_importMethod = 'pbFC'; %'script_full', 'script_simplified', 'pbFC'
switch_outputMode = 'verbose'; %'verbose', 'silent'
[fem_ex03,opts_ex03,time_ex03] = import_model(fo,switch_importMethod,switch_outputMode,pbFC);



%% Run FE-analysis and plot deformed configuration and stress
fem_ex01 = performFEM(fem_ex01,opts_ex01);
LC = 1; %Choose the appropriate load case
viz2D3D_line_deformed(fem_ex01,opts_ex01,LC,'Mag'); %'Mag', 'U1', 'U2', 'U3'
viz2D3D_line_stresses(fem_ex01,opts_ex01,LC);
 
fem_ex02 = performFEM(fem_ex02,opts_ex02);
LC = [1,2]; %Choose the appropriate load case
viz2D3D_line_deformed(fem_ex02,opts_ex02,LC,'Mag'); %'Mag', 'U1', 'U2', 'U3'
viz2D3D_line_stresses(fem_ex02,opts_ex02,LC); 
 
fem_ex03 = performFEM(fem_ex03,opts_ex03);
LC = 1; %Choose the appropriate load case or load cases
viz2D3D_line_deformed(fem_ex03,opts_ex03,LC,'Mag'); %'Mag', 'U1', 'U2', 'U3'
viz2D3D_line_stresses(fem_ex03,opts_ex03,LC);