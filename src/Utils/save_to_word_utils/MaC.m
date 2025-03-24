function MAC = MaC(phi_X, phi_A)
    % MaC calculates the Modal Assurance Criterion (MAC) between two sets of mode shapes.
    % If the input arrays are in the form (n, 1) (column vectors), the output is a
    % scalar. If the input are in the form (n, m), the output is an (m, m) matrix (MAC matrix).
    % [m: number of modes]
    % Literature:
    % [1] Maia, N. M. M., and J. M. M. Silva. "Modal analysis identification techniques."
    % Philosophical Transactions of the Royal Society of London. Series A: Mathematical,
    % Physical and Engineering Sciences 359.1778 (2001): 29-40.
    %
    % Inputs:
    %   phi_X - Mode shape matrix X, size: (n_locations, n_modes) or (n_locations, 1).
    %   phi_A - Mode shape matrix A, size: (n_locations, n_modes) or (n_locations, 1).
    %
    % Output:
    %   MAC - MAC matrix, or MAC value if both phi_X and phi_A are one-dimensional arrays.
    %

    % Ensure phi_X and phi_A are column matrices
    if isvector(phi_X)
        phi_X = phi_X(:);
    end
    if isvector(phi_A)
        phi_A = phi_A(:);
    end

    % Validate input dimensions
    if size(phi_X, 1) ~= size(phi_A, 1)
        error('Mode shapes must have the same number of locations (rows).');
    end

    % Compute MAC matrix
    MAC = abs((phi_X' * phi_A)).^2;
    for i = 1:size(phi_X, 2)
        for j = 1:size(phi_A, 2)
            MAC(i, j) = MAC(i, j) / real((phi_X(:, i)' * phi_X(:, i)) * (phi_A(:, j)' * phi_A(:, j)));
        end
    end

    % If MAC is a 1x1 matrix, return it as a scalar
    if numel(MAC) == 1
        MAC = MAC(1);
    end
end
