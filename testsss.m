%test%%
zz=z;
[n_tau] = simobj.computeTorques(1,x(:,100),v(:,100),zz(1:simobj.nb*7,100),zz(simobj.nb*7+1:end,100),t(100))

