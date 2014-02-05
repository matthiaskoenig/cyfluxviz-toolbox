% Load model and write data for reactions and species in XML

% Get the model
model = Koenig2012_Hepatocyte_Small()

% Create the SBML file for the model
% modelFileName = 'test_model_01.xml';
% model2SBML(model, modelFileName);

% Id of the SBML model
fluxdata.modelId = 'TestModel_01';


% Names of the simulations
fluxData.simIds = {
    'simulation01'
    'simulation02'
    'simulation03'
};

fluxData.simIds = {
    'simulation01'
    'simulation02'
    'simulation03'
};


% Ids of the reactions


% Create random simulation data
Ns = length(simData.names);
Nv = length(model.reactions);
simData.vData = rand(Ns, Nv);

% Write the data XML file
dataFileName = 'test_data.xml';
data2XML(model, filename, simData);
