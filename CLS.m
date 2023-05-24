%%%CLS
%at time t:
%current quaternion,omega(from propagator) ->
%estimator:estimated quaternion ->
%controller:control torque ->
%propagator: quaternion,omega at next iteration ->
%sensor:sensor data(add noise to propagated quaternion)
%%%

%constants
dt = 0.5;%iterate after every 0.5 sec
t = 50;%time till which to iterate
time = 0:dt:t;%array of time steps
w_i = [0.002 0.003 0.004];%initial omega
q_i = [0.5 0.5 0.5 0.5];%initial quaternion
Kp = 0.007;
Kd = 0.01;
I = [0.004 0 0;0 0.005 0;0 0 0.003];%inertia tensor
%

%start cls
%initialise variables
q_prop = q_i;
w = w_i;
q_sen = noise(q_prop);
%start iterations
for i = 1:1:length(time)
    %cls
    q_est = est(q_sen,q_prop);%estimate the quaternion
    N_cont = cont(q_ref,q_est,Kp,Kd,w);%control torque
    q_prop = prop_q(q_prop,w,dt);%propagate quaternion
    w = prop_w(w,dt,N_cont,I);%propagate omega
    q_sen = noise(q_prop);%add noise for sensor quaternion
    %??what about adding noise to angular velocity also??
end