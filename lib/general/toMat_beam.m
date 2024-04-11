% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [mat] = toMat_beam(vec,d)
% TOMAT returns a []xd matrix from the input column vector. 
%   Transforms [n*nDOF,1]'-vectors that were created using the 'toVec' 
%   command back to the original size [n,nDOF]
%   d: dimension

mat = reshape(vec,d*2,[])';


end

