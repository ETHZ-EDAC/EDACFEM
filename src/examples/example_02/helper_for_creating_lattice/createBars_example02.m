% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [b] = createBars_example02(nx,ny,nz)
% creates a connectivity matrix of a fully connected grid. The three inputs
% give the number of unit cells in the three main directions.

% first get some important indices in the p-matrix
numCornerPoints = (nx+1)*(ny+1)*(nz+1);
numFaceCentersX = (nx+1)*ny*nz;
numFaceCentersY = nx*(ny+1)*nz;
numFaceCentersZ = nx*ny*(nz+1);
numBodyCenters = nx*ny*nz;

% in the p-matrix, we have first all corners, then the face centers of the
% faces with x-normal, then of those faces with y-normal, then of those
% faces with z-normal and finally all body centers. The iterations always
% first go along the x-axis, then the y-axis and then the z-axis

firstFaceCenterX = numCornerPoints+1;
firstFaceCenterY = numCornerPoints+numFaceCentersX+1;
firstFaceCenterZ = numCornerPoints+numFaceCentersX+numFaceCentersY+1;
firstBodyCenter = numCornerPoints+numFaceCentersX+numFaceCentersY+numFaceCentersZ+1;

% below is a 'nice' calculation for the number of members. This gives the
% number of 'unique' members. However, here, we first create members
% exhaustively and then remove the duplicates, so we don't need this
% calculation.
% % calculate the number of bars s.t. the container can be prepared.
% numBars = ...
%     (nx*ny*nz)*(3+12+14) + ... % for each unit cell, all the members in the UC and those on the -x, -y and -z faces
%     (ny*nz)*(6) + ... % the x+ face of the block. ny by nz faces, each of them with 6 members.
%     (nx*nz)*(6) + ... % the y+ face of the block
%     (nx*ny)*(6) + ... % the z+ face of the block
%     (nx+ny+nz); % the final edge nodes on the outer edges.
numBars = 50*nx*ny*nz; % 50 members per unit cell...

b = zeros(numBars,2);

% a counter to carry along...
ctr = 1;

% first go through the unit cells
for ucX = 1:nx
    for ucY = 1:ny
        for ucZ = 1:nz
            %% find the indices of the points around
            lowerLeftPoint = (nx+1)*(ny+1)*(ucZ-1) + (nx+1)*(ucY-1) + ucX;
            lowerRightPoint = lowerLeftPoint+1; % along the x-axis from lowerLeftPoint
            lowerLeftPointBack = lowerLeftPoint+(nx+1); % along the y-axis from lowerLeftPoint
            lowerRightPointBack = lowerRightPoint+(nx+1); % along the y-axis from lowerRightPoint
            topLeftPoint = lowerLeftPoint + (nx+1)*(ny+1); % along the z-axis from lowerLeftPoint
            topRightPoint = lowerRightPoint + (nx+1)*(ny+1); % along the z-axis from lowerRightPoint
            topLeftPointBack = lowerLeftPointBack + (nx+1)*(ny+1); % along the z-axis from lowerLeftPointBack
            topRightPointBack = lowerRightPointBack + (nx+1)*(ny+1); % along the z-axis from lowerLeftPointBack
            faceCenterXMinus = firstFaceCenterX + (ucZ-1)*(nx+1)*ny + (ucY-1)*(nx+1) + (ucX-1);
            faceCenterXPlus = faceCenterXMinus+1; % they iterate along the x-axis, so the opposite face center is simply the next in the list.
            faceCenterYMinus = firstFaceCenterY + (ucZ-1)*nx*(ny+1) + (ucY-1)*nx + (ucX-1);
            faceCenterYPlus = faceCenterYMinus + nx; % nx y-face center per 'stack'
            faceCenterZMinus = firstFaceCenterZ + (ucZ-1)*nx*ny + (ucY-1)*nx + (ucX-1);
            faceCenterZPlus = faceCenterZMinus + nx*ny;
            bodyCenter = firstBodyCenter + (ucZ-1)*nx*ny + (ucY-1)*nx + (ucX-1);
            
            %% now add all the members
            
            % first the edges...
            b(ctr:ctr+3,:) = [lowerLeftPoint, lowerRightPoint;...
                lowerLeftPoint, lowerLeftPointBack;...
                lowerRightPoint, lowerRightPointBack;...
                lowerRightPointBack, lowerLeftPointBack];
            ctr=ctr+4;
            % that was the 'bottom' of the UC. Next is the equivalent on
            % top.
            b(ctr:ctr+3,:) = [topLeftPoint, topRightPoint;...
                topLeftPoint, topLeftPointBack;...
                topRightPoint, topRightPointBack;...
                topRightPointBack, topLeftPointBack];
            ctr=ctr+4;
            
            % now the four sides...
            b(ctr:ctr+3,:) = [lowerLeftPoint, topLeftPoint;...
                lowerRightPoint, topRightPoint;...
                lowerRightPointBack, topRightPointBack;...
                lowerLeftPointBack, topLeftPointBack];
            ctr=ctr+4;
            
            % now connect to the face centers. First is the -x face
            b(ctr:ctr+3,:) = [lowerLeftPoint, faceCenterXMinus;...
                lowerLeftPointBack, faceCenterXMinus;...
                topLeftPoint, faceCenterXMinus;...
                topLeftPointBack, faceCenterXMinus];
            ctr=ctr+4;
            
            % next is the +x face
            b(ctr:ctr+3,:) = [lowerRightPoint, faceCenterXPlus;...
                lowerRightPointBack, faceCenterXPlus;...
                topRightPoint, faceCenterXPlus;...
                topRightPointBack, faceCenterXPlus];
            ctr=ctr+4;
            
            % next is the -y face
            b(ctr:ctr+3,:) = [lowerLeftPoint, faceCenterYMinus;...
                lowerRightPoint, faceCenterYMinus;...
                topLeftPoint, faceCenterYMinus;...
                topRightPoint, faceCenterYMinus];
            ctr=ctr+4;
            
            % next is the +y face
            b(ctr:ctr+3,:) = [lowerLeftPointBack, faceCenterYPlus;...
                lowerRightPointBack, faceCenterYPlus;...
                topLeftPointBack, faceCenterYPlus;...
                topRightPointBack, faceCenterYPlus];
            ctr=ctr+4;
            
            % next is the -z face
            b(ctr:ctr+3,:) = [lowerLeftPoint, faceCenterZMinus;...
                lowerRightPoint, faceCenterZMinus;...
                lowerRightPointBack, faceCenterZMinus;...
                lowerLeftPointBack, faceCenterZMinus];
            ctr=ctr+4;
            
            % next is the +z face
            b(ctr:ctr+3,:) = [topLeftPoint, faceCenterZPlus;...
                topRightPoint, faceCenterZPlus;...
                topRightPointBack, faceCenterZPlus;...
                topLeftPointBack, faceCenterZPlus];
            ctr=ctr+4;
            
            % now connect the entire story to the body center
            b(ctr:ctr+13,:) = [lowerLeftPoint, bodyCenter;...
                lowerRightPoint, bodyCenter;...
                lowerRightPointBack, bodyCenter;...
                lowerLeftPointBack, bodyCenter;...
                topLeftPoint, bodyCenter;...
                topRightPoint, bodyCenter;...
                topRightPointBack, bodyCenter;...
                topLeftPointBack, bodyCenter;...
                faceCenterXMinus, bodyCenter;...
                faceCenterXPlus, bodyCenter;...
                faceCenterYMinus, bodyCenter;...
                faceCenterYPlus, bodyCenter;...
                faceCenterZMinus, bodyCenter;...
                faceCenterZPlus, bodyCenter];
            ctr=ctr+14;
        end
    end
end

%% remove all duplicates

% first sort along the rows
b = sort(b,2);
b = unique(b,'rows');

end
