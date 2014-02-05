function [] = cobra2cyNodeAttributes(modelCobra, noaFilename)
% COBRA2CYNODEATTRIBUTES - generates a node attribute file from 
% the additional cobra information which can than be loaded into 
% Cytoscape.
%
% Import node attribute information in Cytoscape
%       File -> Import Attribtute from Table
%       - select the file to import
%       - click 'Show Text File Import Options'
%       - select 'Transfer first line as attribute names'
%       - click 'Import'
% 
% Select the attributes via select attributes in the data panel to see
% the values displayed for the selected network nodes.
%
% Use the attributes to create the subsystems via 'Attribute subnetwork'
% in CyFluxViz.
%
%   Matthias Koenig (2013-08-30)
%   Copyright © Matthias König 2013 All Rights Reserved.

m = modelCobra;
if ~isfield(m, 'rxns_ids')
   error('No SBML reaction ids in COBRA model -> use "addSBMLIdentifiersToCobra"')
end

% write line-by-line
Nr = numel(m.rxns_ids);
fid = fopen(noaFilename, 'wt');
% header
fprintf(fid, '%s\t%s\t%s\n', 'cobra.rxns_ids', 'cobra.rxns', 'cobra.subSystems'); 
for i=1:Nr
    fprintf(fid, '%s\t%s\t%s\n', m.rxns_ids{i}, m.rxns{i}, m.subSystems{i});
end
fclose(fid);
fprintf('Node attribute file generated -> "%s"\n', noaFilename); 

end

