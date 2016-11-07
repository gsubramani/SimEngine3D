%%simEngine3D_A8P1.m
simobj = SimEngine3D('doublependulumstart.symed');
%simobj = SimEngine3D('pendulum.symed');

initq = rand(simobj.nb*7,1);
q = simobj.positionAnalysis(initq,0);
q(6) = -1;
%%
simobj = SimEngine3D('doublependulum.symed');
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

%%
close all

plot(x(2,:),x(3,:),'r')
hold on;
plot(x(5,:),x(6,:),'g')
hold on;
plot(x(5,1),x(6,1),'*g')
hold on;
plot(x(2,1),x(3,1),'*r')
axis equal;
%%
vel_constraint_eqn = zeros(length(ii),1);
for ii = 1:length(x)
   phiqf =  simobj.computephi_qF(x(:,ii));
  vel_constraint_eqn(ii)  =  norm(phiqf(6:10,:)*v(:,ii));
end
    %%


figure(22)
subplot(2,3,1);
plot(t,x([1,2,3],:));
legend('x','y','z');
xlabel('time');
ylabel('[m]');
xlim([0,10])
title('o1 position');

subplot(2,3,2);
plot(t,v([1,2,3],:));
legend('vx','vy','vz');
xlabel('time');
ylabel('[m/s]');
title('o1 velocity');
xlim([0,10])

subplot(2,3,3);
plot(t,z([1,2,3],:));
legend('zx','zy','zz');
xlabel('time');
ylabel('[m/s]');
title('o1 acceleration');
xlim([0,10])

subplot(2,3,4);
plot(t,x([4:6],:));
legend('x','y','z');
xlabel('time');
ylabel('[m]');
title('o2 position');
xlim([0,10])

subplot(2,3,5);
plot(t,v([4:6],:));
legend('vx','vy','vz');
xlabel('time');
ylabel('[m/s]');
title('o2 velocity');
xlim([0,10])

subplot(2,3,6);
plot(t,z([4:6],:));
legend('zx','zy','zz');
xlabel('time');
ylabel('[m/s]');
title('o2 acceleration');
xlim([0,10])

%%
figure(44)
plot(t,vel_constraint_eqn)
title('Velocity Constraint Violation Norm')
xlabel('time')
ylabel('m/s')
xlim([0,10])