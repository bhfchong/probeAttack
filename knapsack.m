%% Solves an instance of the knapsack problem
function [minBag] = knapsack(ws,vs,W)

N = length(ws);
minBag = zeros(N,W);


minBag(1,:) = vs(1)*(1:W>=ws(1));

for n=2:N
    for w=1:W
        if ws(n) > w
            minBag(n,w) = minBag(n-1,w);
        elseif w == ws(n)
            minBag(n,w) = max(minBag(n-1,w),vs(n));
        else
            minBag(n,w) = max(minBag(n-1,w),minBag(n-1,w-ws(n))+vs(n));
        end
    end
end

end

