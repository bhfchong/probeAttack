%% Generates a Barabasi-Albert network with N nodes 

function [A] = makeBA(N)
A = zeros(N);
A(1,2) = 1; A(2,1) = 1;

for n = 3:N
    degs = sum(A(1:n-1,:),2);
    degs = degs/sum(degs);
    conn = rand(1,n-1) < degs';
    A(n,1:n-1) = conn;
    A(1:n-1,n) = conn';
end


end
