function [modelCOBRA] = addSBMLIdentifiersToCobra(modelSBML, modelCOBRA)
%FIXCOBRAIDENTIFIER Store the SBML identifier with the COBRA model.
%   COBRA changes the identifiers when reading the model, which
%   makes it impossible to map back to the original SBML and use
%   the SBML for visualization.

% The following transformations are applied !
% rxnsTmp = regexprep(modelSBML.reaction(i).id,'^R_','');
% rxns{i} = cleanUpFormatting(rxnsTmp);
%
% function str = cleanUpFormatting(str)
% str = strrep(str,'-DASH-','-');
% str = strrep(str,'_DASH_','-');
% str = strrep(str,'_FSLASH_','/');
% str = strrep(str,'_BSLASH_','\');
% str = strrep(str,'_LPAREN_','(');
% str = strrep(str,'_LSQBKT_','[');
% str = strrep(str,'_RSQBKT_',']');
% str = strrep(str,'_RPAREN_',')');
% str = strrep(str,'_COMMA_',',');
% str = strrep(str,'_PERIOD_','.');
% str = strrep(str,'_APOS_','''');
% str = regexprep(str,'_e_$','(e)');
% str = regexprep(str,'_e$','(e)');
% str = strrep(str,'&amp;','&');
% str = strrep(str,'&lt;','<');
% str = strrep(str,'&gt;','>');
% str = strrep(str,'&quot;','"');


%% Store the original SBML ids for the visualization
nRxns = length(modelSBML.reaction);
rxns_ids = cell(nRxns,1);
for i = 1:nRxns
   rxns_ids{i} = modelSBML.reaction(i).id;
end

%% Add SBML identifier to the original model structure
modelCOBRA.rxns_ids = rxns_ids;


end

