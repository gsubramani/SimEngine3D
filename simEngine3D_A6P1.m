%% simEngine3D_A6P1.m
%%simEngine3D testing
simobj = SimEngine3D('me751.mdl')
q = rand(1,7);
qdot = q;
simobj.t = 0;
simobj.computephiF(q)
simobj.computemuF(q)
simobj.computegammaF(q,qdot)
simobj.computephi_qF(q)

