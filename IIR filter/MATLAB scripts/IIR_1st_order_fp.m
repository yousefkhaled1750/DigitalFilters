%% code
close all;
clear;
% final implementation of the 1st order LPF
cut_off_freq = 1e5;
Simulation_sampling_freq = 1e8;
sampling_freq=1e7;
SimTs=1/Simulation_sampling_freq;
Ts=1/sampling_freq;
wo = 2*pi*cut_off_freq;
Tmax=1e-4;


%% time and frequency axis
t = 0:SimTs:Tmax-SimTs;
ts = 0:Ts:Tmax-Ts;
f= -Simulation_sampling_freq/2:1/Tmax:Simulation_sampling_freq/2-1/Tmax;
fs = -sampling_freq/2:1/Tmax:sampling_freq/2 - 1/Tmax;

%% generating and quantizing the sinusoids
vect_len = length(ts);
amp = 1-2^-6;
cos_30K_t = amp*cos(2*pi*3e4*ts);
cos_3M_t = amp*cos(2*pi*3e6*ts);
cos_sum_t = cos_30K_t + cos_3M_t;
%cos_sum_t(cos_sum_t<-2) = -2;
cos_sum_t_q = round(cos_sum_t*2^6)/2^6; %S[2,6]
%cos_sum_t_q(cos_sum_t_q<-2) = -2;
cos_sum_t_q_i = cos_sum_t_q*2^6;
figure
%hold on
%plot(ts,cos_sum_t);
plot(ts,cos_sum_t_q);
legend('t','q');

%% floating point response
y_coeff = exp(-wo*Ts);      
x_coeff = wo;               

y_fl = zeros([1 vect_len]);
y_fl(1) = x_coeff*cos_sum_t_q(1);
for i = 1:vect_len-1
    y_fl(i+1) = y_coeff*y_fl(i) + x_coeff*cos_sum_t_q(i+1);
end
y_fl_power = y_fl.^2;
y_fl_power_avg = sum(y_fl_power)/vect_len;
figure
plot(ts,y_fl);
title('floating point filtering')
y_fl_power = y_fl.^2;
y_fl_power_avg = sum(y_fl_power)/vect_len

%% fixed point response

y_coeff_q = floor(exp(-wo*Ts)*2^11)/(2^11);      % quantize it to U(0,11)
x_coeff_q = 628320;                              % for wo = 2*pi*1e5 U(20,-5)
%I floored wo and get dec2bin to see how I can round the number 

SQNR = zeros([1 21]);
for x = -12:8
   % x = -12;
    y_fx = zeros([1 vect_len]);
    y_fx(1) = x_coeff_q*cos_sum_t_q(1);
    y_temp = floor(y_fx(1) * 2^x);
    y_fx(1) = y_temp/2^x;
   for i = 1:vect_len-1
        y_temp = y_coeff*y_fx(i) + x_coeff*cos_sum_t_q(i+1);
        % round for x
        %y_temp = round(y_temp * 2^x);
        y_temp = floor(y_temp * 2^x);
        y_fx(i+1) = y_temp/(2^x);
   end
%     figure;
%     plot(ts,y_fx);
%     title('fixed point filtering')
%     title('plot # %d',x);
    fx_error_power = (y_fl-y_fx).^2;
    fx_error_power_avg = sum(fx_error_power)/vect_len;
    SQNR(x+13) = pow2db(y_fl_power_avg/fx_error_power_avg);
    
end

x_axis = -12:8;
figure;
%hold on;
plot(x_axis, SQNR);
xlabel('x')
ylabel('SQNR (dB)')
title('SQNR')

%% generating the binary input and outputs for HDL

x_coeff_q_bin = dec2bin(x_coeff_q*2^-5);
y_coeff_q_bin = dec2bin(y_coeff_q*2^11,11);
cos_sum_t_q_bin = dec2bin(cos_sum_t_q_i,8);
y_fx_bin = dec2bin(y_fx.*2^-12,13);
fid_input  = fopen('input_samples_1st_IIR_SQNR.txt','w+');
fid_output = fopen('output_ref_1st_IIR_SQNR.txt','w+');
fid_coeffs = fopen('coefficients_1st_IIR_SQNR.txt','w+');
cos_sum_t_q_bin_cell = cellstr(cos_sum_t_q_bin);
y_fx_bin_cell= cellstr(y_fx_bin);
fprintf(fid_input,'%8s\n',cos_sum_t_q_bin_cell{:});
fprintf(fid_output,'%17s\n',y_fx_bin_cell{:});
fprintf(fid_coeffs,'x_coeff = %15s\n',x_coeff_q_bin);
fprintf(fid_coeffs,'y_coeff = %11s\n',y_coeff_q_bin);
