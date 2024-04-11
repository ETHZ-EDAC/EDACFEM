% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [Kg,Tg] = Kg_chunkB(p,b,E,A,Iyy,Izz,G,J,L,m,n,m_begin,beamType)

% initialize
Kg = sparse(m,n);
Tg = sparse(m,n);

% iterate for each bar
for i = 1:size(b,1)
    % IDs of points
    p1 = b(i,1);
    p2 = b(i,2);

    % coordinate of points
    p1_ = p(b(i,1),:);
    p2_ = p(b(i,2),:);

    % transformation matrix (from local to global coordinate system)
    T = Transf_B_Round(p1_',p2_',L(i));

    % stiffness matrix in beam local coordinate system
    if strcmp(beamType,'eulerbernoulli')
        ke = make_keB_eulerbernoulli(E(i),A(i),Iyy(i),Izz(i),G(i),J(i),L(i)); 
    elseif strcmp(beamType,'timoshenko')
        ke = make_keB_timoshenko(E(i),A(i),Iyy(i),Izz(i),G(i),J(i),L(i));
    else
        error('Unsupported beam type! \n''%s'' was supplied, supported options are: ''eulerbernoulli'' and ''timoshenko''.',beamType)
    end

    % transform to global coordinates
    Ke = T'*ke*T;   

    % Global top index node1
    n1 = 6*b(i,1)-5;
    % Global top index node2  
    n2 = 6*b(i,2)-5;
    % Local top index node1
    n1 = n1-m_begin+1;
    % Local top index node2 
    n2 = n2-m_begin+1;  

    % Assemble global stiffness and transformation matrices
    if n1>=1&&n1<m
        Kg(n1:n1+5,6*p1-5:6*p1)=Kg(n1:n1+5,6*p1-5:6*p1)+Ke(1:6,1:6);
        Tg(n1:n1+5,6*p1-5:6*p1)=T(1:6,1:6); 
    end

    if n1>=1&&n1<m
        Kg(n1:n1+5,6*p2-5:6*p2)=Kg(n1:n1+5,6*p2-5:6*p2)+Ke(1:6,7:12); 
    end

    if n2>=1&&n2<m
        Kg(n2:n2+5,6*p1-5:6*p1)=Kg(n2:n2+5,6*p1-5:6*p1)+Ke(7:12,1:6); 
    end

    if n2>=1&&n2<m
        Kg(n2:n2+5,6*p2-5:6*p2)=Kg(n2:n2+5,6*p2-5:6*p2)+Ke(7:12,7:12);
        Tg(n2:n2+5,6*p2-5:6*p2)=T(7:12,7:12); 
    end

end

end

