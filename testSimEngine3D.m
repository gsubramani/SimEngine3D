%%simEngine3D testing
simobj = SimEngine3D('test.mdl')
[val,mu,gamma,phi_q] = simobj.constraint(1,22)
[val,mu,gamma,phi_q] = simobj.constraint(2,22)
[val,mu,gamma,phi_q] = simobj.constraint(3,22)
[val,mu,gamma,phi_q] = simobj.constraint(4,22)
