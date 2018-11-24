clc
clf 

Dt = 0.22;
Dr = 0.16;
v = 0.5;
dt = 0.1;
rangeMax = 100;

timeSteps = 2^16;
plotTraj = false;

pos = [rand*rangeMax, rand*rangeMax];
dir = rand*2*pi;

posVec = zeros(timeSteps:2);

if plotTraj
subplot(2,1,1)
trajPlot = plot(posVec(1), posVec(2)); 
end

for i = 1:timeSteps
    
    posVec(i,:) = pos;
    
    pos(1,1) = (v*cos(dir)+sqrt(2*Dt)*rand)*dt;
    pos(1,2) = (v*sin(dir)+sqrt(2*Dt)*rand)*dt;
    dir = (sqrt(2*Dr)*rand)*dt;
    
%     if plotTraj
%         set(trajPlot, 'XData', posVec(1), 
    
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


timeVec = timeVec*dt;
loglog(timeVec,MSD);





