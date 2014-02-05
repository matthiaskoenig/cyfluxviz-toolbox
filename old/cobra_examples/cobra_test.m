%{
    Simulation of example model from the Cobra database
    http://bigg.ucsd.edu

    author: Matthias Koenig
    contact: matthias.koenig@charite.de
    date: 120905

    Cobra model fields:
    S: [761x1075 double] -> stoichiometric matrix

    rxns: {1075x1 cell} -> reaction names
    rev: [1075x1 double] -> reversibility (0 or 1)
    lb: [1075x1 double]
    ub: [1075x1 double]
    c: [1075x1 double]
    rules: {1075x1 cell}
    grRules: {1075x1 cell}
    subSystems: {1075x1 cell}
    confidenceScores: {1075x1 cell}
    rxnReferences: {1075x1 cell}
    rxnECNumbers: {1075x1 cell}
    rxnNotes: {1075x1 cell}
    rxnNames: {1075x1 cell}

    genes: {904x1 cell}
    rxnGeneMat: [1075x904 double]

    mets: {761x1 cell} -> metabolite names with [e] or [c] addition
        'val-L[e]'
        'xan[c]'
    metNames: {761x1 cell}
    metFormulas: {761x1 cell}
    metChEBIID: {761x1 cell}
    metKeggID: {761x1 cell}
    metPubChemID: {761x1 cell}
    metInchiString: {761x1 cell}
    b: [761x1 double]
%}

tol = 0.00000001;

% initialize the Cobra solver
initCobraToolbox();

% load the initial model
load('testFBAData.mat');


fprintf('\n*** Test basic FBA calculations ***\n\n');
fprintf('\n** Optimal solution\n');


% printFluxVector(test_model, solution1.x, true, true);
% printFluxVector(model, solution.x, true, true);

% Optimization for growth
% Growth is simulated by optimizing the odel for flux through the biomass
% function of the model.
% The reaction to optimize is set using the model c vector.
fprintf('\n** Optimal minimum 1-norm solution **\n');
model = changeObjective(model,{'BiomassEcoli'},1);
solution = optimizeCbModel(model);
f_values = solution.f;

%testing if f values are within range
x = 1;
for i =1:size(f_values)
    if(abs(solution.f-solutionStd.f)>tol)
        x=0;
    end
end
if(x==0)
    disp('Test failed for Optimal minimum 1-norm solution for f values');
else
    disp('Test succeeded for Optimal minimum 1-norm solution for f values');
end

%testing if c*x == f
y = 1;
for i =1:size(f_values)
    if abs(model.c'*solution.x - solution.f)>tol
        y=0;
    end
end
if(y==0)
    disp('Test failed for Optimal minimum 1-norm solution for c*x values');
else
    disp('Test succeeded for Optimal minimum 1-norm solution for c*x values');
end

printFluxVector(model, solution.x, true, false);
return


% ///////////////////////////////////////////////////////////////////////
fprintf('\n** Optimal solution on fructose **\n');
model2 = changeRxnBounds(model, {'EX_glc(e)','EX_fru(e)'}, [0 -9], 'l');
solution2 = optimizeCbModel(model2);
f_values = solution.f;


x = 1;
for i =1:size(f_values)
    if(abs(solution2.f-solution2Std.f)>tol)
        x=0;
    end
end
if(x==0)
    disp('Test failed for Optimal solution on Fructose for f values');
else
    disp('Test succeeded for Optimal solution on Fructose for f values');
end

%testing if c*x == f
y = 1;
for i =1:size(f_values)
    if abs(model2.c'*solution2.x - solution2.f)>tol
        y=0;
    end
end
if(y==0)
    disp('Test failed for Optimal solution on Fructose for c*x values');
else
    disp('Test succeeded for Optimal solution on Fructose for c*x values');
end
printFluxVector(model2, solution2.x, true, true);



% ///////////////////////////////////////////////////////////////////////
fprintf('\n** Optimal anaerobic solution **\n');
model3 = changeRxnBounds(model, 'EX_o2(e)', 0, 'l');
solution3 = optimizeCbModel(model3);
f_values = solution.f;

x = 1;
for i =1:size(f_values)
    if(abs(solution3.f-solution3Std.f)>tol)
        x=0;
    end
end
if(x==0)
    disp('Test failed for Optimal anaerobic solution for f values');
else
    disp('Test succeeded for Optimal anaerobic solution for f values');
end

%testing if c*x == f
y = 1;
for i =1:size(f_values)
    if abs(model3.c'*solution3.x - solution3.f)>tol
        y=0;
    end
end
if(y==0)
    disp('Test failed for Optimal anaerobic solution for c*x values');
else
    disp('Test succeeded for Optimal anaerobic solution for c*x values');
end


% ///////////////////////////////////////////////////////////////////////
fprintf('\n** Optimal ethanol secretion rate solution **\n');
model4 = changeObjective(model, 'EX_etoh(e)',1);
solution4 = optimizeCbModel(model4);
f_values = solution.f;

x = 1;
for i =1:size(f_values)
    if(abs(solution4.f-solution4Std.f)>tol)
        x=0;
    end
end
if(x==0)
    disp('Test failed for Optimal ethanol secretion rate solution for f values');
else
    disp('Test succeeded for Optimal ethanol secretion rate solution for f values');
end

%testing if c*x == f
y = 1;
for i =1:size(f_values)
    if abs(model4.c'*solution4.x - solution4.f)>tol
        y=0;
    end
end
if(y==0)
    disp('Test failed for Optimal ethanol secretion rate solution for c*x values');
else
    disp('Test succeeded for Optimal ethanol secretion rate solution for c*x values');
end

%}