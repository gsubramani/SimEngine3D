%%simEngine3D_A8P1.m
%simobj = SimEngine3D('pendulumVertical.symed');
simobj = SimEngine3D('pendulum.symed');

initq = rand(simobj.nb*7,1);
q = simobj.positionAnalysis(initq,0);
%q(6) = -1;
%%
simobj = SimEngine3D('pendulum.symed');
qvec = [];
qdot0 = zeros(simobj.nb*7,1);
h1 = 0.0001;
h2 = 0.01;
n1 = 10;
n2 = 1000;
t0 = 0;
mode = 'quasi';
tic
[x, v, zquasi, t,numitrquasi] = simobj.solveSystemDynamics2(h1,h2,n1,n2,q,qdot0,t0,mode);
toc
mode = 'modified';
q0 = x(:,1);
qdot0 = v(:,1);
tic
[x, v, zmodified, t,numitrmodified] = simobj.solveSystemDynamics2(h1,h2,n1,n2,q,qdot0,t0,mode);
toc
mode = 'full';
tic
[x, v, zfull, t,numitrfull] = simobj.solveSystemDynamics2(h1,h2,n1,n2,q,qdot0,t0,mode);
toc

%%
figure(1)
plot(t,numitrquasi,'.r')
hold on;
plot(t,numitrmodified,'-g','LineWidth',10)
hold on;
plot(t,numitrfull,'ob')
hold on;
xlabel('time','FontSize',20)
ylabel('iterations','FontSize',20)
legend('quasi','modified','full')
title('Simple Pendulum Newton Method Iterations','FontSize',25)

figure(2)
subplot(1,2,1);plot(t,zfull([2,3],:) - zmodified([2,3],:))
ylabel('acceleration error','FontSize',20)
legend('ay','xz')
title('MODIFIED','FontSize',25)
subplot(1,2,2);plot(t,zfull([2,3],:) - zquasi([2,3],:))
ylabel('acceleration error','FontSize',20)
legend('ay','xz')
title('QUASI','FontSize',25)

