% generate random test data
%----------------------------

% Id of the SBML model
fluxdata.modelId = 'TestModel_01';

% Ids of the simulations (used to access in CyFluxViz)
fluxdata.simIds = {
    'simulation01'
    'simulation02'
    'simulation03'
};

% Ids of the reactions (identical to SBML reaction ids)
fluxdata.reactionIds = {
    'Reaction_1'
    'Reaction_2'
    'Reaction_3'
};

% Create random simulation data
Ns = length(fluxdata.simIds);
Nv = length(fluxdata.reactionIds);
fluxdata.fluxes = rand(Nv, Ns);

% Write the data XML file
filename = 'TestModel_01_data.xml';
data2XML(fluxdata, filename);
