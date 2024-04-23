% FPGA implementation of the LPF IIR filter previously designed on different
% specs: cut-off frequency = 10 MHz, sampling frequency = 100 MHz.
% DC gain = 0 +- 0.2 dB, Fc = 10 MHz +- 1 KHz. SQNR > 40 dB. 
% Input S(x,y), determined later.

z = tf('z',1e-7);
s = tf('s');
w_dc = 2*pi*1e5;
Ts = 1e-7;
w_ac = (2/Ts)*tan(w_dc*Ts/2);
f_ac = w_ac/(2*pi);
% the tf of the 2nd order butterworth filter
H_s = 1/((s/w_ac)^2 + sqrt(2)*(s/w_ac) + 1);
% do the bilinear transformation
%H_z = 1/((((2/Ts)*((1-z^-1)/(1+z^-1)))/w_ac)^2 + sqrt(2)*(((2/Ts)*((1-z^-1)/(1+z^-1)))/w_ac) + 1)
H_z_i = c2d(H_s,Ts,'impulse')
H_z_b = c2d(H_s,Ts,'tustin')
bode(H_z_i,H_z_b,1e3:1e3:1e7)
legend('impulse','bilinear')
%get the common factors between numerator and denominator
%H_z_zpk = zpk(H_z)
% get manually the H_z after eliminating the common factors
%bode(H_z,1e3:1e3:1e7);
% H_z_m =  0.00094469*(z+1)^2/(z^2 - 1.911*z + 0.915);
% bode(H_z_m,1e3:1e3:1e7);
