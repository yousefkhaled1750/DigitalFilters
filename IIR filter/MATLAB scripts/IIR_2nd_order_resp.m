%% code
close all;
clear;
% final implementation of the 1st order LPF
cut_off_freq = 1e5;
Simulation_sampling_freq = 1e8;
sampling_freq=1e7;
SimTs=1/Simulation_sampling_freq;
DigtalTs=1./sampling_freq;
w3db = 2*pi*cut_off_freq;
Tmax=1e-4;
%% Time and Frequency axes
t = 0:SimTs:Tmax-SimTs;
f= -Simulation_sampling_freq/2:1/Tmax:Simulation_sampling_freq/2-1/Tmax;

s = 1j*2*pi*f;
z = exp(1j*2*pi*f*DigtalTs);

%% plotting the tf frequency response
% to get a better visualization, increase Tmax to 1e-3 
% H_z = (0.06746*z.^2 + 0.1349*z+0.06746)./(z.^2-1.143*z+0.4128); %for 1e6, 1e7 (fc,fs)
H_z = (0.0009447*z.^2 + 0.001889*z+0.0009447)./(z.^2-1.911*z+0.915); %for 1e5, 1e7 (fc,fs)


figure;
title("Frequency response")
plot(f,mag2db(abs(H_z)));
set(gca,'xscale','log');
xlabel("frequency (Hz)")
ylabel("magnitude (dB)")

%% generating the sinusoids
% we want to generate 2 sinusoids, 300 KHz and 3 MHz and add them.
% the response should outputs the 300 KHz and attenuates 3 MHz.
amp = 1;
% cos_300K_t = amp*cos(2*pi*3e5*t);
% cos_3M_t = amp*cos(2*pi*3e6*t);
% cos_sum_t = cos_3M_t + cos_300K_t;
% cos_mul_t = cos_3M_t .* cos_300K_t;
cos_30K_t = amp*cos(2*pi*3e4*t);
cos_3M_t = amp*cos(2*pi*3e6*t);
cos_sum_t = cos_30K_t + cos_3M_t;
cos_mul_t = cos_30K_t .* cos_3M_t;

% figure;
% plot(t,cos_300K_t);
% hold on;
% plot(t,cos_3M_t);
% xlabel('time (10 us)');
% ylabel('amplitude');
% 
figure;
plot(t,cos_sum_t);
%hold on;
%plot(t,cos_mul_t);
%legend('sum','mul');
xlabel('time (10 us)');
ylabel('amplitude');
title('summat')

%% quantizing the inputs to 8 bits
numOfBits_in = 8;
cos_sum_t_q = round(cos_sum_t * 2^(numOfBits_in-2))-1;

% coeff_y1 =  1.143;
% coeff_y2 = -0.4128;
% 
% coeff_x0 = 0.06746;
% coeff_x1 =  0.1349;
% coeff_x2 = 0.06746;

coeff_y1 =  1.911;
coeff_y2 = -0.915;

coeff_x0 = 0.0009447;
coeff_x1 =  0.001889;
coeff_x2 = 0.0009447;


y_fl = zeros([1 length(cos_sum_t)]);
y_fl(1) = coeff_x0*cos_sum_t(1);
y_fl(2) = coeff_x0*cos_sum_t(2) + coeff_x1*cos_sum_t(1) + coeff_y1*y_fl(1);
for i = 1:length(cos_sum_t)-2
    y_fl(i+2) = coeff_x0*cos_sum_t(i+2) + coeff_x1*cos_sum_t(i+1) + coeff_x2*cos_sum_t(i) + coeff_y1*y_fl(i+1) + coeff_y2*y_fl(i);
end

figure;
plot(t,y_fl);
% hold on;
% plot(t,cos_mul_t);
xlabel('time (10 us)');
ylabel('amplitude');

input_f = fftshift(fft(cos_sum_t,length(cos_sum_t))*2/length(cos_sum_t)); 
output_f = fftshift(fft(y_fl,length(cos_sum_t))*2/length(cos_sum_t)); 
figure;
plot(f,input_f);
xlabel('frequency (Hz)');
ylabel('Magnitude');
title('Spectrum of the input');

figure;
plot(f,output_f);
xlabel('frequency (Hz)');
ylabel('Magnitude');
title('Spectrum of the output');
