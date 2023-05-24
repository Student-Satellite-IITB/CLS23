digits(10);

w = [0.6; -0.5; -0.4];
B = [VarName1(1); VarName2(1); VarName3(1)];
h = 1;
t = 21600;
n = t/h;
q = [1, 0, 0, 0];

wx = zeros(1, n);
wy = zeros(1, n);
wz = zeros(1, n);

q0 = zeros(1, n);
q1 = zeros(1, n);
q2 = zeros(1, n);
q3 = zeros(1, n);

q_norm = zeros(1, n);

x = h:h:t;

for i = 1:1:n
    Bn = [VarName1(i+1); VarName2(i+1); VarName3(i+1)];
    k1 = W_dot(w, B, Bn);
    k2 = W_dot(w + h/2*k1, B, Bn);
    k3 = W_dot(w + h/2*k2, B, Bn);
    k4 = W_dot(w + h*k3, B, Bn);

    w = w + h/6*(k1 + 2*k2 + 2*k3 + k4);
    wx(1, i) = w(1, 1);
    wy(1, i) = w(2, 1);
    wz(1, i) = w(3, 1);

    q = QP(q, w, h);
    q0(1, i) = q(1, 1);
    q1(1, i) = q(1, 2);
    q2(1, i) = q(1, 3);
    q3(1, i) = q(1, 4);

    q_norm(1, i) = norm(q);
    
    B = Bn;
end

% Top plot
fig1 = figure(1);
plot(x, wx);
hold on
plot(x, wy);
hold on
plot(x, wz);
legend("wx", "wy", "wz");

fig2 = figure(2);
plot(x, q0);
hold on
plot(x, q1);
hold on
plot(x, q2);
hold on
plot(x, q3);
legend("q0", "q1", "q2", "q3");

fig3 = figure(3);
plot(x, q_norm);
legend("norm of quaternion")

function w_dot = W_dot(ang, field, n_field)
    MOI = [0.033, 0, 0 ; 0, 0.013, 0 ; 0, 0, 0.035];
    mu = U(ang, field, n_field);
    T = cross(mu, field);
    w_dot = MOI \ (T - cross(ang, MOI*ang));
end

function u = U(ang, field, n_field)
    k = 10;
    u_max = 0.0005;
    B_dot = (n_field - field) + cross(field, ang);
    u1 = -k * B_dot;
    if(norm(u1) > u_max) 
        u1 = u1/norm(u1) * u_max;
    end
    u = u1;
end

function q_next = QP(q, w, h)
    d_theta = norm(w)*h / 2;
    w_theta = w/norm(w) * sin(d_theta);
    delta_q = [cos(d_theta), w_theta(1, 1), w_theta(2, 1), w_theta(3, 1)];
    q_next = quatmultiply(q,delta_q);
end