% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [Ke] = make_keB_timoshenko(E,A,Iy,Iz,G,J,L)
%MAKE_KEB_TIMOSHENKO
%   Creates the stiffness matrix of a 3D Timoshenko beam element
%   Based on 'Generating a Parametric Finite Element Model of a 3D Cantilever
%   Timoshenko Beam Using Matlab' by Heiko Panzer, Joerg Hubele, Rudy Eid and
%   Boris Lohmann.


%% Helper variables

%Theory--------------------------------------------------------------------
Ay = 0.89*A; %shear area (e.g. http://ivt-abaqusdoc.ivt.ntnu.no:2080/v6.14/books/usb/default.htm)
Az = 0.89*A;

Py = 12*E*Iz/(G*Ay*L^2); 
Pz = 12*E*Iy/(G*Az*L^2);
%--------------------------------------------------------------------------


%% Assemble stiffness matrix

% template for partition
K11 = zeros(6,6);

% fill partition
K11(1,1) = E*A/L ;
K11(2,2) = 12*E*Iz/(L^3*(1+Py)) ;
K11(3,3) = 12*E*Iy/(L^3*(1+Pz)) ;
K11(4,4) = G*J/L ;
K11(5,5) = (4+Pz)*E*Iy/(L*(1+Pz)) ;
K11(6,6) = (4+Py)*E*Iz/(L*(1+Py)) ;
K11(2,6) = 6*E*Iz/(L^2*(1+Py)) ;
K11(6,2) = K11(2,6) ;
K11(3,5) = -6*E*Iy/(L^2*(1+Pz)) ;
K11(5,3) = K11(3,5) ;

% transform to other partitions
K22 = -K11 + 2*diag(diag(K11));
K21 = K11 - 2*diag(diag(K11));
K21(5,5) = (2-Pz)*E*Iy/(L*(1+Pz)) ;
K21(6,6) = (2-Py)*E*Iz/(L*(1+Py)) ;
K21(2,6) = -K21(6,2);
K21(3,5) = -K21(5,3);

% assemble
Ke = [K11, K21'; K21, K22];

end