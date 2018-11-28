clc 
clf

T0 = -2;
rc = 8;
Dr = 0;
Dt = 0;
dt = 1; 
v = 0.5; 
rPush = 1.5;
rCol = 5; 
xyRange = 100;
nrSwimmers = 100;
timeSteps = 1000;
showPlot = true;
colormap cool 

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
        oldPos(j,:) = [swimmers(j).xPos swimmers(j).yPos];
        newPos = interact(swimmers(j), tVec(j), dt, xyRange);        
    end
    
    colVec = []; 
    distMat = GetDistMat(swimmers);
    for j = 1:nrSwimmers
        swimClose = sum(distMat(:,j) < rPush)-1;
        if(swimClose > 0)
            if rand < 0.5
                swimmers(j).xPos = oldPos(j,1);
            else
                swimmers(j).yPos = oldPos(j,2);
            end
        end        
        xData = [xData;swimmers(j).xPos];
        yData = [yData;swimmers(j).yPos];
        colVec = [sum(distMat(:,j) < rCol); col]; 
    end
        
    if showPlot
        clf
        col
        scatter(xData, yData, 30, colVec);
        axis([0 xyRange 0 xyRange])
        drawnow
    end
end