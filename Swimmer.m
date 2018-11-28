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
        torque = 0;
        active = true;
    end
    
    methods
        function obj = Swimmer(Dr, Dt, v, xyRange, color, active)
            
            obj.xPos = rand*xyRange;
            obj.yPos = rand*xyRange;
            obj.dir = rand*2*pi;
            obj.Dr = Dr;
            obj.Dt = Dt;
            obj.v = v;
            obj.color = color;
            obj.vel = [cos(obj.dir) sin(obj.dir) 0];
            obj.vel = obj.vel/norm(obj.vel);
            obj.active = active;
            
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
        
        function interact(obj, dt, xyRange)
            
            if obj.active
                Wx = normrnd(0,1)/sqrt(dt);
                Wy = normrnd(0,1)/sqrt(dt);
                Wdir = normrnd(0,1)/sqrt(dt);
                
                dDir = obj.torque + sqrt(2*obj.Dr)*Wdir;
                obj.dir = obj.dir + dDir*dt;
                
                obj.dir = rem(obj.dir, 2*pi);
                
                if(obj.xPos < -5)
                    obj.dir = 0;
                end
                if(obj.xPos > xyRange +5 )
                    obj.dir = pi;
                end
                if(obj.yPos < -5)
                    obj.dir = pi/2;
                end
                if(obj.yPos > xyRange- 1)
                    obj.dir = 3*pi/2;
                end
                
                dx = obj.v*cos(obj.dir)+sqrt(2*obj.Dt)*Wx;
                dy = obj.v*sin(obj.dir)+sqrt(2*obj.Dt)*Wy;
                
                obj.xPos = obj.xPos + dx*dt;
                obj.yPos = obj.yPos + dy*dt;
                if obj.active
                    obj.vel = [dx; dy; 0]/norm([dx; dy; 0]);
                end
            end
            
        end
        
        function Tn = CalculateTorque(swimmer, otherSwimmer, rc, T0)
            
            vn = swimmer.vel;
            xn = swimmer.xPos;
            yn = swimmer.yPos;
            Tn = 0;
            for i = 1:numel(otherSwimmer)
                rni = CalcDist([swimmer.xPos swimmer.yPos], [otherSwimmer(i).xPos otherSwimmer(i).yPos]);
                
                if(rni < rc && rni ~= 0)
                    si = otherSwimmer(i);
                    rn = [si.xPos-xn si.yPos-yn 0];
                    dT = TorqueEq(vn, rn, T0);
                    Tn = Tn+dT;
                end
                swimmer.torque = Tn;
            end
            
        end
        
        function CalculatePasiveTorque(swimmer, particles, rc, T0)
            
            otherSwimmers =[]; 
            otherParticles = []; 
            for i = 1:numel(particles) 
                if particles(i).active 
                    otherSwimmers = [otherSwimmers; particles(i)]; 
                else
                    otherParticles = [otherParticles; particle(i)]; 
                end
            end                
            
            swimTq = CalculateTorque(swimmer, otherSwimmers, rc, T0);
            passTq = CalculateTorque(swimmer, otherParticles, rc, T0);
            swimmer.torque = swimTq-passTq;
        end
        
        function pushVec = Push(swimmer, otherSwimmers, rPush)
            
            pushVec = [0;0];
            for i = 1:numel(otherSwimmers)
                veci = [otherSwimmers(i).xPos-swimmer.xPos; otherSwimmers(i).yPos-swimmer.yPos];
                veci = veci/norm(veci); 
               % pushVec = pushVec - veci;
            end
            swimmer.xPos = swimmer.xPos + pushVec(1);
            swimmer.xPos = swimmer.xPos + pushVec(2);
        end
    end
end
