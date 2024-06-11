% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [Ke] = make_keB_eulerbernoulli(E,A,Iy,Iz,G,J,L)

    % initialize
    Ke = sparse(12,12); 

    % Axial Force
    a=E*A/L; 
    Ke(1,1)=a;
    Ke(7,7)=a;
    Ke(7,1)=-a;
    Ke(1,7)=-a;

    % Torsion
    a=G*J/L; 
    Ke(4,4)=a;
    Ke(10,10)=a;
    Ke(4,10)=-a;
    Ke(10,4)=-a;

    % Bending y axis 
    a=12*E*Iy/L^3; 
    Ke(3,3)=a;
    Ke(9,9)=a;
    Ke(9,3)=-a;
    Ke(3,9)=-a;

    a=4*E*Iy/L;
    Ke(5,5)=a;
    Ke(11,11)=a;
    Ke(5,11)=a/2;
    Ke(11,5)=a/2;

    a=6*E*Iy/L^2; 
    Ke(5,3)=-a;
    Ke(3,5)=-a;
    Ke(11,3)=-a;
    Ke(3,11)=-a;

    Ke(9,5)=a;
    Ke(5,9)=a;
    Ke(11,9)=a;
    Ke(9,11)=a;

    % Bending z axis 
    a=12*E*Iz/L^3; 
    Ke(2,2)=a;
    Ke(8,8)=a;
    Ke(8,2)=-a;
    Ke(2,8)=-a;
    
    a=4*E*Iz/L;
    Ke(6,6)=a;
    Ke(12,12)=a;
    Ke(6,12)=a/2;
    Ke(12,6)=a/2;

    a=6*E*Iz/L^2;
    Ke(6,2)=a;
    Ke(2,6)=a;
    Ke(12,2)=a;
    Ke(2,12)=a;

    Ke(8,6)=-a;
    Ke(6,8)=-a;
    Ke(12,8)=-a;
    Ke(8,12)=-a;
    
end