function labels = assign_labels_from_sensorsOSP(node_sel_tot, dir_sel_tot, References)
%{
FUNCTION DUTIES:

Assign labels (ch i) to nodes and directions based on sensor references. It
also indicates display status and reference match.

INPUT:
  node_sel_tot   - Matrix of nodes for which labels need to be assigned.
                   Each element represents a node identifier.
  dir_sel_tot    - Matrix indicating direction associated with each node in node_sel_tot.
                   Each element should be 1, 2, or 3 to indicate direction.
  References     - Matrix containing reference information, where each row specifies a node and direction combination.

OUTPUT:
  labels         - Cell array where each element contains a table with the following fields:
                   'ch'        - Label count (unique identifier for the entry).
                   'node'      - Node identifier.
                   'direction' - Direction for the node (1, 2, or 3).
                   'display'   - Boolean flag (0 or 1) indicating if the label should be plotted.
                   'isRef'     - Boolean flag (0 or 1) indicating if the node-direction pair matches a reference.
%}
columnNames = {'ch', 'node', 'direction', 'display', 'isRef'};
countlabels = 0;
displayed_dofs = zeros(0, 2);
labels = cell(size(node_sel_tot));
for i = 1:size(node_sel_tot,1)
    for j = 1:size(node_sel_tot,2)
        node = node_sel_tot(i,j);
        dir = dir_sel_tot(i,j);
        if ismember([node, dir], displayed_dofs, 'rows')
            display_label = 0; % will not be plotted
        else
            display_label = 1; % will be plotted
            countlabels = countlabels+1;
            displayed_dofs = [displayed_dofs; [node, dir]];
        end
        if dir == 1
            aux = [node, 1, 0, 0];
        elseif dir==2
            aux = [node, 0, 1, 0];
        else
            aux = [node, 0, 0, 1];
        end
        if isempty(References)
            is_ref = 0;
        else
            is_ref = ismember(aux, References, 'rows');
        end
        aux_table = cell2table({countlabels, node, dir, display_label, is_ref}, 'VariableNames', columnNames);
        labels{i, j} = aux_table;
    end
end

end

