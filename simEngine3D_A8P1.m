%%simEngine3D_A8P1.m
simobj = SimEngine3D('pendulum.symed');
initq = rand(simobj.nb*7,1);
t0 = 0.6675;
t0 = 0;
q = simobj.positionAnalysis(initq,t0);
%%
simobj = SimEngine3D('pendulum.symed');
qvec = [];
qdot0 = zeros(simobj.nb*7,1);
h1 = 0.01;
h2 = 0.01;
n1 = 3;
n2 = 1000;

tic
[x, v, z, t] = simobj.solveSystemDynamics2(h1,h2,n1,n2,q,qdot0,t0);
toc
tic
h1 = 0.01;
h2 = 0.01;
n1 = 1000;
n2 = 3;
[x, v, z, t] = simobj.solveSystemDynamics2(h1,h2,n1,n2,q,qdot0,t0);
toc

tau_vec = zeros(length(x),3);
for ii = 1:length(x)
   tau_vec(ii,:) = simobj.computeTorques(1,x(:,ii),v(:,ii),...
        z(1:simobj.nb*7,ii),z(simobj.nb*7+1:end,ii),t(ii));
end
%%
figure(1)
plot(t,tau_vec(:,3))
xlabel('time')
ylabel('Torque applied on body [Nm]');
ylim([-2000 3000])
xlim([0 10])
grid on;
% figure(2)
% plot(t,x(3,:))
