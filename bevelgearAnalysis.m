%All calculations are done in S.I.
    format long g
    IM = 39.37; %Divide by 39.37 to go from Inches to Metres
    T = 123; %Max Output Torque
    n = 400; %Output speed in rpm
    nL = 10000000; %Number of load cycles 10 000 000 
    Theta = 23; %Temperature where drill is used (just needs to be bwetween 0 and 120degrees C)

%GEOMETRY
    Pa = 20; 
    N = 20; %Number of teeth
    P = 6; %Diametral pitch teeth/in ***The Variable We Varied***
    di = N/P; %Pitch diameter in inches
    d = di*1000/IM; %Pitch diameter in mm
    F = 10/P; %Face width in inches
    b = F*1000/IM; %Face width in mm
    g = 45; %Pitch angle
    davi = di - F*cosd(g);
    dav = davi*1000/IM;

%FORCE ANALYSIS
    Wt = 2*T/(dav); %In N
    Wr = Wt*tand(Pa)*cosd(g);
    Wa = Wt*tand(Pa)*sind(g);

%CONTACT STRESS
    %Elastic Coeffcient
        ZE = 190; %in Mpa^1/2 for steel (Eq. 15-21 *Default value for steel*)
    %Geometry Factor for Pitting Resistance
        ZI = 0.0625; %(Fig 15-6) 0.0625 for 0.06 and for N=16 N=20 
    %Overload Factor
        KA = 1.5; %Uniform shock power source, load on machine is medium shock
    %Dynamic Factor 
        QV = 7; %Transmition accuracy number (assumed) 
        B = (1/4)*(12-QV)^(2/3);%(Eqn 15-5 to 15-8)
        A = 50+56*(1-B); 
        vet = 5.236*(10^-5)*d*n; %in (m/s)
        KV = ((A+(200*vet)^(1/2))/A)^B; 
    %Load-Distribution Factor 
        Kmb = 1; %Both gears are straddle mounted (assumption based off diagram given in project)
        KHbeta = Kmb + 5.6*(10^-6)*b^2; %(Eqn 15-11)    
    %Size Factor for Pitting Resistance
        if(b < 12.7)
            ZX = 0.5;
        elseif(b >= 12.7 && b <= 114.3)
            ZX = 0.00492*b + 0.4375;
        else
            ZX = 1;
        end
    %Crowning Factor for Pitting
        ZXC = 2; %Teeth are uncrowned
        
CS = ZE*((1000*Wt*KA*KV*KHbeta*ZX*ZXC)/(b*d*ZI))^(1/2); %Contact Stress (Eqn 15-1)

%BENDING STRESS
    %Outer Transverse Module
        met = d/N; %Conversion from diametral pitch to outer transverse module (Eqn 13-2)
    %Size Factor for Bending
        YX = 0.4867 + 0.008339*met; %(Eqn 15-10)
    %Lengthwise Curvature Factor for Bending Strength
        YB = 1; %(Eqn 15-13)
    %Bending Strength Factor
        YJ = 0.20; %(Fig 15-7) 0.18 for N=16 and 0.2 for N=20
        
BS = (1000*Wt*KA*KV*YX*KHbeta)/(b*met*YB*YJ); %Bending Stress (Eqn 15-3)

%BENDING STRENGTH
    %Allowable Bending Stress Number
        ATStress = 275; %for Steel Gears Grade 3 - Table 15-4 Pg 804
    %Stress Cycle Factor for Bending Strength
        if(nL >=10^2 && nL < 10^3) %(Eqn 15-15)
            YNT = 2.7;
        elseif(nL >= 10^3 && nL < 3*(10^6))
            YNT = 6.1514*nL^-0.1192;
        elseif(nL >= 3*(10^6) && nL <= 10^10)
            YNT = 1.3558*nL^-0.0178;
        end
    %Bending Safety Factor
        SF = 1.5; %Pg.797
    %Bending Reliability Factor
        YZ = 0.70-0.15*log10(1-0.90); %(Eqn 15-20) using targeted reliability of 90%
    %Temperature Factor
        if(Theta >= 0 && Theta <= 120) %(Eqn 15-18)
            Ktheta = 1;
        elseif(Theta > 120)
            Ktheta = (273+Theta)/393;
        end
        
BSA = (ATStress*YNT)/(SF*Ktheta*YZ);  %Permissible Bending Stress Number (Eqn 15-4)

%CONTACT STRENGTH
    %Allowable Contact Stress Number
        ACStress = 1720; %for Steel Gears Grade 3 - Table 15-4 Pg 804
    %Stress Cycle Factor for Pitting Resistance
        if(nL >= 10^3 && nL <= 10^4) %(Eqn 15-14)
            ZNT = 2;  
        elseif(nL >= 10^4 && nL <= 10^10)
            ZNT = 3.4822*nL^-0.0602;
        end
    %Hardness Ratio Factor for Pitting Resistance (HRFPR)
        ZW = 1; %(Fig 15-11)
    %Contact Safety Factor 
        SH = SF^.5; %(Pg 797)
    %Reliability Factor 
        ZZ = YZ^.5; %(Eqn 15-20)

CSA = (ACStress*ZNT*ZW)/(SH*Ktheta*ZZ); %Permissible Contact Stress Number (Eqn 15-2)

SFC = CSA/CS; %Contact F.O.S.
SFB = BSA/BS; %Bending F.O.S.

%Since the gear ratio is 1:1, the factors of safety applies to both the
%pinion and the gear
%Copy and paste the following to get the stress and F.O.S
%{
SFB 
SFC
BSA
BS
CSA
CS
%}