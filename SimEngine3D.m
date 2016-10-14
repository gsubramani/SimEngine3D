%% function to return kinematic constraints
classdef SimEngine3D
    properties
        parts
        markers
        joints
    end
    methods
        function obj = SimEngine3D(file_name)
            attributes = parseModel(file_name);
            obj.parts = attributes.parts;
            obj.markers = attributes.markers';
            obj.joints = attributes.joints';
            
        end
        %% Returns the value of the specified constraint
        % flag returns which values are required:
        % flag = 0 : just value of the constraint
        % flag = 1 : return mu
        % flag = 2 : return with gamma
        % flag = 11 : with phi_q
        % flag = 12 : with phi_q
        
        function [val,varargout] = constraint(obj,joint_id,i,j,flag)
            markeri = obj.markers(i);
            markerj = obj.markers(j);
            parti = obj.parts(obj.parts.id == (markersi.part));
            partj = obj.parts(obj.parts.id == (markersj.part));
            ai_ = markeri.ir;
            aj_ = markerj.ir;
            Ai = p2A(parti.p);
            Aj = p2A(partj.p);
            pi = parti.p;
            pj = partj.p;
            pdoti = parti.pdot;
            pdotj = partj.pdot;
            ai = Ai*ai_;
            aj = Aj*aj_;
            f = obj.joints(joint_id).f;
            c = obj.joints(joint_id).c;
            si_ = ai_;
            sj_ = si_;
            
            if(strcmp(obj.joints(joint_id).name,'DP1'))
                val = ai_'*Ai'*Aj*aj_ - f(1);
                if(flag == 1)
                    varargout(1) = -f(2);
                end
                if(flag == 2)
                    varargout(1) = -f(2);
                    varargout(2) = -ai'*B(pdotj,aj_)*pdotj ...
                        - aj'*B(pdoti,ai_)*pdoti - 2*B(pi,ai_)*pdoti*(B(pj,aj_)*pdotj)' + f(2);
                end
                if(flag == 12)
                    varargout(1) = -f(2);
                    varargout(2) = -ai'*B(pdotj,aj_)*pdotj ...
                        - aj'*B(pdoti,ai_)*pdoti - 2*B(pi,ai_)*pdoti*(B(pj,aj_)*pdotj)' + f(2);
                    varargout(3) = [-c' -c'*B(pi,si_) c' c'*B(pj,sj_)];
                end
                
                if(flag == 11)
                    varargout(1) = -f(2);
                    varargout(2) = [];
                    varargout(3) = [-c' -c'*B(pi,si_) c' c'*B(pj,sj_)];
                end
                
                
                
            elseif(strcmp(obj.joints(joint_id).name,'CD'))
                val = c'*(rj + Aj*sj_ - ri - Ai*si_) - f;
                if(flag == 1)
                    varargout(1) = -f(2);
                end
                if(flag == 2)
                    varargout(1) = -f(2);
                    varargout(2) = c'*B(pdoti,si_)*pdoti ...
                        - c'*B(pdoti,ai_)*pdoti - c'B(pdotj,sj_)*pdotj + f(2);
                end
                
                if(flag == 12)
                    varargout(1) = -f(2);
                    varargout(2) = [];
                    varargout(3) = [0 aj'*B(pi,ai_) 0 ai'*B(pj,aj_)];
                end
                
                if(flag == 22)
                    varargout(1) = -f(2);
                    varargout(2) = c'*B(pdoti,si_)*pdoti ...
                        - c'*B(pdoti,ai_)*pdoti - c'B(pdotj,sj_)*pdotj + f(2);
                    varargout(3) = [0 aj'*B(pi,ai_) 0 ai'*B(pj,aj_)];
                    
                end
                
                
            end
            
        end
    end
end