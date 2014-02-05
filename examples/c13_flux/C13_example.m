% Script generating the SBML model and the CyFluxViz files
%   @author: Matthias Koenig (2013-08-07)
clear all, format compact

% ModelId for identification and mapping of fluxes to network
modelId = 'C13SampleNetwork';

% input file with network structure and C13 data
fluxInFile = 'sampleFluxes.csv';

% Generate SBML and fluxdata
sbmlOutFile = strcat(modelId, '.xml');
[fluxdata, sources, targets] = C13flux(modelId, fluxInFile, sbmlOutFile);

% generate the CyFluxViz XML file
xmlOutFile = 'C13sampleFluxes.xml';
fluxdata2XML(fluxdata, xmlOutFile);

% generate the CyFluxViz JSON file
jsonOutFile = 'C13sampleFluxes.json';
fluxdata2JSON(fluxdata, jsonOutFile);

% After the files for CyFluxViz have been generated they have to be 
% loaded into Cytoscape.
% 1. Start Cytoscape with CySBML and CyFluxViz installed.
% 2. Load network file -> C13SampleNetwork.xml with CySBML
% 3. Click on CyFluxViz symbol to start the interface and go to import tab
% 4. Select XML import and load the sampleFluxes.xml
% 5. Load layout via the load layout function from the CySBML tab. An
%   example layout exists in 'sampleNetworkLayout.xml'
% 6. Tweek the layout and the visual appearance via the VisualMapper.
% 7. Generate images from the resulting files.


