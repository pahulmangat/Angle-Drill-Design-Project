%h_gearAnalysis calculates stress (bending and contact), strength (bending and contact), and FOS (bending and contact) of helical gear set 
%NOTES:
   
    %Angles reported in radians 
    
%CODE LIMITATIONS 
    %both pinion and gear are same material
    %All gears have same face width 
    %Power @588W
    %operating point set at n=53RPM and Torque output=106N*m
    %Must manually change code/or refer to figs for stress cycle factors if life is other than 10^7 cycles
    %Surface factor Ks is the same for both pinion and gear since the face widths are both the same 
    %If value of Cp needs to be changed, you must do so in the code (Not treated asa argument to the function)
    %Hardness ratio is 1:1 since same pinion and gear material 
    
    %Information for gear ratios, pitch/gear teeth, speed and torque should
    %be obtained from the interference.m and gearratio.m file 
    
    
    
%% Helical Gear Analysis 

%A priori design decisions 
Np=11;
Ng=106;
mG=Ng/Np; %gear ratio 

%Pitch/Pressure Angle Info. Most of these are to be used in intermediate calculations to determine correction factors below
%units: [toothinch], degrees, inches
helAng=deg2rad(40); 
normal_PressAngle=deg2rad(20); %same for both pinion and gear
transverse_PressAngle=atan(tan(normal_PressAngle)/cos(helAng)); %Eqn.13-19
Pn=24; %normal diametral pitch. The same for both pinion and mating gear to enusre proper meshing. Value should be chosen from Table 13-2, pg 689
pn= pi/Pn;  %normal circular pitch
pt=pn/cos(helAng); %transverse circular pitch 
px=pt/tan(helAng);   %axial circular pitch
Pt=pi/pt; %Transverse diametral pitch
Px=pi/px; %Axial diametral pitch
dP=Np/Pt;  %Pinion pitch diameter
dG=Ng/Pt;  %Gear pitch diamter inches
rP=dP/2; %Pitch radius of pinion
rG=dG/2; %pitch radius of gear 
rbP=rP*cos(transverse_PressAngle);  %base-circle radii for pinion, Eqn. 14-24
rbG=rG*cos(transverse_PressAngle);  %base circle radii for gear 
F=2; %Face width in inches?????
Qv=7; %quality number to calculate Kv. Assume 7 
R=0.9; 

%Power Transmission and Speeds
H=0.789; %transmitted power in HP @98% efficiency , 588W=0.789 h.p
n=53.3; %operting speed @588W or 0.789h.p, [RPM]
V=pi*dP*n/12; %pitch line velocity, [ft/min]
Wt= 33000*H/V;%transmission load in lbf 


%Lewis form Factor (obtain from table 14-2)
Yp=0.229; %pinion lewis factor 
Yg=0.449; %gear lewis factor 
%material properties
St=75000; %table 14-3: Grade 3 Carburized/hardened steel bending strength 
Sc=275000; %table 14-2: Grd 3 Carburised steel contact strength
H_Ratio=1; % material of both pinion and gear are the same therefore hardness ratio=1
 

%Temp Factor
Kt=1; %operating at less than 250deg Fahrenheit 

%Elastic Coefficent Cp [psi^0.5]
Cp=2300; %[psi^0.5], Table 14-8, Steel on Steel 

%Stress Cycle Factors 
%obtain from figure 14-14/14-15. For this design, the life is set for 10^7cycles therefore, YN=ZN=1 for both pinion and gear 
YNp=1;
YNg=1;
ZNp=1;
ZNg=1;

%Geometry Factors; values obtained for pinion and gear from fig 14-7,14-8
Jp=0.399;%pinion
Jg=0.578; %gear
a=1/Pn; %addendum
Z=((rP+a)^2 - (rbP^2))^0.5 +((rG+a)^2 - (rbG)^2)^0.5 - ((rP+rG)*sin(transverse_PressAngle));
mN=(pn*cos(normal_PressAngle))/0.95*Z; %load sharing ratio, Eqn14-21
I=(cos(transverse_PressAngle)*sin(transverse_PressAngle)*mG)/2*mN*(mG - 1); %surface strength geometry factor, external gearing, Eqn 14-23

%Dynamic Factor -accounts for inaccuracies in manufacture and meshing of gear
B=0.25*(12-Qv)^(2/3); %eq 14-28
A=50 + 56*(1 - B);    %eqn 14-28 
Kv=((A + sqrt(V))/ A)^B;  %eqn 14-27

%Reliability Factor Kr; argument can be changed 
if R>=0.5 && R<=0.99
    Kr=0.658-0.0759*log(1-R);
else
    Kr=0.5-0.109*log(1-R); %0.99<=R<+0.9999, Eqn 14-38
end 

%Overload Factor Ko
Ko=1; %unifrom power source with moderate shock considering the normal forces the drill may experience 

Cf = 1; % surface condition factor (given as 1)

%Size factor Ks for pinion and gear 

Ks_p=((1.192*F*sqrt(Yp))/Pn)^0.0535; %Eqn a, section 14-10
Ks_g=((1.192*F*sqrt(Yg))/Pn)^0.0535;

if Ks_p<=1 && Ks_g<=1
    Ks_p=1;
    Ks_g=1;
end 

%Load Distribution Factor
Cmc=1; %uncrowned teeth, Eqn 14-31
if (F <= 1)
        Cpf= F/10*dP - 0.025;
    elseif(F > 1 && F <= 17)
        Cpf= F/10*dP - 0.0375 + 0.0125*F;
    elseif(F > 17 && F <= 40)
        Cpf= F/10*dP - 0.1109 + 0.0207*F - 0.000228*(F)^2;
end % Eqn 14-32

Cpm=1; 
Cma=0.127+0.0167*F+-0.0000765*(F^2); %commercial enclosed unit assumed 
Ce=1; 
Km=1 + Cmc*(Cpf*Cpm + Cma*Ce); %Eqn 14-30 

%Hardness Ratio Factor (CH) **ONLY FOR GEAR 
Ch=1; %Eqn 14-36, A'=0 since ratio H is less than 1.2

%Rim thickness factor, Kb
Kb=1; %assume 1. Eqn 14-40 


%Pinion/gear Bending Stress Analysis
bSp = Wt*Ko*Kv*Ks_p*Pt*Km*Kb/F*Jp;
bFOSp = (St*YNp)./(Kt*Kr*bSp);
bESp = (St*YNp)/(bFOSp*Kt*Kr);

bSg = Wt*Ko*Kv*Ks_g*Pt*Km*Kb/F*Jg;
bFOSg = (St*YNg)./(Kt*Kr*bSg);
bESg=(St*YNg)/(bFOSg*Kt*Kr);

%Pinion/gear Contact Strell Analysis
cSp= Cp*((Wt*Ko*Ks_p*Km*Cf)/(dP*F*I))^0.5;
wFOSp= (Sc*ZNp*Ch)/(Kt*Kr*cSp);
wESp= (Sc*ZNp*Ch)/(wFOSp*Kt*Kr);

cSg= Cp*((Wt*Ko*Ks_g*Km*Cf)/(dP*F*I))^0.5;
wFOSg= (Sc*ZNp*Ch)/(Kt*Kr*cSg);
wESg=(Sc*ZNg*Ch)/(wFOSg*Kt*Kr);


