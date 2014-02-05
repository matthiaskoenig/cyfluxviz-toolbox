function [] = modelOverview(model)
% modelOverview : gives overview over the constraints and objectives for
% the given model

% load the model
if (nargin == 0)
    model = Koenig2012_Hepatocyte_Small();
end

% checkConsistency(model);

% give overview over constraints
[Nc, Nv] = size(model.S);
clc
fprintf('--------------------------------------------------------------------\n');
model
fprintf('--------------------------------------------------------------------\n');
fprintf('Id\tName\trev\tclb\tcub\tobjS\tobjG1\tobjG2\n');
fprintf('--------------------------------------------------------------------\n');
for k = 1:Nv
    fprintf('%d\t%s\t%d\t%5.2f\t%5.2f\t%5.2f\t%5.2f\t%5.2f\n', ...
                k, model.reactions{k}, ...
                model.rev(k), ...
                model.clb(k), ...
                model.cub(k), ...
                model.objS(k), ...
                model.objG1(k), ...
                model.objG2(k));
end
fprintf('--------------------------------------------------------------------\n');
fprintf('Id\tName\t\tfree\n');
fprintf('--------------------------------------------------------------------\n');
for k = 1:Nc
    fprintf('%d\t%s\t\t%d\n', ...
                k, model.metabolites{k}, ...
                model.freeMetabs(k));
end
fprintf('--------------------------------------------------------------------\n');
