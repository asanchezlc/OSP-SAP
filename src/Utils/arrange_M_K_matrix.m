

function [matrix_rearranged, correspondance] = arrange_M_K_matrix(dofsElm, joints, matrix)
%{
Function Duties:
    Rearranges a matrix (M or K) from SAP2000, to match the order of degrees
    of freedom (DOFs) specified by the DOFs in dofsElm. 

Inputs:
    - dofsElm: A table specifying the DOFs considered
    - joints: A structure containing the joint information from SAP2000,
      where:
        * `joints.Joint_Label` is a cell array of joint identifiers.
        * `joints.U1`, `joints.U2`, and `joints.U3` provide the SAP2000 DOF
          indices for each joint (i.e. index in the original K or M matrix).
    - matrix: n1 x n1 matrix, either M or K matrix.

Outputs:
    - matrix_rearranged: n×n matrix reordered to match the sensor order in
      sensors, with NaN rows and columns where correspondance has NaN.
    - correspondance: n×1 vector mapping each sensor to a row in matrix,
      with NaN indicating no matching joint DOF.
%}

correspondance = zeros(size(dofsElm,1),1);
for i = 1:size(dofsElm, 1)
    index =  find(strcmp(dofsElm.nodeLabel{i}, joints.Joint_Label));
    if dofsElm.U1(i) == 1
        correspondance(i) = joints.U1(index);
    elseif dofsElm.U2(i) == 1
        correspondance(i) = joints.U2(index);
    elseif dofsElm.U3(i) == 1
        correspondance(i) = joints.U3(index);
    elseif dofsElm.R1(i) == 1
        correspondance(i) = joints.R1(index);
    elseif dofsElm.R2(i) == 1
        correspondance(i) = joints.R2(index);
    elseif dofsElm.R3(i) == 1
        correspondance(i) = joints.R3(index);
    end
end

% Populate matrix_rearranged based on correspondance
matrix_rearranged = NaN(length(correspondance), length(correspondance));
for k = 1:length(correspondance)
    for l = 1:length(correspondance)
        if ~isnan(correspondance(k)) && ~isnan(correspondance(l))
            row_index = correspondance(k);
            col_index = correspondance(l);
            matrix_rearranged(k, l) = matrix(row_index, col_index);
        end
    end
end

matrix_rearranged(isnan(matrix_rearranged)) = 0;

end