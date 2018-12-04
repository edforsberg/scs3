clear all 



nrSwimmers = 60; 
Dr = 0; 
Dt  = 0; 
xyRange = 50; 
color = 1; 
v = 0.3; 
dt = 1; 
rc = 10; 
T0 = -1; 
timeSteps = 10000; 
rPush = 2; 



swimmers = [];
for i = 1:nrSwimmers
    swimmers = [swimmers; Swimmer(Dr,Dt,v, xyRange, color, true)];
end
   
for i = 1:timeSteps

for j=1:nrSwimmers 
    CalculateTorque(swimmers(j), swimmers([1:j-1, j+1:end]), rc, T0);    
end 

for j = 1:nrSwimmers 
    interact(swimmers(j), dt, xyRange);
end

for j = 1:nrSwimmers     
    push(swimmers, rPush);    
end

for j = 1:nrSwimmers    
    xPos(j) = swimmers(j).xPos;
    yPos(j) = swimmers(j).yPos;    
end

clf 
scatter(xPos, yPos, 100); 
axis equal 
xlim([0 xyRange]) 
ylim([0 xyRange])
drawnow

end
        