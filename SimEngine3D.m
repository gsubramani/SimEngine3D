%% SIMENGINE3D
classdef SimEngine3D
    properties
        parts
        markers
        joints
        t
    end
    methods
        function obj = SimEngine3D(file_name)
            attributes = parseModel(file_name);
            obj.parts = attributes.parts;
            obj.markers = attributes.markers';
            obj.joints = attributes.joints';
            obj.t = 0;
            
        end
        %% Returns the value of the specified constraint
        % flag returns which values are required:
        % flag = 0 : just value of the constraint
        % flag = 1 : return mu
        % flag = 2 : return with gamma
        % flag = 11 : with phi_q
        % flag = 12 : with phi_q
        
        function [varargout] = constraint(obj,joint_id,flag)
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
            ddotij = rdotj - rdoti + getB(pj,sj_)*pj - + getB(pi,si_)*pi;
            nb = length(obj.parts);
            %partiald = zeros(1,length(obj.parts)*7);
            
            if(strcmp(obj.joints(joint_id).type,'DP1'))
                varargout{1} = ai_'*Ai'*Aj*aj_ - f(1);
                if(flag == 1)
                    varargout{2} = -f(2);
                end
                if(flag == 2)
                    varargout{2} = -f(2);
                    varargout{3} = -ai'*getB(pdotj,aj_)*pdotj ...
                        - aj'*getB(pdoti,ai_)*pdoti - 2*getB(pi,ai_)*pdoti*(getB(pj,aj_)*pdotj)' + f(3);
                end
                if(flag == 22)
                    varargout{2} = -f(2);
                    varargout{3} = -ai'*getB(pdotj,aj_)*pdotj ...
                        - aj'*getB(pdoti,ai_)*pdoti - 2*getB(pi,ai_)*pdoti*(getB(pj,aj_)*pdotj)' + f(3);
                    varargout{4} = [zeros(1,3) aj'*getB(pi,ai_) ...
                        zeros(1,3) ai'*getB(pj,aj_)];
                    varargout{4} = matresize(varargout{4},ind_i,ind_j,nb);
                    
                end
                
                if(flag == 12)
                    varargout{2} = -f(2);
                    varargout{3} = [];
                    varargout{4} = [zeros(1,3) aj'*getB(pi,ai_) ...
                        zeros(1,3) ai'*getB(pj,aj_)];
                    varargout{4} = matresize(varargout{4},ind_i,ind_j,nb);
                end
                
                
                
            elseif(strcmp(obj.joints(joint_id).type,'CD'))
                varargout{1} = c'*(rj + Aj*sj_ - ri - Ai*si_) - f(1);
                if(flag == 1)
                    varargout{2} = -c'*(getB(pdotj,sj_)*pj - getB(pdoti,si_)*pi)-f(2);
                end
                if(flag == 2)
                    varargout{2} = -c'*(getB(pdotj,sj_)*pj - getB(pdoti,si_)*pi)-f(2);
                    varargout{3} = c'*getB(pdoti,si_)*pdoti ...
                        - c'*getB(pdoti,ai_)*pdoti - c'*getB(pdotj,sj_)*pdotj + f(3);
                end
                
                if(flag == 12)
                    varargout{2} = -c'*(getB(pdotj,sj_)*pj - getB(pdoti,si_)*pi)-f(2);
                    varargout{3} = [];
                    varargout{4} = [-c' -c'*getB(pi,si_) c' c'*getB(pj,sj_)];
                    varargout{4} = matresize(varargout{4},ind_i,ind_j,nb);
                end
                
                if(flag == 22)
                    varargout{2} = -c'*(getB(pdotj,sj_)*pj - getB(pdoti,si_)*pi)-f(2);
                    varargout{3} = c'*getB(pdoti,si_)*pdoti ...
                        - c'*getB(pdoti,ai_)*pdoti - c'*getB(pdotj,sj_)*pdotj + f(3);
                    varargout{4} = [-c' -c'*getB(pi,si_) c' c'*getB(pj,sj_)];
                    varargout{4} = matresize(varargout{4},ind_i,ind_j,nb);
                    
                end
                
                
                
                
            elseif(strcmp(obj.joints(joint_id).type,'DP2'))
                varargout{1} = ai_'*Ai'*dij - f(1);
                if(flag == 1)
                    varargout{2} =  -f(2);
                end
                if(flag == 2)
                    varargout{2} = -f(2);
                    varargout{3} = -ai'*getB(pdotj,sj_)*pdotj ...
                        + ai'*getB(pdoti,si_)*pdoti ...
                        - dij'*getB(poti,ai_)*pdoti - 2*adoti'*ddotij +f(3);
                end
                
                if(flag == 12)
                    varargout{2} = -f(2);
                    varargout{3} = [];
                    varargout{4} = [-ai' dij'*getB(pi,ai_)-ai'*getB(pj,sj_) ...
                        ai' ai'*B(pj,sj_)];
                    varargout{4} = matresize(varargout{4},ind_i,ind_j,nb);
                    
                end
                
                if(flag == 22)
                    varargout{2} = -f(2);
                    varargout{3} = -ai'*getB(pdotj,sj_)*pdotj ...
                        + ai'*getB(pdoti,si_)*pdoti ...
                        - dij'*getB(pdoti,ai_)*pdoti - 2*adoti'*ddotij +f(3);
                    varargout{4} = [-ai' dij'*getB(pi,ai_)-ai'*getB(pj,sj_) ...
                        ai' ai'*getB(pj,sj_)];
                    varargout{4} = matresize(varargout{4},ind_i,ind_j,nb);
                    
                end
                
            elseif(strcmp(obj.joints(joint_id).type,'D'))
                varargout{1} = dij'*dij - f(1);
                if(flag == 1)
                    varargout{2} =  -f(2);
                end
                if(flag == 2)
                    varargout{2} = -f(2);
                    varargout{3} = -2*dij'*getB(pdotj,sj_)*pdotj ...
                        + 2*dij'*getB(pdoti,si_)*pdoti - 2*ddotij'*ddotij + f(3);
                end
                
                if(flag == 12)
                    varargout{2} = -f(2);
                    varargout{3} = [];
                    varargout{4} = [-2*dij' 2*dij'*getB(pj,sj_) 2*dij' ...
                        2*dij'*getB(pj,sj_)];
                    varargout{4} = matresize(varargout{4},ind_i,ind_j,nb);
                    
                end
                
                if(flag == 22)
                    varargout{2} = -f(2);
                    varargout{3} = -2*dij'*getB(pdotj,sj_)*pdotj ...
                        + 2*dij'*getB(pdoti,si_)*pdoti - 2*ddotij'*ddotij +f(3);
                    varargout{4} = [-2*dij' 2*dij'*getB(pj,sj_) 2*dij' ...
                        2*dij'*getB(pj,sj_)];
                    varargout{4} = matresize(varargout{4},ind_i,ind_j,nb);
                    
                end
                
                
                
                
            end
        end
    end
end