function G = getG(p)
e = p(2:end);
e = reshape(e,length(e),1);
e0 = p(1);
G = [-e squ(e)+e0*eye(3)];
end