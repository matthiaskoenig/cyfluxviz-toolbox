function [valideModel] = modelValidation(model);
% Validate the model
valideModel = 1;

% do the necessary fields exist
existFields = [ 
    isfield(model, 'id')
    isfield(model, 'name')
    isfield(model, 'metabolites')
    isfield(model, 'reactions')
    isfield(model, 'S')
    isfield(model, 'boundaryConditions')
    isfield(model, 'reversible')
];
if (any(existFields==0))
   warning('Fields in model missing for SBML generation'); 
   valideModel = 0;
   return;
end

Nv = length(model.reactions);
Nx = length(model.metabolites);

[tmp1, tmp2] = size(model.S);
if (tmp1~=Nx || tmp2~=Nv)
   warning('Stoichiometric matrix has wrong dimensions'); 
   valideModel = 0;
   return;
end
if (length(model.reversible)~=Nv)
   warning('Reversible vector has wrong dimensions'); 
   valideModel = 0;
   return;
end
if (length(model.boundaryConditions)~=Nx)
    warning('BoundaryCondition vector has wrong dimensions'); 
    valideModel = 0;
   return;
end

end