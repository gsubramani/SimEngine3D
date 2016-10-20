%%simEngine3D testing
simobj = SimEngine3D('pendulum.symed')
q = rand(1,7);
phiF = simobj.computephiF(q)
outq = [];
t = 10;
delt = 0.1;
samples = t/delt;
outq = zeros(length(q),length(samples));
outqdot = zeros(length(q),length(samples));
parfor sample = 1:samples
    t = delt*(sample - 1);
    q = simobj.getq();
    q = simobj.positionAnalysis(q,t);
    qdot = simobj.velocityAnalysis(q,t);
    outq(:,sample) = q;
    outqdot(:,sample) = qdot;
end
%%
ts = (0:samples-1)*delt;
close all;
figure(1)
plot(outq(2,:),outq(3,:))
figure(2)
plot(delt*(0:samples - 1),outqdot(1,:)')
axis equal
%phi_qF = simobj.computephi_qF()
%%
subplot(2,1,1);plot(ts,outq(3,:)')
subplot(2,1,2);plot(ts,outqdot(3,:)')
