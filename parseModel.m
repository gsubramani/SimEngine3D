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
        char(line_items)        
        tline = fgets(fid);
    end
    if (nextLineFlag == 1)
        lines{index} = line_items;
        index  = index + 1;
    else
        lines{index-1} = [lines{index-1} line_items];
    end

end
%
% while ischar(tline)
% tline = fgets(fid);
%     if(tline(1) == '!')
%         continue;
%     else
%         disp(tline)
%     end
%
% end