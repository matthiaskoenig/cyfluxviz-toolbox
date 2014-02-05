function [] = optimResults2XML(model, res, xmlFileName)
% Load the optimResults and generate the Flux Distributions

Nv = length(model.reactions);
NG1 = length(res.G1durations);
NG2 = length(res.G2durations);
NS = length(res.Sdurations);
Nsim = NG1 + NG2 + NS;  

% Create the data matrix
vData = [res.G1steadys res.G2steadys res.Ssteadys];

% Create the names
names = {};
counter = 0;
for k=1:NG1
   counter = counter + 1;
   names{ counter } = strcat(getCountStr(counter), '_G1_', num2str(k));
end
for k=1:NG2
   counter = counter + 1;
   names{ counter } = strcat(getCountStr(counter), '_G2_', num2str(k));
end
for k=1:NS
   counter = counter + 1;
   names{ counter } = strcat(getCountStr(counter), '_S_', num2str(k));
end

data.names = names;
data.vData = vData;

% Create the resulting XML file for CyFluxViz
data2XML(model, xmlFileName, data)


    function [countStr] = getCountStr(counter)
       if (counter < 10) 
           countStr = strcat('00', num2str(counter));
       elseif (counter < 100)
           countStr = strcat('0', num2str(counter));
       else
           countStr = num2str(counter);
       end
    end


end
