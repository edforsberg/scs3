function msd = MeanSquareDist(step, xPos, yPos, timeSteps)

dists = [];
currPos = 1;
while(currPos+step <= timeSteps)
    
    xCurr = xPos(currPos);
    xNext = xPos(currPos+step);
    yCurr = yPos(currPos);
    yNext = yPos(currPos+step);
    
    dx = xCurr-xNext;
    dy = yCurr-yNext;
    
    dists = [dists; dx^2+dy^2];
    
    currPos = currPos+step;
end

msd = mean(dists);

end