
function [fig, ax] = plot_MAC_1(MAC, annot_kws, modes_number)
    % This function plots the MAC matrix using imagesc to create a heatmap in MATLAB.
    % Arguments:
    % - MAC: The MAC matrix to be plotted.
    % - annot_kws: Annotation settings (can be extended manually). (e.g.
    % struct('fontsize', 10, 'fontweight', 'normal', 'color', 'black'))
    % - modes_number: List of modes for labeling the axes.
    label = 'Mode';
    
    if nargin < 2 || isempty(annot_kws)
        annot_kws = struct('fontsize', 10, 'fontweight', 'normal', 'color', 'black');
    end
    if nargin < 3
        modes_number = [];
    end

    % Number of modes (assuming a square MAC matrix)
    n_modes = size(MAC, 1);

    % Generate labels for the modes
    col = cell(1, n_modes);
    for kk = 1:n_modes
        if ~isempty(modes_number)
            col{kk} = [label, ' ', num2str(modes_number(kk))];
        else
            col{kk} = [label, ' ', num2str(kk)];
        end
    end

    % Plot the MAC matrix as a heatmap
    fig = figure;
    ax = imagesc(MAC);
    colormap('jet');
    colorbar;
    axis equal;

    % Set axis labels
    set(gca, 'XTick', 1:n_modes, 'XTickLabel', col, 'YTick', 1:n_modes, 'YTickLabel', col);
    xtickangle(45); % Rotate x-axis labels for better readability
    title('MAC Matrix');

    % Annotate the matrix values if annot_kws are provided
    if ~isempty(annot_kws)
        [rows, cols] = size(MAC);
        for row = 1:rows
            for col = 1:cols
                % Set font size
                if isfield(annot_kws, 'fontsize')
                    fontSize = annot_kws.fontsize;
                else
                    fontSize = 10;
                end

                % Set font weight
                if isfield(annot_kws, 'fontweight')
                    fontWeight = annot_kws.fontweight;
                else
                    fontWeight = 'normal';
                end

                % Set color
                if isfield(annot_kws, 'color')
                    fontColor = annot_kws.color;
                else
                    fontColor = 'white';
                end

                % Annotate the text
                text(col, row, sprintf('%.3f', MAC(row, col)), ...
                    'HorizontalAlignment', 'center', ...
                    'VerticalAlignment', 'middle', ...
                    'FontSize', fontSize, ...
                    'FontWeight', fontWeight, ...
                    'Color', fontColor);
            end
        end
    end
    
    % Adjust layout
    set(fig, 'Position', [100, 100, 800, 500]);

    % Return handles
    ax = gca; % Get the current axes handle

end