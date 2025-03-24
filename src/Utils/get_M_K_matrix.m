function matrix = get_M_K_matrix(FilePath)
    % Function Duties:
    %   Read the mass or stiffness matrix from the .TXM or .TXK file
    % Input:
    %   FilePath: Path to the .TXM (for mass) or .TXK (for stiffness) file
    % Output:
    %   matrix: Mass or stiffness matrix in MATLAB array format

    % Read the file
    fid = fopen(FilePath, 'r');
    lines = {};
    tline = fgetl(fid);
    while ischar(tline)
        lines{end+1} = strtrim(tline); %#ok<AGROW>
        tline = fgetl(fid);
    end
    fclose(fid);

    % Process the lines (skipping the header line)
    data_aux = cellfun(@(x) strsplit(x, '	'), lines(2:end), 'UniformOutput', false);
    data = cellfun(@(x) strtrim(x), data_aux, 'UniformOutput', false);
    data = vertcat(data{:});

    % Convert data to numerical format
    data = cellfun(@(x) {str2double(x)}, data);
    data = reshape(data, [], 3);
    data = cell2mat(data);

    % Determine the shape of the matrix (max row and column indices)
    max_row = max(data(:, 1));
    max_col = max(data(:, 2));

    % Populate the matrix with the values from the data list
    matrix = zeros(max_row, max_col);
    for i = 1:size(data, 1)
        row = data(i, 1);
        col = data(i, 2);
        value = data(i, 3);
        matrix(row, col) = value;
        matrix(col, row) = value;  % Symmetric matrix
    end
end
