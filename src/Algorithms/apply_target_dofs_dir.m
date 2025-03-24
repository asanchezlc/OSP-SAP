function [dofs_matrix, sensors_GRL_tot] = apply_target_dofs_dir(Target_DOFs_dir, dofs)
%% FUNCTION DUTIES:
% Given the target DOF directions (Target_DOFs_dir) and the complete object DOF (dofs),
% retrieves the DOFs that match the specified directions and constructs 
% a matrix that associates DOFs with their respective nodes and directional components.
%
% INPUTS:
%   Target_DOFs_dir - Row vector of size (1 x 3): Defines which DOFs (Ux, Uy, Uz) are 
%                    considered as target directions.
%       - Example: [1, 0, 1] ? Only Ux and Uz are considered as targets.
%       - Remark: Each value must be either 1 (included) or 0 (ignored).
%
%   dofs - Table (3*Nx6) containing DOF information for all nodes in the structure.
%       - Required Fields:
%           * U1, U2, U3: DOFs per direction (Binary indicators: 1 if the DOF exists, 0 otherwise).
%           * dofID: Unique identifier for each DOF.
%           * nodeLabel: Node to which the DOF belongs.
%       - Remark: from from RPOJECT_OSP.geometry.dofs
%
% OUTPUT:
%   dofs_matrix - Matrix of size (target_dofs * N x 4):
%       - Contains the list of DOFs corresponding to the selected target directions.
%       - Columns:
%           * Column 1: DOF identifier (dofs.dofID)
%           * Columns 2-4: DOF direction indicators ([1,0,0], [0,1,0], or [0,0,1])
%       - Sorted by DOF identifier.
%
%   sensors_GRL_tot - Matrix of size (target_dofs * N x 4):
%       - Contains the node label corresponding to the retrieved DOFs.
%       - Columns:
%           * Column 1: Node label (dofs.nodeLabel)
%           * Columns 2-4: DOF direction indicators ([1,0,0], [0,1,0], or [0,0,1])
%
% REMARKS:
%       - N: total number of nodes in the structure
%       - target_dofs * N: total number of target dofs in the structure
%       - target_dofs: number of target_DOFS (e.g. 2 if Uy and Uz)
%

%% Retrieve the dofs measuring the Target_DOFs_dir directions
dofs_matrix_aux = [];
dofs_dir = eye(3);
for i = 1:length(Target_DOFs_dir)
    j = Target_DOFs_dir(i);
    if j > 0 % if it is a target dof dir
        a = find(dofs.(['U', num2str(i)]) == j);
        if ~isempty(a)
            a = [a, repmat(dofs_dir(i, :), length(a), 1)];
            dofs_matrix_aux = [dofs_matrix_aux; a];
        end
    end
end
dofs_matrix = sortrows(dofs_matrix_aux, 1);

%% Retrieve the nodes corresponding to these dofs
[bool,indices] = ismember(dofs_matrix(:,1), dofs.dofID);
sensors_GRL_tot = zeros(size(dofs_matrix_aux,1), 4);
sensors_GRL_tot(:,1) = dofs.nodeLabel(indices);
sensors_GRL_tot(:,2:4) = dofs_matrix(:,2:4);
end