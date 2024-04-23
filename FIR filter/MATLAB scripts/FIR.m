close all;

Simulation_sampling_freq = 1e6;
sampling_freq=10e3;
SimTs=1/Simulation_sampling_freq;
DigtalTs=1./sampling_freq;
Tmax = 1;
t = 0:SimTs:Tmax-SimTs;
f= -Simulation_sampling_freq/2:1/Tmax:Simulation_sampling_freq/2-1/Tmax;

s = 1j*2*pi*f;
z = exp(1j*2*pi*f*DigtalTs);

H_fir = 0.159 + 0.225*z.^-1 + z.^-2 + 0.225*z.^-3 + 0.159*z.^-4;
% plot(f,mag2db(H_fir))
H_fir = -0.032 - 0.053*z.^(-1) - 0.045*z.^(-2) + 0.075*z.^(-4) + 0.159*z.^(-5)... 
+ 0.225*z.^(-6) + 0.25*z.^(-7) + 0.225*z.^(-8) + 0.159*z.^(-9) + 0.075*z.^(-10)...
- 0.045*z.^(-12) - 0.053*z.^(-13) - 0.032*z.^(-14); 
plot(2*pi*f/sampling_freq,mag2db(H_fir));