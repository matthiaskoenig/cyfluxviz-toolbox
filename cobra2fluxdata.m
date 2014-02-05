function [fluxdata] = cobra2fluxdata(modelId, model, solIds, solutions)
%% COBRA2FLUXDATA : Convert the COBRA solutions to fluxdata.
% Function generates the fluxdata struct which is the main format for
% storing CyFluxViz FluxDistributions. The CyFluxViz XML and VAL files 
% can than be generated from the fluxdata.
%
% modelId:  SBML model id found in the <model> tag of the SBML; has to match to the SBML id
% model:    COBRA model with which the simulations were performed
% solIds:   cell array of unique solution ids 
% solutions:cell array of solution vectors from COBRA(sol.x)
%
% @author: Matthias Koenig
% @date: 2013-08-07

% model identifier (necessary to map FluxDistributions to SBML models.
fluxdata.modelId = modelId;

% reaction identifiers (SBML identifier)
% The SBML reaction identifiers should be stored in the COBRA model and 
% should be added via 'addSBMLIdentifiersToCobra' before generating the 
% fluxdata! COBRA uses different identifiers than the original identifiers
% in the SBML which generates problems in the mapping.
if isfield(model, 'rxns_ids')
    fluxdata.reactionIds = model.rxns_ids;
else
   warning('model.rxns identifier are used, which are different from the SBML ids.') 
   fluxdata.reactionIds = model.rxns;
end

% solution identifiers
fluxdata.simIds = solIds;

% generate the flux matrix
Nv = numel(model.rxns);
Ns = numel(solIds);
fluxdata.fluxes = zeros(Nv, Ns);  % [Nv x Ns]
for k=1:Ns
    fluxdata.fluxes(:,k) = solutions{k};          
end

% fluxdata is validated against the standard.
validateFluxdata(fluxdata)