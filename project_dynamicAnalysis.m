% DYNAMIC ANALYSIS FOR PROJECT
simobj = SimEngine3D('parallel4DOFFullLinks.symed');

dd = load('disjointsSoftStart','initq');
initq = dd.initq;
initq = rand(simobj.nb*7,1);
qvec = [];
qdot0 = zeros(simobj.nb*7,1);
h1 = 0.001;
h2 = 0.1;
<<<<<<< Updated upstream
n1 = 10;
n2 = 1;
=======
n1 = 3;
n2 = 100;
>>>>>>> Stashed changes
t0 = 0;
mode = 'quasi';
tic
[x, v, zquasi, t,numitrquasi] = simobj.solveSystemDynamics2(h1,h2,n1,n2,initq,qdot0,t0,mode);
%% 
%for ii = 1:length(t)
<<<<<<< Updated upstream
ii = 10;
=======
ii = 50;
>>>>>>> Stashed changes
simobj.plotBodies(x(:,ii))
    hold off;
    %pause;
    %clf;
    
%end
