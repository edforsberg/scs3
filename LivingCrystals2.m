clc 
clf

T0 = 4;
rc = 10;
Dr = 0;
Dt = 0;
dt = 0.5; 
v = 0.2; 
xyRange = 100;
nrSwimmers = 100;
timeSteps = 1000;
showPlot = true;

xData = [];
yData = [];

swimmers = [];
for i = 1:nrSwimmers
    swimmer = Swimmer(Dr, Dt, v, xyRange, 1);
    swimmer.Move(dt);
    swimmers = [swimmers; swimmer];
    xData = [xData; swimmer.xPos];
    yData = [yData; swimmer.yPos];
end

if showPlot
    scatter(xData, yData, 30);
end



for i = 1:timeSteps    
    xData = [];
    yData = [];
    
    tVec = []; 
    for j = 1:nrSwimmers
        Tn = CalculateTorque(swimmers(j), swimmers, rc, T0);
        tVec = [tVec; Tn];        
    end    
    
    for j = 1:nrSwimmers
        newPos = interact(swimmers(j), tVec(j), dt, xyRange);
        xData = [xData;newPos(1)];
        yData = [yData;newPos(2)];
    end
    
    if showPlot
        clf
        scatter(xData, yData, 30, 'filled');
        axis([0 xyRange 0 xyRange])
        drawnow
    end
end