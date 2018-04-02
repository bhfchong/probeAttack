function [path] = recurPar(parents,path,thisN,rt)
if thisN ~= rt
    thisPar = parents(thisN);
    path = [thisPar recurPar(parents,path,thisPar,rt)];
end

end