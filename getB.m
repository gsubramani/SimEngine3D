function B = getB(p,a)
B = 2*[(p(1)*eye(3) + squ(p(2:end)))*a... 
    p(2:end)*a' - (p(1)*eye(3) + squ(p(2:end)))*squ(a)];
end