function PROJECT_OSP = OSP_run(PROJECT_OSP)
%% FUNCTION DUTIES
% This function obtains and assigns `dofs_matrix` and `LISTADO_SETUP` to `PROJECT_OSP`.
% Specifically, the function performs the following assignments:
%   - `PROJECT_OSP.OSP_results.dofs_matrix = dofs_matrix`
%   - `PROJECT_OSP.OSP_results.LISTADO_SETUP = LISTADO_SETUP`
%
% Additionally, this function calls `Setups_OSP`, which executes one of four 
% OSP algorithms.
%
% Structure of LISTADO_SETUP:
% `LISTADO_SETUP` is a **cell array** where:
% - Rows store the evolution of specific parameters along the iterations of the OSP algorithm:
%     1. DOF and Node
%     2. DOF
%     3. Minimum value of Ed
%     4. DOF (same as row 2, remove when refactoring!)
%     5. Node
%     6. Direction
%     7. Full Ed vector
% - Columns store information for different setups (if available).
%
% INPUT:
%   - `PROJECT_OSP` : A structure that contains the OSP project data.
%
% OUTPUT:
%   - No direct output, but `dofs_matrix` and `LISTADO_SETUP` are assigned 
%     to `PROJECT_OSP.OSP_results`.


%% Obtain dofs that participate in the problem
% Retrieve basic variables of the problem
method = PROJECT_OSP.config.method; % 'EFI', 'KEMRO', 'SEMRO' or 'EFIWM'
n_modes = numel(PROJECT_OSP.config.selmodes);
sel_modes = PROJECT_OSP.config.selmodes;
sensors = PROJECT_OSP.geometry.sensors; % CHECK IF SHOULD BE REMOVED
all_nodes = PROJECT_OSP.geometry.nodes;
Target_DOFs_dir = PROJECT_OSP.config.Target_DOFs;
dofs = PROJECT_OSP.geometry.dofs;
Target_DOFs_labels = [1,2,3]; % i.e. dir [0,1,0] corresponds to DOF 2

% Retrieve the dofs measuring the Target_DOFs_dir directions
[dofs_matrix, sensors_GRL_tot] = apply_target_dofs_dir(Target_DOFs_dir, dofs);

% Get the information in a proper table
[bool,indices] = ismember(dofs_matrix(:,1), dofs.dofID); % Retrieve the nodes corresponding to these dofs
anode_grl_tot = dofs.nodeLabel(indices);
considered_dofs = Target_DOFs_labels(Target_DOFs_dir>0);
LISTA_GRL = create_dof_table(dofs_matrix, anode_grl_tot, considered_dofs);

% Get the DOF and directions assigned to References
if ~isfield(PROJECT_OSP.geometry,'References') | PROJECT_OSP.config.runGlobalOSP
    ref = [];
    gdl_ref = [];
else
    if ~isempty(PROJECT_OSP.geometry.References) % get dof and dir of references
        References = PROJECT_OSP.geometry.References;
        ref = References(:,1)';
        [tf, indices] = ismember(References, sensors_GRL_tot, 'rows');
        gdl_ref = dofs_matrix(indices(indices>0),1);
        gdl_ref = gdl_ref';
        for i = 1:size(gdl_ref, 2)
            if isequal(References(i, 2:4),[1,0,0])
                dir_ref(i) = Target_DOFs_labels(1); % i.e. 1
            elseif isequal(References(i, 2:4),[0,1,0])
                dir_ref(i) = Target_DOFs_labels(2); % i.e. 2
            else
                dir_ref(i) = Target_DOFs_labels(3); % i.e. 3
            end
        end
    else
        ref = [];
        gdl_ref = [];
    end
end

%% Run OSP algorithm calling Setups_OSP function
n_setup = PROJECT_OSP.geometry.Nsetups; % n_setup decides if running a global or a multisetup OSP
if n_setup == 0 | PROJECT_OSP.config.runGlobalOSP
    n_setup = 1;
end
LISTADO_SETUP = cell(7,n_setup);
for sets = 1:n_setup
    % 1. Retrieve the subset dof_setup from all DOFs;
    if n_setup>1 % the subset corresponds to nodes in Setup_i group
        eval(['setup_nodes = PROJECT_OSP.geometry.Setup_',int2str(sets),';']);
        setup_nodes = [setup_nodes(:), zeros(length(setup_nodes),3)];
        [isMember,indices] = ismember(setup_nodes(:,1), all_nodes(:,1));
        setup_nodes(:,2:4) = all_nodes(indices,2:4);       
        % [dof_setup,nodes_setup,dir_setup] = dof_conv_2(setup_nodes, sensors_GRL_tot);
        [dof_setup,nodes_setup,dir_setup] = get_dof_setup(setup_nodes, sensors_GRL_tot, dofs_matrix);       
    else % the subset corresponds to nodes in Candidate_DOFs group / all Setup_i groups
        existsCandidateDOFs = PROJECT_OSP.config.SAP2000_groups.existsCandidateDOFs;
        if existsCandidateDOFs
            aux = PROJECT_OSP.geometry.candiateNodes;
        else
            aux = PROJECT_OSP.geometry.candiateNodes_Setups;
        end
        candidates = zeros(length(aux), 4);
        candidates(:,1) = aux;
        [isMember,indices] = ismember(candidates(:,1), all_nodes(:,1));
        candidates(:,2:4) = all_nodes(indices,2:4);
        % [dof_setup,nodes_setup,dir_setup] = dof_conv_2(candidates, sensors_GRL_tot);
        [dof_setup,nodes_setup,dir_setup] = get_dof_setup(candidates, sensors_GRL_tot, dofs_matrix);
    end
    % 2. Introduce the references (which might be excluded) in dof_setup
    pos_ref_in_setup = [];
    if ~isempty(gdl_ref)
        for i=1:length(gdl_ref)
            if ~ismember(gdl_ref(i), dof_setup)
                dof_setup = [dof_setup,gdl_ref(i)];
                nodes_setup = [nodes_setup, References(i,1)];
                dir_setup = [dir_setup,dir_ref(i)];
            end
        end
        % Delete if repeated
        [dof_setup,ia,ic] = unique(dof_setup);
        nodes_setup = nodes_setup(ia);
        dir_setup = dir_setup(ia);
        
        clear pos_ref_in_setup
        for ijijij = 1:numel(gdl_ref)
            pos_ref_in_setup(ijijij) = find(dof_setup == gdl_ref(ijijij) & nodes_setup == ref(ijijij));
        end
    end
    
    % 3. Run OSP from main script and fill LISTADO_SETUP with results
    warning ('off','all');
    Setups_OSP
    warning ('on','all');
    LISTADO_SETUP{1,sets}=[LISTA_OSP_C]; % evolution of DOF and NODE
    LISTADO_SETUP{2,sets}=[surv_DOF_C]; % evolution of DOF
    LISTADO_SETUP{3,sets}=[minED]; % evolution of minED
    LISTADO_SETUP{4,sets}=[surv_DOF_C]; % !! Same as LISTADO_SETUP{2,sets}
    LISTADO_SETUP{5,sets}=[surv_nodes_C];
    LISTADO_SETUP{6,sets}=[surv_dir];
    LISTADO_SETUP{7,sets}=[Edserie];
end

% Make all setups have the same number of iterations
min_sens = min(cellfun(@numel,LISTADO_SETUP(1,:)));
for i=1:size(LISTADO_SETUP,1)
    for j=1:size(LISTADO_SETUP,2)
        item = LISTADO_SETUP{i,j};
        nelem = numel(LISTADO_SETUP{i,j});
        LISTADO_SETUP{i,j} = item(nelem-min_sens+1:end);
    end
end

% Save results in PROJECT_OSP structure
PROJECT_OSP.OSP_results.dofs_matrix = dofs_matrix;
PROJECT_OSP.OSP_results.LISTADO_SETUP = LISTADO_SETUP;
end