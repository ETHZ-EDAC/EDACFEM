% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [A,eL]=assembleA(fem)

% delta length of truss element in each DOF [m x d]
ueL  =  fem.truss.C*toVec(fem.p);   

% length of truss elements
eL   = elLength(fem.p,fem.b);     

% check if members are too short
if any(eL <= 1e-5)
        fprintf('There are very short members!\n\t Shortest Member: %.1E',min(eL));
end

% delta of each element in Matrix form
U    = sparse((1:fem.m*fem.d),repmat(1:fem.m,fem.d,1),ueL);  % delta of each bar in Matrix form

% length of truss elements in matrix form
L    = sparse((1:fem.m),(1:fem.m),eL);    

% equilibrium matrix as [DOF x m] in each column, each bar has the directional cosines once positive and once negative
% derived from: Zhang, Jing Yao Zhang & Ohsaki, Makoto (2015). Equilibrium. In M. Wakayama (Ed.), Tensegrity Structures. Springer Tokyo. https://doi.org/10.1007/978-4-431-54813-3
A = -fem.truss.C.'*U*L^-1;                   

% check if A is valid
if any(any(isnan(A)))
    fprintf('NANs in A!');
end
    
end




