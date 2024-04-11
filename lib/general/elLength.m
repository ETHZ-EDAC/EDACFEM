% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function l = elLength(p,b)

dxyz = p(b(:,2),:) - p(b(:,1),:);

l = sqrt(sum(dxyz.^2,2));

end