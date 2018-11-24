clf 

nrSwimmers = 4; 
Dt = 0.22;
Dr = 0.16;
dt = 0.1;
xyRange = 100; 
timeSteps = 2^8;
showPlot = false; 
vMin = 5; 
freezeFrame = 1000; 

posMat = zeros(1, 2*nrSwimmers); 

colors = ['r', 'g', 'b', 'y']; 

swimmers = [];
for i = 1:nrSwimmers 
   
   v = vMin*i/nrSwimmers;
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
            col = colors(swimmer.color);
            scatter(posMat(:,i),posMat(:,nrSwimmers+i),1,col);
            scatter(newPos(1),newPos(2),30,col,'filled');
            axis equal
            xlim([0 rangeMax])
            ylim([0 rangeMax])
            hold on
        end
    end     
     drawnow
     clf
        
    
end

