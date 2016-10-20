%% simEngine3D_A6P2.m
simobj = SimEngine3D('revJoint.mdl');
q = rand(1,7);
qdot = q;
simobj.t = 0;
simobj.computephiF(q)
simobj.computemuF(q)
simobj.computegammaF(q,qdot)
simobj.computephi_qF(q)
