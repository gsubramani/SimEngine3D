function p = A2p(A)
p = zeros(4,1);

p(1) = sqrt((trace(A) + 1)/4);

if (p(1) == 0)
%     if(a(2,1) + a(1,2) >0)
%         p(4) = 0;
%         p(2) = a(2,1) + a(1,2)
%     end
%     
%     ee(2) = a(3,1) + a(1,3);
%     ee(1) = a(3,2) + a(2,3);
%     
    p(1) = eps;
end
    p(2) = (A(3,2) - A(2,3))/4*p(1);
    p(3) = (A(1,3) - A(3,1))/4*p(1);
    p(4) = (A(2,1) - A(1,2))/4*p(1);
end