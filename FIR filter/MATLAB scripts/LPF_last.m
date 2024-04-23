% There's an important note in c2d function
% There's multiple methods for the conversion but I want to stick to 2 of
% them, impulse invariant, ZoH(step invariant),
% impulse, is making sure that the impulse response is exactly the same of
% the continuous at the sample points where ZoH is delayed 1 Ts. On the
% other hand, the step response of the impulse response is very bad
% comparing to the step of the continuous which is done pretty well with
% ZoH.
% the main reason for that is that impulse method deals with the input as a
% train of impulses discretized while in real life (continuous life) we
% deal with input as a sequence of steps which makes ZoH more realistic.
% but why in Z-trasnform, the impulse is more 
%% code
close all;
% final implementation of the 1st order LPF
cut_off_freq = 100;
Simulation_sampling_freq = 1e6;
sampling_freq=10e3;
SimTs=1/Simulation_sampling_freq;
DigtalTs=1./sampling_freq;
w3db = 2*pi*cut_off_freq;
Tmax=1;
%% Time and Frequency axes
t = 0:SimTs:Tmax-SimTs;
f= -Simulation_sampling_freq/2:1/Tmax:Simulation_sampling_freq/2-1/Tmax;

%%
s = 1j*2*pi*f;
z = exp(1j*2*pi*f*DigtalTs);
H_cont = 1./(1+(s/w3db));
%H_disc = (w3db/sampling_freq)*(1./(1-exp(-w3db/sampling_freq)))*z./(z-exp(-w3db/sampling_freq));
H_disc = (w3db/sampling_freq)*z./(z-exp(-w3db/sampling_freq));
H_dis_zoh = (1-exp(-w3db/sampling_freq))./(z-exp(-w3db/sampling_freq));
H_bilinear=1./(1+(((2/DigtalTs)*(z-1)./(z+1))/w3db));
figure;
title("Frequency response")
hold on
plot(f,mag2db(abs(H_cont)))
plot(f,mag2db(abs(H_disc)))
plot(f,mag2db(abs(H_dis_zoh)))
plot(f,mag2db(abs(H_bilinear)))
set(gca,'xscale','log')
legend('continuous-time','discrete-time','discrete-time with ZoH')
figure;
title("Phase response")
hold on
plot(f,rad2deg(angle((H_cont))))
plot(f,rad2deg(angle((H_disc))))
plot(f,rad2deg(angle((H_dis_zoh))))
plot(f,rad2deg(angle((H_bilinear))))
set(gca,'xscale','log')
legend('continuous-time','discrete-time','discrete-time with ZoH')
% generating the sinusoid
s1 = sin(2*pi*t);      %f = 1 Hz;
s2 = sin(100*2*pi*t);   %f = 100 Hz;
s3 = sin(4500*2*pi*t);  %f = 4500 Hz;

%% discrete with no ZoH
y1 = zeros(size(t));
y2 = zeros(size(t));
y3 = zeros(size(t));
y1(1) =  (w3db/(2*pi*sampling_freq))*s1(1);
y2(1) =  (w3db/(2*pi*sampling_freq))*s2(1);
y2(1) =  (w3db/(2*pi*sampling_freq))*s3(1);
for i = 1:length(t)-1
    y1(i+1) = exp(-w3db/sampling_freq)*y1(i) + (w3db/(2*pi*sampling_freq))*s1(i+1);
    y2(i+1) = exp(-w3db/sampling_freq)*y2(i) + (w3db/(2*pi*sampling_freq))*s2(i+1);
    y3(i+1) = exp(-w3db/sampling_freq)*y3(i) + (w3db/(2*pi*sampling_freq))*s3(i+1);
end
h=w3db*exp(-w3db*t)/(sampling_freq);
figure;
plot(t,y1, 'b');
hold on;
plot(t,y2, 'r');
hold on;
plot(t,y3, 'g');


%% discrete with ZoH
y1_zoh = zeros(size(t));
y2_zoh = zeros(size(t));
y3_zoh = zeros(size(t));
y1_zoh(1) =  s1(1);
y2_zoh(1) =  s2(1);
y3_zoh(1) =  s3(1);
for i = 1:length(t)-1
    y1_zoh(i+1) = exp(-w3db/sampling_freq)*y1_zoh(i) + (1-exp(-w3db/sampling_freq))*s1(i+1);
    y2_zoh(i+1) = exp(-w3db/sampling_freq)*y2_zoh(i) + (1-exp(-w3db/sampling_freq))*s2(i+1);
    y3_zoh(i+1) = exp(-w3db/sampling_freq)*y3_zoh(i) + (1-exp(-w3db/sampling_freq))*s3(i+1);
end
h_zoh = (exp(w3db/sampling_freq) - 1)*exp(-w3db*(t/sampling_preiod-1)/sampling_freq); 
figure;
plot(t,y1_zoh, 'b');
hold on;
plot(t,y2_zoh, 'r');
hold on;
plot(t,y3_zoh, 'g');