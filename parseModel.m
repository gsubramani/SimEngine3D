% Parse adams file
function attributes = parseModel(file_name)
% body 1 is always ground
fid = fopen(file_name);
index = 1;
tline = fgets(fid);
lines = [];
while ischar(tline)
    if(tline(1) == '!')
        tline = fgets(fid);
        continue;
    else
        if(tline(1) == ',')
            nextLineFlag = 0;
        else
            nextLineFlag = 1;
        end
        expression = '[/,=]';
        
        line_items = regexp(tline,expression,'split');
        %line_items = strsplit(tline,'/');
        line_items = strtrim(line_items);
        line_items(strcmp('',line_items)) = [];
        
        tline = fgets(fid);
    end
    if (nextLineFlag == 1)
        lines{index} = line_items;
        index  = index + 1;
        
    else
        lines{index-1} = [lines{index-1} line_items];
    end
    
end
attributes = [];
markerIndex = 0;
partIndex = 0;
jointIndex = 0;
for i = 1:length(lines)
    lineItem = lines{i};
    if(strcmp(lineItem(1),'MARKER'))
        markerIndex = markerIndex + 1;
        attributes.markers(markerIndex).id = str2double(lineItem(2));
        attributes.markers(markerIndex).part = str2double(lineItem(4));
        attributes.markers(markerIndex).ireuler = [0,0,0]';
        attributes.markers(markerIndex).iA = eul2A([0,0,0]');
        attributes.markers(markerIndex).r = [0 0 0]';
        attributes.markers(markerIndex).ip = A2p(eul2A([0,0,0]'));
        attributes.markers(markerIndex).p = A2p(eul2A([0,0,0]'));
        
        if(length(lineItem) <5)
            continue;
        end
        for anItem = 5:length(lineItem)
            if(strcmp(lineItem(anItem),'QP'))
                attributes.markers(markerIndex).r = ...
                    (str2double(strrep(lineItem(anItem + 1 : anItem + 3),'D','')))';
            end
            if(strcmp(lineItem(anItem),'REULER'))
                attributes.markers(markerIndex).ireuler = ...
                    (str2double(strrep(lineItem(anItem + 1 : anItem + 3),'D','')))';
                attributes.markers(markerIndex).iA = eul2A(attributes.markers(markerIndex).ireuler);
                attributes.markers(markerIndex).ip = A2p(attributes.markers(markerIndex).iA);
                attributes.markers(markerIndex).p = A2p(attributes.markers(markerIndex).iA);
                
            end
        end
    end
    if(strcmp(lineItem(1),'PART'))
        partIndex = partIndex + 1;
        attributes.parts(partIndex).id = str2double(lineItem(2));
        attributes.parts(partIndex).m = 0;
        attributes.parts(partIndex).cm = [0 0 0]';
        attributes.parts(partIndex).j = [1 0 0;0 1 0;0 0 1];
        attributes.parts(partIndex).ir = [0 0 0]';
        attributes.parts(partIndex).ground = 0;
        attributes.parts(partIndex).ireuler = [0,0,0]';
        attributes.parts(partIndex).iA = eul2A([0,0,0]');
        attributes.parts(partIndex).r = [0 0 0]';
        attributes.parts(partIndex).rdot = [0 0 0]';
        attributes.parts(partIndex).rdotdot = [0 0 0]';
        
        attributes.parts(partIndex).ip = A2p(eul2A([0,0,0]'));
        attributes.parts(partIndex).p = A2p(eul2A([0,0,0]'));
        attributes.parts(partIndex).pdot =[0 0 0 0]';
        attributes.parts(partIndex).pdotdot = [0 0 0 0]';
        
        
        for anItem = 1:length(lineItem)
            if(strcmp(lineItem(anItem),'MASS'))
                attributes.parts(partIndex).m = str2double(lineItem(anItem + 1));
            end
            if(strcmp(lineItem(anItem),'CM'))
                attributes.parts(partIndex).cm= ...
                    (str2double(strrep(lineItem(anItem + 1 : anItem + 3),'D','')))';
            end
            if(strcmp(lineItem(anItem),'J'))
                attributes.parts(partIndex).j= ...
                    (str2double(strrep(lineItem(anItem + 1 : anItem + 9),'D','')))';
                attributes.parts(partIndex).j...
                    = reshape(attributes.parts(partIndex).j,3,3);
            end
            if(strcmp(lineItem(anItem),'IP'))
                attributes.parts(partIndex).ip = ...
                    (str2double(strrep(lineItem(anItem + 1 : anItem + 3),'D','')))';
                attributes.parts(partIndex).r = attributes.parts(partIndex).ir;
            end
            if(strcmp(lineItem(anItem),'REULER'))
                attributes.parts(partIndex).ireuler = ...
                    (str2double(strrep(lineItem(anItem + 1 : anItem + 3),'D','')))';
                attributes.parts(partIndex).iA ...
                    = eul2A(attributes.parts(partIndex).ireuler);
                attributes.parts(partIndex).ip = A2p(attributes.parts(partIndex).iA);
                attributes.parts(partIndex).p = A2p(attributes.parts(partIndex).iA);
            end
            if(strcmp(lineItem(anItem),'GROUND'))
                attributes.parts(partIndex).ground = 1;
            end
        end
    end
    if(strcmp(lineItem(1),'JOINT'))
        jointIndex = jointIndex + 1;
        attributes.joints(jointIndex).id = str2double(lineItem(2));
        attributes.joints(jointIndex).type = lineItem(3);
        attributes.joints(jointIndex).i = NaN;
        attributes.joints(jointIndex).j = NaN;
        attributes.joints(jointIndex).f = 1;
        attributes.joints(jointIndex).c = [0 0 0]';
        
        for anItem = 1:length(lineItem)
            if(strcmp(lineItem(anItem),'I'))
                attributes.joints(jointIndex).i ...
                    = str2double(lineItem(anItem + 1));
            end
            if(strcmp(lineItem(anItem),'D'))
                attributes.joints(jointIndex).d ...
                    = str2double(lineItem(anItem + 1));
            end
            if(strcmp(lineItem(anItem),'J'))
                attributes.joints(jointIndex).j ...
                    = str2double(lineItem(anItem + 1));
            end
            if(strcmp(lineItem(anItem),'CD'))
                attributes.joints(jointIndex).c ...
                    = str2double(lineItem(anItem + 1:anItem + 3))';
            end
            if(strcmp(lineItem(anItem),'F'))
                attributes.joints(jointIndex).f ...
                    = str2func(char(lineItem(anItem + 1:end)...
                    ));
            end
            %             if(strcmp(lineItem(anItem),'DIJ'))
            %                 attributes.joints(jointIndex).dij ...
            %                     = str2double(lineItem(anItem + 1:anItem + 3))';
            %             end
            
            %if(strcmp(lineItem(anItem),'P'))
            %    attributes.joints(jointIndex).si_ ...
            %        = str2double(lineItem(anItem + 1:anItem + 3))';
            %end
            if(strcmp(lineItem(anItem),'C'))
                attributes.joints(jointIndex).c ...
                    = str2double(lineItem(anItem + 1:anItem + 3))';
                
            end
        end
    end
end
