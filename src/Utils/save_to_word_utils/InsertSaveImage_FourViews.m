function InsertSaveImage_FourViews(ax, selection, baseFileName, folderpath)
    % InsertSaveImage_FourViews Generates and saves multiple view images of a figure
    %
    % This function takes an axes object (`ax`), copies it to a new figure,
    % captures and saves images from multiple predefined views, and inserts
    % them into a Microsoft Word document using the `selection` object.
    
    %%
    if isempty(folderpath)
        folderpath = pwd;
    end
    % Create a new figure and copy the provided axes
    figFile = [baseFileName, '_base.png'];
    fig = figure();
    ax2 = copyobj(ax, fig);
    
    % Save and insert the base image
    saveas(fig, fullfile(folderpath, figFile));
    selection.TypeParagraph;  
    selection.InlineShapes.AddPicture(fullfile(folderpath, figFile));  
    
    % Define view angles (each row is [azimuth, elevation])
    viewAngles = [90, 0; 0, 90; 0, 0]; 
    
    % Loop through each view angle and save the images
    for i = 1:size(viewAngles, 1)
        viewAngle = viewAngles(i, :);
        figFile = [baseFileName, '_', int2str(viewAngle(1)), '_', int2str(viewAngle(2)), '.png'];
        
        view(ax2, viewAngle);
        saveas(fig, fullfile(folderpath, figFile));
        
        selection.TypeParagraph;
        selection.InlineShapes.AddPicture(fullfile(folderpath, figFile));
    end
    
    % Close figure to free memory
    close(fig);
end
