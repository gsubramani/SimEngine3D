%%simEngine3D_A8P1.m
simobj = SimEngine3D('parallel4DOF.symed');
initq = rand(simobj.nb*7,1);
initq(5*3 - 2:5*3) = [0 0 -10]';
%initq(1:4*3)= [1.0000,-0.0000,-1.0000,0,1.0000,-1.0000,0.0000,-1.0000,-1.0000,...
%    -1.0000,-0.0000,-1.0000];
%bb = load('startVars.mat','q');
%initq = bb.q;
q = simobj.positionAnalysis(initq,0);
%%
 simobj.plotBodies(q)
% simobj.computephiF(q)
% simobj.computephi_qF(initq)
% F = @(initq)[simobj.computephiF(initq)]';
% [x,~,~,~,~,~,jacobian] = lsqnonlin(F,initq,[],[],optimset('MaxIter',0));
% 
% howaboutthis = full(jacobian) - simobj.computephi_qF(initq)
