function LISTA_GRL = create_dof_table(dofs_matrix, anode_grl_tot, considered_dofs)
% FUNCTION DUTIES:
% This function generates a structured cell array (`LISTA_GRL`) containing 
% formatted information about the DOFs and their associated nodes in a readable format.
%
% INPUTS:
%   dofs_matrix - Matrix of size (target_dofs * N x 4):
%       - Contains the list of DOFs corresponding to the selected target directions.
%       - Columns:
%           * Column 1: DOF identifier (dofs.dofID)
%           * Columns 2-4: DOF direction indicators ([1,0,0], [0,1,0], or [0,0,1])
%       - Remark: obtained in apply_target_dofs_dir
%
%   anode_grl_tot - Vector of size (target_dofs * N x 1):
%       - Contains the node numbers corresponding to each DOF in `dofs_matrix`.
%
%   considered_dofs - Vector of size (1 x target_dofs):
%       - Specifies the considered DOFs in the current setup.
%       - Example: [1, 2, 3] ? Corresponds to Ux, Uy, and Uz.
%
% OUTPUT:
%   LISTA_GRL - Cell array of size (M x 2) containing formatted DOF and node information:
%       - Column 1: Formatted DOF identifiers (e.g., "D.O.F.- 5").
%       - Column 2: Corresponding node information with DOF direction (e.g., "Node - 3 - Ux").
%       - Transposed for proper formatting as (M x 2).
%
% REMARKS:
%   - The function loops through `dofs_matrix` and retrieves DOF numbers, node associations, and directions.
%   - The result is a structured list (`LISTA_GRL`) that can be used for display, export, or further processing.
%   - The DOF direction is labeled as 'Ux', 'Uy', or 'Uz' based on `dofs_matrix(:,2:4)`.
%   - The `considered_dofs` input is included for consistency, although it is not used in the function.


LISTA_GRL = cell(2, size(dofs_matrix,1)); 
for i = 1:size(dofs_matrix,1)
    nodo = anode_grl_tot(i);    % Get node number
    dof = dofs_matrix(i,1);     % Get DOF number
    dof_dir = dofs_matrix(i,2:4); % Get DOF direction indicator
    
    % Determine DOF direction label
    if isequal(dof_dir, [1,0,0])
        label_dir = 'Ux';
    elseif isequal(dof_dir, [0,1,0])
        label_dir = 'Uy';
    elseif isequal(dof_dir, [0,0,1])
        label_dir = 'Uz';
    end  

    % Store formatted information in LISTA_GRL
    LISTA_GRL{1,i} = sprintf('D.O.F.- %d', dof);
    LISTA_GRL{2,i} = sprintf('Node - %d - %s', nodo, label_dir);
end

LISTA_GRL = LISTA_GRL'; % Transpose LISTA_GRL for proper formatting
end
