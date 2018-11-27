clc
clf

T0 = -2;
rc = 15;
%rPush = 1;
rCol = 4;
Dr = 0;
Dt = 0;
dt = 0.2;
v = 10;
xyRange = 100;
nrSwimmers = 100;
timeSteps = 1000;
showPlot = true;
c = [1 0 0; 0 1 0; 0 0 1; 1 0 1; 0 1 1; 0 0 0];
c = [c; zeros(20,3)]; 

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
    
    oldPos = zeros(nrSwimmers,2);
    for j = 1:nrSwimmers
        oldPos(j,:)=[swimmers(j).xPos swimmers(j).yPos];
        newPos = interact(swimmers(j), tVec(j), dt, xyRange);
        xData = [xData;newPos(1)];
        yData = [yData;newPos(2)];
    end
    
    distMat = GetDistMat(swimmers);
    col = [];
    for j = 1:nrSwimmers
        if(sum(distMat(j,:) < rPush) > 1)
            swimmers(j).xPos = oldPos(j,1);
            swimmers(j).yPos = oldPos(j,2);
        end
        a = sum(distMat(j,:) < rCol);
        b = c(a,:);
        col = [col; b];
    end
  
    if showPlot
        clf
        scatter(xData, yData, 30, col);
        axis([0 xyRange 0 xyRange])
        drawnow
    end
end