% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [fem] = set_elementProperties(fem,E,A)
%% Set A and E
% set A
fem.el.eA = A;
% set E
fem.el.eE = E;
end

