function [] = cobraModelOverview(model, printCompounds)
%% COBRAMODELOVERVIEW: Print model overview for the given COBRA model.
% Prints model output for analysis of the model. Helper function for debugging.
%
% @author: Matthias Koenig
% @date: 2013-08-07
format compact
fprintf('-----------------------------------------------------------\n')
formulas = printRxnFormula(model, model.rxns);

Nv = numel(model.rxns);
fprintf('-----------------------------------------------------------\n')
fprintf('REACTIONS [Nv=%i]\n', Nv)
fprintf('%s (%s) %s [%s <-> %s] %s\n', 'rxns', 'f', 'rev', 'lb', 'ub', 'c')
fprintf('-----------------------------------------------------------\n')
for i=1:Nv
    fprintf('%s (%s) %u [%4.1f <-> %4.1f] %4.1f (%s)\n', model.rxns{i}, formulas{i}, model.rev(i), ...
                                model.lb(i), model.ub(i), model.c(i), model.rxnNames{i});
end
fprintf('-----------------------------------------------------------\n')

if (nargin==2 & printCompounds==1)
    Nc = numel(model.mets);
    fprintf('COMPOUNDS [Nc=%i]\n', Nc)
    fprintf('%s %s\n', 'mets', '(metsNames)')
    fprintf('-----------------------------------------------------------\n')
    for i=1:Nc
         fprintf('%s (%s)\n', model.mets{i}, model.metNames{i});
    end
    fprintf('-----------------------------------------------------------\n')
end

end