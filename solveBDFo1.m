function y = solveBDFo1(func,y0,t0,n,h)

ts = (1:n)*h + t0;
y(1,:) = zeros(n,length(y0));
y(1,:) = y0;

for ii = 2:o1steps
    yy = y(ii - 1,:);
    
    for j = 1:length(n)
        [f,g] = func(yy,ts(ii),h);
        delyy = -g\(yy' - y(ii-1,:)' - h*f);
        yy = yy + delyy';
        if(norm(delyy) < 0.01)
            break;
        end
    end
    y(ii,:) = yy;
end

end
