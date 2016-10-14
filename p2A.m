function A = p2A(p)
if(size(p,2) > 1)
    error('Oh my god, p"s size is totally wrong!');
end
A = (p(1)^2 - p(2:end)'*p(2:end))*eye(3) + 2*p(2:end)*(p(2:end))' + 2*p(1)*squ(p(2:end));
end