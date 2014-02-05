function [sbml_model] = C13flux2SBML(modelId, sources, targets, sbmlFilename)
% C13FLUX2SBML : Generates SBML from source and target nodes.
% Between all source and target nodes a virtual reaction is included.
% SBMLToolbox has to be installed.
%
% @author: Matthias Koenig
% @date: 2013-08-07

sprintf('* Creating C13 SBML file : %s *\n   ...', sbmlFilename)

%% Create SBML MODEL and set the id and name
species = unique([sources; targets]);
reactions = generateC13ReactionIds(sources, targets);
Nx = numel(species);
Nv = numel(reactions);

level = 2;
version = 4;
sbml_model = Model_create(level, version);
sbml_model = Model_setId(sbml_model, modelId);
sbml_model = Model_setName(sbml_model, modelId);

% Everything is in one compartment
c_id = 'cell';
c = Compartment_create(level, version);
c = Compartment_setId(c, c_id);
c = Compartment_setName(c, c_id);
sbml_model = Model_addCompartment(sbml_model, c);

% Create the species
for k=1:Nx
    id = species{k};
    bc = int8(0);
    s = Species_create(level, version);
    s = Species_setId(s, id);
    s = Species_setName(s, id);
    s = Species_setCompartment(s, c_id);
    s = Species_setBoundaryCondition(s, bc); 
    sbml_model = Model_addSpecies(sbml_model, s);
end

% Create the reactions
for k=1:Nv
    rId = reactions{k};
    r = Reaction_create(level, version);
    r = Reaction_setId(r, rId);
    r = Reaction_setName(r, rId);
    reversible = int8(1.0);
    r = Reaction_setReversible(r, reversible);
    
    % Set the subtrate and product for the reaction from the
    % source and target list
    sId = sources{k};
    sRef = SpeciesReference_create(level, version);
    sRef = SpeciesReference_setSpecies(sRef, sId);
    sRef = SpeciesReference_setStoichiometry(sRef, 1.0);
    r = Reaction_addReactant(r, sRef); 
    
    tId = targets{k};
    tRef = SpeciesReference_create(level, version);
    tRef = SpeciesReference_setSpecies(tRef, tId);
    tRef = SpeciesReference_setStoichiometry(tRef, 1.0);
    r = Reaction_addProduct(r, tRef); 

    sbml_model = Model_addReaction(sbml_model, r);
end

% export SBML file
OutputSBML(sbml_model, sbmlFilename);


end 