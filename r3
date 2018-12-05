s=serial('COM4','BAUD', 9600);  % Make sure the baud rate and COM port is the same as in Arduino IDE

fopen(s);

user1 = 0;
user11 = 0;
user12 = 0;
user13 = 0;

JOINT1 = 0;
JOINT2 = 0;
JOINT3 = 0;

RADJOINT1 = 0;
RADJOINT2 = 0;

DEGJOINT3 = 0;

joint1 = 0;
joint2 = 0;
joint3 = 0;

A1 = 168;
A2 = 140 ;

X = 0;
Y = 0;
Z = 0;

x = 308;
y = 0;
z = 0;

steps1 = 0;
steps2 = 0;
steps3 = 0;

mask = 128;

while(user1 ~= 666)
    user1 = input('Enter "1" for DIRECT KINEMATICS, "2" for INVERSE KINEMATICS, "3" for LINEAR INTERPOLATION or "666" to close: ');
    if (user1 == 666)
        if ~isempty(instrfind)
            fclose(instrfind);
            delete(instrfind);
            clear;
        end
        return;
    end
    if (user1 == 1)
        user11 = input('Enter the value for JOINT1(degrees) or "666" to close: ');
        if (user11 == 666)
            if ~isempty(instrfind)
                fclose(instrfind);
                delete(instrfind);
                clear;
            end
            return;
        end
        JOINT1 = user11;
        user11 = input('Enter the value for JOINT2(degrees) or "666" to close: ');
        if (user11 == 666)
            if ~isempty(instrfind)
                fclose(instrfind);
                delete(instrfind);
                clear;
            end
            return;
        end
        JOINT2 = user11;
        user11 = input('Enter the value for JOINT3(milimeters) or "666" to close: ');
        if (user11 == 666)
            if ~isempty(instrfind)
                fclose(instrfind);
                delete(instrfind);
                clear;
            end
            return;
        end
        JOINT3 = user11;
        RADJOINT1 = (JOINT1*2*pi)/360;
        RADJOINT2 = (JOINT2*2*pi)/360;
        x = A1*cos(JOINT1)+A2*cos(JOINT1+JOINT2);
        y = A1*sin(JOINT1)+A2*sin(JOINT1+JOINT2);
        z = z -JOINT3;
        if ((x^2 + y^2 > 308^2)&&(x^2 + y^2 < 168^2)||(y<0)) 
            disp('Destino final fora do volume de trabalho');
            if ~isempty(instrfind)
                fclose(instrfind);
                delete(instrfind);
                clear;
            end
            return;            
        end
        DEGJOINT3 = JOINT3;
        disp(x)
        disp(y)
        disp(z)
        if (JOINT1 < 0)
            JOINT1 = JOINT1*(-1);
            steps = JOINT1;
            steps = round(steps); 
            steps = uint8(steps);
            steps = steps + uint8(mask);
            fwrite(s,steps,'uint8');
        else
            steps = JOINT1;
            steps = round(steps);
            steps = uint8(steps);
            fwrite(s, steps, 'uint8');
        end
        if (JOINT2 < 0)
            JOINT2 = JOINT2*(-1);
            steps = JOINT2;
            steps = round(steps);
            steps = uint8(steps);
            steps = steps + uint8(mask);
            fwrite(s,steps,'uint8');
        else
            steps = JOINT2;
            steps = round(steps);
            steps = uint8(steps);
            fwrite(s, steps, 'uint8');
        end
        if (DEGJOINT3 < 0)
            DEGJOINT3 = DEGJOINT3*(-1);
            steps = DEGJOINT3;
            steps = round(steps);
            steps = uint8(steps);
            steps = steps + uint8(mask);
            fwrite(s,steps,'uint8');
        else
            steps = DEGJOINT3;
            steps = round(steps);
            steps = uint8(steps);
            fwrite(s, steps, 'uint8');
        end
    end
    if (user1 == 2)
        user12 = input('Enter the value for X or "666" to close: ');
        if (user12 == 666)
            if ~isempty(instrfind)
                fclose(instrfind);
                delete(instrfind);
                clear;
            end
            return;
        end
        X = user12;
        user12 = input('Enter the value for Y or "666" to close: ');
        if (user12 == 666)
            if ~isempty(instrfind)
                fclose(instrfind);
                delete(instrfind);
                clear;
            end
            return;
        end
        Y = user12;
        user12 = input('Enter the value for Z or "666" to close: ');
        if (user12 == 666)
            if ~isempty(instrfind)
                fclose(instrfind);
                delete(instrfind);
                clear;
            end
            return;
        end
        Z = user12;
        if ((X^2 + Y^2 > 308^2)&&(X^2 + Y^2 < 168^2)||(Y<0)) 
            disp('Destino final fora do volume de trabalho');
            if ~isempty(instrfind)
                fclose(instrfind);
                delete(instrfind);
                clear;
            end
            return;            
        end
        joint2 = acos((X^2+Y^2-A1^2-A2^2)/2*A1*A2);
        joint1 = atan(y/x)-atan((A2*sin(joint2))/A1+A2*cos(joint2));
        joint3 = -Z;
        joint1 = (joint1*360)/2*pi;
        joint2 = (joint2*360)/2*pi;
        disp(joint1);
        disp(joint2);
        disp(joint3);
        if (joint1 < 0)
            joint1 = joint1*(-1);
            steps = joint1;
            steps = round(steps);
            steps = uint8(steps);
            steps = steps + uint8(mask);
            fwrite(s,steps,'uint8');
        else
            steps = joint1;
            steps = round(steps);
            steps = uint8(steps);
            fwrite(s, steps, 'uint8');
        end
        if (joint2 < 0)
            joint2 = joint2*(-1);
            steps = joint2;
            steps = round(steps);
            steps = uint8(steps);
            steps = steps + uint8(mask);
            fwrite(s,steps,'uint8');
        else
            steps = joint2;
            steps = round(steps);
            steps = uint8(steps);
            fwrite(s, steps, 'uint8');
        end
        if (joint3 < 0)
            joint3 = joint3*(-1);
            steps = joint3;
            steps = round(steps);
            steps = uint8(steps);
            steps = steps + uint8(mask);
            fwrite(s,steps,'uint8');
        else
            steps = joint3;
            steps = round(steps);
            steps = uint8(steps);
            fwrite(s, steps, 'uint8');
        end
    end
    if (user1 == 3)
        user13 = input('Enter the value for X or "666" to close: ');
        if (user13 == 666)
            if ~isempty(instrfind)
                fclose(instrfind);
                delete(instrfind);
                clear;
            end
            return;
        end
        X = user13;
        user13 = input('Enter the value for Y or "666" to close: ');
        if (user13 == 666)
            if ~isempty(instrfind)
                fclose(instrfind);
                delete(instrfind);
                clear;
            end
            return;
        end
        Y = user13;
        user13 = input('Enter the value for Z or "666" to close: ');
        if (user13 == 666)
            if ~isempty(instrfind)
                fclose(instrfind);
                delete(instrfind);
                clear;
            end
            return;
        end
        
        m = (Y - y)/(X - x);
        
        u = ((Y - y)/m) + x % x
        
        v =  m(X - x) + y % y
        
        Z = user13;
        distance = sqrt((x - X)^2 - (y - Y)^2);
        %disp('distancia total = 'distance);
    end
end   
if ~isempty(instrfind)
    fclose(instrfind);
    delete(instrfind);
    clear;
end
