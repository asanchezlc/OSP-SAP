function [dof_setup,nodes_setup,dir_setup] = dof_conv_2(setup_nodes, sensors_GRL_tot)
% FUNCTION DUTIES:
% Given setup_nodes (the nodes considered for this case),and sensors_GRL_tot
% (variable indicating the target DOFs for all nodes in the structure),
% the function retrieves which are the dofs corresponding to setup_nodes
%
% INPUTS:
%   setup_nodes - Matrix of size (n2 x 4): [subset of the full set nodes in the structure]
%       - Column 1: Names of the nodes included in the setup (or all candidate nodes if using a global EfI).
%                   These nodes must be present in the first column of the 'nodes' matrix.
%       - Columns 2-4: Node coordinates (not used in this function).
%
%   sensors_GRL_tot - Matrix of size (target_dofs * N x 4)
%       - Column 1: Nodes names
%       - Columns 2-4: [1,0,0], [0,1,0] or [0,0,1], depending on the DOF
%   Remark:
%       - n2: number of candidates (global or setup)
%       - N: total number of nodes in the structure
%       - target_dofs * N: total number of dofs in the structure
%       - target_dofs * n2: total number of dofs in this specific OSP problem
%       - target_dofs: number of target_DOFS (e.g. 2 if Uy and Uz)
%
% OUTPUT:
%   dof_setup - Vector of size (1 x n_target_dofs*n2):
%       - Contains the DOF numbers associated with each element in setup_nodes.
%       - Each DOF number is between 1 and 3*N.
%
%   nodes_setup - Vector of size (1 x n_target_dofs*n2):
%       - Contains the names of the nodes to which each DOF in dof_setup belongs.
%       - Example:
%           If dof_setup = [1, 2, 3, 7, 8, 9] and nodes_setup = [2, 2, 2, 5, 5, 5],
%           it means:
%           - DOFs 1, 2, 3 belong to node 2.
%           - DOFs 7, 8, 9 belong to node 5.
%
%   dir_setup - Vector of size (1 x n_target_dofs*n2):
%       - Indicates the direction of each DOF:
%           - 1 ? U1 (x-direction)
%           - 2 ? U2 (y-direction)
%           - 3 ? U3 (z-direction)

%% Retrieve the dof_setup variable
indexes = cell(size(setup_nodes,1),1);
for i = 1:size(setup_nodes,1)
    indexes{i} = find(sensors_GRL_tot(:,1) == setup_nodes(i));
end
dof_setup_aux = horzcat(indexes{:});
dof_setup = [];
for i=1:size(dof_setup_aux,2)
    dof_setup = [dof_setup, dof_setup_aux(:, i).'];
end

%% Retrieve the dir_setup variable
dir_setup = zeros(1,length(dof_setup));
for i=1:size(dof_setup,2)
    if sensors_GRL_tot(dof_setup(i),2:4) == [1, 0, 0]
        dir_setup(i) = 1;
    elseif sensors_GRL_tot(dof_setup(i),2:4) == [0, 1, 0]
        dir_setup(i) = 2;
    else
        dir_setup(i) = 3;
    end    
end

%% Retrieve the nodes_setup variable
nodes_setup = sensors_GRL_tot(dof_setup,1).';

end