% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [vec] = toVec(mat)
% TOVEC returns a vector of the input matrix. Similar to A(:) put first come
% the lines

vec = reshape(mat',[],1);

end

