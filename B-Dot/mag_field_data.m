h = 1;
t = 21600;

time  = 0:h:t/h; % true anomaly

omega_o = 2.*pi/5400; %omega
theta = omega_o.*time;
r = 250000; % altitude
x_bar = r.*(cos(theta)); % x-component in perifocal frame
y_bar = r.*(sin(theta)); % y-component in perifocal frame
in = 1.684242728; % inclination
X = x_bar; % x-component in ECI frame
Y = cos(in) .* y_bar; % y-component in ECI frame
Z = sin(in) .* y_bar; % z-component in ECI frame
lat = asind(Z ./  r); % array of latitudes in degrees
long = (180 ./ pi) .* atan2(Y, X); % array of longitudes in degrees
[BXYZ,H,D,I,F] = igrfmagm(250000 .* ones([1, length(time)]), lat, long, decyear(2022, 6, 9) .* ones([1, length(time)]), 13); % mag field in NED frame in nT
%BXYZ = BXYZ.*1e-9; % mag field in NED frame in T
Bx = BXYZ(:,1);
By = BXYZ(:,2);
Bz = BXYZ(:,3);
[Bx1, By1, Bz1] = ned2ecef(Bx, By, Bz, lat, long, 250000 .* ones([length(time), 1]), referenceSphere('earth', 'meter')); % mag field in ECEF frame
Bx1 = Bx1(1,:)';
By1 = By1(1,:)';
Bz1= Bz1(1,:)';
BXYZ1(:,1) = Bx1;
BXYZ1(:,2) = By1;
BXYZ1(:,3) = Bz1;
utc = [2022 6 9 15 0 0];
BXYZ2=zeros([length(time), 3]);
for i=(1:length(time))
BXYZ2(i, :) = ecef2eci(utc,BXYZ1(i,:)); % mag field in ECI frame
end
Bx2 = BXYZ2(:,1);
By2 = BXYZ2(:,2);
Bz2 = BXYZ2(:,3);
inc = 96.5; % inclination of orbit
BXYZ3=zeros([length(time), 3]);
for i = (1:length(time))
    M = [-cos(inc).*sin(theta(i)), -cos(inc).*cos(theta(i)), sin(inc);
         cos(theta(i)), -sin(theta(i)), 0;
         sin(inc).*sin(theta(i)), sin(inc).*cos(theta(i)), cos(inc)];
    BXYZ3(i, :) = M*[Bx2(i); By2(i); Bz2(i)]; % mag field in orbit frame
end
writematrix(BXYZ3.*1e-9, 'magdata1.csv')
BXYZ3 = BXYZ3.*1e-9;%convert into T