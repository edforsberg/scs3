clf

nrSwimmers = 4;
Dt = 0.22;
Dr = 0.16;
dt = 0.1;
xyRange = 100;
timeSteps = 2^16+1;
showPlot = true;
vMin = 2;
freezeFrame = 5;

posMat = zeros(1, 2*nrSwimmers);

colors = ['r', 'g', 'b', 'k'];

swimmers = [];
for i = 1:nrSwimmers
    
    v = vMin*i;
    swimmer = Swimmer(Dr, Dt, v, xyRange, i);
    swimmers = [swimmers; swimmer];
    
end

for t = 1:timeSteps
    
    for i = 1:nrSwimmers
        swimmer = swimmers(i);
        posMat(t,i) = swimmer.xPos;
        posMat(t,nrSwimmers+i) = swimmer.yPos;
        newPos = swimmer.Move(dt);
        
        if (showPlot && t<freezeFrame)
            subplot(1,2,1)
            col = colors(swimmer.color);
            scatter(posMat(:,i),posMat(:,nrSwimmers+i),1,col,'HandleVisibility','off');
            hold on
            scatter(newPos(1),newPos(2),30,col,'filled');
            axis equal
            xlim([0 xyRange])
            ylim([0 xyRange])
            legend({'v=2 \mum/s', 'v=4 \mum/s','v=6 \mum/s','v=8 \mum/s'},'Location','southwest');
            xlabel('x \mum');
            ylabel('y \mum');
        end
    end
    if (t<freezeFrame)
        drawnow 
        if(t<freezeFrame-1)
            clf
        end
    end
    
end


msdMat = []; 

for i = 1:nrSwimmers
    timeVec = []; 
    msdVec = [];
    xPos = posMat(:,i); 
    yPos = posMat(:,nrSwimmers+i); 

for j = 0:log2(timeSteps)    
    step = round(2^j);     
    msdVec(j+1) = MeanSquareDist(step, xPos, yPos, timeSteps);    
    timeVec = [timeVec; step]; 
end

msdMat(:,i) = msdVec';

end

timeVec = timeVec*dt; 

for i = 1:nrSwimmers
    subplot(1,2,2)
    col = colors(swimmers(i).color);
    loglog(timeVec, msdMat(:,i), 'color', col)
    hold on 
    axis equal
    legend({'y = sin(x)','y = cos(x)'},'Location','southeast'); 
    xlabel('log(t)'); 
    ylabel('log(MSD) [\mum^2]'); 
    
end
