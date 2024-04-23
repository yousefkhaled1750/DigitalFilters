%% code
close all;
clear;
% final implementation of the 1st order LPF
cut_off_freq = 1e5;
Simulation_sampling_freq = 1e8;
sampling_freq=1e7;
SimTs=1/Simulation_sampling_freq;
Ts=1/sampling_freq;
w3db = 2*pi*cut_off_freq;
Tmax=1e-4;

%% time and frequency axis
t = 0:SimTs:Tmax-SimTs;
ts = 0:Ts:Tmax-Ts;
f= -Simulation_sampling_freq/2:1/Tmax:Simulation_sampling_freq/2-1/Tmax;
fs = -sampling_freq/2:1/Tmax:sampling_freq/2 - 1/Tmax;

%% generating and quantizing the sinusoids
vect_len = length(ts);
amp = 1;
cos_30K_t = amp*cos(2*pi*3e4*ts);
cos_3M_t = amp*cos(2*pi*3e6*ts);
cos_sum_t = cos_30K_t + cos_3M_t;
cos_sum_t(cos_sum_t<-2) = -2;
cos_sum_t_q = (round(cos_sum_t*2^6)-1)/2^6; %S[2,6]
cos_sum_t_q(cos_sum_t_q<-2) = -2;
cos_sum_t_q_i = cos_sum_t_q*2^6;
figure
hold on
plot(ts,cos_sum_t);
plot(ts,cos_sum_t_q);
legend('t','q');

%% floating point response
% coeff_y1 =  1.911;
% coeff_y2 = -0.915;
% 
% coeff_x0 = 0.0009447;
% coeff_x1 =  0.001889;
% coeff_x2 = 0.0009447;

%coeff_x0_q = 0.000946;
coeff_x0_q = 2^-11 + 2^-12 + 2^-13 + 2^-14 + 2^-15;
%coeff_x1_q = 0.001892;
coeff_x1_q = 2^-10 + 2^-11 + 2^-12 + 2^-13 + 2^-14;
%coeff_x2_q = 0.000946;
coeff_x2_q = 2^-11 + 2^-12 + 2^-13 + 2^-14 + 2^-15;
coeff_x0_q_i = coeff_x0_q*2^15; %U[-10,5]
coeff_x1_q_i = coeff_x1_q*2^14;  %U[-9,5]
coeff_x2_q_i = coeff_x2_q*2^15; %U[-10,5]


y_fl = zeros([1 length(cos_sum_t)]);
y_fl(1) = coeff_x0*cos_sum_t(1);
y_fl(2) = coeff_x0*cos_sum_t(2) + coeff_x1*cos_sum_t(1) + coeff_y1*y_fl(1);
for i = 1:length(cos_sum_t)-2
    y_fl(i+2) = coeff_x0*cos_sum_t(i+2) + coeff_x1*cos_sum_t(i+1) + coeff_x2*cos_sum_t(i) + coeff_y1*y_fl(i+1) + coeff_y2*y_fl(i);
end
figure
plot(ts,y_fl);
title('floating point filtering')
y_fl_power = y_fl.^2;
y_fl_power_avg = sum(y_fl_power)/vect_len

%% fixed point response
% here we have 2 ways:
% 1. we get the quantized value of the coefficients directly 
% 2. we get the integer quantized value and after multiplication we shift
% back to the original fixed-point representation

%coeff_x0_q = 0.000946;
coeff_x0_q = 2^-11 + 2^-12 + 2^-13 + 2^-14 + 2^-15;
%coeff_x1_q = 0.001892;
coeff_x1_q = 2^-10 + 2^-11 + 2^-12 + 2^-13 + 2^-14;
%coeff_x2_q = 0.000946;
coeff_x2_q = 2^-11 + 2^-12 + 2^-13 + 2^-14 + 2^-15;
coeff_x0_q_i = coeff_x0_q*2^15; %U[-10,5]
coeff_x1_q_i = coeff_x1_q*2^14;  %U[-9,5]
coeff_x2_q_i = coeff_x2_q*2^15; %U[-10,5]


coeff_y1_q =  1.91015625; 
coeff_y2_q = -0.9140625;

coeff_y1_q_i =  coeff_y1_q*2^8;  %U[1,8] 
coeff_y2_q_i = coeff_y2_q *2^7;   %S[1,7]


%SQNR = zeros([1 21]);
%for x = 8:28
    x = 15;
    y_fx = zeros([1 length(cos_sum_t_q)]);
    y_fx(1) = coeff_x0_q*cos_sum_t_q(1);
    y_temp = floor(y_fx(1) * 2^x);
    y_fx(1) = y_temp/2^x;
    y_fx(2) = coeff_x0_q*cos_sum_t_q(2) + coeff_x1_q*cos_sum_t_q(1) + coeff_y1_q*y_fx(1);
    y_temp = floor(y_fx(2) * 2^x);
    y_fx(2) = y_temp/2^x;
    for i = 1:length(cos_sum_t_q)-2
        y_fx(i+2) = coeff_x0_q*cos_sum_t_q(i+2) + coeff_x1_q*cos_sum_t_q(i+1) + coeff_x2_q*cos_sum_t_q(i) + coeff_y1_q*y_fx(i+1) + coeff_y2_q*y_fx(i);
        y_temp = floor(y_fx(i+2) * 2^x);
        y_fx(i+2) = y_temp/2^x;
    end
    y_fx_i = y_fx*2^x;

    figure;
    plot(ts,y_fx);
    title('fixed point filtering')
    %title('plot # %d',x);
    fx_error_power = (y_fl-y_fx).^2;
    fx_error_power_avg = sum(fx_error_power)/vect_len;
    SQNR(x-7) = pow2db(y_fl_power_avg/fx_error_power_avg);
    %SQNR(x-7) = pow2db(y_fl_power_avg/fx_error_power_avg);
%end

% x = 8:28;
% figure;
% %hold on;
% plot(x, SQNR);
% xlabel('x')
% ylabel('SQNR (dB)')
% title('SQNR')

%% generating the binary input and outputs for HDL

coeff_x0_q_bin = dec2bin(coeff_x0_q_i,5) %U[-10,5]
coeff_x1_q_bin = dec2bin(coeff_x1_q_i,5)  %U[-9,5]
coeff_x2_q_bin = dec2bin(coeff_x2_q_i,5)  %U[-10,5]


coeff_y1_q_bin = dec2bin(coeff_y1_q_i,9)  %U[1,8] 
coeff_y2_q_bin = dec2bin(coeff_y2_q_i,8)   %S[1,7]

cos_sum_t_q_bin = dec2bin(cos_sum_t_q_i,8);
y_fx_bin = dec2bin(y_fx_i,17);
fid_input  = fopen('input_samples.txt','w+');
fid_output = fopen('output_ref.txt','w+');
fid_coeffs = fopen('coefficients.txt','w+');
cos_sum_t_q_bin_cell = cellstr(cos_sum_t_q_bin);
y_fx_bin_cell= cellstr(y_fx_bin);
fprintf(fid_input,'%8s\n',cos_sum_t_q_bin_cell{:});
fprintf(fid_output,'%17s\n',y_fx_bin_cell{:});
fprintf(fid_coeffs,'a0 = %5s\n',coeff_x0_q_bin);
fprintf(fid_coeffs,'a1 = %5s\n',coeff_x1_q_bin);
fprintf(fid_coeffs,'a2 = %5s\n',coeff_x2_q_bin);
fprintf(fid_coeffs,'b1 = %5s\n',coeff_y1_q_bin);
fprintf(fid_coeffs,'b2 = %5s\n',coeff_y2_q_bin);
