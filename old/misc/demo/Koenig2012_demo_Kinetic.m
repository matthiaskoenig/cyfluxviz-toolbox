function [model, solutions] = Koenig2012_Demo_Kinetic() 
% Koenig2012_Demo_Kinetic - Simulation of simple demo kinetic network for visualization.
%   author: Matthias Koenig 
%           Charite Berlin
%           Computational Systems Biochemistry Berlin
%           matthias.koenig@charite.de
%   date:   2013-06-02

% read the SBML model
fname = 'Koenig2012_demo.xml';
modelSBML = TranslateSBML(fname);

fprintf('# Species #\n')
fprintf('-----------------------\n')
for k=1:numel(modelSBML.species)
    fprintf('[%i] %s\n', k, modelSBML.species(k).id)
end

fprintf('# Reactions #\n')
fprintf('-----------------------\n')
for k=1:numel(modelSBML.reaction)
    fprintf('[%i] %s\n', k, modelSBML.reaction(k).id)
end


S0 = [
    0.0  % [mM] [1] A_in
    0.0  % [mM] [2] B_in
    0.0  % [mM] [3] C_in
    10.0 % [mM] [4] A_out
    0.0  % [mM] [5] B_out
    0.0  % [mM] [6] C_out
]

    function [dydt, v] = Koenig2012_demo_dxdt(t, y)
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
    
    function [] = Koenig2012_demo_figs(t, c, v)
   
        for i=1:length(t)
        
       close all;
       fig1 = figure('Name', 'Koenig2012_demo_kinetic', 'Color', [1 1 1]);
       set(fig1,'Position', [0 0 1100 300])
       % 1100 x 300
   
       for k=1:length(cnames)
        subplot(2,7,k)
        plot(t, c(:,k), 'b-'), hold on;
        plot(t(i), c(i,k), 'ro'), hold off;
        title(cnames{k}, 'FontWeight', 'bold')
        xlabel('time [sec]', 'FontWeight', 'bold')
        ylabel(sprintf('%s %s', cnames{k}, '[mM]'), 'FontWeight', 'bold');
        axis square;
       end
       
       for k=1:length(vnames)
        subplot(2,7,k+7)
        plot(t, v(:,k), 'b-'), hold on;
        plot(t(i), v(i,k), 'ro'), hold off;
        title(vnames{k}, 'FontWeight', 'bold')
        xlabel('time [sec]', 'FontWeight', 'bold')
        ylabel(sprintf('%s %s', vnames{k}, '[mM/s]'), 'FontWeight', 'bold');
        axis square;
       end
       
      set(gcf,'PaperUnits','inches','PaperSize',[11,3],'PaperPosition',[0 0 11 3])
      print('-dpng','-r200',sprintf('./xml_fluxes/test_%03i', i))
       
        end
    end

% Integration
tspan = [0:1:20]; % [sec]
[t,c] = ode15s(@(t,y) Koenig2012_demo_dxdt(t, y), tspan , S0, odeset('RelTol', 1e-6));

% Calculate fluxes
[~, vtmp] = Koenig2012_demo_dxdt(0, S0);
Nv = numel(vtmp);
Nt = numel(t);
v  = zeros(Nt, Nv);
for k=1:Nt
    [~, v(k, :)] = Koenig2012_demo_dxdt(t(k), c(k, :));
end

% Plot data 
cnames = {'A_{in}', 'B_{in}', 'C_{in}', 'A_{out}', 'B_{out}', 'C_{out}'};
vnames = {'b1', 'b2', 'b3', 'v1', 'v2', 'v3', 'v4'};
Koenig2012_demo_figs(t, c, v);


% Generate the fluxdata (fluxes & concentrations) for CyFluxViz
fluxdata = kinetic2fluxdata(modelSBML.id, cnames, vnames, t, c, v);

% Generate the output files
fluxdata2XML(fluxdata, './xml_fluxes/Koenig2012_demo_COBRA_Kinetic.xml')


end





