function N = cont(q_ref,q_est,Kp,Kd,w)
%determine control torque, given estimated and reference quaternions
del_q = quatmultiply(quatconj(q_est),q_ref);%error quaternion
dq0 = del_q(1,1);
dq1 = del_q(1,2);
dq2 = del_q(1,3);
dq3 = del_q(1,4);
error = (2*dq0)*[dq1 dq2 dq3];%error vector
N = Kp*error - Kd*w;%control torque
Nx = N(1,1);
Ny = N(1,2);
Nz = N(1,3);
if (abs(Nx) > 10^(-3))
Nx = 10^(-3)*Nx/abs(Nx);
end
if (abs(Ny) > 10^(-3))
Ny = 10^(-3)*Ny/abs(Ny);
end
if (abs(Nz) > 10^(-3))
Nz = 10^(-3)*Nz/abs(Nz);
end
N = [Nx Ny Nz];%set limiton max value of applicable torque
end