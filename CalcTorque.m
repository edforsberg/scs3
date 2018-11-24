function Tn = CalcTorque(swimmers,rc) 

n = numel(swimmers); 

distMat = zeros(n); 

for i = 1:n
   
    for j = i+1:n
        
        rni = CalcDist([swimmers(i).xPos swimmers(i).yPos], [swimmers(j).xPos swimmers(j).yPos]); 
        
        if (rni < rc)            
            distMat(i, j) = rni; 
            distMat(j, i) = rni; 
        end
    end    
end


for i = 1:n
    
    Tn = 0; 
    
    for j = 1:numel(distMat(i,:))
        
    
    
    
    
end