function distMat = GetDistMat(swimmers)

n = numel(swimmers);
distMat = zeros(n);

for i =1:n    
    for j = i+1:n   
        distij = CalcDist([swimmers(i).xPos swimmers(i).yPos],[swimmers(j).xPos swimmers(j).yPos]);     
            
            distMat(i,j) = distij;
            distMat(j,i) = distij;      

    end
end


