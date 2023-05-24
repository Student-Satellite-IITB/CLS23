function [q_next] = prop_q(q,w,dt)
%%%%
%propagation of quaternion, given current quaternion,omega
%q(t+dt)=q(t)*dq(t)
%%%%
dtheta = norm(w)*dt;
wcap = w/norm(w);
delq = [cos(dtheta/2) sin(dtheta/2)*wcap];%instantaneous rotation
q_next = quatmultiply(q,delq);%q(t+dt)

end