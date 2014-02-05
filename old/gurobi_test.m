% Testing if problems can be solved with GUROBI via the provided 
% Matlab interface.

% This example formulates and solves the following simple MIP model:
%  maximize
%        x +   y + 2 z
%  subject to
%        x + 2 y + 3 z <= 4
%        x +   y       >= 1
%  x, y, z binary

% The Gurobi MATLAB interface allows you to set as many Gurobi 
% parameters as you would like. The field names in the parameter 
% structure simply need to match Gurobi parameter names, and 
% the values of the fields should be set to the desired parameter
% value. Please consult the Parameters section of the
% Gurobi Reference Manual for a complete list of all Gurobi parameters.

names = {'x'; 'y'; 'z'};

try
    clear model;
    model.A = sparse([1 2 3; 1 1 0]);
    model.obj = [1 1 2];
    model.rhs = [4; 1];
    model.sense = '<>';
    model.vtype = 'B';
    model.modelsense = 'max';

    clear params;
    params.outputflag = 0;
    params.resultfile = 'mip1.lp';

    result = gurobi(model, params);

    disp(result)

    for v=1:length(names)
        fprintf('%s %d\n', names{v}, result.x(v));
    end

    fprintf('Obj: %e\n', result.objval);

catch gurobiError
    fprintf('Error reported\n');
end