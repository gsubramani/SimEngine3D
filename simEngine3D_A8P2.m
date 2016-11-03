%%simEngine3D_A8P1.m
simobj = SimEngine3D('pendulum.symed');
q  = [1:simobj.nb*7]';
[A,B] = simobj.getEOM(q,q)
A\B




% calculating moment of inertias:
% M = 0.05^2*4*7800;
% 
% Ix = 1/12*M*(4^2 + 0.05^2);
% Iy = 1/12*M*(4^2 + 0.05^2);
% Iz = 1/12*M*(2*0.05^2);
% %%
% simobj = SimEngine3D('doublependulum.symed');
% q = rand(1,7);
% outq = [];
% t = 10;
% delt = 0.1;
% samples = t/delt;
% outq = zeros(length(q),length(samples));
% outqdot = zeros(length(q),length(samples));
% outqdotdot = zeros(length(q),length(samples));
% Tre = zeros(samples,4);
% torqpend = zeros(samples,1);
% for sample = 1:samples
%     t = delt*(sample - 1);
%     q = simobj.getq();
%     q = simobj.positionAnalysis(q,t);
%     [qdotdot, qdot] = simobj.acclerationAnalysis(q,t);
%     outq(:,sample) = q;
%     outqdot(:,sample) = qdot;
%     outqdotdot(:,sample) = qdotdot;
%     Fr = simobj.inverseDynamicsAnalysis(q,t);
%     Tre(sample,:) = Fr(6,4:end);
%     magnitude = sqrt(Fr(6,4:end)*Fr(6,4:end)');
%     p = Fr(6,4:end)*1/sqrt(Fr(6,4:end)*Fr(6,4:end)');
%     torqpend(sample) = (p(2)/sqrt(1 - p(1)^2))*magnitude;
% end
% %%
% ts = (0:samples-1)*delt;
% close all;
% figure(1)
% plot(outq(2,:),outq(3,:))
% %%
% figure(2)
% subplot(6,1,1);plot(ts,outq(1:3,:)')
% title(['Position - O' char(39)])
% legend('x','y','z');
% subplot(6,1,2);plot(ts,outqdot(1:3,:)')
% title(['Velocity - O' char(39)])
% subplot(6,1,3);plot(ts,outqdotdot(1:3,:)')
% title(['Acceleration - O' char(39)])
% 
% a_ = [-1 0 0]';
% 
% outqQ = ones(3,length(samples));
% outqQdot = ones(3,length(samples));
% outqQdotdot = ones(3,length(samples));
% 
% for ii = length(outq)
%     q = outq(:,ii)';
%     qdot = outqdot(:,ii)';
%     qdotdot = outqdotdot(:,ii)';
%     qQ(:,ii) = q(1:3)' + p2A(q(1:4)')*a_;
%     qQdot(:,ii) =qdot(1:3)' + p2A(qdot(1:4)')*a_;
%     qQdotdot(:,ii) =qdotdot(1:3)' + p2A(qdotdot(1:4)')*a_;
% end
% 
% 
% 
% subplot(6,1,4);plot(ts,qQ(1:3,:)')
% title(['Position - Q' char(39)])
% legend('x','y','z');
% subplot(6,1,5);plot(ts,qQdot(1:3,:)')
% title(['Velocity - Q' char(39)])
% subplot(6,1,6);plot(ts,qQdotdot(1:3,:)')
% title(['Acceleration - Q' char(39)])
% 
% figure(3)
% plot(ts,torqpend)







