function [] = initCyFluxVizToolbox()
%initCyFluxVizToolbox : Initialize scripts to generate CyFluxViz output
%
% Define default solvers and paths
% Function only needs to be called once. Save paths afer script terminates.
%
% In addition add the following into startup.m (generally in MATLAB_DIRECTORY/toolbox/local/startup.m)
%     initCyFluxVizToolbox 

% Matthias Koenig 2013-05-27
clc
fprintf('# Install CyFluxVizToolbox #\n');

%% add main path
pth = which('initCyFluxVizToolbox.m');
dir = pth(1:end-(length('initCyFluxVizToolbox.m')+1));
fprintf('%s\n', dir)
path(path, dir);

% add tools subfolders
dir = strcat(dir, filesep, 'tools');
fprintf('%s\n', dir)
path(path, dir)

% add tools/json subfolder
dir = strcat(dir, filesep, 'jsonlab');
fprintf('%s\n', dir)
path(path, dir)


fprintf('\nSave paths with "savepath".\n');


end
