clc
clear 
% Name: Oritseserundede Eda 
% CUID: 100993421 
% ELEC4700 LAB 7

G = zeros(6, 6); 

% Resistances for the five resistors:
R1 = 1;
R2 = 2;
R3 = 10;
R4 = 0.1; 
R0 = 1000; 

% Conductances:
G1 = 1/R1;
G2 = 1/R2;
G3 = 1/R3;
G4 = 1/R4;
G0 = 1/R0;

alpha = 100;
capacitance_value = 0.25;
L = 0.2;
vi = zeros(100, 1);
vo = zeros(100, 1);
v3 = zeros(100, 1);

G(1, 1) = 1;                                        
G(2, 1) = G1; G(2, 2) = -(G1 + G2); G(2, 6) = -1;   
G(3 ,3) = -G3; G(3, 6) = 1;                       
G(4, 3) = -alpha*G3; G(4, 4) = 1;                        
G(5, 5) = -(G4+G0); G(5, 4) = G4;   
G(6, 2) = -1; G(6, 3) = 1;                


C = zeros(6, 6);

C(2, 1) = capacitance_value; C(2, 2) = -capacitance_value;
C(6, 6) = L;

F = zeros(6, 1);
v = 0;

for vin = -10:0.1:10
    v = v + 1;
    F(1) = vin;
    Vm = G\F;
    vi(v) = vin;
    vo(v) = Vm(5);
    v3(v) = Vm(3);
end

figure(1)
plot(vi, vo);
hold on;
plot(vi, v3);
title('VO and V3 for DC Sweep (Vin): -10 V to 10 V');
xlabel('Vin (V)')
ylabel('Vo (V)')
legend('Voltage at node 3', 'Output voltage (Vo)');
grid on
hold off
vo2 = zeros(1000, 1); 
W = zeros(1000, 1);
Avlog = zeros(1000, 1);

for freq = linspace(0, 100, 1000)
    v = v+1;
    Vm2 = (G+1j*freq*C)\F;
    W(v) = freq;
    vo2(v) = norm(Vm2(5));
    Avlog(v) = 20*log10(norm(Vm2(5))/10);
end 
    
figure(2)
plot(W, vo2)
hold on;
plot(W, Avlog)
title('Vo(w) dB (part C)')
xlabel('w (rad)')
ylabel('Av (dB)')
w = pi;
new_c = zeros(1000,1);
new_G = zeros(1000,1);

for i = 1:1000
    crand = capacitance_value + 0.05*randn();
    C(2, 1) = crand; 
    C(2, 2) = -crand;
    C(3, 3) = L;
    Vm3 = (G+(1i*w*C))\F;
    new_c(i) = crand;
    new_G(i) = 20*log10(abs(Vm3(5))/10);
end

figure(3)
histogram(new_c)
title('Gain Histogram')
figure(4)
hist(new_G)