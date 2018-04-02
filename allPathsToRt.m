%% Recursively finds all paths from the root node to a target node. 

function [paths] = allPathsToRt(A,targNod,rt)

if nargin == 2
    rt = 1;
end

paths = {};
path = [];
paths = allPathsRec(A,targNod,paths,rt,path);

end


function [paths] = allPathsRec(A,targNod,paths,thisNod,path)
if thisNod == targNod && ~isempty(path) % found a path to target node, add to list
    %     paths = [paths, {[path,thisNod]}];
    paths = [paths, {path}];
else
    % Check if node has unvisited children
    allChilds = A(thisNod,:);
    allChilds(path) = 0;
    realChilds = find(allChilds);
    for child = realChilds
        paths = allPathsRec(A,targNod,paths,child,[path,thisNod]);
    end
end

end
