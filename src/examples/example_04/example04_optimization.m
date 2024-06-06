% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
%% Config
clc; clear all; close all;                                          %clear workspace

%% Import Model pdFC Method
%see FEM_toolkit_examples.m for specificy on this import method
nameProblem = 'example_04';
fo = [cd,strcat(filesep,'src',filesep,'examples',filesep),nameProblem];  

pbFC = load('pbFC_example04').pbFC_example04;

switch_importMethod = 'pbFC'; 
switch_outputMode = 'silent';
[fem_ex04,opts_ex04,time_ex04] = import_model(fo,switch_importMethod,switch_outputMode,pbFC);

%% Optimization Set-Up
% Variables ***************************************************************
DLB=.0001;                                                          % Bar diameter - lower bound per direction
DUB= 2.0;                                                           % Bar diameter - upper bound per direction
LB(1:6,1) = DLB^2*pi/4;                                             % Bar cross-section sizes - lower bound
UB(1:6,1) = DUB^2*pi/4;                                             % Bar cross-section sizes - upper bound

% Design variable linking based on the position of bars *******************
p=fem_ex04.p; b=fem_ex04.b;
bar_centroids= (p(b(:,2),:)+p(b(:,1),:))/2;                         %Bar centroids
minX=min(bar_centroids(:,1));                                       %Scaling X
maXX=max(bar_centroids(:,1));               
minY=min(bar_centroids(:,2));                                       %Scaling Y
maXY=max(bar_centroids(:,2));
minZ=min(bar_centroids(:,3));                                       %Scaling Z
maXZ=max(bar_centroids(:,3));
% Variable linking
A_var=@(x)(x(2)-x(1))/(maXX-minX).*(bar_centroids(:,1)-minX)+x(1)+...
          (x(4)-x(3))/(maXY-minY).*(bar_centroids(:,2)-minY)+x(3)+...
          (x(6)-x(5))/(maXZ-minZ).*(bar_centroids(:,3)-minZ)+x(5);
A0=(LB+UB)/2;                                                       %Optimization starting point

% Objective function ******************************************************
L = fem_ex04.el.eL;                                                 %Get bar lenghts
V=@(x)A_var(x)'*L;                                                  %Objective function

% Constraints *************************************************************
vmLimit=100; %vMises limit in MPa
Constr=@(x)example04_constraintFunction(A_var(x),fem_ex04,opts_ex04,vmLimit,DUB);

%% Optimization FMINCON using IPOPT
options = optimoptions(@fmincon,...                                 %Optimization options
    'Algorithm', 'interior-point',...
    'Display', 'iter-detailed',...  
    'PlotFcns', @optimplotfval,...                                  %Command window output
    'MaxFunctionEvaluations', 10000);                               %Built-in plot function call
[x_star,V_star] = fmincon(V,A0,[],[],[],[],...                      %Solver call
    LB,UB,Constr,options);

%% Results
disp('Optimization finished <><><><><><><><><><><><><><><><><><><><>');
disp(['V* = ' num2str(V_star)]);
disp(['x* = ' num2str(x_star')]);
A=A_var(x_star);

%% Visualize Results
fem_ex04.el.eA=A; %Update cross-sections A
[fem_ex04,opts_ex04] = setParamsBeamFEM(fem_ex04,opts_ex04);        %Update moments of inertia I
fem_ex04 = performFEM(fem_ex04,opts_ex04);                          %Get the response
nLoadCases = size(fem_ex04.sol,2);                                  %Number of load cases
for i=1:nLoadCases %Visual
    viz2D3D_line_deformed(fem_ex04,opts_ex04,i,'Mag'); 
    viz2D3D_line_stresses(fem_ex04,opts_ex04,i);
end

%% Make Output Table with Results 
m=fem_ex04.m;
Bar = repmat((1:m)',nLoadCases,1);                                  %Bar IDs in b
A_star=repmat(A,nLoadCases,1);
D_star=repmat((A*4/pi).^0.5,nLoadCases,1);
c=Constr(x_star);
g_vMises=c(1:nLoadCases*m);
g_Buckling=c(nLoadCases*m+1:nLoadCases*2*m);
g_MaxGauge=c(nLoadCases*2*m+1:nLoadCases*2*m+m);
g_MaxGauge=repmat(g_MaxGauge,nLoadCases,1);
LC=repelem((1:nLoadCases),m)';
ResTab=table(Bar,A_star,D_star,LC, g_vMises,g_Buckling,g_MaxGauge); %Results table