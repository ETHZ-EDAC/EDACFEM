% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [Kg,Tg] = Kg_chunkB(p,b,E,A,Iyy,Izz,G,J,L,m,n,m_begin,beamType)

% Kg and Tg will be built as sparse matrices using the regular sparse
% matrix initialization.
% To do this, three vectors need to be built. For each nonzero in the final
% matrices, there is one entry in each of the three vectors. The first
% vector holds the row index, the second one the column index and the third
% one the value.
% The sparse initialization automatically carries out the addition.

% we first estimate the maximum number of entries. Per element, there are a
% maximum of 144 nonzeros.

numEls = size(b,1);
numNonZerosMax = numEls*144;

% prepare vectors for the indices 
rowVec = zeros(numNonZerosMax,1);
colVec = zeros(numNonZerosMax,1);
valVec = zeros(numNonZerosMax,1); % name of this vector sounds almost like a good red wine

% we need a counter to keep track of the extent to which the vectors are
% filled.

ctr = 1;

% set up a parallel structure for T. There, we add a maximum of 72 nonzeros
% per element
numNonzerosMaxTG = numEls*72;
rowVecTG = zeros(numNonzerosMaxTG,1);
colVecTG = zeros(numNonzerosMaxTG,1);
valVecTG = zeros(numNonzerosMaxTG,1);
ctrTG = 1;

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
        % adds 36 entries to Kg and Tg
        % old implementation, for reference
%         KgOld(n1:n1+5,6*p1-5:6*p1)=KgOld(n1:n1+5,6*p1-5:6*p1)+Ke(1:6,1:6);
%         Tg(n1:n1+5,6*p1-5:6*p1)=T(1:6,1:6);

        % create vectors holding the rows and columns
        % ...and then flatten them into our vectors where we gather
        % everything.
        [rows,cols] = meshgrid(n1:n1+5,6*p1-5:6*p1);
        vals = Ke(1:6,1:6);
        rowVec(ctr:ctr+35) = reshape(rows',1,[])';
        colVec(ctr:ctr+35) = reshape(cols',1,[])';
        valVec(ctr:ctr+35) = vals(:);
        % don't forget to update the counter
        ctr = ctr+36; % we advanced by 36 entries
        
        % same story for TG
        valsTG = T(1:6,1:6);
        rowVecTG(ctrTG:ctrTG+35) = reshape(rows',1,[])';
        colVecTG(ctrTG:ctrTG+35) = reshape(cols',1,[])';
        valVecTG(ctrTG:ctrTG+35) = valsTG(:);
        ctrTG = ctrTG+36;
    end

    if n1>=1&&n1<m
        % adds 36 entries to Kg
        % for reference: old implementation
%         KgOld(n1:n1+5,6*p2-5:6*p2)=KgOld(n1:n1+5,6*p2-5:6*p2)+Ke(1:6,7:12); 
        
        % same story. Build matrices with rows and column index, as well as
        % values.
        [rows, cols] = meshgrid(n1:n1+5,6*p2-5:6*p2);
        vals = Ke(1:6,7:12);
        rowVec(ctr:ctr+35) = reshape(rows',1,[])';
        colVec(ctr:ctr+35) = reshape(cols',1,[])';
        valVec(ctr:ctr+35) = vals(:);
        
        % don't forget to update the counter...
        ctr = ctr+36;
    end

    if n2>=1&&n2<m
        % adds 36 entries to Kg
        % for reference: old implementation
%         KgOld(n2:n2+5,6*p1-5:6*p1)=KgOld(n2:n2+5,6*p1-5:6*p1)+Ke(7:12,1:6); 
        
        % same old story
        [rows,cols] = meshgrid(n2:n2+5,6*p1-5:6*p1);
        vals = Ke(7:12,1:6);
        rowVec(ctr:ctr+35) = reshape(rows',1,[])';
        colVec(ctr:ctr+35) = reshape(cols',1,[])';
        valVec(ctr:ctr+35) = vals(:);
        
        %...and update the counter
        ctr = ctr+36;
    end

    if n2>=1&&n2<m
        % adds 36 entries to Kg and Tg
        % for reference: old implementation
%         KgOld(n2:n2+5,6*p2-5:6*p2)=KgOld(n2:n2+5,6*p2-5:6*p2)+Ke(7:12,7:12);
        % Tg(n2:n2+5,6*p2-5:6*p2)=T(7:12,7:12);
        
        % ...and a last time...
        [rows,cols] = meshgrid(n2:n2+5,6*p2-5:6*p2);
        vals = Ke(7:12,7:12);
        rowVec(ctr:ctr+35) = reshape(rows',1,[])';
        colVec(ctr:ctr+35) = reshape(cols',1,[])';
        valVec(ctr:ctr+35) = vals(:);
        
        % and again, don't forget the counter
        ctr = ctr+36;
        
        % same story for Tg
        valsTG = T(7:12,7:12);
        rowVecTG(ctrTG:ctrTG+35) = reshape(rows',1,[])';
        colVecTG(ctrTG:ctrTG+35) = reshape(cols',1,[])';
        valVecTG(ctrTG:ctrTG+35) = valsTG(:);
        
        ctrTG = ctrTG+36;
    end

end

% trim off the end where we did not fill in any nonzeros
rowVec = rowVec(1:ctr-1);
colVec = colVec(1:ctr-1);
valVec = valVec(1:ctr-1);
rowVecTG = rowVecTG(1:ctrTG-1);
colVecTG = colVecTG(1:ctrTG-1);
valVecTG = valVecTG(1:ctrTG-1);

% and build the big thing at once...
Kg = sparse(rowVec,colVec,valVec,m,n);
Tg = sparse(rowVecTG,colVecTG,valVecTG,m,n);

end

