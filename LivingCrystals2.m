clear all

nrSwimmers = 100;
xyRange = 100;
Dr = 0.22;
Dt = 0.0;
v = 2;
dt = 0.1;
rc = 15;
T0 = 5;
rPush = 2.2;
timeSteps = 1000;

swimmers = [];
F = []; 
for i = 1:nrSwimmers
    swimmers = [swimmers; Swimmer(Dr, Dt, v, xyRange, 0)];
end

xData = zeros(nrSwimmers, 1);
yData = zeros(nrSwimmers, 1);
t = 0; 
f = []; 
for i = 1:timeSteps
    t = t+1;
    
    for j = 1:nrSwimmers
        otherSwimmers = swimmers;
        otherSwimmers(j) = [];
        CalculateTorque(swimmers(j), otherSwimmers, rc, T0);
    end
    
    posMat = [];
    for j = 1:nrSwimmers
        interact(swimmers(j), dt, xyRange);
        posMat = [posMat [swimmers(j).xPos; swimmers(j).yPos]];
    end
    
    
    distMat = dist(posMat);
    for j = 1:nrSwimmers
        indices = find(distMat(j,:)<rPush);
        indices = indices(find(indices ~= j));
        if(numel(indices) > 0)            
            Push(swimmers(j), swimmers(indices),rPush);
        end
    end
    
    
    for j = 1:nrSwimmers
        xData(j) = swimmers(j).xPos;
        yData(j) = swimmers(j).yPos;
    end
    
    clf
    figure(1)
    scatter(xData, yData,60);
    axis([0 xyRange 0 xyRange]); 
    legend({sprintf('Dr = 0.05, v = 2,nrSwimmers = 100, T0 = 6, dt = 0.1, t = %d', t)}, 'Location','southwest');
    drawnow
    
    F = [F; getframe]; 
    
    
    
end


writerObj = VideoWriter('myVideo.avi');
  writerObj.FrameRate = 10;
  % set the seconds per image
% open the video writer
open(writerObj);
% write the frames to the video
for i=1:length(F)
    % convert the image to a frame
    frame = F(i) ;    
    writeVideo(writerObj, frame);
end
% close the writer object
close(writerObj);


