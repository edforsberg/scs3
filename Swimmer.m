classdef Swimmer < handle
    
    properties
        xPos = 0;
        yPos = 0;
        dir = 0;
        Dr = 0;
        Dt = 0;
        v = 0;
        color = 0;
        vel = [0; 0; 0];
    end
    
    methods
        function obj = Swimmer(Dr, Dt, v, xyRange, color)
            
            obj.xPos = rand*xyRange;
            obj.yPos = rand*xyRange;
            obj.dir = rand*xyRange;
            obj.Dr = Dr;
            obj.Dt = Dt;
            obj.v = v;
            obj.color = color;
            
        end
        
        function newPos = Move(obj,dt)
            
            Wx = normrnd(0,1)/sqrt(dt);
            Wy = normrnd(0,1)/sqrt(dt);
            Wdir = normrnd(0,1)/sqrt(dt);
            
            dx = obj.v*cos(obj.dir)+sqrt(2*obj.Dt)*Wx;
            dy = obj.v*sin(obj.dir)+sqrt(2*obj.Dt)*Wy;
            dDir = sqrt(2*obj.Dr)*Wdir;
            
            obj.xPos = obj.xPos + dx*dt;
            obj.yPos = obj.yPos + dy*dt;
            obj.dir = obj.dir + dDir*dt;
            
            newPos = [obj.xPos obj.yPos];
            obj.vel = [dx; dy; 0]/norm([dx; dy; 0]);
        end
        
        function newPos = interact(swimmer, Tn, dt, xyRange)
            
            Wdir = normrnd(0,1)/sqrt(dt);
            dDir = Tn + sqrt(2*swimmer.Dr)*Wdir;
            swimmer.dir = swimmer.dir + dDir*dt;
            
                     
            swimmer.dir = rem(swimmer.dir, 2*pi);
            
            if(swimmer.xPos < -5)
                swimmer.dir = 0;
            end
            if(swimmer.xPos > xyRange +5 )
                swimmer.dir = pi;
            end
            if(swimmer.yPos < -5)
                swimmer.dir = pi/2;
            end
            if(swimmer.yPos > xyRange- 1)
                swimmer.dir = 3*pi/2;
            end
            
            dx = swimmer.v*cos(swimmer.dir);
            dy = swimmer.v*sin(swimmer.dir);
            
            swimmer.xPos = swimmer.xPos + dx*dt;
            swimmer.yPos = swimmer.yPos + dy*dt;
            
            swimmer.vel = [dx; dy; 0]/norm([dx; dy; 0]);
            newPos = [swimmer.xPos swimmer.yPos];
            
        end
        
        function fixOverlap(swimmer, otherSwimmers)
           
            accVec = [0 0]; 
            for i = 1:numel(otherSwimmers)
                vec = [otherSwimmers(i).xPos-swimmer.xPos otherSwimmers(i).xPos-swimmer.xPos];
                if(sum(vec) ~=0)
                    accVec = accVec + vec;
                end
            end
            swimmer.xPos = swimmer.xPos + accVec(1)/2; 
            swimmer.yPos = swimmer.xPos + accVec(2)/2; 
        end
        
        function Tn = CalculateTorque(swimmer, otherSwimmer, rc, T0)
            
            Tn = 0;
            vn = swimmer.vel;
            xn = swimmer.xPos;
            yn = swimmer.yPos;
            
            for i = 1:numel(otherSwimmer)
                rni = CalcDist([swimmer.xPos swimmer.yPos], [otherSwimmer(i).xPos otherSwimmer(i).yPos]);
                
                if(rni < rc && rni ~= 0)
                    si = otherSwimmer(i);
                    rn = [si.xPos-xn si.yPos-yn 0];
                    dT = TorqueEq(vn, rn, T0);
                    Tn = Tn-dT;
                end
            end
            
            
        end
    end
end
