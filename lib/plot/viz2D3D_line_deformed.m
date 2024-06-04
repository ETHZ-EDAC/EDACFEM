% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function viz2D3D_line_deformed(fem,opts,LC,dispType)
%iterate through the requested load cases
for iLC = 1:size(LC,2)  
    %Output Load Case Number
    fprintf(['Displacement plot for "', opts.nameProblem, '"\n']);
    fprintf(['Load Case ', num2str(LC(iLC)), ' of ', num2str(fem.nLC),'\n']);

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
    U = fem.sol{LC(iLC)}.u;
    eA = fem.el.eA;
    eE = fem.el.eE;
    
    % magnification factor
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
    
        switch dispType
            case 'Mag'
                Umag(1) = sqrt((dp1(1))^2+(dp1(2))^2+(dp1(3))^2);
                Umag(2) = sqrt((dp2(1))^2+(dp2(2))^2+(dp2(3))^2);
            case 'U1'
                Umag(1) = dp1(1);
                Umag(2) = dp2(1);
            case 'U2'
                Umag(1) = dp1(2);
                Umag(2) = dp2(2);
            case 'U3'
                Umag(1) = dp1(3);
                Umag(2) = dp2(3);
        end
        
        %Find min and max displacment values
        if i == 1
            maxDisp = max(Umag);
            minDisp = min(Umag);
        else
            maxDisp = max([maxDisp,Umag]);
            minDisp = min([minDisp,Umag]);
        end
    
        % Plot deformed structure
        if d==2
            harray(i,1)=patch([p1(1)+dp1(1)*mag p2(1)+dp2(1)*mag],...
                             [p1(2)+dp1(2)*mag p2(2)+dp2(2)*mag],...
                             [Umag(1),Umag(2)],...
                             'LineWidth',D(i)*2,...
                             'EdgeColor','interp');
        elseif d==3
            harray(i,1)=patch([p1(1)+dp1(1)*mag p2(1)+dp2(1)*mag],...
                             [p1(2)+dp1(2)*mag p2(2)+dp2(2)*mag],...
                             [p1(3)+dp1(3)*mag p2(3)+dp2(3)*mag],...
                             [Umag(1),Umag(2)],...
                             'LineWidth',D(i)*2,...
                             'EdgeColor','interp');
        end
    end
    
    %% Plot Displacements
    % Rounding for labels
    rd=2;                   % rounding digits for chart display
    
    %Displacement outputs to console
    fprintf(['Max displacement: %3.', num2str(rd) ,'f mm \n'],maxDisp);
    fprintf(['Min displacement: %3.', num2str(rd) ,'f mm \n'],minDisp);
    
    %Define Colormap
    colormap("jet");
    
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
    
    %Legend Labeling Options
    FormSpec = strcat('%.',num2str(rd),'f'); %Floating Point Notation
    % FormSpec = strcat('%.',num2str(rd),'e'); %Scientific Notation
    
    %Colorbar Options
    cbh = colorbar;
    set(cbh,'TickLabelInterpreter','latex','FontSize',12,'LineWidth',1.5);
    cbh.Ticks = linspace(minDisp,maxDisp,7);
    cbh.TickLabels = cellfun(@(x) num2str(x,FormSpec), num2cell([linspace(minDisp,maxDisp,7)]),'UniformOutput',false);
    ylabel(cbh, 'Displacment [mm]','Interpreter', 'latex','FontSize',12)
    
    % make title
    switch dispType
        case 'Mag'
            title(['Displacement Magnitude, LC ',num2str(LC(iLC))]);
        case 'U1'
            title(['Displacement U1, LC ',num2str(LC(iLC))]);
        case 'U2'
            title(['Displacement U2, LC ',num2str(LC(iLC))]);
        case 'U3'
            title(['Displacement U3, LC ',num2str(LC(iLC))]);
    end
    
    % draw
    drawnow;
    hold off;
    fprintf('Displacement plotting ... DONE\n\n');
end
end 