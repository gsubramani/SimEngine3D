function G = getK(a,b)
G = 2*[a'*b        a'*squ(b);
       squ(a)*b    a*b' + b*a' - a'*b*[1 0 0;0 1 0;0 0 1]];
end