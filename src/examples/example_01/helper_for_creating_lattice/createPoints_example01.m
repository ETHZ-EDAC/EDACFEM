% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [p] = createPoints_example01(nx,ny,nz,L)
% creates points for example 2

% create the corners of the unit cells
xCornerCoords = (0:nx)*L;
yCornerCoords = (0:ny)*L;
zCornerCoords = (0:nz)*L;

% use meshgrid to get all coordinates
[cornersX, cornersY, cornersZ] = ndgrid(xCornerCoords,yCornerCoords,zCornerCoords);

allCorners = [cornersX(:) cornersY(:) cornersZ(:)];

% next: create the centerpoints on the faces with x-normal
% first prepare the coordinates of the centerpoints
ycenterCoords = ((1:ny)-.5)*L;
zcenterCoords = ((1:nz)-.5)*L;
xcenterCoords = ((1:nx)-.5)*L;

[faceCentersXX, faceCentersXY, faceCentersXZ] = ndgrid(xCornerCoords,ycenterCoords,zcenterCoords);

xFaceCenters = [faceCentersXX(:) faceCentersXY(:) faceCentersXZ(:)];

% centerpoints on the faces with y-normal
[faceCentersYX, faceCentersYY, faceCentersYZ] = ndgrid(xcenterCoords,yCornerCoords,zcenterCoords);

yFaceCenters = [faceCentersYX(:) faceCentersYY(:) faceCentersYZ(:)];

% centerpoints on the faces with z-normal
[faceCentersZX, faceCentersZY, faceCentersZZ] = ndgrid(xcenterCoords,ycenterCoords,zCornerCoords);

zFaceCenters = [faceCentersZX(:) faceCentersZY(:) faceCentersZZ(:)];

% centers of the cubes
[bodyCentersX, bodyCentersY, bodyCentersZ] = ndgrid(xcenterCoords,ycenterCoords,zcenterCoords);

bodyCenters = [bodyCentersX(:) bodyCentersY(:) bodyCentersZ(:)];

% ...and concatenate them all...

p = [allCorners; xFaceCenters; yFaceCenters; zFaceCenters; bodyCenters];

end