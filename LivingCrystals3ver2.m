clear all

nrParticles = 200;
fractionActive = 1/10; 
xyRange = 20;
Dr = 0.22;
Dt = 0.0;
v = 2;
dt = 0.1;
rc = 15;
T0 = 5;
rPush = 0.2;
timeSteps = 1000;

particles = [];
F = []; 
for i = 1:nrParticles
    active = rand < fractionActive;
    particles = [particles; Swimmer(Dr, Dt, v, xyRange, 0, active)];
end


xDataS = zeros(nrSwimmers, 1);
yDataS = zeros(nrSwimmers, 1);
xDataP = zeros(nrPasive, 1);
yDataP = zeros(nrPasive, 1);
t = 0;
f = [];


for i = 1:timeSteps
    t = t+1;
    
    for j = 1:nrParticles
        otherSwimmers = swimmers;
        otherSwimmers(j) = [];
        CalculatePasiveTorque(swimmers(j), otherSwimmers, particles, rc, T0);
    end
    
    posMat = [];
    for j = 1:nrParticles
        interact(swimmers(j), dt, xyRange);
        posMat = [posMat [swimmers(j).xPos; swimmers(j).yPos]];
    end
    
    
    distMat = dist(posMat);
    for j = 1:nrParticles
        indices = find(distMat(j,:)<rPush);
        indices = indices(find(indices ~= j));
        if(numel(indices) > 0)
            Push(swimmers(j), swimmers(indices),rPush);
        end
    end
    
    
    for j = 1:nrParticles
        if particles(j).active
            xDataS(j) = swimmers(j).xPos;
            yDataS(j) = swimmers(j).yPos;
        else
            xDataP(j) = particles(j).xPos;
            yDataP(j) = particles(j).yPos;
        end
    end
    
    clf
%     scatter(xDataS, yDataS,60, 'b');
%     hold on
%     scatter(xDataP, yDataP,60, 'r'); 
 viscircles([xDataS yDataS], ones(1, nrSwimmers)*rPush, 'LineWidth', 0.1, 'color','r'); 
 hold on
 viscircles([xDataP yDataP], ones(1, nrPasive)*rPush, 'LineWidth', 0.1, 'color','b'); 
 
    axis([0 xyRange 0 xyRange]);
    legend({sprintf('Dr = 0.05, v = 2,nrSwimmers = 100, T0 = 6, dt = 0.1, t = %d', t)}, 'Location','southwest');
    drawnow
    
end

