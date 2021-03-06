% ECOLI_SUBSYSTEM - generates node attribute file from 
% the additional cobra information which than can than be loaded into 
% Cytoscape.
% Especially encodes the COBRA reaction names and the subsystem
% information.
%
%   Matthias Koenig (2013-08-30)
%   Copyright � Matthias K�nig 2013 All Rights Reserved.

% read SBML model
modelSBML = TranslateSBML('ModelD4G.xml');

% convert to COBRA model
[modelCOBRA] = convertSBMLToCobra(modelSBML);

% add original SBML identifiers
[modelCOBRA] = addSBMLIdentifiersToCobra(modelSBML, modelCOBRA);

% generate the node attribute file containing the subsystem information
cobra2cyNodeAttributes(modelCOBRA, 'ModelD4G_COBRA.noa');

