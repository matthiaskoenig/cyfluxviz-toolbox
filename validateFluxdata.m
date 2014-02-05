function [] = validateFluxdata(fluxdata)
%% validateFluxdata : Validate if the fluxdata has the correct form.
% fluxdata is the main data format to store FluxDistributions. In case
% of FBA data it has the following form

%   fluxdata = 
%        modelId: 'Koenig_demo'
%    reactionIds: {10x1 cell}
%         simIds: {'sol_01', 'sol_02'}
%         fluxes: [10x2 double]

% @author: Matthias Koenig
% @date: 2013-08-06
%
% TODO: only tested for FBA FluxDistributions -> additional tests for 
%       kinetic data is necessary.


%% Testing the fluxdata struct.
fba_fields = {'modelId', 'reactionIds', 'simIds', 'fluxes'};

%% Test if struct
if ~isstruct(fluxdata)
   warning('fluxdata has to be a struct with the fields : modelId, reactionIds, simIds, fluxes');
else
    % test if all fba fields exist
    for i=1:length(fba_fields)
        fname = fba_fields{i};
        if ~isfield(fluxdata, fname)
            warning(['field missing in fluxdata: ' fname]); 
        end
    end
end

%% Test modelId
if ~isstr(fluxdata.modelId)
    % must be string
    warning('fluxdata.modelId has to be string');
else
    if length(fluxdata.modelId)==0
        warning('fluxdata.modelId can not be empty string');
    end
    
    % cannot start with number
    string = fluxdata.modelId;
    if isstrprop(string(1),'digit')
       warning(['fluxdata.modelId can not start with numbers: ' fluxdata.modelId]);
    end
end

%% Test data types
if ~iscell(fluxdata.reactionIds)
    warning('fluxdata.reactionIds has to be cell array');
    class(fluxdata.reactionIds)
end
if ~iscell(fluxdata.simIds)
    warning('fluxdata.simIds has to be cell array');
    class(fluxdata.simIds)
end
if ~isnumeric(fluxdata.fluxes)
    warning('fluxdata.reactionIds has to be cell array');
    class(fluxdata.fluxes)
end

%% Test the dimensions of the different fields
if numel(fluxdata.reactionIds) ~= size(fluxdata.fluxes,1)
    warning('The number of elements in fluxdata.reactionIds should be equal to the number of rows in fluxdata.fluxes.');
end
if numel(fluxdata.simIds) ~= size(fluxdata.fluxes,2)
    warning('The number of elements in fluxdata.simIds must equal the number of columns in fluxdata.fluxes');
end

end
