%%simEngine3D_A8P1.m
simobj = SimEngine3D('pendulumVertical.symed');
initq = rand(simobj.nb*7,1);
q = simobj.positionAnalysis(initq,0);

%%
simobj = SimEngine3D('pendulum.symed');
qvec = [];
qdot0 = zeros(simobj.nb*7,1);
h1 = 0.001;
h2 = 0.01;
n1 = 10;
n2 = 100;


[x, v, z, t] = simobj.solveSystemDynamics2(h1,h2,n1,n2,q,qdot0,0);




