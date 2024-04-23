% simple implementation of IIR LPF filter after discretization using
% bilinear transformation (refer to Discretizaiton.m file)

%close all
clear
sampling_freq = 10000;
cutoff_freq = 100;
wo = 2*pi*cutoff_freq;
Ts = 1/sampling_freq;
Simulation_sampling_freq = 1e6;
SimTs=1/Simulation_sampling_freq;
Tmax = 1;

tsim = 0:SimTs:Tmax-SimTs;
tsam = 0:Ts:Tmax-Ts;
fsim= -Simulation_sampling_freq/2:1/Tmax:Simulation_sampling_freq/2-1/Tmax;
fsam = -sampling_freq/2:1/Tmax:sampling_freq/2 - 1/Tmax;

numOfBits_in = 8;
binPoint_in = 3;
vect_len = length(tsam);
% generating the input vector (uniform distribution)
vect_in = floor(rand([1 vect_len])*(2^numOfBits_in))/(2^binPoint_in);

y_coeff = 0.5;
x_coeff = 2;

%floating point operations
y_fl = zeros([1 vect_len]);
y_fl(1) = x_coeff*vect_in(1);
for i = 1:vect_len-1
    y_fl(i+1) = y_coeff*y_fl(i) + x_coeff*vect_in(i+1);
end
y_fl_power = y_fl.^2;
y_fl_power_avg = sum(y_fl_power)/vect_len;

% we decided that the integral part is 7 bits so now we need to decide the
% fracional part (x)
SQNR = zeros([1 10-3+1])
for x = 3:10
    y_fx = zeros([1 vect_len]);
    y_fx(1) = x_coeff*vect_in(1);
    for i = 1:vect_len-1
        y_temp = y_coeff*y_fx(i) + x_coeff*vect_in(i+1);
        % round for x
        %y_temp = round(y_temp * 2^x);
        y_temp = floor(y_temp * 2^x);
        y_fx(i+1) = y_temp/(2^x);
    end
    fx_error_power = (y_fl-y_fx).^2;
    fx_error_power_avg = sum(fx_error_power)/vect_len;
    SQNR(x-2) = pow2db(y_fl_power_avg/fx_error_power_avg);
end
x = 3:10;
%figure;
hold on;
plot(x, SQNR);
