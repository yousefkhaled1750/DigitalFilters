 % simulating a filter by genertaing different sinusoids and compare the
% magnitude and phase after applying the filter on the sinusoids.

cut_off_freq = 100;
sampling_freq = 10000;
sampling_preiod = 1/sampling_freq;
w3db = 2*pi*cut_off_freq;
t = 0:sampling_preiod:10;

% generating the sinusoid
s1 = sin(2*pi*t);      %f = 1 Hz;
s2 = sin(10*2*pi*t);   %f = 10 Hz;
s3 = sin(450*2*pi*t);  %f = 100 Hz;

% function of the sinusoid
y1 = zeros(size(t));
y1(1) =  s1(1);
for i = 1:length(t)-1
    y1(i+1) = exp(-w3db*sampling_preiod)*y1(i) + (w3db/(2*pi*sampling_freq))*s1(i+1);
end

h=w3db*exp(-w3db*t)/(sampling_freq);
plot(t,s1,'b');
hold on
plot(t,y1,'r');
fvtool(h);


%continuous filter
s = tf('s');
h_cont = 1/(1+s/w3db);


h_disc = c2d(h_cont,sampling_preiod)
bode(h_disc,'r', h_cont,'b')
legend('discrete','continuous')
% response with ZoH

y1_zoh = zeros(size(t));
y1_zoh(1) =  s1(1);
for i = 1:length(t)-1
    y1_zoh(i+1) = exp(-w3db*sampling_preiod)*y1_zoh(i) + (1-exp(-w3db/sampling_freq))*s1(i+1);
end
h_zoh = (1-exp(-w3db/sampling_freq))*exp(-w3db*(t/sampling_preiod-1)/sampling_freq); 
hold on;
plot(t,y1_zoh,'c');



