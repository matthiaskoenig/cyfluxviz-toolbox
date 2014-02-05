% Set solver
changeCobraSolver('gurobi5', 'all')

% read SBML model with default bounds
modelSBML = TranslateSBML('Koenig2012_demo.xml');
defaultBound = 10.0;
[model] = convertSBMLToCobra(modelSBML, defaultBound);

% alter/set reaction bounds (constraints)
% model = changeRxnBounds(model, rxnNameList, boundValue, boundType)
% u - upper, l - lower, b - both
model = changeRxnBounds(model, {'b1', 'b2'}, [1.0, 1.0], {'u', 'u'});

% set objective function 
% Maximize the B output
model = changeObjective(model, {'b2'}, [1.0]);

% Add the exchange reactions to the example (otherwise no exchange
% possible -> unbalanced metabolites)
% addExchangeRxn(model,metList,lb,ub) 
ex_mets = {'A_out', 'B_out', 'C_out'};
Nex = numel(ex_mets);
lb_ex = -inf*ones(1,Nex);
ub_ex = inf*ones(1, Nex);
model = addExchangeRxn(model, ex_mets, lb_ex, ub_ex);

% model overview 
cobraModelOverview(model)

% Flux minimization based on Taxicab norm
% 'one'  Minimise the Taxicab Norm using LP.
%                                 min |v|
%                                   s.t. S*v = b
%                                        c'v = f
%                                        lb <= v <= ub

sol = optimizeCbModel(model, 'max', 'one')
printFluxVector(model, sol.x, true, false)

% Generate the output files
simIds{1} = 'FBA_test'
solutions{1} = sol.x;
fluxdata = cobra2fluxdata(modelSBML.id, model, simIds, solutions);
fluxdata2XML(fluxdata, './xml_fluxes/Koenig2012_demo_COBRA_simple.xml')







