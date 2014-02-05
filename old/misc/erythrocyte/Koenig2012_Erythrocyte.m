function [model, solutions] = Koenig2012_Erythrocyte() 
% Simulation of the example Network with COBRA Toolbox & Visualization with
% CyFluxViz
%%
clc
changeCobraSolver('gurobi5', 'all')

% read SBML model with SBML Toolbox
fname = 'Koenig2012_Erythrocyte.xml';
modelSBML = TranslateSBML(fname);

% generate a COBRA model
defaultBound = 10.0;

% convert model to an COBRA model
% !!! Some reactionIds are changed via regexprs in the convert function.
% If this happens change the ids to ids which are not modified by COBRA.
[model] = convertSBMLToCobra(modelSBML, defaultBound);
cobraModelOverview(model)
% !!! Defaultbounds not used !!! Lots of problems with the COBRA SBML
% converter. This is a headache. Especially problems when kinetic laws
% available but no bounds specified. 
% So set the bounds again, this time for real.
for k=1:numel(model.rxns)
    % if reversible set upper and lower bounds
    if model.rev(k)==1
       model.ub(k) = defaultBound;
       model.lb(k) = -defaultBound;
   else
       model.ub(k) = defaultBound;
       model.lb(k) = 0.0;
    end
end
cobraModelOverview(model)

% Add the exchange reactions to the example (otherwise no exchange
% possible -> unbalanced metabolites)

% Not necessary to add exchange reactions becaus automatically detected
%ex_mets = {'Pyr_ext', 'Lac_ext', 'Glc_ext', 'CO2_ext', 'Pi_ext', 'PrPP_ext'}
%Nex = numel(ex_mets);
%lb_ex = -inf*ones(1,Nex);
%ub_ex = inf*ones(1, Nex);
%model = addExchangeRxn(model, ex_mets, lb_ex, ub_ex);

%%
% alter/set reaction bounds (constraints)
% model = changeRxnBounds(model, rxnNameList, boundValue, boundType)
% u - upper, l - lower, b - both
model = changeRxnBounds(model, {'ATPase'}, 1.0, 'u');

% set objective function 
% Maximize ATP
model = changeObjective(model, {'ATPase'}, [1.0]);

% model overview 
cobraModelOverview(model)


% FBA simulations
fprintf('-----------------------------------------------------------\n')
fprintf('# FBA with exchange fluxes - min Taxicab Norm\n')
fprintf('-----------------------------------------------------------\n')
Ns = 10;
simIds = cell(1, Ns);
solutions = cell(1, Ns);
for k=1:Ns
    % Flux minimization based on Taxicab norm
    % 'one'  Minimise the Taxicab Norm using LP.
    %                                 min |v|
    %                                   s.t. S*v = b
    %                                        c'v = f
    %                                        lb <= v <= ub
    
    % stepwise increase the allowed glucose import 
    ub_GlcT = k*0.1;
    model = changeRxnBounds(model, {'GlcT'}, ub_GlcT, 'u');
    
    ub_PPrPT = k*0.1;
    

    sol = optimizeCbModel(model, 'max', 'one')
    %printFluxVector(model, sol_2.x, true, false)
    simIds{k} = sprintf('%02.0f_ATP_production', k);
    solutions{k} = sol.x;
end

% Generate the  fluxdata for CyFluxViz
fluxdata = cobra2fluxdata(modelSBML.id, model, simIds, solutions);

% Generate the output files
fluxdata2XML(fluxdata, './xml_fluxes/Koenig2012_Erythrocyte_COBRA_FD.xml')







