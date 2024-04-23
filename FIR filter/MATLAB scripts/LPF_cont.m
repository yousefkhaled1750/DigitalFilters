f3db = 1e6;
w3db = 2*pi*f3db;
s = tf('s');
z = tf('z');
H = 1/(1+s/w3db);
Hcl = feedback(H,1)
step(H);
margin(H);
H_disc = c2d(H,1e-9);
