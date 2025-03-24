function joints_matrix_index = get_joint_matrix_index(FilePath)
    % Function Duties:
    %   Read the joint matrix index from a file
    % Input:
    %   FilePath: Path to the .TXE file
    % Output:
    %   joints_matrix_index: Table containing the joint matrix index

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
    processed_lines = {};
    temp_line = '';
    header_skipped = false;
    for i = 1:length(lines)
        line = lines{i};
        if ~header_skipped
            header_skipped = true;
            continue;  % Skip the header line
        end
        if ~contains(line, '	') % Check if the line is a continuation
            temp_line = [temp_line ' 	' line]; % Continue the previous record
        else
            if ~isempty(temp_line)
                processed_lines{end+1} = temp_line; %#ok<AGROW> % Add the completed record
            end
            temp_line = line; % Start a new record
        end
    end

    if ~isempty(temp_line) % Append the last line if it was in progress
        processed_lines{end+1} = temp_line;
    end

    % Split the processed lines into columns and remove whitespaces
    data_aux = cellfun(@(x) strsplit(x, '	'), processed_lines, 'UniformOutput', false);
    data = cellfun(@(x) strtrim(x), data_aux, 'UniformOutput', false);
        % Define the columns
    columns = {'Joint_Label', 'U1', 'U2', 'U3', 'R1', 'R2', 'R3'};
    data = vertcat(data{:});

    % Define the columns
    columns = {'Joint_Label', 'U1', 'U2', 'U3', 'R1', 'R2', 'R3'};

    % Convert data to table
    joints_matrix_index = cell2table(data, 'VariableNames', columns);

    % Transform the values to integers and adjust indexing
    for col = 2:length(columns) % Skip the first column 'Joint_Label'
        joints_matrix_index.(columns{col}) = cellfun(@(x) transform_value(x), joints_matrix_index.(columns{col}));
    end
end

function value = transform_value(value)
    % Helper function to transform value
    if strcmp(value, '0') % Restrained nodes are labeled as 0
        value = NaN;
    else
        % value = str2double(value) - 1; % For python (adjust indexing)
        value = str2double(value); % For maltab
    end
end
