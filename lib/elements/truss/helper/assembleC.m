% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [C] = assembleC(fem)

% -1/1 entries for outgoing/incoming bars [2*m x 1]
data  = [-1*ones(fem.m, 1);ones(fem.m, 1)];  

% enumerate rows from 1 to m [2*m x 1]
rows  = [(1:fem.m).';(1:fem.m).'];         

% columns indicating positions of truss members [2*m x 1]
cols  = fem.b(:);                         

% connectivity matrix: maps the node DOF to the member DOF [m*d x nDOF]
C = sparse( id2DOF(rows,fem.d),...
            id2DOF(cols,fem.d),...
            toVec(repmat(data,1,fem.d)),fem.m*fem.d,fem.n*fem.d); 
           
% check floating nodes
if any(sum(abs(C))==0)
    fprintf(2,'Warning, some nodes are not connected to any elements!\n');
end

end