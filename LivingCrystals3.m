clear all



nrSwimmers = 500;
nrActive = 20; 
Dr = 0.1;
Dt  = 0.1;
xyRange = 100;
color = 1;
v = 0.3;
dt = 1;
rc = 8;
T0 = 0.8;
timeSteps = 1000;
rPush = 3;
record = false;

swimmers = [];
for i = 1:nrSwimmers
    swimmers = [swimmers; Swimmer(Dr,Dt,(i < nrActive+1)*v, xyRange, color, true)];    
end

for t = 1:timeSteps
    
    for j=1:nrActive
        CalculateTorque(swimmers(j), swimmers([1:j-1, j+1:end]), rc, T0);
    end
    
    for j = 1:nrActive
        interact(swimmers(j), dt, xyRange);
    end   
    
    push(swimmers, rPush);
    
    
    for j = 1:nrActive
        xPosActive(j) = swimmers(j).xPos;
        yPosActive(j) = swimmers(j).yPos;
        xDirActive(j) = xPosActive(j)+cos(swimmers(j).dir);
        yDirActive(j) = yPosActive(j)+sin(swimmers(j).dir);
    end
    
    for j = nrActive+1:nrSwimmers
        xPosPassive(j) = swimmers(j).xPos;
        yPosPassive(j) = swimmers(j).yPos;
    end
    
    clf
    scatter(xPosActive, yPosActive, 60, 'b');
    hold on
    scatter(xPosPassive, yPosPassive, 60, 'r', 'filled');
    hold on
    plot([xPosActive;xDirActive], [yPosActive;yDirActive], 'color', 'red');
    legend({sprintf('Dr = %g, Dt = %g, v = %g, T0 = %g, dt = %g, t = %g',...
        Dr, Dt,v, T0, dt, t)}, 'Location','southwest');
    axis equal
    xlim([0 xyRange])
    ylim([0 xyRange])
    drawnow
    if record
        F(t) = getframe;
    end    
end

if record
    writerObj = VideoWriter('myVideo.avi');
    writerObj.FrameRate = 10;
    open(writerObj);
    for t=1:length(F)
        frame = F(t) ;
        writeVideo(writerObj, frame);
    end
    close(writerObj);
end

