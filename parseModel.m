% Parse adams file
file_name = 'test.mdl';
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
for i = 1:length(lines)
    lineItem = lines{i};
    if(strcmp(lineItem(1),'MARKER'))
        markerIndex = markerIndex + 1;
        attributes.markers(markerIndex).id = lineItem(2);
        attributes.markers(markerIndex).part = lineItem(4);
        attributes.markers(markerIndex).qp = [0, 0, 0]';
        attributes.markers(markerIndex).reuler = [0, 0, 0]';
        if(length(lineItem) <5)
            continue;
        end
        for anItem = 5:length(lineItem)
            if(strcmp(lineItem(anItem),'QP'))
                attributes.markers(markerIndex).qp = ...
                    (str2double(strrep(lineItem(anItem + 1 : anItem + 3),'D','')))';
            end
            if(strcmp(lineItem(anItem),'REULER'))
                attributes.markers(markerIndex).reuler = ...
                    (str2double(strrep(lineItem(anItem + 1 : anItem + 3),'D','')))';
            end
        end
    end
    if(strcmp(lineItem(1),'PART'))
        partIndex = partIndex + 1;
        attributes.parts(partIndex).id = lineItem(2);
        attributes.parts(partIndex).m = 0;
        attributes.parts(partIndex).cm = [0 0 0]';
        attributes.parts(partIndex).j = [1 0 0;0 1 0;0 0 1];
        attributes.parts(partIndex).ip = [0 0 0]';
        attributes.parts(partIndex).ground = 0;
        for anItem = 1:length(lineItem)
            if(strcmp(lineItem(anItem),'MASS'))
                attributes.parts(partIndex).m = lineItem(anItem + 1);
            end
            if(strcmp(lineItem(anItem),'CM'))
                attributes.parts(partIndex).cm= ...
                    (str2double(strrep(lineItem(anItem + 1 : anItem + 3),'D','')))';
            end
            if(strcmp(lineItem(anItem),'J'))
                attributes.parts(partIndex).j= ...
                    (str2double(strrep(lineItem(anItem + 1 : anItem + 9),'D','')))';
            end
            if(strcmp(lineItem(anItem),'IP'))
                attributes.parts(partIndex).ip = ...
                    (str2double(strrep(lineItem(anItem + 1 : anItem + 3),'D','')))';
            end
            if(strcmp(lineItem(anItem),'GROUND'))
                attributes.parts(partIndex).ground = 1;
            end

        end
    end
    
end
