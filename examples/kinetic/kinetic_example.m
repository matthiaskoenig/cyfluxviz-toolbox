function [modelSBML, fluxdata] = kinetic_example() 
% kinetic_example - Simulation of simple demo kinetic network for visualization.
%   author: Matthias Koenig 
%           Charite Berlin
%           Computational Systems Biochemistry Berlin
%           matthias.koenig@charite.de
%   date:   2013-06-24
clear all; format compact; clc;
fprintf('----------------------------------------\n')
fprintf('\n# Kinetic Simulation on Demo Network #\n')
fprintf('----------------------------------------\n')

% read the SBML model
fname = 'Koenig2013_demo.xml';
modelSBML = TranslateSBML(fname);



% some basic overview of the stoichiometric model
fprintf('\n# Species #\n')
for ks=1:numel(modelSBML.species)
    fprintf('[%i] %s\n', ks, modelSBML.species(ks).id)
end

fprintf('\n# Reactions #\n')
for kr=1:numel(modelSBML.reaction)
    fprintf('[%i] %s\n', kr, modelSBML.reaction(kr).id)
end

% initial concentrations
fprintf('\n# Initial Concentrations #\n')
S0 = [
    0.0  % [mM] [1] A_in
    0.0  % [mM] [2] B_in
    0.0  % [mM] [3] C_in
    10.0 % [mM] [4] A_out
    0.0  % [mM] [5] B_out
    0.0  % [mM] [6] C_out
]
  
% Integration
tspan = 0:1:20; % [sec]
[t,c] = ode15s(@(t,y) demo_dxdt(t, y), tspan , S0, odeset('RelTol', 1e-6));

% Calculate fluxes
[~, vtmp] = demo_dxdt(0, S0);
Nv = numel(vtmp);
Nt = numel(t);
v  = zeros(Nt, Nv);
for kt=1:Nt
    [~, v(kt, :)] = demo_dxdt(t(kt), c(kt, :));
end

% Species and reaction ids
speciesNames = {'A_{in}', 'B_{in}', 'C_{in}', 'A_{out}', 'B_{out}', 'C_{out}'};
speciesIds = {'A_in', 'B_in', 'C_in', 'A_out', 'B_out', 'C_out'};
reactionIds = {'b1', 'b2', 'b3', 'v1', 'v2', 'v3', 'v4'};

% Generate the fluxdata (fluxes & concentrations) for CyFluxViz
fluxdata = kinetic2fluxdata(modelSBML.id, speciesIds, reactionIds, t, c, v);

% Generate the output files
fluxdata2XML(fluxdata, './Koenig2013_demo_Fluxes.xml')

% Plot data 
% demo_figs(t, c, v);


  %% Differential equation system
    function [dydt, v] = demo_dxdt(t, y)
        % Concentrations
        A_in         = y(1);
        B_in         = y(2);
        C_in         = y(3);
        A_out        = y(4);
        B_out        = y(5);
        C_out        = y(6);

        % b1 : A import
        Km_A = 1.0;   % mM
        Vmax_b1 = 5.0;  % mM/s 
        b1 = Vmax_b1/Km_A * (A_out - A_in)/(1 + A_out/Km_A + A_in/Km_A);
        
        % b2 : B export
        Km_B = 0.5;   % mM
        Vmax_b2 = 2.0;  % mM/s 
        b2 = Vmax_b2/Km_B * (B_in - B_out)/(1 + B_out/Km_B + B_in/Km_B);
        
        % b3 : C export
        Km_C = 3.0;   % mM
        Vmax_b3 = 2.0;  % mM/s 
        b3 = Vmax_b3/Km_C * (C_in - C_out)/(1 + C_out/Km_C + C_in/Km_C);
        
        % v1 : C (A_in -> B_in)
        Vmax_v1 = 1.0;  % [mM/s] 
        Keq_v1 = 10.0;  % []
        v1 = Vmax_v1*(A_in - 1/Keq_v1*B_in);
        
        % v2 : C (A_in -> C_in)
        Vmax_v2 = 0.5;  % [1/s] 
        v2 = Vmax_v2*A_in;
        
        % v3 : C (C_in -> A_in)
        Vmax_v3 = 0.1;  % [1/s] 
        v3 = Vmax_v3*C_in;
        
        % v4 : C (C_in -> B_in)
        Vmax_v4 = 0.5;  % [mM/s] 
        Keq_v4 = 2.0;  % []
        v4 = Vmax_v4*(C_in - 1/Keq_v4*B_in);
        
        
        dydt = zeros(size(y));
        %A_in         = y(1);
        dydt(1) = b1 -v1 -v2 +v3;
        %B_in         = y(2);
        dydt(2) = -b2 +v1 +v4;
        %C_in         = y(3);
        dydt(3) = -b3 +v2 -v3 -v4;
        %A_out        = y(4);
        dydt(4) = -b1;
        %B_out        = y(5);
        dydt(5) = +b2;
        %C_out        = y(6);
        dydt(6) = +b3;
        
        % fluxes
        v  = [b1 b2 b3 v1 v2 v3 v4];
    end
    

    %% Visualization routine in Matlab to generate the single images
    function [] = demo_figs(t, c, v)
       % generate single image for every frame
       for i=1:length(t)  
           close all;
           fig1 = figure('Name', 'Koenig2012_demo_kinetic', 'Color', [1 1 1]);
           set(fig1,'Position', [0 0 1100 300])
           % 1100 x 300

           % all concentrations
           for k=1:length(speciesNames)
            subplot(2,7,k)
            plot(t, c(:,k), 'b-'), hold on;
            plot(t(i), c(i,k), 'ro'), hold off;
            title(speciesNames{k}, 'FontWeight', 'bold')
            xlabel('time [sec]', 'FontWeight', 'bold')
            ylabel(sprintf('%s %s', speciesNames{k}, '[mM]'), 'FontWeight', 'bold');
            axis square;
           end
            
           % balance for control
            subplot(2,7,7)
            plot(t, sum(c(:,:),2), 'b-'), hold on;
            plot(t(i), sum(c(i,:)), 'ro'), hold off;
            title('Balance', 'FontWeight', 'bold')
            xlabel('time [sec]', 'FontWeight', 'bold')
            ylabel(sprintf('%s %s', 'Balance', '[mM]'), 'FontWeight', 'bold');
            axis square;
            ylim([0 11])

           for k=1:length(reactionIds)
            subplot(2,7,k+7)
            plot(t, v(:,k), 'b-'), hold on;
            plot(t(i), v(i,k), 'ro'), hold off;
            title(reactionIds{k}, 'FontWeight', 'bold')
            xlabel('time [sec]', 'FontWeight', 'bold')
            ylabel(sprintf('%s %s', reactionIds{k}, '[mM/s]'), 'FontWeight', 'bold');
            axis square;
           end

          set(gcf,'PaperUnits','inches','PaperSize',[11,3],'PaperPosition',[0 0 11 3])
          print('-dpng','-r200',sprintf('./results/demo_kinetic_%03i', i))

        end
    end

end