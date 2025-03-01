%% save_to_word.m
% File Duties
% Write a report in Word with the model geometry and OSP results

%% Important variables
% General variables
if isfield(PROJECT_OSP.config, 'WordReport')
    if isfield(PROJECT_OSP.config.WordReport, 'save_figures')
        save_figures = PROJECT_OSP.config.WordReport.save_figures;
    else
        save_figures = 0;
    end
    if isfield(PROJECT_OSP.config.WordReport, 'Path')
        save_path = PROJECT_OSP.config.WordReport.Path;
    else
        save_path = pwd;
    end    
else
    save_figures = 0;
    save_path = pwd;
end
runGlobalOSP = PROJECT_OSP.config.runGlobalOSP;
method = PROJECT_OSP.config.method;

%Variables that will be modified; we store them to restore at the end
backup_Plotsetups = PROJECT_OSP.Style_Options.styleplot.Plotsetups;
backup_Plotref = PROJECT_OSP.Style_Options.styleplot.Plotref;

% OSP Variables
LISTADO_SETUP = PROJECT_OSP.OSP_results.LISTADO_SETUP;
n_sensors = PROJECT_OSP.config.n_sensors;
nsensors = cellfun(@(x) size(x,1),LISTADO_SETUP{1,1});
pos = find(nsensors == n_sensors);
if isfield(PROJECT_OSP.geometry,'References') & ~runGlobalOSP
    References = PROJECT_OSP.geometry.References;
else
    References = [];
end
Nsetup = size(PROJECT_OSP.OSP_results.LISTADO_SETUP,2);
generated_figures = {}; % cell with all figures will be generated

%% Settings
% Add a new document
wordApp = actxserver('Word.Application');
wordApp.Visible = true;
doc = wordApp.Documents.Add;
languageID = wordApp.LanguageSettings.LanguageID('msoLanguageIDUI');

% Define the style name based on the language
switch languageID
    case {1033, 2057} % English (US and UK)
        language = 'English';
    case 3082 % Spanish
        language = 'Spanish';
    case 1036 % French
        language = 'French';
    case 1040 % Italian
        language = 'Italian';
    otherwise % Default to English if language not recognized
        language = 'English';
        warning('Errors may occur due to names of headings in a different language.');
end

% Set heading style based on language
if strcmp(language, 'English')
    headingStyle_1 = 'Heading 1';
    headingStyle_2 = 'Heading 2';
    headingStyle_3 = 'Heading 3';
elseif strcmp(language, 'Spanish')
    headingStyle_1 = 'Título 1';
    headingStyle_2 = 'Título 2';
    headingStyle_3 = 'Título 3';
elseif strcmp(language, 'French')
    headingStyle_1 = 'Titre 1';
    headingStyle_2 = 'Titre 2';
    headingStyle_3 = 'Titre 3';
elseif strcmp(language, 'Italian')
    headingStyle_1 = 'Titolo 1';
    headingStyle_2 = 'Titolo 2';
    headingStyle_3 = 'Titolo 3';
else
    headingStyle_1 = 'Heading 1'; % Default to English
    headingStyle_2 = 'Heading 2';
    headingStyle_3 = 'Heading 3';
    warning('Defaulting to English heading styles due to unrecognized language.');
end

%% Write document title, header and footer
selection = wordApp.Selection;

% Access the header
header = selection.Sections.Item(1).Headers.Item(1); % 1 = wdHeaderFooterPrimary
header.Range.Text = ''; % Clear existing header content if needed
p = mfilename('fullpath');
k = strfind(p,'\Utils');
currfolder = p(1:k(1)-1);
imagePath = fullfile(currfolder, 'figure.png'); % Get full path of the image
header.Range.InlineShapes.AddPicture(fullfile(currfolder, 'Logos/Big_Logo_OSP.jpg'), 0, 1); % (LinkToFile=0, SaveWithDocument=1)

% Add page number to the footer
footer = selection.Sections.Item(1).Footers.Item(1); % 1 = wdHeaderFooterPrimary
footerRange = footer.Range;
footerRange.ParagraphFormat.Alignment = 1; % 1 = Center alignment
footerRange.Fields.Add(footerRange, -1, 'PAGE', true); % -1 = wdFieldEmpty, 'PAGE' inserts page number

% Title
text_title ='OSP-SAP: Software for performing Optimal Sensor Placement using SAP2000 - University of Granada';
headingStyle = headingStyle_1;
insertPageBreak = false;
insertHeading(selection, text_title, headingStyle, insertPageBreak);

% Insert the Table of Contents
selection.TypeParagraph;
selection.Fields.Add(selection.Range, -1, 'TOC \o "2-4" \h \z \u', true);
selection.InsertBreak(7);

% Section
text_title ='SAP2000 Model';
headingStyle = headingStyle_2;
insertPageBreak = false;
insertHeading(selection, text_title, headingStyle, insertPageBreak);

%% GEOMETRY
% Write heading
text_title ='Geometry';
headingStyle = headingStyle_3;
insertPageBreak = false;
insertHeading(selection, text_title, headingStyle, insertPageBreak);

% ---------------------------------------
% Update the GUI view to gemetry
% ---------------------------------------
handles.popupmenu5.Value = 1;  % "Geometry" and "Convergence" popupmenu
handles.popupmenu1.Value = 1; % "Modal Analysis" and "Undeformed" popupmenu
set(handles.edit4,'visible','off');  % convergence diagram labels
set(handles.edit5,'visible','off');  % convergence diagram labels
set(handles.text16,'visible','off');  % convergence diagram labels
set(handles.text17,'visible','off');  % convergence diagram labels
set(handles.popupmenu1,'visible','on')
%     set(handles.popupmenu2,'visible','on')
%     set(handles.slider1,'visible','on')
set(handles.axes2,'visible','on');
set(handles.axes3,'visible','on');

set(handles.pushbutton16,'visible','on')
set(handles.pushbutton17,'visible','on')
set(handles.pushbutton18,'visible','on')
set(handles.pushbutton19,'visible','on')

for j = 1:numel(handles.axes2.Children)
    handles.axes2.Children(j).Visible = 'on';
end
for j = 1:numel(handles.axes3.Children)
    handles.axes3.Children(j).Visible = 'on';
end
for j = 1:numel(handles.axes4.Children)
    handles.axes4.Children(j).Visible = 'off';
end
set(handles.axes4,'visible','off');
% ---------------------------------------
% SET VARIABLES FOR NOT PLOTTING CHANNELS
% In Plot_Mode_Shape_OSP function, if
% isempty(PROJECT_OSP.Style_Options.styleplot.Plotsetups) ||
% PROJECT_OSP.Style_Options.styleplot.Plotsetups(jiij) == 1 -> Channels are
% plotted, so we adjust PROJECT_OSP.Style_Options.styleplot.Plotsetups so
% that they won't be plotted
if length(backup_Plotsetups) > 0
    PROJECT_OSP.Style_Options.styleplot.Plotsetups = backup_Plotsetups*0;
else  % This way we do not plot channels in a Global OSP case
    PROJECT_OSP.Style_Options.styleplot.Plotsetups = 0;
end
PROJECT_OSP.Style_Options.styleplot.Plotref = 0;

axis(handles.axes1,'off')
axis(handles.axes2,'off')
axis(handles.axes4,'off')
axis(handles.axes3,'off')

% Plot and insert the images
assist_plot
baseFileName = 'Geometry';
ax = handles.axes2;
InsertSaveImage_FourViews(ax, selection, baseFileName, save_path);
generated_figures{end+1} = baseFileName;

%% MODE SHAPES
% Write heading
text_title ='Target Mode Shapes';
headingStyle = headingStyle_3;
insertPageBreak = true;
insertHeading(selection, text_title, headingStyle, insertPageBreak);

modes = cell2mat(handles.uitable1.Data(:,1));
selected = cell2mat(handles.uitable1.Data(:,2));
frequencies = cell2mat(handles.uitable1.Data(:,3));

for i = 1:numel(selected)
    if selected(i) == 1
        % Write mode and frequency
        selection.TypeParagraph; % Move to a new paragraph after the text
        selection.Font.Underline = true; % Enable underline
        selection.TypeText(['Mode ',int2str(i)]); % Insert the text
        selection.TypeParagraph; % Move to a new paragraph after the text
        selection.Font.Underline = false;
        %selection.TypeParagraph; % Move to a new paragraph
        selection.TypeText(['Frequency: ',num2str(frequencies(i)),' Hz']);
        selection.TypeParagraph; % Move to a new paragraph
        
        % ---------------------------------------
        % Update the GUI view to show mode shapes
        % ---------------------------------------
        handles.popupmenu2.Value = i; % mode shape popup menu
        handles.popupmenu5.Value = 1; % Select "Geometry" instead of "convergence"
        handles.popupmenu1.Value = 2;
        set(handles.edit4,'visible','off');
        set(handles.edit5,'visible','off');
        set(handles.text16,'visible','off');
        set(handles.text17,'visible','off');
        set(handles.popupmenu1,'visible','on')
        %     set(handles.popupmenu2,'visible','on')
        %     set(handles.slider1,'visible','on')
        set(handles.axes2,'visible','on');
        set(handles.axes3,'visible','on');
        
        set(handles.pushbutton16,'visible','on')
        set(handles.pushbutton17,'visible','on')
        set(handles.pushbutton18,'visible','on')
        set(handles.pushbutton19,'visible','on')
        
        for j = 1:numel(handles.axes2.Children)
            handles.axes2.Children(j).Visible = 'on';
        end
        for j = 1:numel(handles.axes3.Children)
            handles.axes3.Children(j).Visible = 'on';
        end
        for j = 1:numel(handles.axes4.Children)
            handles.axes4.Children(j).Visible = 'off';
        end
        set(handles.axes4,'visible','off');
        % ---------------------------------------

        % SET VARIABLES FOR NOT PLOTTING CHANNELS
        % In Plot_Mode_Shape_OSP function, if
        % isempty(PROJECT_OSP.Style_Options.styleplot.Plotsetups) ||
        % PROJECT_OSP.Style_Options.styleplot.Plotsetups(jiij) == 1 -> Channels are
        % plotted, so we adjust PROJECT_OSP.Style_Options.styleplot.Plotsetups so
        % that they won't be plotted
        if length(backup_Plotsetups) > 0
            PROJECT_OSP.Style_Options.styleplot.Plotsetups = backup_Plotsetups*0;
        else  % This way we do not plot channels in a Global OSP case
            PROJECT_OSP.Style_Options.styleplot.Plotsetups = 0;
        end
        PROJECT_OSP.Style_Options.styleplot.Plotref = 0;
        
        axis(handles.axes1,'off')
        axis(handles.axes2,'off')
        axis(handles.axes4,'off')
        axis(handles.axes3,'off')
        
        % Plot and insert the images
        assist_plot
        baseFileName = ['Mode_',int2str(i)];
        ax = handles.axes2;
        InsertSaveImage_FourViews(ax, selection, baseFileName, save_path);
        generated_figures{end+1} = baseFileName;
    end
end


%% TABLE WITH THE SELECTED DOFS
% Write heading
text_title =['OSP Algorithm - ', method, ' Method'];
headingStyle = headingStyle_2;
insertPageBreak = true;
insertHeading(selection, text_title, headingStyle, insertPageBreak);

% Write heading
text_title =[method, ' - Selected DOFs'];
headingStyle = headingStyle_3;
insertPageBreak = false;
insertHeading(selection, text_title, headingStyle, insertPageBreak);

% Create tables
for i=1:Nsetup
    T = get_table(LISTADO_SETUP, pos, References, i);
    selection.TypeParagraph;
    selection.Font.Underline = true; % Enable underline
    if Nsetup == 1
        selection.TypeText('Global OSP');
    else
        selection.TypeText(['Setup ' num2str(i)]);
    end
    selection.TypeParagraph;
    selection.Font.Underline = false;

    % Access the table and rename columns
    Table = T;
    Table.Properties.VariableNames = {'Is_Reference', 'Ed', 'Node_and_DOF'};

    % Convert the table to a cell array for easier insertion in Word
    tableData = [Table.Properties.VariableNames; table2cell(Table)];

    % Insert the table row by row
    numRows = size(tableData, 1);
    numCols = size(tableData, 2);
    wordTable = selection.Tables.Add(selection.Range, numRows, numCols);

    % Populate the Word table with data from MATLAB
    for i = 1:numRows
        for j = 1:numCols
            value = tableData{i, j};
            if i==1
                if ismember('_',value)
                    value = strrep(value, '_', ' ');
                end
            end
            if j == 1 & i>1
                if value
                    value = 'YES';
                else
                    value = 'NO';
                end
            end
            if isnumeric(value) % Check if the value is numeric
                value = num2str(value, '%.4f'); % Convert numeric value to string
            end
            wordTable.Cell(i, j).Range.Text = value; % Insert the value into the Word table cell
        end
    end

    % Format the table (optional) - e.g., make the header row bold
    for j = 1:numCols
        wordTable.Cell(1, j).Range.Bold = true; % Bold for header row
    end

    % Adjust column widths (optional)
    wordTable.Columns.Item(1).Width = 100; % Adjust width as needed
    wordTable.Columns.Item(2).Width = 50;
    wordTable.Columns.Item(3).Width = 100;

    % Apply borders to the table
    wordTable.Borders.Enable = true; % Enable all borders

    % Optionally, customize the border style and width
    for k = 1:6 % Loop through each border type (Word has 6 sides to handle)
        wordTable.Borders.Item(k).LineStyle = 1; % Solid line (1 = wdLineStyleSingle)
        wordTable.Borders.Item(k).LineWidth = 12; % Width of the border (12 = 1.5 pt)
    end
    selection.EndKey(6);
end
selection.TypeParagraph;

%% ALGORITHM PERFORMANCE BASED ON MAC
% Write heading
text_title =[method, ' performance based on MAC.'];
headingStyle = headingStyle_3;
insertPageBreak = true;
insertHeading(selection, text_title, headingStyle, insertPageBreak);

% Get the mac values
selmodes = PROJECT_OSP.config.selmodes;
modes_number = selmodes.';
Phi_OSP = PROJECT_OSP.modalprop.Mode_shape(PROJECT_OSP.OSP_results.surv_DOF,:);
if isfield(PROJECT_OSP.modalprop,'Mode_shape_Elm')
    Phi_Model = PROJECT_OSP.modalprop.Mode_shape_Elm;
else
    Phi_Model = PROJECT_OSP.modalprop.Mode_shape;
end
Phi_OSP = Phi_OSP(:, selmodes);
Phi_Model = Phi_Model(:, selmodes);

mac_model = MaC(Phi_Model, Phi_Model);
mac_OSP = MaC(Phi_OSP, Phi_OSP);
annot_kws = struct('fontsize', 10, 'fontweight', 'normal', 'color', 'white');

% Insert underlined text
selection.Font.Underline = true; % Enable underline
selection.TypeText('MAC Matrix considering optimal sensors:'); % Insert the text
selection.TypeParagraph; % Move to a new paragraph after the text
selection.Font.Underline = false;

% Insert figure
[fig, ax] = plot_MAC_1(mac_OSP, annot_kws, modes_number);
baseFileName = 'MAC_OSP'; % Define the file name for the saved figure
figFile = [baseFileName, '.png'];
saveas(fig, fullfile(save_path,figFile)); % Save the figure as a PNG file in the current folder
selection.InlineShapes.AddPicture(fullfile(save_path, figFile)); % Insert the image
close(fig);
generated_figures{end+1} = baseFileName;

% Insert underlined text
selection.Font.Underline = true; % Enable underline
selection.TypeText('MAC Matrix considering all the DOFs'); % Insert the text
selection.TypeParagraph; % Move to a new paragraph after the text
selection.Font.Underline = false;

[fig, ax] = plot_MAC_1(mac_model, annot_kws, modes_number);
baseFileName = 'MAC_Full'; % Define the file name for the saved figure
figFile = [baseFileName, '.png'];
saveas(fig, fullfile(save_path,figFile)); % Save the figure as a PNG file in the current folder
selection.InlineShapes.AddPicture(fullfile(save_path, figFile)); % Insert the image
close(fig);
generated_figures{end+1} = baseFileName;

%% Plot Sensors Location

% Write heading
if runGlobalOSP
    text_title = 'Sensors Location';
    n = 1;
else
    text_title ='Sensors Location in Setups and References';
    n = PROJECT_OSP.geometry.Nsetups;
end
headingStyle = headingStyle_3;
insertPageBreak = true;
insertHeading(selection, text_title, headingStyle, insertPageBreak);

handles.popupmenu5.Value = 1;  % Set to "Geometry" instead of "Convergence"
handles.popupmenu1.Value = 1;  % Set to "Undeformed" instead of "Modal Analysis"

% Plot Sensors Locations (Global or by Setups if Multisetup OSP was run)
for iijjii = 1:n
    selection.InsertBreak(7); % 7 = wdPageBreak
    selection.TypeParagraph; % Move to a new paragraph

    if ~runGlobalOSP  % Write Setup_i underlined
        selection.Font.Underline = true; % Enable underline
        selection.TypeText(['Setup ',int2str(iijjii)]); % Insert the text
        selection.TypeParagraph; % Move to a new paragraph after the text
        selection.Font.Underline = false;
        baseFileName = ['Setup ',int2str(iijjii)];
    else
        baseFileName = 'Sensors_Locations';
    end

    % Set variables for plotting channels according to Plot_Mode_Shape_OSP.
    PROJECT_OSP.Style_Options.styleplot.Plotsetups = backup_Plotsetups*0;
    PROJECT_OSP.Style_Options.styleplot.Plotref = 0;  % Do not plot references
    PROJECT_OSP.Style_Options.styleplot.Plotsetups(iijjii) = 1;

    axis(handles.axes1,'off')
    axis(handles.axes2,'off')
    axis(handles.axes4,'off')
    axis(handles.axes3,'off')

    % Plot and insert the images
    assist_plot

    ax = handles.axes2;
    InsertSaveImage_FourViews(ax, selection, baseFileName, save_path);
    generated_figures{end+1} = baseFileName;
end

% PLOT REFERENCES
if ~runGlobalOSP
    selection.InsertBreak(7); % 7 = wdPageBreak

    selection.Font.Underline = true; % Enable underline
    selection.TypeText(['References']); % Insert the text
    selection.TypeParagraph; % Move to a new paragraph after the text
    selection.Font.Underline = false;

    PROJECT_OSP.Style_Options.styleplot.Plotsetups = backup_Plotsetups*0;
    PROJECT_OSP.Style_Options.styleplot.Plotref = 1;

    axis(handles.axes1,'off')
    axis(handles.axes2,'off')
    axis(handles.axes4,'off')
    axis(handles.axes3,'off')

    % Plot and insert the images
    assist_plot
    baseFileName = 'References';
    ax = handles.axes2;
    InsertSaveImage_FourViews(ax, selection, baseFileName, save_path);
    generated_figures{end+1} = baseFileName;
end

%% Delete generated figures
if save_figures == 0
    for i = 1:length(generated_figures)
        baseFileName = generated_figures{i}; % Extract filename
        searchPattern = [baseFileName, '*'];
        files = dir(fullfile(save_path, searchPattern));
        for k = 1:length(files)
            fileToDelete = fullfile(save_path, files(k).name);
            if endsWith(fileToDelete, '.png')
                delete(fileToDelete);
            end
        end
    end
end

%% Restore default variables
PROJECT_OSP.Style_Options.styleplot.Plotsetups = backup_Plotsetups;
PROJECT_OSP.Style_Options.styleplot.Plotref = backup_Plotref;

%% Update Table of Contents
doc.TablesOfContents.Item(1).Update;  % Item(1) because there's only one ToC

%% Save the document and close Word
doc.SaveAs2(FileName);

% Close Word application
doc.Close(false); % Close the document without prompt
wordApp.Quit; % Quit Word
wordApp.delete; % Delete COM server
msgbox(['Document saved to: ', FileName], 'Save Confirmation', 'help');