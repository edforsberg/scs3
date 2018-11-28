clc
clf

T0 = 10;
rc = 15;
rPush = 2;
rCol = 4;
Dr = 0;
Dt = 0;
dt = 0.2;
v = 2;
xyRange = 100;
nrSwimmers = 100;
timeSteps = 1000;
showPlot = true;
c = [1 0 0; 0 1 0; 0 0 1; 1 0 1; 0 1 1; 0 0 0];
c = [c; zeros(20,3)]; 
c = linspace(1,3,100); 
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

% if showPlot
%     scatter(xData, yData, 30);
% end

for i = 1:timeSteps
    xData = [];
    yData = [];
    
    tVec = [];
    for j = 1:nrSwimmers
        Tn = CalculateTorque(swimmers(j), swimmers, rc, T0);
        tVec = [tVec; Tn];
    end
    
   % oldPos = zeros(nrSwimmers,2);
    for j = 1:nrSwimmers
      %  oldPos(j,:)=[swimmers(j).xPos swimmers(j).yPos];
        newPos = interact(swimmers(j), tVec(j), dt, xyRange);
    end
    
    distMat = GetDistMat(swimmers);
    col = [];
    for j = 1:nrSwimmers
        
        neighbourI = find(distMat(j,:) < rPush);
        newPos = fixOverlap(swimmers(j), swimmers(neighbourI), rPush);
        
        xData = [xData;newPos(1)];
        yData = [yData;newPos(2)];
        
        a = sum(distMat(j,:) < rCol);
        b = c(a);
        col = [col; b];
    end
  
    if showPlot
        clf
       % viscircles([xData yData], ones(nrSwimmers, 1), 'linewidth', 0.1); 
        scatter(xData, yData, 30, col);
        axis([0 xyRange 0 xyRange])
        drawnow
    end
    end