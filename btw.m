function [C] = btw(A)

N = length(A);
C = zeros(1,N);
perc = 5:5:100;
percN = round(N*perc/100); pCount = 1;
for nod = 1:N
    if ismember(nod,percN);
        fprintf('%d%%.. ',perc(pCount)); pCount = pCount+1;
    end
    S = [];
    P = cell(1,N);
    sig = zeros(1,N); sig(nod) = 1;
    d = -1*ones(1,N); d(nod) = 0;
    Q = nod;
    while ~isempty(Q)
        v = Q(end); Q(end) = [];% 1 is end of queue, end is front of queue
        S = [v S]; % 1 is top of stack, end is bottom of stack
        neibs = find(A(v,:));
        for neib = 1:length(neibs)
            thisNeib = neibs(neib);
            
            if d(thisNeib) < 0
                Q = [thisNeib, Q]; 
                d(thisNeib) = d(v) + 1;
            end
            
            if d(thisNeib) == d(v) + 1
                sig(thisNeib) = sig(thisNeib) + sig(v);
                thisP = P{thisNeib};
                thisP = [thisP v];
                P{thisNeib} = thisP;
            end
        end
    end
    
    del = zeros(1,N);
    while ~isempty(S)
        w = S(1);
        S(1) = [];
        thisP = P{w}; numP = length(thisP);
        for VInP = 1:numP
            v = thisP(VInP);
            del(v) = del(v) + sig(v)/sig(w)*(1+del(w));
        end
        if w~=nod 
            C(w) = C(w) + del(w);
        end
    end
end

C = C/((N-1)*(N-2));
fprintf('\n');
end