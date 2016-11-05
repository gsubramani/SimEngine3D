function y = solveBDFo2(func,y0,t0,n,h,o1steps)
ts = (1:n)*h + t0;
y(1,:) = zeros(n,length(y0));
y(1,:) = y0;

for ii = 2:o1steps
    yy = y(ii - 1,:);
    
    for j = 1:10
        [f,g] = func(yy,ts(ii),h);
        delyy = -g\(yy' - y(ii-1,:)' - h*f);
        yy = yy + delyy';
        if(norm(delyy) < 0.01)
            break;
        end
    end
    y(ii,:) = yy;
end

for ii = o1steps + 1:n
    yy = y(ii - 1,:);
    
    for j = 1:10
        [f,g] = funcbdf(yy,ts(ii),h);
        delyy = -g\(yy'...
            -48/25*y(ii-1,:)' +36/25*y(ii-2,:) ...
             - 16/25*y(ii-3,:) +3/25*y(ii-4,:) - 12/25*h*f);
        yy = yy + delyy';
        if(abs(delyy) < 0.001)
            break;
        end
    end
    y(ii,:) = yy;
end

end

function [x, v] = xvnBDF1(a,x_1,v_1,h)
    
    x = x_1 + h*v_1 + h^2*a;
    v = v_1 + h*a;
end

function [x, v] = xvnBDF2(a,x_1,x_2,v_1,v_2,h)
% order 2
    %Cnx2 = 4/3*x_1 - 1/3*x_2 + 8/9*h*v_1 - 2/9*v_2;
    %Cnv2 = 4/3*v_1 - 1/3*v_2;
    %beta_h = 2/3*h;
    x = 4/3*x_1 - 1/3*x_2 + 8/9*h*v_1 - 2/9*v_2 + (2/3*h)^2*a;
    v = 4/3*v_1 - 1/3*v_2 + (2/3*h)*a;
    
end



function [Cnx1,Cnv1,beta_h] = Cxv1(x_1,v_1,h)
% order 1
    Cnv1 = v_1;
    Cnx1 = x_1 + h*v_1;
    beta_h = h;
end

function [Cnx2, Cnv2,beta_h] = Cxvn2(x_1,x_2,v_1,v_2,h)
% order 2
    Cnx2 = 4/3*x_1 - 1/3*x_2 + 8/9*h*v_1 - 2/9*v_2;
    Cnv2 = 4/3*v_1 - 1/3*v_2;
    beta_h = 2/3*h;
end


