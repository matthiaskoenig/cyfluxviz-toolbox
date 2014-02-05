function [model, fluxdata] = ecoli_example() 
% Visualization of FBA in genome scale E.coli network.
% @author: Matthias Koenig
% @date: 2013-08-06

% Select solver (has to be adapted to the used solver)
changeCobraSolver('gurobi5', 'all');

% read SBML model
modelSBML = TranslateSBML('ModelD4G.xml');

% set the defaultBounds for the system
defaultBound = 20.0;
[modelCOBRA] = convertSBMLToCobra(modelSBML, defaultBound);
% keep the original SBML identifiers
[modelCOBRA] = addSBMLIdentifiersToCobra(modelSBML, modelCOBRA);

% ! Cobra does some strange renaming of metabolites resulting in nonset
% bounds -> do it manually again.
% alter/set reaction bounds (constraints)
% model = changeRxnBounds(model, rxnNameList, boundValue, boundType)
% u - upper, l - lower, b - both
modelCOBRA.ub(:) = defaultBound;
modelCOBRA.lb(modelCOBRA.rev==1) = -defaultBound;

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
model = changeObjective(modelCOBRA, {'Biomass'}, [1.0]);
sol = optimizeCbModel(modelCOBRA, 'max', 'one')
printFluxVector(modelCOBRA, sol.x, true, false)

simIds{1} = '01_Biomass';
solutions{1} = sol.x;

% Generate the  fluxdata for CyFluxViz
fluxdata = cobra2fluxdata(modelSBML.id, modelCOBRA, simIds, solutions);

% Generate the output files
fluxdata2XML(fluxdata, 'ecoli_fluxdata.xml')
