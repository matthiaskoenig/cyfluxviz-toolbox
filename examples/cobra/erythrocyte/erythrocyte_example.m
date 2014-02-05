function [model, fluxdata] = erythrocyte_example() 
% Simulation of the simple example Network with the COBRA Toolbox

% Select solver (has to be adapted to the used solver)
changeCobraSolver('gurobi5', 'all');

% read SBML model
modelSBML = TranslateSBML('Koenig2013_Erythrocyte.xml');

% set the defaultBounds for the system
defaultBound = 20.0;
[model] = convertSBMLToCobra(modelSBML, defaultBound);
% keep the original SBML identifiers
[model] = addSBMLIdentifiersToCobra(modelSBML, model);

% ! Cobra does some strange renaming of metabolites resulting in nonset
% bounds -> do it manually again.


% alter/set reaction bounds (constraints)
% model = changeRxnBounds(model, rxnNameList, boundValue, boundType)
% u - upper, l - lower, b - both
model.ub(:) = defaultBound;
model.lb(model.rev==1) = -defaultBound;
% set bounds manually for the glucose uptake and pyruvate export
model = changeRxnBounds(model, {'GlcT', 'PyrT'}, [5.0, 1.0], {'u', 'u'});

% model overview 
cobraModelOverview(model)

% exchange reactions have been added automatically

% Storage of the simulations and solutions for visualization
simIds = {};
solutions = {};

% Flux minimization based on Taxicab norm
% 'one'  Minimise the Taxicab Norm using LP.
%                                 min |v|
%                                   s.t. S*v = b
%                                        c'v = f
%                                        lb <= v <= ub
fprintf('-----------------------------------------------------------\n')
fprintf('# max ATP - min Taxicab Norm\n')
fprintf('-----------------------------------------------------------\n')
% set objective function 
% Maximize the ATP prodcution
model = changeObjective(model, {'ATPase', 'PPrPT'}, [1.0, 0.0]);
sol = optimizeCbModel(model, 'max', 'one')
printFluxVector(model, sol.x, true, false)
simIds{1} = '01_max_ATP';
solutions{1} = sol.x;

fprintf('-----------------------------------------------------------\n')
fprintf('# max PrPPS - min Taxicab Norm\n')
fprintf('-----------------------------------------------------------\n')
% set objective function 
% Maximize the ATP prodcution
model = changeObjective(model, {'ATPase', 'PPrPT'}, [0.0, 1.0]);
sol = optimizeCbModel(model, 'max', 'one')
printFluxVector(model, sol.x, true, false)
simIds{2} = '02_max_PRPP';
solutions{2} = sol.x;

fprintf('-----------------------------------------------------------\n')
fprintf('# max PrPPS & ATP\n')
fprintf('-----------------------------------------------------------\n')
% set objective function 
% Maximize the ATP prodcution
model = changeObjective(model, {'ATPase', 'PPrPT'}, [1.0, 5.0]);
sol = optimizeCbModel(model, 'max')
printFluxVector(model, sol.x, true, false)
simIds{3} = '03_max_ATP_PRPP';
solutions{3} = sol.x;


% Generate the  fluxdata for CyFluxViz
fluxdata = cobra2fluxdata(modelSBML.id, model, simIds, solutions);

% Generate the output files
fluxdata2XML(fluxdata, 'erythrocyte_fluxes.xml')
