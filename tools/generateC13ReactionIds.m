function [ids] = generateC13ReactionIds(sources, targets)
% generateC13ReactionIds : Function generates the reaction ids from the 
% list of source compounds and target compounds.

Nv = numel(sources);
ids = cell(Nv,1);
for k=1:Nv
    ids{k,1} = sprintf('%s__%s', sources{k}, targets{k});
end

end