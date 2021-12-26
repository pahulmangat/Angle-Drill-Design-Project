%Inputs ****
    %Input midrange/alternating torque/bending moments for each point
    Ma= 1;
    Mm = 1;
    Ta= 1;
    Tm =1;
    % Input stress factor concentration guess
    Kf = 1;
    Kfs = 1;

% Calculate S'e (Equation 6-10)
Sut = 470;
if Sut <= 1400
    Se_ = 0.5*Sut;
end
if Sut > 1400
    Se_ = 700;
end

%Marin Factors
%ka
a = 3.04; % cold-drawn
b = -0.217; % cold-drawn
ka = a*(Sut^b); %Equation 6-18
%kb: guess kb = 0.9 (check later)
kb = 0.9;
%kd
kd = 1;
%ke: Table 6-4 (90% relaibility)
ke = 0.897;

%Se (equation 6-17)
Se = ka*kb*kd*ke*Se_;

%De-gerber
n =1.5;
    A = ((4*((Kf*Ma)^2))+(3*((Kfs*Ta)^2)))^(1/2);
    B = ((4*((Kf*Mm)^2))+(3*((Kfs*Tm)^2)))^(1/2);
    d_1 = (8*n*A)/(pi*Se);
    d_2 = ((1+((2*B*Se)/(A*Sut))^2))^(1/2);
d = (d_1*(1+d_2))^(1/3); % Equation 7-12


% verification
% check if kb is close to inital guess or iterate
if d >= 7.62 && d <= 51
    kb_check = 1.24*(d^-0.107); %Equation 6-19
end
if d > 51 && d < 254
    kb_check = 1.51*(d^-0.157); %Equation 6-19
end
% factor of safety check  
Kt_check = 1; %Input # from Fig. A-15-9 or Table 7-1
q_check = 1; %Input # from Fig. 6-26
Kts_check = 1; %Input # from Fig. A-15-8 or Table 7-1
qs_check = 1; %Input # from Fig. 6-27
Kf_check=1+q_check*(Kt_check-1); %Equation 6-32
Kfs_check=1+qs_check*(Kts_check-1); %Equation 6-32
Se_check= ka*kb_check*kd*ke*Se_; %Equation 6-17

n_check = 1/((8*A)/(pi*(d^3)*Se_check)*(1+d_2)); % Equation 7-11



    
   