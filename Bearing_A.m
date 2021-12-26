%Bearing Calcs for Combined Loading using Ball Bearings
    format long g
    n = 400; %Output speed in rpm
    L = 30000; %Bearing-Life Recommendation in h
    
%Forces
    Fr = 9; %Radial Force (kN)
    Fa = 12.797; %Axial Force (kN)
    
    V = 1; %Assuming inner ring rotates
    af = 1; %Load factor (T 11-5) *Assuming a load factor of 1 
    R = 0.9; %Reliability of 90%
    a = 3; %Constant for ball bearings
    
    LD = n*60*8*5*50*2; %Life in rev (Eq 11-2b)
    LR = 10^6; %Manufacturer rated life from (T 11-6)
    
    E = Fa/(Fr*V); %Combined radial and thrust loading constant (Eq 11-11a)
    e1 = 0.44; %Starting with a guess of e=0.27 (the middle)
    
    if(E > e1)
        X = 0.56; %X is ordinate intercept
        Y = 1.29; %Y is the slope
    else
        X = 1;
        Y = 0;
    end
    
    Fe = X*V*Fr + Y*Fa; %Equivalent Radial Load
    
    if(Fe > Fr) %Setting Fc to be the conservative value of the two radial loads
        Fc = Fe; 
    else
        Fc = Fr;
    end
    
    CT = af*Fc*(LD/LR)^(1/a); %Since R = 0.9 using (Eq 11-3) to calculate catalog load rating
    
    C0 = 69.5; %Corresponding C0 value for C10 of 83.2kN (kN)
    Z = Fa/C0; %Constant for Table 11-1
    
    Y = 1.31+(((Z-0.17)/(0.28-0.17))*(1.15-1.31)); %New Y Value, update line 23 with this value
    
    