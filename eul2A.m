function A = eul2A(euler)
    Rx2 = [1 0 0;
        0 cos(euler(2)) -sin(euler(2));
        0 sin(euler(2))  cos(euler(2))];
    
    Rz1 = [cos(euler(1)) -sin(euler(1)) 0;
           sin(euler(1)) cos(euler(1))  0;
           0 0 1];
    
    Rz3 = [cos(euler(3)) -sin(euler(3)) 0;
           sin(euler(3)) cos(euler(3))  0;
           0 0 1];  
    A = Rz1*Rx2*Rz3;
end