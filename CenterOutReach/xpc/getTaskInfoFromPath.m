function [taskName, taskVersion] = getTaskInfoFromPath(file)
% infers the task version based on the folder where this file is located
% assumes I live in path ending in /TaskName/vVersionNumber/
    

    if nargin < 1
        stack = dbstack('-completenames');
        file = stack(2).file;
    end

    while(~isempty(file))
        [parent, leaf, ext] = fileparts(file);
        % parent has /task/version/ in it, leaf is file name
        [parent, vstring] = fileparts(parent);
        [~, taskName] = fileparts(parent);
        
        if vstring(1) ~= 'v';
            file = fileparts(file);
            continue;
        else
            taskVersion = str2double(vstring(2:end));
            return;
        end
    end
    
    error('Parent folder must begin with v########');
    
end
