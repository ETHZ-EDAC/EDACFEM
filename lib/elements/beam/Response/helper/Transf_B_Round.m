% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [T] = Transf_B_Round(n1,n2,L)
    % calculates T for cicular cross sections
    % n1 - node 1 coordinates
    % n2 - node 2 coordinates
    % L  - element length
 
    % normalized vector between points
    lmn_x=(n2-n1)'/L;
    % normalized projection on xy plane
    Lxy=sqrt(lmn_x(1)^2+lmn_x(2)^2);

    %element in direction of z axis
    if Lxy==0 
        T = [0 0 lmn_x(3);0 1 0;-lmn_x(3) 0 0];
    else               
        lmn_y=[-lmn_x(2)/Lxy lmn_x(1)/Lxy 0];
    
        lmn_z=[-lmn_x(1)*lmn_x(3)/Lxy, -lmn_x(2)*lmn_x(3)/Lxy, Lxy];
        
        T=[lmn_x; lmn_y; lmn_z]; %Normalize
    end

    % Make transformation matrix
    T=blkdiag(T,T,T,T);
    T=sparse(T);
end