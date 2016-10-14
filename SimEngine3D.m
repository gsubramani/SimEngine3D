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
            
            parti = obj.parts([obj.parts.id] == (markeri.part));
            partj = obj.parts([obj.parts.id] == (markerj.part));
            ri = parti.r;
            rj = partj.r;
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
            sj_ = si_;
            
            if(strcmp(obj.joints(joint_id).type,'DP1'))
                varargout{1} = ai_'*Ai'*Aj*aj_ - f(1);
                %val = vararagout{1};
                if(flag == 1)
                    varargout{2} = -f(2);
                end
                if(flag == 2)
                    varargout{2} = -f(2);
                    varargout{3} = -ai'*getB(pdotj,aj_)*pdotj ...
                        - aj'*getB(pdoti,ai_)*pdoti - 2*getB(pi,ai_)*pdoti*(getB(pj,aj_)*pdotj)' - f(3);
                end
                if(flag == 12)
                    varargout{2} = -f(2);
                    varargout{3} = -ai'*getB(pdotj,aj_)*pdotj ...
                        - aj'*getB(pdoti,ai_)*pdoti - 2*getB(pi,ai_)*pdoti*(getB(pj,aj_)*pdotj)' - f(3);
                    varargout{4} = [-c' -c'*getB(pi,si_) c' c'*getB(pj,sj_)];
                end
                
                if(flag == 11)
                    varargout{2} = -f(2);
                    varargout{3} = [];
                    varargout{4} = [-c' -c'*getB(pi,si_) c' c'*getB(pj,sj_)];
                end
                
                
                
            elseif(strcmp(obj.joints(joint_id).type,'CD'))
                varargout{1} = c'*(rj + Aj*sj_ - ri - Ai*si_) - f(1);
                if(flag == 1)
                    varargout{2} = -c'*(getB(pdotj,sj_)*pj - getB(pdoti,si_)*pi)-f(2);
                end
                if(flag == 2)
                    varargout{2} = -c'*(getB(pdotj,sj_)*pj - getB(pdoti,si_)*pi)-f(2);
                    varargout{3} = c'*getB(pdoti,si_)*pdoti ...
                        - c'*getB(pdoti,ai_)*pdoti - c'*getB(pdotj,sj_)*pdotj - f(3);
                end
                
                if(flag == 12)
                    varargout{2} = -c'*(getB(pdotj,sj_)*pj - getB(pdoti,si_)*pi)-f(2);
                    varargout{3} = [];
                    varargout{4} = [0 aj'*getB(pi,ai_) 0 ai'*getB(pj,aj_)];
                end
                
                if(flag == 22)
                    varargout{2} = -c'*(getB(pdotj,sj_)*pj - getB(pdoti,si_)*pi)-f(2);
                    varargout{3} = c'*getB(pdoti,si_)*pdoti ...
                        - c'*getB(pdoti,ai_)*pdoti - c'*getB(pdotj,sj_)*pdotj - f(3);
                    varargout{4} = [0 aj'*getB(pi,ai_) 0 ai'*getB(pj,aj_)];
                    
                end
                
                
            end
            
        end
    end
end