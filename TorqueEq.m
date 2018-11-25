function Tn = TorqueEq(v, r, T0)

ez = [0; 0; 1]; 
fac1 = T0*(dot(v,r')/norm(r)^2)*v;
fac2 = r; 

Tn = cross(fac1, fac2); 
Tn = -Tn*ez; 

end