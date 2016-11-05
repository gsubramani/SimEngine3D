syms t;
f = cos(pi/2 + pi/4*cos(2*t))
f_t = diff(f,t)
f_tt = diff(f_t,t)
%%
clear
%%
t = 0.01;
for ii = 1:100
result(ii,:) =   penGen(t*ii);
end

plot(t*[1:100],result)