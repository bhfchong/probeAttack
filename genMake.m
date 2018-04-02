%% Generates the adjacency matrix for a simple, connected graph with N 
%% nodes and M edges, drawn uniformly from the relevant space
function [A] = genMake(N,M)
A=zeros(N);

if M < N-1
    fprintf('Not enough edges to make a connected graph with %d nodes\n',N);
    A=NaN;
    return;
elseif M > N*(N-1)/2
    fprintf('Too many edges for a graph with %d nodes\n', N);
    A=NaN;
    return;
end

% Generate random spanning tree (D.B. Wilson, 1996)

visited = 1;
lastVisited = 1;
while visited < N
    nextNod = 1+randi(N-1);
    if sum(A(:,nextNod)) == 0 % nextNod has never been visited
        A(lastVisited,nextNod) = 1;
        A(nextNod,lastVisited) = 1;  
        visited = visited+1;
    end
    lastVisited = nextNod;
end



for e=N:M
    added=0;
    while added==0
        nods = randsample(N,2);
        if A(nods(1),nods(2)) == 0
            A(nods(1),nods(2)) = 1;
            A(nods(2),nods(1)) = 1;
            added = 1;
        end
    end
end

end

