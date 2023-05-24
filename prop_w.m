function [w_next] = prop_w(w,dt,N,I)
p1 = dt*w_dot(t,w,N,I);
p2 = dt*w_dot(t+dt/2,w+p1/2,N,I);
p3 = dt*w_dot(t+dt/2,w+p2/2,N,I);
p4 = dt*w_dot(t+dtw+p3,N,I);
dw = (p1+2*p2+2*p3+p4)/6;
w_next = w + dw;
end

function [wdot] = w_dot(t,w,N,I)
%%%%
%derivative of omega
%given: applied torque,inertia tensor,current omega,time
%%%%
J = (I*(w.')).';%take care of matrix multiplication and transpose
wdot = inv(I)\(N - cross(w,J));%derivative
end