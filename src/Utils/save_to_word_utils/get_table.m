function T = get_table(LISTADO_SETUP, pos, References, nsetup)
    % GET_TABLE generates a sorted table of selected nodes and directions for a specific setup.
    %
    % This function extracts and organizes sensor configuration data for a given setup
    % in LISTADO_SETUP. It sorts the selected degrees of freedom (DOFs) by Ed in
    % descending order, checks if each DOF is a reference, and outputs
    % a table with this information.
    %
    % INPUTS:
    %   LISTADO_SETUP - A cell array containing OSP data
    %   pos           - Index specifying the position corresponding to the num of sensors.
    %   References    - Matrix of reference nodes.
    %   nsetup        - Integer specifying which setup in LISTADO_SETUP to process.
    %
    % OUTPUT:
    %   T             - A table containing three columns:
    %                   1. Is_Reference - Binary indicator (1 if the node is a reference, 0 otherwise).
    %                   2. Ed           - Metric of EFI
    %                   3. Node_and_DOF - Labels of the selected nodes and their DOF.

    confsel = LISTADO_SETUP{1,nsetup};
    EDsel = LISTADO_SETUP{7,nsetup};
    surv_nodes_C = LISTADO_SETUP{5,nsetup};
    surv_dir = LISTADO_SETUP{6,nsetup};

    confsel = confsel{pos};
    EDsel = EDsel{pos};
    surv_nodes_C = surv_nodes_C{pos};
    surv_dir = surv_dir{pos};

    [~,I] = sort(EDsel,'descend');
    Ref_check = zeros(size(confsel,1),1);
    for ij = 1:size(References,1)
        if isequal(References(ij,2:end),[1,0,0])
            vect = 1;
        elseif isequal(References(ij,2:end),[0,1,0])
            vect = 2;
        else
            vect = 3;
        end
        Ref_check(find(surv_nodes_C == References(ij,1) & surv_dir == vect)) = 1;
    end

    Label = confsel(:,2);
    T = table(Ref_check(I),EDsel(I),Label(I));

end