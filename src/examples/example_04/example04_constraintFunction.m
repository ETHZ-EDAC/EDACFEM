% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [c,ceq] = example04_constraintFunction(x,fem,opts,SY,DUB)
    %% Response calculation
    fem.el.eA=x;                                        %Update cross-sections A
    [fem,opts] = setParamsBeamFEM(fem,opts);            %Update moments of inertia
    fem = performFEM(fem,opts);                         %Get the response
    nLoadCases = fem.nLC;                               %Number of load cases
    m = fem.m;                                          %Number of bars

    %% von Mises
    Stress=zeros(m*nLoadCases,1);
    for i=1:nLoadCases
        Stress((i-1)*m+1:i*m,1)=fem.sol{i}.Smises;      %Get the von Mises stress response
    end

    %% Buckling
    N=zeros(m*nLoadCases,1);
    for i=1:nLoadCases
        N((i-1)*m+1:i*m,1)=fem.sol{i}.N;                %Get the axial forces
    end     

    % Critical member buckling load calculation
    K=.5;                                               %Buckling effective length parameter
    L = fem.el.eL;                                      %Get bar lenghts
    E=fem.el.eE;                                        %Get Young's modulus
    I = fem.el.eIy;                                     %Get moments of intertia 
    rg=(I./x).^0.5;                                     %Radius of gyration for members
    Crit_Buck=(pi^2*E)./(K*L./rg).^2;                   %Critical buckling load
    Stress_Axial=N./repmat(x,nLoadCases,1);

    %% Constraints set-up
    c1 = Stress-SY*ones(nLoadCases*m,1);                % Inequality constraints - vMises, <=0
    c2 = -Stress_Axial-repmat(Crit_Buck,nLoadCases,1);  % Inequality constraints - Buckling, <=0
    c3 = (x*4/pi).^0.5-DUB*ones(m,1);                   % Inequality constraints - max gauge <=0

    %% Output
    c = [c1;c2;c3];                                     % Inequality constraints;
    ceq=[];                                             % Equality constraints;
end