%Bearing Calcs for Single Loading using Ball Bearings
    format long g
    n = 400; %Output speed in rpm
    L = 30000; %Bearing-Life Recommendation in h
    
%Force
    Fr = 7.471; %Radial Force (kN)
    
    V = 1; %Assuming inner ring rotates
    af = 1; %Load factor (T 11-5) *Assuming a load factor of 1
    R = 0.9; %Reliability of 90%
    a = 3; %Constant for ball bearings
    
    LD = n*60*8*5*50*2; %Life in rev (Eq 11-2b)
    LR = 10^6; %Manufacturer rated life from (T 11-6) for roller
    
    CT = af*Fr*(LD/LR)^(1/a); %Since R = 0.9 using (Eq 11-3) to calculate catalog load rating