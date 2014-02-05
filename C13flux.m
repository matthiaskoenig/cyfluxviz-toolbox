function [fluxdata, sources, targets] = C13flux(modelId, fluxInFile, sbmlOutFile)
%% C13FLUX: Generate the SBML and the CyFluxViz XML files from C13flux data.
% The C13Flux data consists of s, t, flux1, flux2, ... representing the tracer flux
% between the nodes 's' and 't' in the network.
% A SBML file with the modelId is generated and the flux information stored
% in the CyFluxViz XML format.
%
% fluxInFile Example with 2 FluxDistributions
% --------------------------------------------
% Glc_ext,G6P,100,100
% G6P,F6P,72,72
% F6P,FBP,81,81
% FBP,GAP,81,81
% FBP,DHAP,81,28
%
% @author: Matthias Koenig (2013-08-07)


%% Load the flux data (s -> t)
% first column : source node s
% second column : target node t
% column 3, ... : flux data
[fluxes, nodes, ~] = xlsread(fluxInFile);

%% get the source and target nodes of the network
% The identifier have to be cleaned-up to correspond to the SBML standard:
%   * no '-' or ' ' allowed in names, have to be replaced
%   * names can not start with numbers
sources = nodes(:,1);
targets = nodes(:,2);
sources = generateSBMLIds(sources);
targets = generateSBMLIds(targets);
clear nodes

% all missing fluxes are set to zero
fluxes(isnan(fluxes)) = 0.0;

% generate the SBML model from source and target nodes
C13flux2SBML(modelId, sources, targets, sbmlOutFile)

% generate reactionIds from the sources and target names
reactionIds = generateC13ReactionIds(sources, targets);

% generate ids for the various solutions
solIds = cell(size(fluxes,2),1);
for k=1:numel(solIds)
   solIds{k,1} = sprintf('C13_sol_%i', k); 
end

% generate the fluxdata struct
fluxdata = C13flux2fluxdata(modelId, reactionIds, solIds, fluxes);



end
