function msd = MeanSquareDist(step, xPos, yPos)

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

msd = mean(dists);

end