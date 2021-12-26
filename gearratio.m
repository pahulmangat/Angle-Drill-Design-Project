%% Determination of Operating (Desired) Point of Output
torque=[123 0]; %[N*m] stall torque at output
speed=[0 41.888]; %[rad/s] output no load speed 
n=0.98; %gearing efficiency 
Pin=600; %[W] Input power from motor to transmission system 
P_transmitted=n*Pin; %[W] Output(transmitted) power throughout transmission system 

%Torque/Speed Curve 
plot(speed,torque);
title('Torque-Speed Curve');
xlabel('Speed(rad/s)');
ylabel('Torque(N*m)');

%Power-Speed and Power-Torque Relation @OUTPUT
Ts_out=123; %[N*m]
Wn_out=41.888; %[rad/s]

%Find operating speed @588Watts
P_out=[-Ts_out/Wn_out Ts_out -P_transmitted]; %vector for polynomial Power(w)=-(Ts/Wn)*w^2 + Ts*Wn that represents power curve interms of speed. Refer to report for details.
roots_Speed=roots(P_out); %the output operating speed @588W is w2=5.5036 and w1=36.3844 (from workspace)
Wop_out=min(roots_Speed);   %Choosing the lower speed will result in higher torque closer to the max torque of 123Nm igving a more conservative estimate 

Top_out=P_transmitted/Wop_out; %operating torque @588W and w2=5.5036. Lower operating speed is chosen so that a higher operating torque closer to that of the specified stall torque is achieved 


%% Determination of Operating Point of Input(Motor) 
%Input operating point @600Watts was found directly from power-torque curve from datasheet
%Since power-speed/torque curve is a parabola, there are 2 operating torques/speeds. 
Top_in=[1.75 11.25]; %N*m T1 & T2
Wop_in=[342.86 53.3];%rad/s W1 & W2

for i=1:2
    m(i)=Wop_in(i)/Wop_out;
end

m=min(m); % Choose the smaller of the 2 gear ratios in order to meet small size requirements. Smaller the ratio, fewer the teeth and thus smaller pitch diameter. 
          % In order to verify validity of gear ratio, multiply Top_in*n*m and see if the product is approximately equal to Top_out



