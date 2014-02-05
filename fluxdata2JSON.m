function [json] = fluxdata2JSON(fluxdata, jsonFilename)
% FLUXDATA2JSON : Save fluxdata in JSON format. 
% Saves the FluxDistribution fluxdata as JSON (JavaScript Object Notation).
% Uses jsonlab (http://iso2mesh.sourceforge.net/cgi-bin/index.cgi?jsonlab)
% to generate the JSON from the Matlab struct.
%
% @author: Matthias Koenig (2013-08-07)
% TODO: adapt the json struct, to avoid zero flux storage (large overhead
%       for sparse FluxDistributions).

% data2json=struct('name','Nexus Prime','rank',9);
% data2json(2)=struct('name','Sentinel Prime','rank',9);
% data2json(3)=struct('name','Optimus Prime','rank',9);
% savejson('Supreme Commander',data2json)
% ans =
% {
% 	"Supreme Commander": [
% 		{
% 			"name": "Nexus Prime",
% 			"rank": 9
% 		},
% 		{
% 			"name": "Sentinel Prime",
% 			"rank": 9
% 		},
% 		{
% 			"name": "Optimus Prime",
% 			"rank": 9
% 		}
% 	]
% }

% write the json file (uses JSON)
json = savejson('', fluxdata);
fid = fopen(jsonFilename,'w');
fprintf(fid, json);
fclose(fid);
fprintf('fluxdata2JSON : JSON file written -> %s\n', jsonFilename);

end