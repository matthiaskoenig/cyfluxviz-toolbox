function [fluxdata] = C13flux2fluxdata(modelId, reactionIds, solIds, fluxes)
% C13flux2fluxdata : Convert the C13 flux solutions to fluxdata.
%
% modelId:      SBML model ID found in the <model> tag of the SBML
% reactionIds:  cell array of reaction Ids in the SBML
% solIds :      cell array of unique solution ids 
% solutions :   double array of solution vectors from COBRA(sol.x)
%
% @author: Matthias Koenig
% @date: 2013-08-07


fluxdata.modelId = modelId;
fluxdata.reactionIds = reactionIds;
fluxdata.simIds = solIds;
fluxdata.fluxes = fluxes;

validateFluxdata(fluxdata)

end 