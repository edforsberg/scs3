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
            obj.dir = rand*xyRange;
            obj.Dr = Dr;
            obj.Dt = Dt;
            obj.v = v;
            obj.color = color;
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
        
        function newPos = interact(obj, dt, xyRange)
            
            if obj.active
                Wdir = normrnd(0,1)/sqrt(dt);
                dDir = obj.torque + sqrt(2*obj.Dr)*Wdir;
                obj.dir = obj.dir + dDir*dt;
                
                
                obj.dir = rem(obj.dir, 2*pi);
                
                if(obj.xPos < -1)
                    obj.dir = 0;
                end
                if(obj.xPos > xyRange +1 )
                    obj.dir = pi;
                end
                if(obj.yPos < -1)
                    obj.dir = pi/2;
                end
                if(obj.yPos > xyRange+ 1)
                    obj.dir = 3*pi/2;
                end
                
                dx = obj.v*cos(obj.dir);
                dy = obj.v*sin(obj.dir);
                
                obj.xPos = obj.xPos + dx*dt;
                obj.yPos = obj.yPos + dy*dt;
                
                obj.vel = [dx; dy; 0]/norm([dx; dy; 0]);
                newPos = [obj.xPos obj.yPos];
            end
        end
        
        function CalculateTorque(swimmer, otherSwimmers, rc, T0)
            
            Tn = 0;
            vn = swimmer.vel;
            xn = swimmer.xPos;
            yn = swimmer.yPos;
            
            for i = 1:numel(otherSwimmers)                
                
                rni = sqrt((swimmer.xPos-otherSwimmers(i).xPos)^2+(swimmer.yPos-otherSwimmers(i).yPos)^2);
                if(rni < rc && rni ~= 0)
                    si = otherSwimmers(i);
                    rn = [si.xPos-xn si.yPos-yn 0];
                    dT = TorqueEq(vn, rn, -T0);
                    if (otherSwimmers(i).active)
                        Tn = Tn+dT;
                    else
                        Tn = Tn-dT;
                    end
                end
            end
            swimmer.torque = Tn;
        end
        function push(swimmers, rPush)
         
            for i=1:numel(swimmers)
                xPos(i) = swimmers(i).xPos;
                yPos(i) = swimmers(i).yPos;
            end
           
            distMat = dist([xPos;yPos]);
           
            checkMat = distMat < 2*rPush;
            for i = 1:numel(swimmers)
                swimmer = swimmers(i);
                otherSwimmers = swimmers(find(checkMat(i,:)));
                for j = 1:numel(otherSwimmers)
                    rni = sqrt((swimmer.xPos-otherSwimmers(j).xPos)^2+(swimmer.yPos-otherSwimmers(j).yPos)^2);
                    if (rni < rPush && rni ~= 0)
                        pushVec = [swimmer.xPos-otherSwimmers(j).xPos swimmer.yPos-otherSwimmers(j).yPos];
                        pLength = (rPush-rni)/2;
                        pushVec = (pushVec/norm(pushVec))*pLength;
                        swimmer.xPos = swimmer.xPos+pushVec(1);
                        swimmer.yPos = swimmer.yPos+pushVec(2);
                    end
                end
            end         
        end
    end
end
