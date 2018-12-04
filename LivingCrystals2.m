clear all



nrSwimmers = 60;
Dr = 0;
Dt  = 0;
xyRange = 100;
color = 1;
v = 0.3;
dt = 1;
rc = 8;
T0 = 0.8;
timeSteps = 1000;
rPush = 3;
record = true;



swimmers = [];
for i = 1:nrSwimmers
    swimmers = [swimmers; Swimmer(Dr,Dt,v, xyRange, color, true)];
end

for t = 1:timeSteps
    
    for j=1:nrSwimmers
        CalculateTorque(swimmers(j), swimmers([1:j-1, j+1:end]), rc, T0);
    end
    
    for j = 1:nrSwimmers
        interact(swimmers(j), dt, xyRange);
    end
    
    
    push(swimmers, rPush);
    
    
    for j = 1:nrSwimmers
        xPos(j) = swimmers(j).xPos;
        yPos(j) = swimmers(j).yPos;
        xDir(j) = xPos(j)+cos(swimmers(j).dir);
        yDir(j) = yPos(j)+sin(swimmers(j).dir);
    end
    
    clf
    gcf = scatter(xPos, yPos, 60);
    hold on
    plot([xPos;xDir], [yPos;yDir], 'color', 'red');
    legend({sprintf('Dr = %d, Dt = %d, v = 0.3, T0 = %0f, dt = %d, t = %d',...
        Dr, Dt, T0, dt, t)}, 'Location','southwest');
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

