%%simEngine3D_A8P1.m
simobj = SimEngine3D('parallel4DOF.symed');
initq = rand(simobj.nb*7,1);
q = simobj.positionAnalysis(initq,0);