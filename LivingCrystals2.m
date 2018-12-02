clear all 



nrSwimmers = 100; 
Dr = 0; 
Dt  = 0; 
xyRange = 100; 
color = 1; 
v = 1; 
dt = 1; 
rc = 10; 
T0 = 1; 

swimmers = [];
for i = 1:nrSwimmers
    swimmers = [swimmers; Swimmer(Dr,Dt,v, xyRange, color, true)];
end
       
for j=1:nrSwimmers 
    CalculateTorque(swimmers(j), swimmers([1:j-1, j+1:end]), rc, T0);    
end 

for j = 1:nrSwimmers 
    interact(swimmers(j), dt, xyRange)
end

for j = 1:nrSwimmers 
    
    push(swimmers, rc);
    
end

xPos = swimmers.xPos; 
yPos = swimmers.yPos; 
        