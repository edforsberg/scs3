clc
clf 

Dt = 0.22;
Dr = 0.16;
v = 0.001;
dt = 0.1;
rangeMax = 100;

timeSteps = 2^16;
plotTraj = false;

posX = rand*rangeMax;
posY = rand*rangeMax;
dir = rand*2*pi;

posVec = [];

if plotTraj
    subplot(1,2,1);
    trajPlot = scatter(posX, posY, 5, 'green', 'filled');
    axis equal
    xlim([0 rangeMax])
    ylim([0 rangeMax])
    drawnow
end

for i = 1:timeSteps    
    
    Wx = normrnd(0,1)/sqrt(dt);
    Wy = normrnd(0,1)/sqrt(dt);
    Wdir = normrnd(0,1)/sqrt(dt);
    
    dx = v*cos(dir)+sqrt(2*Dt)*Wx; 
    dy = v*sin(dir)+sqrt(2*Dt)*Wy; 
    dDir = sqrt(2*Dr)*Wdir; 
    
    xPos = xPos + dx*dt; 
    yPos = yPos + dy*dt; 
    dir = dir + dDir*dt;     
    
    posVec = [posVec; xPos yPos]; 
    
    if plotTraj
        set(trajPlot, 'XData', posVec(:,1), 'YData', posVec(:,2)); 
        drawnow
    end
    
end

MSD = [];
timeVec = [];

for i = 0:log2(timeSteps)
    
    step = 2^i;
    
    dists = [];
    currPos = 1;
    while(currPos+step <= timeSteps)
        
        xPos = posVec(currPos,1);
        xNext = posVec(currPos+step, 1);
        yPos = posVec(currPos, 2);
        yNext = posVec(currPos+step, 2);
        
        dx = xPos-xNext;
        dy = yPos-yNext;
        
        dists = [dists; dx^2+dy^2];
        
        currPos = currPos+step;
    end
    
    meanDist = mean(dists);
    
    MSD = [MSD; meanDist];
    timeVec = [timeVec; step];
end

subplot(1,2,2);
timeVec = timeVec*dt;
loglog(timeVec,MSD);
axis equal





