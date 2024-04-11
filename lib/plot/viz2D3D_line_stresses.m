% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function viz2D3D_line_stresses(fem,opts) 
% reduce to 2D if possible
if size(fem.p,2)==2 || all(fem.p(:,3)==0)
    fem.d = 2;
    fem.p = fem.p(:,1:2);
else
    fem.d = 3;
end

% load parameter
d = fem.d;
p = fem.p;
b = fem.b;
U = fem.sol.u;
eA = fem.el.eA;
eE = fem.el.eE;

% load stress
if strcmp(opts.slv.elemType,'truss')
    eS = fem.sol.S;
elseif strcmp(opts.slv.elemType,'beam')
    eS = fem.sol.Smises;
end

%magnification factor
mag = 1; 


%% Removing parts of the model to plot
% toggle if parts shall be cut
flagCut = 0;

% determine cut case
% 'inner' - cut all points inside structure
% 'xz' - cut all points except the ones on the xz plane
% 'xy' - cut all points except the ones on the xy plane
% 'yz' - cut all points except the ones on the yz plane
cutCase = 'xz';

if flagCut == 1

    switch cutCase
        case 'inner'
            ind = find( p(:,1)==0 | p(:,1)==max(p(:,1)) |...
                p(:,2)==0 | p(:,2)==max(p(:,2)) |...
                p(:,3)==0 | p(:,3)==max(p(:,3)) );
        case 'xz'
            ind = find( p(:,2)==0 );
        case 'xy'
            ind = find( p(:,3)==0 );
        case 'yz'
            ind = find( p(:,1)==0 );
    end
    % Check which members include any of these nodes
    delId = ismember(b,ind);

    % Remove members that don't include any of these nodes
    b(~delId(:,1)) = -Inf;
    b(~delId(:,2)) = -Inf;
    b(b(:,1)==-Inf,:)=[];
    b(b(:,2)==-Inf,:)=[];
end


%% Creating Graphic Objects
% Open figure
figure('Color','white');
hold on;
grid on;
set(gcf, 'renderer', 'painters') 

% Member diameter uniform/proportional to eA
flagD = 0;
if flagD==1
    D = (4*eA/pi).^0.5; 
else
    D = ones(size(eA,1),1)*1;
end

% Set view
if d==2
    view([0, 90]); %2D
elseif d==3
    view(45, 20); %3D   
end

% replace nan values with 0
U(isnan(U))=0;


% create a handle-array for graphic objects
harray = gobjects(size(b,1),1); 
for i=1:size(b,1)
    p1 =  p(b(i,1), 1:d);
    p2 =  p(b(i,2), 1:d);
    if strcmp(opts.slv.elemType,'truss')
        dp1 = U(b(i,1)*d-d+1:b(i,1)*d).';
        dp2 = U(b(i,2)*d-d+1:b(i,2)*d).';
    elseif strcmp(opts.slv.elemType,'beam')
        dp1 = U(b(i,1)*6-5:b(i,1)*6-3).';
        dp2 = U(b(i,2)*6-5:b(i,2)*6-3).';
    end

    % Plot deformed structure
    if d==2
        harray(i,1)=line([p1(1)+dp1(1)*mag p2(1)+dp2(1)*mag],...
                         [p1(2)+dp1(2)*mag p2(2)+dp2(2)*mag],...
                         'LineWidth',D(i)*2,...
                         'Color','black' );
    elseif d==3
        harray(i,1)=line([p1(1)+dp1(1)*mag p2(1)+dp2(1)*mag],...
                         [p1(2)+dp1(2)*mag p2(2)+dp2(2)*mag],...
                         [p1(3)+dp1(3)*mag p2(3)+dp2(3)*mag],...
                         'LineWidth',D(i)*2,...
                         'Color','black' );
    end
end
    
%% Plot Stresses
% toggle what to plot
flagStresses = 1;       % shows stresses as colors
flagNormalized = 0;     % normalizes streses
flagLimitsManual = 0;   % limits can be typed manually
rd=2;                   % rounding digits for chart display

%Stress Setup
max_axis = round(max(eS),rd);
fprintf(['Max Stress is %3.', num2str(rd) ,'f MPa \n'],max_axis);
min_axis = round(min(eS),rd);
fprintf(['Min Stress is %3.', num2str(rd) ,'f MPa \n'],min_axis);
abs_max = round(max(abs(max_axis),abs(min_axis)),rd);

%Define Colormap
cmap_normal=[255 0   0  ;
             239 94  114;
             214 154 164;
             192 192 192;
             164 154 214;
             114 94  239;
             0   0   255]/255;
  
cmap_mises=[255 0   0;
            255 170 0;
            170 255 0;
            0   255 0;
            0   255 170;
            0   170 255;
            0   0   255]/255;

%Limits
limits=[];

% determine limits manually
if flagLimitsManual == 1
    limits=[1750 1300 870 435 -435 -870 -1300 -1750];

% evenly split stress range for limit definition
else
    if min_axis < 0
        limits(1) = abs_max;
        limits(2) = round(abs_max*3/4,rd);
        limits(3) = round(abs_max*1/2,rd);
        limits(4) = round(abs_max*1/4,rd);
        limits(5) = round(-abs_max*1/4,rd);
        limits(6) = round(-abs_max*1/2,rd);
        limits(7) = round(-abs_max*3/4,rd);
        limits(8) = -abs_max;
    else
        limits(1) = abs_max;
        limits(2) = round(abs_max*6/7,rd);
        limits(3) = round(abs_max*5/7,rd);
        limits(4) = round(abs_max*4/7,rd);
        limits(5) = round(abs_max*3/7,rd);
        limits(6) = round(abs_max*2/7,rd);
        limits(7) = round(abs_max*1/7,rd);
        limits(8) = 0;
    end
end

% Determine colors depending on the limit values
if flagStresses == 1
    if min_axis < 0
        varColors = colormap(flipud(cmap_normal));
    else
        varColors = colormap(flipud(cmap_mises));
    end
    for k=1:size(harray,1)
        if eS(k)>limits(2)&&eS(k)<=limits(1)
            colorId = 7;
        elseif eS(k)>limits(3)&&eS(k)<=limits(2)
            colorId = 6;
        elseif eS(k)>limits(4)&&eS(k)<=limits(3)
            colorId = 5;
        elseif eS(k)>limits(5)&&eS(k)<=limits(4)
            colorId = 4;
        elseif eS(k)>limits(6)&&eS(k)<=limits(5)
            colorId = 3;
        elseif eS(k)>limits(7)&&eS(k)<=limits(6)
            colorId = 2;
        elseif eS(k)>limits(8)&&eS(k)<=limits(7)
            colorId = 1;
        elseif eS(k)>limits(1)
            colorId = 7;
        elseif eS(k)<limits(8)
            colorId = 1;
        end
        set(harray(k,1),'Color',varColors(colorId,:));
    end
end


%% Set plot properties
%Text Interpreter
set(gca,'defaulttextinterpreter','latex');
set(gca,'DefaultTextFontname', 'CMU Serif');
set(gca,'TickLabelInterpreter','latex','FontSize',12,'LineWidth',1.5);

%Axis Options
box on;
axis equal;

%Axis Labels
xlabel('$x$ $[mm]$');
ylabel('$y$ $[mm]$');
zlabel('$z$ $[mm]$');

%Colorbar Options
cbh = colorbar;
set(cbh,'TickLabelInterpreter','latex','FontSize',12,'LineWidth',1.5);

%Legend Labeling Options
FormSpec = strcat('%.',num2str(rd),'f'); %Floating Point Notation
% FormSpec = strcat('%.',num2str(rd),'e'); %Scientific Notation

% create ticks and labels depending on the flags and stress type
if flagNormalized == 1
    if min_axis < 0 && max_axis > 0
        cbh.Ticks = [0 0.14 0.2857 0.4286 0.5 0.5714 0.7143 0.8571 1];
        cbh.TickLabels = {'-1','-0.75','-0.5','-0.25','0','0.25','0.5','0.75','1'};
    else
        cbh.Ticks = [0 0.14 0.2857 0.4286 0.5714 0.7143 0.8571 1];
        cbh.TickLabels = {'0', '0.14', '0.29', '0.43', '0.57', '0.71', '0.86', '1'};
    end
    switch opts.slv.elemType
        case 'truss'
            ylabel(cbh, 'Normalized Normal Stress $\frac{\sigma}{\sigma_{max}}$ $[-]$','Interpreter', 'latex','FontSize',12)
        case 'beam'
            ylabel(cbh, 'Normalized von Mises Stress $\frac{\sigma}{\sigma_{max}}$ $[-]$','Interpreter', 'latex','FontSize',12)
    end

else
    if min_axis < 0 && max_axis > 0
        cbh.Ticks = [0 0.14 0.2857 0.4286 0.5 0.5714 0.7143 0.8571 1];
        cbh.TickLabels = {num2str(limits(8),FormSpec),num2str(limits(7),FormSpec),num2str(limits(6),FormSpec),num2str(limits(5),FormSpec),num2str(0,FormSpec),num2str(limits(4),FormSpec),num2str(limits(3),FormSpec),num2str(limits(2),FormSpec),num2str(limits(1),FormSpec)};
    else
        cbh.Ticks = [0 0.14 0.2857 0.4286 0.5714 0.7143 0.8571 1];
        cbh.TickLabels = {num2str(limits(8),FormSpec),num2str(limits(7),FormSpec),num2str(limits(6),FormSpec),num2str(limits(5),FormSpec),num2str(limits(4),FormSpec),num2str(limits(3),FormSpec),num2str(limits(2),FormSpec),num2str(limits(1),FormSpec)};
    end
    switch opts.slv.elemType
        case 'truss'
            ylabel(cbh, 'Normal Stress [MPa]','Interpreter', 'latex','FontSize',12)
        case 'beam'
            ylabel(cbh, 'von Mises Stress [MPa]','Interpreter', 'latex','FontSize',12)
    end
end

% make title
switch opts.slv.elemType
    case 'truss'
        title('Normal Stress');
    case 'beam'
        title('von Mises Stress');
end

% draw
drawnow;
hold off;
fprintf('Stress Plotting Done\n\n');

end 