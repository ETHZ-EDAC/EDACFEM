% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function dofID = id2DOF_beam(id,d)
% Returns the id to the DOFs if only the ids were passed.
% id = [1 2]'
% leads to dof = [1 2 3 4 5 6 7 8 9 10 11 12]' if d=3
%                 ----------- --------------
%                      id1          id2

if size(id,1) == 1
    id = id';
end

dofID = toVec(   (repmat(id,1,2*d)-1) .* (2*d) + repmat(1:2*d,size(id,1),1)  );


end