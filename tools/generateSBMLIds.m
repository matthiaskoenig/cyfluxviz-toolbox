function [ids] = generateSBMLIds(ids)
% generateSBMLIds : Convert ids into SBML compatible ids.

if ~iscell(ids)
   warning('CyFluxVizToolbox:TypeError', 'ids have to be of type cell') 
end

for k=1:numel(ids)
    id = ids{k};
    
    % add x for trailing numbers
    if (isNumber(id(1)))
        warning('CyFluxVizToolbox:C13Id', 'Ids should not start with numbers.') 
        id
        id = strcat('x', id);
    end
    
    % replace whitespaces and '-'
    if numel(strfind(id, '-'))>0
        warning('CyFluxVizToolbox:C13Id', 'Ids should not contain "-"')
        id
        id = strrep(id, '-', '_');
    end
    if numel(strfind(id, ' '))>0
        warning('CyFluxVizToolbox:C13Id', 'Ids should not contain " "')
        id
        id = strrep(id, ' ', '_');
    end    
    ids{k} = id;
end


end