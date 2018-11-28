function torque = TorqueEq(vn, rn, T0)

fac1 = (dot(vn, rn)/norm(rn)^2)*vn; 
fac2 = cross(fac1, rn);

torque = T0*dot(fac2,[0;0;1]); 
