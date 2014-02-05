function [model, fluxdata] = demo_example_2() 
% Simulation of the simple example Network with the COBRA Toolbox

changeCobraSolver('gurobi5', 'all')

% read SBML model
modelSBML = TranslateSBML('Koenig2013_demo.xml');

% set the defaultBounds for the system
defaultBound = 10.0;
[model] = convertSBMLToCobra(modelSBML, defaultBound);
% keep the original SBML identifiers
[model] = addSBMLIdentifiersToCobra(modelSBML, model);

% alter/set reaction bounds (constraints)
% model = changeRxnBounds(model, rxnNameList, boundValue, boundType)
% u - upper, l - lower, b - both
model = changeRxnBounds(model, {'b1', 'b2'}, [1.0, 1.0], {'u', 'u'});

% set objective function 
% Maximize the B output
model = changeObjective(model, {'b2'}, [1.0]);
%checkObjective(model)

% model overview 
cobraModelOverview(model)

% Storage of the simulations and solutions for visualization
simIds = {};
solutions = {};

%% FBA calculation
fprintf('-----------------------------------------------------------\n')
fprintf('# FBA without exchange fluxes\n')
fprintf('-----------------------------------------------------------\n')
sol_0 = optimizeCbModel(model, 'max')
printFluxVector(model, sol_0.x, true, false)


% Add the exchange reactions to the example (otherwise no exchange
% possible -> unbalanced metabolites)
% addExchangeRxn(model,metList,lb,ub) 
ex_mets = {'A_out', 'B_out', 'C_out'};
Nex = numel(ex_mets);
lb_ex = -inf*ones(1,Nex);
ub_ex = inf*ones(1, Nex);
model = addExchangeRxn(model, ex_mets, lb_ex, ub_ex);


% Solves LP problems of the form: max/min c'*v
%                                 subject to S*v = b
%                                            lb <= v <= ub
fprintf('-----------------------------------------------------------\n')
fprintf('# FBA with exchange fluxes - normal LP\n')
fprintf('-----------------------------------------------------------\n')
sol_1 = optimizeCbModel(model, 'max')
printFluxVector(model, sol_1.x, true, false)
simIds{1} = '01_B_out_FBA_normal_LP'
solutions{1} = sol_1.x;


% Flux minimization based on Taxicab norm
% 'one'  Minimise the Taxicab Norm using LP.
%                                 min |v|
%                                   s.t. S*v = b
%                                        c'v = f
%                                        lb <= v <= ub
fprintf('-----------------------------------------------------------\n')
fprintf('# FBA with exchange fluxes - min Taxicab Norm\n')
fprintf('-----------------------------------------------------------\n')
sol_2 = optimizeCbModel(model, 'max', 'one')
printFluxVector(model, sol_2.x, true, false)
simIds{2} = '02_B_out_FBA_min_Taxicab'
solutions{2} = sol_2.x;

% > 0    Minimises the Euclidean Norm of internal fluxes.
%                       Typically 1e-6 works well.
%                                 min ||v||
%                                   s.t. S*v = b
%                                        c'v = f
%                                        lb <= v <= ub
fprintf('-----------------------------------------------------------\n')
fprintf('# FBA with exchange fluxes - Min Euclidean Norm of int. fluxes\n')
fprintf('-----------------------------------------------------------\n')
sol_3 = optimizeCbModel(model, 'max', 1e-6)
printFluxVector(model, sol_3.x, true, false)
simIds{3} = '03_B_out_FBA_min_Euclidean';
solutions{3} = sol_3.x;

% Flux variability analysis (FVA)
% FVA calculates the full range of numerical values for each reaction
% flux within a network.
% Determines the minimal and maximal flux values that the reaction within
% the model can carry, while obtaining a specific percentage of optimal
% growth rate.
% [minFlux, maxFlux] = fluxVariability(model, 90)


fprintf('-----------------------------------------------------------\n')
fprintf('# FBA with exchange fluxes (B_out & C_out)- min Taxicab Norm\n')
fprintf('-----------------------------------------------------------\n')
% Change constraints in the model for further solutions
% C_out and B_out should be produced
model = changeObjective(model, {'b2', 'b3'}, [1.0, 1.0]);

sol_4 = optimizeCbModel(model, 'max', 'one')
printFluxVector(model, sol_4.x, true, false)
simIds{4} = '04_B_out_C_out_FBA_min_Taxicab';
solutions{4} = sol_4.x;

solutions

% Generate the  fluxdata for CyFluxViz
fluxdata = cobra2fluxdata(modelSBML.id, model, simIds, solutions);

% Generate the output files
fluxdata2XML(fluxdata, 'demo_fluxes_02.xml')







