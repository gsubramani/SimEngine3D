%%simEngine3D_A6P3.m
simobj = SimEngine3D('revJoint.mdl');
q = rand(1,7);
phiF = simobj.computephiF(q)
outq = [];
t = 10;
delt = 0.001;
samples = t/delt;
outq = zeros(length(q),length(samples));
outqdot = zeros(length(q),length(samples));
outqdotdot = zeros(length(q),length(samples));

parfor sample = 1:samples
    t = delt*(sample - 1);
    q = simobj.getq();
    q = simobj.positionAnalysis(q,t);
    [qdotdot, qdot] = simobj.acclerationAnalysis(q,t);
    outq(:,sample) = q;
    outqdot(:,sample) = qdot;
    outqdotdot(:,sample) = qdotdot;

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
subplot(6,1,1);plot(ts,outq(1:3,:)')
title(['Position - O' char(39)])
legend('x','y','z');
subplot(6,1,2);plot(ts,outqdot(1:3,:)')
title(['Velocity - O' char(39)])
subplot(6,1,3);plot(ts,outqdotdot(1:3,:)')
title(['Acceleration - O' char(39)])

a_ = [-1 0 0]';

outqQ = ones(3,length(samples));
outqQdot = ones(3,length(samples));
outqQdotdot = ones(3,length(samples));

parfor ii = length(outq)
    q = outq(:,ii)';
    qdot = outqdot(:,ii)';
    qdotdot = outqdotdot(:,ii)';
    qQ(:,ii) = q(1:3)' + p2A(q(1:4)')*a_;
    qQdot(:,ii) =qdot(1:3)' + p2A(qdot(1:4)')*a_;
    qQdotdot(:,ii) =qdotdot(1:3)' + p2A(qdotdot(1:4)')*a_;
end



subplot(6,1,4);plot(ts,qQ(1:3,:)')
title(['Position - Q' char(39)])
legend('x','y','z');
subplot(6,1,5);plot(ts,qQdot(1:3,:)')
title(['Velocity - Q' char(39)])
subplot(6,1,6);plot(ts,qQdotdot(1:3,:)')
title(['Acceleration - Q' char(39)])






