% we have fixed-point inputs in the form U(5,3) where it's unsigned with 5
% bits integral and 3 bits fractional.
% the problem is to choose the fixed-point size of the coefficients and the
% multipliers and adders registers to get average SQNR of 60 dB at least.
% note: the size of the operands can be different but need to be aligned in
% case of addition and to track the binary point in case of multiplication.

% strategy: iterate over different sizes and fractional widths of the
% coefficients and the acumulators.
close all
clear
sampling_freq = 10000;
cutoff_freq = 100;
wo = 2*pi*cutoff_freq;
Ts = 1/sampling_freq;
Simulation_sampling_freq = 1e6;
SimTs=1/Simulation_sampling_freq;
Tmax = 1/10;

tsim = 0:SimTs:Tmax-SimTs;
tsam = 0:Ts:Tmax-Ts;
fsim= -Simulation_sampling_freq/2:1/Tmax:Simulation_sampling_freq/2-1/Tmax;
fsam = -sampling_freq/2:1/Tmax:sampling_freq/2 - 1/Tmax;

numOfBits_in = 8;
binPoint_in = 3;
vect_len = length(tsam);
% generating the input vector (uniform distribution)
vect_in = floor(rand([1 vect_len])*(2^numOfBits_in))/(2^binPoint_in);



% the filter designed is LPF with sampling frequency 10KHz, cut-off
% frequency 100Hz whose TF is H(s)=wo/(s+wo).
% the fitler equation is y(n) = exp(-wo*T)*y(n-1) + wo*x(n)
% wo = 628.31853, exp(-wo*Ts) = 0.9391
% wo = 1001110100.0101, exp(-wo*Ts) = .1111000001


%floating point operations
y_fl = zeros([1 vect_len]);
y_fl(1) = (wo/(2*pi*sampling_freq))*vect_in(1);
%y_fl(1) = (wo)*vect_in(1);

    y_coeff = floor(exp(-wo*Ts))
    for i = 1:vect_len-1
        y_fl(i+1) = exp(-wo*Ts)*y_fl(i) + (wo/(2*pi*sampling_freq))*vect_in(i+1);
        %y_fl(i+1) = exp(-wo*Ts)*y_fl(i) + (wo)*vect_in(i+1);
    end


% calculating the signal power
y_fl_power = y_fl.^2;
y_fl_power_avg = sum(y_fl_power)/length(tsam)
%plot(tsam,y_fl_power);
% 
% % we need sum((y_fl-y_fx).^2)/L = 7*10^-3
% 
% for m = 8:16
%     x_coeff_fx = fi(wo/(2*pi*sampling_freq),0,m,m);
%     y_coeff_fx = fi(exp(-wo*Ts),0,m,m);
%     y_fx(m-7,1) = fi(x_coeff_fx*vect_in(1),0,m);
%     for i = 1:vect_len-1
%         acc1 = fi(y_coeff_fx*y_fx(m-7,i),0,m,m);
%         acc2 = fi(x_coeff_fx*vect_in(i+1),0,2*m,2*m);
%         acc = acc1 + acc2;
%         y_fx(m-7,i+1) = fi(acc,0,m);
%         %y_fl(i+1) = exp(-wo*Ts)*y_fl(i) + (wo)*vect_in(i+1);
%     end
% end
% 
% y_fx_power = y_fx.^2;
% for i = 1:8
%     y_fx_power_avg = sum(y_fx_power(i,:))/length(tsam);
% end

in_ft = fftshift(fft(vect_in(1:sampling_freq),sampling_freq));
out_ft = fftshift(fft(y_fl(1:sampling_freq),sampling_freq));
figure;
plot(fsam,mag2db(abs(in_ft)))
hold("on");
plot(fsam,mag2db(abs(out_ft)))
hold("off")

