%% SIMENGINE3D
classdef SimEngine3D
    properties
        parts
        markers
        joints
        t
        g
        nb
        nc
    end
    methods
        function obj = SimEngine3D(file_name)
            attributes = parseModel(file_name);
            obj.parts = attributes.parts;
            obj.markers = attributes.markers';
            obj.joints = attributes.joints';
            obj.t = 0;
            obj.g = attributes.g;
            obj.nb = length(obj.parts) - 1;
            obj.nc = length(obj.joints);
        end
        %% Returns the value of the specified constraint
        % flag returns which values are required:
        % flag = 0 : just value of the constraint
        % flag = 1 : return mu
        % flag = 2 : return with gamma
        % flag = 11 : with phi_q
        % flag = 12 : with phi_q
        
        function out = constraint(obj,joint_id,flag)
            ii = obj.joints(joint_id).i;
            jj = obj.joints(joint_id).j;
            
            markeri = obj.markers(ii);
            markerj = obj.markers(jj);
            
            ind_i = markeri.part;
            ind_j = markerj.part;
            
            parti = obj.parts([obj.parts.id] == (markeri.part));
            partj = obj.parts([obj.parts.id] == (markerj.part));
            ri = parti.r;
            rj = partj.r;
            
            rdoti = parti.rdot;
            rdotj = partj.rdot;
            
            ai_ = markeri.r;
            aj_ = markerj.r;
            Ai = p2A(parti.p);
            Aj = p2A(partj.p);
            pi = parti.p;
            pj = partj.p;
            pdoti = parti.pdot;
            pdotj = partj.pdot;
            ai = Ai*ai_;
            aj = Aj*aj_;
            f = obj.joints(joint_id).f(obj.t);
            c = obj.joints(joint_id).c;
            si_ = ai_;
            sj_ = aj_;
            dij = rj + Aj*sj_ - ri - Ai*si_;
            adoti = getB(pi,ai_)*pdoti;
            %adotj = getB(pj,aj_)*pdotj;
            ddotij = rdotj - rdoti + getB(pj,sj_)*pj - getB(pi,si_)*pi;
            nb = length(obj.parts);
            %partiald = zeros(1,length(obj.parts)*7);
            
            if(strcmp(obj.joints(joint_id).type,'DP1'))
                if(flag == 1)
                    out = ai_'*Ai'*Aj*aj_ - f(1);
                    
                elseif(flag == 2)
                    out = -f(2);
                    
                elseif(flag == 3)
                    out = -ai'*getB(pdotj,aj_)*pdotj ...
                        -aj'*getB(pdoti,ai_)*pdoti ...
                        - 2*((getB(pi,ai_)*pdoti)'*(getB(pj,aj_)*pdotj)) - f(3);
                    
                    
                    
                elseif(flag == 4)
                    out = [zeros(1,3) aj'*getB(pi,ai_) ...
                        zeros(1,3) ai'*getB(pj,aj_)];
                    out = matresize(out,ind_i,ind_j,nb);
                else
                    error('Invalid flag');
                end
                
                
                
            elseif(strcmp(obj.joints(joint_id).type,'CD'))
                if (flag == 1)
                    out = c'*(rj + Aj*sj_ - ri - Ai*si_) - f(1);
                    
                elseif(flag == 2)
                    %out = -c'*(getB(pdotj,sj_)*pj - getB(pdoti,si_)*pi)-f(2);
                    out = -f(2);
                    
                elseif(flag == 3)
                    out = c'*getB(pdoti,si_)*pdoti ...
                        - c'*getB(pdoti,ai_)*pdoti - c'*getB(pdotj,sj_)*pdotj - f(3);
                    
                    
                elseif(flag == 4)
                    out = [-c' -c'*getB(pi,si_) c' c'*getB(pj,sj_)];
                    out = matresize(out,ind_i,ind_j,nb);
                    
                else
                    error('Invalid flag');
                end
                
            elseif(strcmp(obj.joints(joint_id).type,'DP2'))
                if(flag == 1)
                    out = ai_'*Ai'*dij - f(1);
                    
                elseif(flag == 2)
                    out =  -f(2);
                    
                elseif(flag == 3)
                    out = -ai'*getB(pdotj,sj_)*pdotj ...
                        + ai'*getB(pdoti,si_)*pdoti ...
                        - dij'*getB(poti,ai_)*pdoti - 2*adoti'*ddotij - f(3);
                    
                    
                elseif(flag == 4)
                    out = [-ai' dij'*getB(pi,ai_)-ai'*getB(pj,sj_) ...
                        ai' ai'*getB(pj,sj_)];
                    out = matresize(out,ind_i,ind_j,nb);
                    
                else
                    error('Invalid flag');
                end
                
                
            elseif(strcmp(obj.joints(joint_id).type,'D'))
                if(flag == 1)
                    out = dij'*dij - f(1);
                    
                elseif(flag == 2)
                    out =  -f(2);
                    
                elseif(flag == 3)
                    out = -2*dij'*getB(pdotj,sj_)*pdotj ...
                        + 2*dij'*getB(pdoti,si_)*pdoti - 2*ddotij'*ddotij - f(3);
                    
                    
                elseif(flag == 4)
                    out = [-2*dij' 2*dij'*getB(pj,sj_) 2*dij' ...
                        2*dij'*getB(pj,sj_)];
                    out = matresize(out,ind_i,ind_j,nb);
                else
                    error('Invalid flag');
                    
                end
            else
                error('Constraint not found')
            end
        end
        function phi_q = computephi_qF(obj,q)
            q = reshape(q,length(q),1);
            obj = obj.setq(q);
            phi_q = zeros(length(obj.joints) ...
                + length(obj.parts) - 1,7*(length(obj.parts) - 1));
            for ii = 1:length(obj.joints)
                phi_q(ii,:) = constraint(obj,ii,4);
            end
            % adding the euler parameterization constraints
            % skipping first body since it is the ground body
            nb = length(obj.parts);
            for ii = 2 : length(obj.parts)
                indexing = (nb-1)*3 + (ii - 1)*4 - 3 : (nb-1)*3 + (ii - 1)*4;
                phi_q(length(obj.joints) + ii - 1,indexing) = q(4:end);
            end
        end
        function muF = computemuF(obj,q)
            q = reshape(q,length(q),1);
            obj = obj.setq(q);
            muF = zeros(length(obj.joints) + length(obj.parts) - 1,1);
            for ii = 1:length(obj.joints)
                muF(ii) = constraint(obj,ii,2);
            end
            % adding the euler parameterization constraints
            % skipping first body since it is the ground body
            for ii = 2 : length(obj.parts)
                muF(length(obj.joints) + ii - 1) = 0;
            end
        end
        function gammaF = computegammaF(obj,q,qdot)
            q = reshape(q,length(q),1);
            qdot = reshape(qdot,length(qdot),1);
            
            obj = obj.setq(q);
            obj = obj.setqdot(qdot);
            gammaF = zeros(length(obj.joints) + length(obj.parts) - 1,1);
            for ii = 1:length(obj.joints)
                gammaF(ii) = constraint(obj,ii,3);
            end
            % adding the euler parameterization constraints
            % skipping first body since it is the ground body
            for ii = 2 : length(obj.parts)
                gammaF(length(obj.joints) + ii - 1) ...
                    = -2*(obj.parts(ii).pdot'*obj.parts(ii).pdot);
            end
        end
        
        function phiF = computephiF(obj,q)
            % This function computes all the kinematics constraints
            % input - a vector of [q t]
            % we need to remove the ground bodies euler parameterization
            % constraint therefore : -1
            q = reshape(q,length(q),1);
            obj = obj.setq(q);
            
            phiF = zeros(length(obj.joints) + length(obj.parts) - 1,1);
            for ii = 1:length(obj.joints)
                phiF(ii) = constraint(obj,ii,1);
            end
            % adding the euler parameterization constraints
            % skipping first body since it is the ground body
            for ii = 2 : length(obj.parts)
                phiF(length(obj.joints) + ii - 1) ...
                    = obj.parts(ii).p'*obj.parts(ii).p - 1;
                
            end
        end

        function q = getq(obj)
            for ii = 2:length(obj.parts)
                q((ii - 1)*3 - 2 : (ii - 1)*3) = obj.parts(ii).r;
                q((length(obj.parts) - 1)*3 + (ii - 1)*4 - 3 ...
                    :(length(obj.parts) - 1)*3 + (ii - 1)*4) = obj.parts(ii).p;
            end
            % force to column vector
            q = reshape(q,length(q),1);
        end
        function obj = setq(obj,q)
            for ii = 2:length(obj.parts)
                obj.parts(ii).r = q((ii - 1)*3 - 2 : (ii - 1)*3);
                obj.parts(ii).p = q((length(obj.parts) - 1)*3 + (ii - 1)*4 - 3 ...
                    :(length(obj.parts) - 1)*3 + (ii - 1)*4);
            end
        end
        function obj = setqdot(obj,qdot)
            for ii = 2:length(obj.parts)
                obj.parts(ii).rdot = qdot((ii - 1)*3 - 2 : (ii - 1)*3);
                obj.parts(ii).pdot = qdot((length(obj.parts) - 1)*3 + (ii - 1)*4 - 3 ...
                    :(length(obj.parts) - 1)*3 + (ii - 1)*4);
            end
        end

        
        function q = positionAnalysis(obj,initq,t)
            obj.t = t;
            initq = reshape(initq,length(initq),1);
            q = fsolve(@(q)obj.computephiF(q),initq);
            
        end
        
        function qdot = velocityAnalysis(obj,q,t)
            obj.t = t;
            q = reshape(q,length(q),1);
            qdot = obj.computephi_qF(q)\obj.computemuF(q);
        end
        function [qdotdot, qdot] = acclerationAnalysis(obj,q,t)
            obj.t = t;
            q = reshape(q,length(q),1);
            phi_qF = obj.computephi_qF(q);
            qdot = phi_qF\obj.computemuF(q);
            qdotdot = phi_qF\obj.computegammaF(q,qdot);
        end
        function M = getM(obj)
            M_diag = zeros(1,(length(obj.parts) - 1)*3);
            for ii = 1:length(obj.parts)-1
                M_diag(3*ii - 2:3*ii) = obj.parts(ii+1).m*ones(1,3);
            end
            M = diag(M_diag);
        end
        function Jp = getJ(obj,q)
            p = q(3*(length(obj.parts) - 1)+ 1 : end);
            Jp = zeros((length(obj.parts) - 1)*4);
            for ii = 1:length(obj.parts)-1
                Gp = getG(p(ii*4 - 3:ii*4));
                Jp(4*ii - 3:4*ii,4*ii - 3:4*ii) = 4*Gp'*obj.parts(ii+1).j*Gp;
            end
        end
        function tau = gettau(obj,q,qdot)
        tau = zeros((length(obj.parts) - 1)*4,1);
        p = q(3*(length(obj.parts) - 1)+ 1 : end);
        pdot = qdot(3*(length(obj.parts) - 1)+ 1 : end);
            for ii = 1:length(obj.parts)-1
                Gpdot = getG(pdot(ii*4 - 3:ii*4));
                tau(4*ii - 3:4*ii) ...
                     = 8*Gpdot'*obj.parts(ii+1).j*Gpdot*pdot(ii*4 - 3:ii*4);
            end
        end
        function F = getF(obj) 
            F = zeros(obj.nb*3,1);
            for ii = 1:obj.nb
                F(3*ii - 2) = obj.parts(ii + 1).m*obj.g;
            end
        end
        function [A, B]  = getEOM(obj,q,qdot)
            M = obj.getM();
            Jp = obj.getJ(q);
            phi_qF = obj.computephi_qF(q);
            phi_rF = phi_qF(1:obj.nc,1:3*obj.nb);
            phi_pF = phi_qF(1:obj.nc,3*obj.nb + 1:end);
            p_pF = phi_qF(length(obj.joints) + 1:end,3*obj.nb + 1:end);
            A = [M               ,zeros(3*obj.nb,4*obj.nb),zeros(3*obj.nb,obj.nb),phi_rF';
                 zeros(4*obj.nb,3*obj.nb),Jp              ,p_pF'                 ,phi_pF';
                 zeros(obj.nb,3*obj.nb)  ,p_pF            ,zeros(obj.nb,obj.nb)  ,zeros(obj.nb,obj.nc);
                 phi_rF                  ,phi_pF          ,zeros(obj.nc,obj.nb)  ,zeros(obj.nc,obj.nc)];
            F = obj.getF();
            tau = obj.gettau(q,qdot);
            gammaF = obj.computegammaF(q,qdot)
            gamma = gammaF(1:obj.nc,1);
            gamma_p = gammaF(obj.nc + 1:end,1);
            
            B = [F;tau;gamma_p;gamma];
        end
        function [reactionForces] = inverseDynamicsAnalysis(obj,q,t)
            q = reshape(q,length(q),1);
            [qdotdot,qdot] = obj.acclerationAnalysis(q,t);
            rdotdot = qdotdot(1:(length(obj.parts)-1)*3);
            pdotdot = qdotdot((length(obj.parts)-1)*3 + 1:end);
            phi_qF = obj.computephi_qF(q);
            M = obj.getM();
            Jp = obj.getJ(q);
            tau = obj.gettau(q,qdot);
            lambdas = -phi_qF'\([M*rdotdot;Jp*pdotdot - tau]);
            reactionForces = (-phi_qF'*diag(lambdas))';
        end
        
    end
end