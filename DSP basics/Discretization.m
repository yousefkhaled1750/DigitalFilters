% first we will use the tf('s') tf('z') and c2d method and then we will
% try our manual s and z
close all;
clear all;
Fsim = 1e6;
Fc = 100;
%Fs = 10000;
Fs = 500;
Wc = 2*pi*Fc;
Tmax = 1;
Ts = 1/Fs;

t = 0:Ts:Tmax-Ts;
f = -Fsim/2:(1/Tmax):Fsim/2-(1/Tmax);

s_m = 1i*2*pi*f;
z_m = exp(1i*2*pi*f*Ts);
s_bi = (2/Ts)*(z_m-1)./(z_m+1);

G_s_m = (200*pi)./(s_m+200*pi);
G_bi_z_m = 200*pi./(s_bi + 200*pi);

figure;
plot(f,mag2db(abs(G_s_m)));
hold on;
plot(f,mag2db(abs(G_bi_z_m)));
set(gca,'xscale','log');

w3db_a = (2/Ts)*tan(Wc*Ts/2);
G_s_a = w3db_a./(s_m+w3db_a);
G_z_bi = w3db_a./(s_bi + w3db_a);


plot(f,mag2db(abs(G_s_a)));
hold on;
plot(f,mag2db(abs(G_z_bi)));
set(gca,'xscale','log');
legend('cont','bilinear','cont_prewarp','bilinear_prewarp')


G_s_m_zoh = ((1-exp(-s_m*Ts))./s_m).*G_s_m;
G_z_m_zoh = (1-exp(-Wc*Ts))./(z_m-exp(-Wc*Ts));
figure;
hold on;
plot(f,mag2db(abs(G_z_m_zoh)));
plot(f,mag2db(abs(G_s_m)));
set(gca,'xscale','log');
legend('zoh','cont');


s = tf('s');
z = tf("z");
G = Wc/(s+Wc);
%G = 1/(s+1);
Gz = c2d(G,Ts,'zoh')
Gi = c2d(G,Ts,'impulse')
Gb = c2d(G,Ts,'tustin')
bode(G,Gz,Gi,Gb);
legend('G','Gz','Gi','Gb');

figure;
hold on;
G_man = Wc*Ts * z/(z-exp(-Wc*Ts));
G_man_zoh = (1-exp(-Wc*Ts))/(z-exp(-Wc*Ts));
%bode(G,G_man,G_man_zoh);
bode(G_man,G_man_zoh);
legend('G\_man','G\_man\_zoh');

figure;
step(G,Gi,Gz);
legend('G','Gi','Gz');
figure;
impulse(G,Gi,Gz);
legend('G','Gi','Gz');