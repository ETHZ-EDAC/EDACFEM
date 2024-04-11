% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
% This file creates the points and bars for the current model
% 
% create p for vertices and b for bar connectivities

nx = 5;   % N of cells x-direction 10
ny = 1;   % N of cells y-direction 6
nz = 3;   % N of cells z-direction 5
L_cell = 10; % edge length of one cell

p = createPoints_example02(nx,ny,nz,L_cell); %Points
b = createBars_example02(nx,ny,nz); %Bars


% Compute element lengths
L = elLength(p,b);