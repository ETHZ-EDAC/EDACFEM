% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
%EAEL_SCRIPT Define Young's modulus E, bar cross-section area A, desnsity rho and element type
%   
%   E:          [1x1] or [nx1] -- all n members have the same E or specify for each
%   A:          [1x1] or [nx1] -- all n members have the same A or specify for each
%   r:          [1x1] or [nx1] -- all n members have the same r or specify for each
%  
%
%   elemType:   'truss', 'beam'
%   elemSubtype:   
%     - 'truss'    => 'linear'
%     - 'beam'     => 'eulerbernoulli', 'timoshenko'


E = 1000;
A = pi*1^.2;
r = 1.2e-9;

elemType      = 'beam';
elemSubtype   = 'timoshenko';