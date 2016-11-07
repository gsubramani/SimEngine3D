%%simEngine3D_A8P1.m
simobj = SimEngine3D('doublependulumstart.symed');
%simobj = SimEngine3D('pendulum.symed');

initq = rand(simobj.nb*7,1);
q = simobj.positionAnalysis(initq,0);
q(6) = -1;
%%
simobj = SimEngine3D('doublependulum.symed');
qvec = [];
qdot0 = zeros(simobj.nb*7,1);
h1 = 0.005;
h2 = 0.05;
n1 = 3;
n2 = 200;
[x, v, z, t] = simobj.solveSystemDynamics2(h1,h2,n1,n2,q,qdot0,0);
%%
close all

plot(x(2,:),x(3,:),'r')
hold on;
plot(x(5,:),x(6,:),'g')
hold on;
plot(x(5,1),x(6,1),'*g')
hold on;
plot(x(2,1),x(3,1),'*r')
axis equal;



