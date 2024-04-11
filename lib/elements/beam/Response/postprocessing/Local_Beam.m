% ©2024 ETH Zurich; D-​MAVT; Engineering Design and Computing
function [val] = Local_Beam(p,b,E,A,Iy,Iz,G,J,L,U,opts)
    %Local forces and moments calculation
    val=zeros(size(b,1),25); %output preparation
    
    for i=1:size(b,1) %************** LOOP *******************************
          p1=b(i,1); %1st point of a beam
          p2=b(i,2); %2nd point of a beam
          D=sqrt(A(i)/pi)*2; %Diameter
          Ug=[U(p1*6-5:p1*6);U(p2*6-5:p2*6)]; %Getting global displacmenets from U coresponding to p1 and p2
          Tg=Transf_B_Round(p(p1,:)',p(p2,:)',L(i)); %Coordinate and inertia transformation
          u=Tg*Ug;  %Local displacements
          if strcmp(opts.slv.elemSubtype,'eulerbernoulli')
              Ke=make_keB_eulerbernoulli(E(i),A(i),Iy(i),Iz(i),G(i),J(i),L(i));
          elseif strcmp(opts.slv.elemSubtype,'timoshenko')
              Ke=make_keB_timoshenko(E(i),A(i),Iy(i),Iz(i),G(i),J(i),L(i));
          else
              error('Unsupported beam type! \n''%s'' was supplied, supported options are: ''eulerbernoulli'' and ''timoshenko''.',opts.slv.beamType)
          end

          %Calculate f ******************************************
          %f = [N(p1),Qy(p1),Qz(p1),Mx(p1),My(p1),Mz(p1),N(p2),Qy(p2),Qz(p2),Mx(p2),My(p2),Mz(p2)]
          f=Ke*u;   %Local forces
          
          %N and Mx ******************************************
          N=[f(1) f(7)]';
          Mt=[f(4) f(10)]';
          Sx=N(2)/A(i);
          Tt=abs(Mt(2)/J(i)*D/2);
          
          %QzMy *********************************************
          QzMy=[f(3) f(5) f(9) f(11)]'; 
          Mymax=(abs(QzMy(2))+abs(QzMy(4)))/2;
          Sy=Mymax/Iz(i)*D/2;
          Qz=QzMy(1);
          Tzy=abs(4*Qz/(3*pi*(D/2)^2));
          
          %Qy and Mz ***********************************************
          QyMz=[f(2) f(6) f(8) f(12)]'; %QyMz
          Mzmax=(abs(QyMz(2))+abs(QyMz(4)))/2;
          Sz=Mzmax/Iy(i)*D/2;
          Qy=QyMz(1);
          Tyz=abs(4*Qy/(3*pi*(D/2)^2));
          
          %Equivalent stress calculation ***************************
          S1_eq=abs(Sx)+Sy;
          S2_eq=abs(Sx)+Sz;
          T_eq=Tt+Tzy+Tyz;
          
          %von Mises stress calculation ***************************
          a_zy = -Tzy/(D/2)^2;
          b_zy = Tzy;
          a_yz = -Tyz/(D/2)^2;
          b_yz = Tyz;
          
          r_dist = linspace(0,D/2,6);
          Sy_dist = Mymax/Iz(i)*r_dist;
          Tzy_dist = a_zy*r_dist.^2+b_zy;
          Sz_dist = Mzmax/Iy(i)*r_dist;
          Tyz_dist = a_yz*r_dist.^2+b_yz;
          
          [~,id_y_max] = max(Sy_dist.^2 + 6*Tzy_dist.^2); 
          [~,id_z_max] = max(Sz_dist.^2 + 6*Tyz_dist.^2);
          
          Sy_mises = Sy_dist(id_y_max);
          Tzy_mises = Tzy_dist(id_y_max);
          Sz_mises = Sz_dist(id_z_max);
          Tyz_mises = Tyz_dist(id_z_max);
          
          S_mises=sqrt(0.5*((Sx-Sy_mises)^2+(Sy_mises-Sz_mises)^2+(Sz_mises-Sx)^2+6*(Tt^2+Tzy_mises^2+Tyz_mises^2)));
          
          % ********************************************************
          %[axial force(N), Lateral forces (Qy, Qz), Torsion(Tt), Bending Moments(Mymax Mzmax), von Misses(S_ekv)]
          val(i,:)=[N(2) Qy Qz Tt Mymax Mzmax Sx Sy Sz S1_eq S2_eq T_eq S_mises u']; %Output
    end
end