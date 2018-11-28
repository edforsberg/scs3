clear all

nrSwimmers = 100;
xyRange = 100;
Dr = 0;
Dt = 0;
v = 0.3;
dt = 0.1;
rc = 8;
T0 = 1;
rPush = 1;
timeSteps = 1000;

swimmers = [];
for i = 1:nrSwimmers
    swimmers = [swimmers; Swimmer(Dr, Dt, v, xyRange, 0)];
end

xData = zeros(nrSwimmers, 1);
yData = zeros(nrSwimmers, 1);
for i = 1:timeSteps
    
    for j = 1:nrSwimmers
        otherSwimmers = swimmers;
        otherSwimmers(j) = [];
        CalculateTorque(swimmers(j), otherSwimmers, rc, T0);
    end
    
    posMat = [];
    for j = 1:nrSwimmers
        interact(swimmers(j), dt, xyRange);
        posMat = [posMat [swimmers(j).xPos; swimmers(j).yPos]];
    end
    
    
    overlaps = true;
    distMat = dist(posMat);
    for j = 1:nrSwimmers
        indices = find(distMat(j,:)<rPush);
        indices = indices(find(indices ~= j));
        if(numel(indices) > 0)            
            Push(swimmers(j), swimmers(indices),rPush);
        end
    end
    
    
    for j = 1:nrSwimmers
        xData(j) = swimmers(j).xPos;
        yData(j) = swimmers(j).yPos;
    end
    
    clf
    scatter(xData, yData,30);
    drawnow
    
    
    a = 1;
    
end



