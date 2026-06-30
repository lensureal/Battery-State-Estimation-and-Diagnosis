%% Parameter initialization
% SOC and OCV refers to the SOC-OCV curve
% R0 is the internal resistance
% R1 and Tau1 describe the RC-circuit
% SOC_Param is the SOC vector for the parameters


par_model.Data = load('CellParameter.mat');

%% Battery Pack Paramter
par_model.np = 4; % Parallel

%% Calculating the new parameters for the parallel connection model, Assumtion: CellParameter.mat contains single Cell values

% Resistances (parallel)
par_model.R0 = par_model.Data.R0 ./ par_model.np;
par_model.R1 = par_model.Data.R1 ./ par_model.np;

% Time constant (unchanged)
par_model.Tau1 = par_model.Data.Tau1;

% Capacity 
C_nom_single_cell_Ah = 2.5;                                         % [Ah]
C_nom_single_cell_As = C_nom_single_cell_Ah .* 3600;                % [As]
par_model.CN = C_nom_single_cell_As .* par_model.np;                % [As]


% Efficiency based on I
par_model.eta_charge = 0.985;
par_model.eta_discharge = 1;

par_model.eta = [par_model.eta_charge;par_model.eta_discharge];

% OCV/SOC data

par_model.SOCData = par_model.Data.SOC;
par_model.SOC_Param = par_model.Data.SOC_Param;
par_model.OCVData = par_model.Data.OCV;


%% Initilization of the state space model


SOC_init = 0.01; % 1% SOC initial
U1_init = 0.0;   % Assumtion: no initial polarization voltage
par_model.x_init = [SOC_init;U1_init];

disp(par_model)