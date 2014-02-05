name = 'optimResults2Matthias' 
xmlFileName = strcat(name, 'Fluxes.xml');
dataFileName = strcat(name, '.mat');

load(dataFileName);
res = optimResults;
model = Koenig2012_Hepatocyte_Small();
optimResults2XML(model, res, xmlFileName);