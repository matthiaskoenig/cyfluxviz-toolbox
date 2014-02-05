function [sbml_model] = model2SBML(model, filename)
% Takes a model and creates SBML based on SBMLToolbox
% Model is a structure with the following fields
%       model.id
%       model.name
%       model.metabolites [Nc]          - Metabolite ids
%       model.reactions [Nv]            - Reaction ids
%       model.S [Nc x Nv]               - Stoichiometric matrix
%       model.boundaryConditions [Nc]   - Unbalanced
%       model.reversible [Nv]           - Reversibility of reactions

%% Validate the model
if (~modelValidation(model))
    error('Model is not valide -> SBML is not generated');
end

%% Create SBML MODEL and set the id and name
Nx = length(model.metabolites);
Nv = length(model.reactions);

level = 2;
version = 4;
sbml_model = Model_create(level, version);
sbml_model = Model_setId(sbml_model, model.id);
sbml_model = Model_setName(sbml_model, model.name);

% Everything is in one compartment
% TODO: use additional compartment information
c_id = 'cell';
c = Compartment_create(level, version);
c = Compartment_setId(c, c_id);
c = Compartment_setName(c, c_id);
sbml_model = Model_addCompartment(sbml_model, c);

% Create the species
for k=1:Nx
    id = model.metabolites{k};
    bc = int8(model.boundaryConditions(k));
    s = Species_create(level, version);
    s = Species_setId(s, id);
    s = Species_setName(s, id);
    s = Species_setCompartment(s, c_id);
    s = Species_setBoundaryCondition(s, bc); 
    sbml_model = Model_addSpecies(sbml_model, s);
end

% Create the reactions
for kv=1:Nv
    id_v = model.reactions{kv};
    reversible = int8(model.reversible(kv));
    
    r = Reaction_create(level, version);
    r = Reaction_setId(r, id_v);
    r = Reaction_setName(r, id_v);
    r = Reaction_setReversible(r, reversible);
    
    % Set the subtrates and products for the reaction from the
    % stoichiometric matrix
    for kx=1:Nx
       stoichiometry = model.S(kx, kv);
       if (stoichiometry ~= 0.0)
           id_c = model.metabolites{kx};
           sRef = SpeciesReference_create(level, version);
           sRef = SpeciesReference_setSpecies(sRef, id_c);
           sRef = SpeciesReference_setStoichiometry(sRef, abs(stoichiometry));
          if (stoichiometry < 0)
             r = Reaction_addReactant(r, sRef); 
          elseif (stoichiometry > 0)
             r = Reaction_addProduct(r, sRef);
          end
       end
    end
    sbml_model = Model_addReaction(sbml_model, r);
end

% export SBML file
OutputSBML(sbml_model, filename);

