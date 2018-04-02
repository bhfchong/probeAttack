%% Generates a Watts-Strogatz network with N nodes, k initial neighbors on each side, and probability of rewiring b
function [A] = makeWS(N,k,b)

A = zeros(N);
for neib = 1:k
    A = A + diag(ones(N-neib,1),neib)+diag(ones(neib,1),N-neib);
end
A = A + A';

for i=1:N 
    for j=i+1:N
        if A(i,j) == 1 && rand() < b
            idx = find(A(i,:)==0);
            idx(idx==i) = [];
            newNode = randsample(idx,1);
            A(i,newNode) = 1; A(newNode,i) = 1;
            A(i,j) = 0; A(j,i) = 0;
        end
    end
end

end
