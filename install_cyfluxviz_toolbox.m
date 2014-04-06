function [] = install_cyfluxviz_toolbox()
%install_cyfluxviz_toolbox : Sets the necessary paths for the toolbox.
%
% Matthias Koenig 2014-04-05

clear all, clc

fprintf('----------------------------\n');
fprintf('# Install CyFluxVizToolbox #\n');
fprintf('----------------------------\n');
dir = pwd
fprintf('----------------------------\n');

% add main path
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
savepath()
fprintf('----------------------------\n');
end
