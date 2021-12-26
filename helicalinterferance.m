%% Helical Gear Interference Calculations 
pressAngle_Normal=[deg2rad(14.5),deg2rad(20)]; %2 common normal pressure angles 
helixAngle=deg2rad(30);
k=1; %full depth teeth assumption
m=9.68; %gear ratio for helical reduction found from 'gearratio.m' file 

for i=1:2
 pressAngle_Tangential(i)=atan((tan(pressAngle_Normal(i))/cos(helixAngle)));%read value from workspace (in radians)
 
 %Minumum # of teeth on pinion, eqn (13-22) from Shigley
 Np(i)=(2*k*cos(helixAngle))/((1+2*m)*(sin(pressAngle_Tangential(i))^2))*(m+(m^2 + ((1 + 2*m)*sin(pressAngle_Tangential(i))^2))^0.5)
 Ng(i)=Np(i)*m % #of teeth on output gear 
end 

%% Possible pinion tooth combos
%Once values from workspace have been read for the section of code above,
%the minumum # of teeth on pinion should be atleast 11 teeth. However
%becasue of the gear ratio being 9.68 which as relatively large, 