function [fluxdata] = kinetic2fluxdata(modelId, speciesIds, reactionIds, t, c, v)
%% KINETIC2FLUXDATA : Convert ODE results to fluxdata
% Stores the kinetic ODE results in the fluxdata format. In addition to 
% FBA FluxDistributions also the concentration information for the species
% nodes are stored. 
% A kinetic simulation is a series of FluxDistributions given by the 
% solution time points of the solver.
%
%   @author: Matthias Koenig 2013-08-07

fluxdata.modelId = modelId;

% every single time point handeled as an individual flux/concentration
% distribution
Nt = numel(t);
fluxdata.simIds = cell(Nt, 1);
for k=1:Nt
   fluxdata.simIds{k} = sprintf('%03i_kin_t-%3.1f', k, t(k)); 
end

% generate the flux matrix
fluxdata.reactionIds = reactionIds;
fluxdata.fluxes = v';

validateFluxdata(fluxdata);

% generate the time vector
fluxdata.time = t;

% generate the concentration matrix
fluxdata.speciesIds = speciesIds;
fluxdata.concentrations = c';

