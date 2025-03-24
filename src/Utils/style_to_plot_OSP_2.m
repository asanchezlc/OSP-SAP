%%
%{
% Structure of DEFAULT_STYLE:

% DEFAULT_STYLE
% ??? geometry
% ?   ??? colorplane
% ??? Style_Options
%     ??? styleplot
%     ?   ??? Plotref
%     ?   ??? sensorstyle
%     ?   ?   ??? Color
%     ?   ?   ??? LineStyle
%     ?   ?   ??? length
%     ?   ?   ??? width
%     ?   ?   ??? widtharrow
%     ?   ?   ??? heightarrow
%     ?   ??? OSPsensorstyle
%     ?   ?   ??? Color
%     ?   ?   ??? length
%     ?   ?   ??? width
%     ?   ?   ??? widtharrow
%     ?   ?   ??? heightarrow
%     ?   ??? CADsensors (same as OSPsensorstyle)
%     ?   ??? stylenodes
%     ?   ?   ??? MarkerFaceColor
%     ?   ?   ??? LineStyle
%     ?   ?   ??? Marker
%     ?   ?   ??? MarkerSize
%     ?   ?   ??? Color
%     ?   ??? stylelinenorm
%     ?   ?   ??? LineStyle
%     ?   ?   ??? LineWidth
%     ?   ?   ??? Color
%     ?   ??? stylelinenorm2
%     ?   ?   ??? LineStyle
%     ?   ?   ??? LineWidth
%     ?   ?   ??? Color
%     ?   ??? stylesensors
%     ?   ?   ??? MarkerFaceColor
%     ?   ?   ??? LineStyle
%     ?   ?   ??? Marker
%     ?   ?   ??? MarkerSize
%     ?   ?   ??? Color
%     ?   ??? REFsensorstyle
%     ?       ??? Color
%     ?       ??? length
%     ?       ??? width
%     ?       ??? widtharrow
%     ?       ??? heightarrow
%     ??? labelplot
%         ??? labelnodes
%         ??? nodeFontsize
%         ??? stylelinenorm
%         ??? lineFontsize
%         ??? sensorstyle
%         ??? sensorFontsize
%         ??? OSPsensorstyle
%         ??? OSPFontsize
%         ??? REFFontsize
%         ??? reflabels
%         ??? CAD_labels
%         ??? OSP_labels
%         ??? CADFontsize
%}
%%
DEFAULT_STYLE = struct();

stylenodes.MarkerFaceColor = [0 0 1];
stylenodes.LineStyle = 'none';
stylenodes.Marker = 'o';
stylenodes.MarkerSize = 5;
stylenodes.Color = [0 0 0];

stylelinenorm.LineStyle = '-';
stylelinenorm.LineWidth = 1;
stylelinenorm.Color = [0.5 0.5 0.5];

stylelinenorm2.LineStyle = '--';
stylelinenorm2.LineWidth = 1;
stylelinenorm2.Color = [0.9 0.9 0.9];

stylesensors.MarkerFaceColor = [1 0 0];
stylesensors.LineStyle = 'none';
stylesensors.Marker = 'o';
stylesensors.MarkerSize = 8;
stylesensors.Color = [0 0 0];

% Sensor
sensorstyle.Color = 'r';
sensorstyle.LineStyle = 'none';
sensorstyle.length = 2;
sensorstyle.width = 1;
sensorstyle.widtharrow = 1;
sensorstyle.heightarrow = 1;

% OSP Sensor
OSPsensorstyle.Color = 'r';
OSPsensorstyle.length = 2;
OSPsensorstyle.width = 1;
OSPsensorstyle.widtharrow = 1;
OSPsensorstyle.heightarrow = 1;

% CAD sensors
CADsensorstyle.Color = 'r';
CADsensorstyle.length = 2;
CADsensorstyle.width = 1;
CADsensorstyle.widtharrow = 1;
CADsensorstyle.heightarrow = 1;

% References
REFsensorstyle.Color = 'm';
REFsensorstyle.length = 2;
REFsensorstyle.width = 1;
REFsensorstyle.widtharrow = 1;
REFsensorstyle.heightarrow = 1;

Plotref = 1;

% Labels
labelplot.labelnodes = 0;
labelplot.nodeFontsize = 7;
labelplot.stylelinenorm = 1;
labelplot.lineFontsize = 7;
labelplot.sensorstyle = 1;
labelplot.sensorFontsize = 7;
labelplot.OSPsensorstyle = 0;
labelplot.OSPFontsize = 7;
labelplot.REFFontsize = 4;
labelplot.reflabels = 1;
labelplot.CAD_labels = 1;
labelplot.OSP_labels = 1;
labelplot.OSPFontsize = 8;
labelplot.CADFontsize = 1;

DEFAULT_STYLE.geometry.colorplane = [];
DEFAULT_STYLE.Style_Options.styleplot.Plotref = Plotref;
DEFAULT_STYLE.Style_Options.styleplot.sensorstyle = sensorstyle;
DEFAULT_STYLE.Style_Options.styleplot.OSPsensorstyle = OSPsensorstyle;
DEFAULT_STYLE.Style_Options.styleplot.CADsensors = CADsensorstyle;
DEFAULT_STYLE.Style_Options.styleplot.stylenodes = stylenodes;
DEFAULT_STYLE.Style_Options.styleplot.stylelinenorm = stylelinenorm;
DEFAULT_STYLE.Style_Options.styleplot.stylelinenorm2 = stylelinenorm2;
DEFAULT_STYLE.Style_Options.styleplot.stylesensors = stylesensors;
DEFAULT_STYLE.Style_Options.styleplot.REFsensorstyle = REFsensorstyle;
DEFAULT_STYLE.Style_Options.labelplot = labelplot;

%% Check if auto-fill complete sub-structures
if ~isfield(PROJECT_OSP, 'geometry') || ~isfield(PROJECT_OSP.geometry, 'colorplane')
    PROJECT_OSP.geometry.colorplane = DEFAULT_STYLE.geometry.colorplane;
end

if ~isfield(PROJECT_OSP, 'Style_Options')
    PROJECT_OSP.Style_Options = DEFAULT_STYLE.Style_Options;
end

if ~isfield(PROJECT_OSP.Style_Options, 'styleplot')
    PROJECT_OSP.Style_Options.styleplot = DEFAULT_STYLE.Style_Options.styleplot;
end

if ~isfield(PROJECT_OSP.Style_Options, 'labelplot')
    PROJECT_OSP.Style_Options.labelplot = DEFAULT_STYLE.Style_Options.labelplot;
end

%% Fill items of each sub-structure in styleplot
fieldNames = fieldnames(DEFAULT_STYLE.Style_Options.styleplot);
for i = 1:length(fieldNames)
    fieldName = fieldNames{i}; % Get the current field name
    if strcmp(fieldName, 'Plotref')
        continue
    end
    fieldValue = DEFAULT_STYLE.Style_Options.styleplot.(fieldName); % Access the value of the current field
    
    if ~isfield(PROJECT_OSP.Style_Options.styleplot, fieldName)
        PROJECT_OSP.Style_Options.styleplot.(fieldName) = DEFAULT_STYLE.Style_Options.styleplot.(fieldName);
    else
        fieldNames2 = fieldnames(DEFAULT_STYLE.Style_Options.styleplot.(fieldName));
        for j=1:length(fieldNames2)
            fieldName2 = fieldNames2{j};
            if ~isfield(PROJECT_OSP.Style_Options.styleplot.(fieldName), fieldName2)
                PROJECT_OSP.Style_Options.styleplot.(fieldName).(fieldName2) = DEFAULT_STYLE.Style_Options.styleplot.(fieldName).(fieldName2);
            end
        end
    end
end

%% Fill items of each sub-structure in labelplot
fieldNames = fieldnames(DEFAULT_STYLE.Style_Options.labelplot);
for i = 1:length(fieldNames)
    fieldName = fieldNames{i}; % Get the current field name
    fieldValue = DEFAULT_STYLE.Style_Options.labelplot.(fieldName); % Access the value of the current field
    if ~isfield(PROJECT_OSP.Style_Options.labelplot, fieldName)
        PROJECT_OSP.Style_Options.labelplot.(fieldName) = DEFAULT_STYLE.Style_Options.labelplot.(fieldName);
    end
end

%%
assignin('base', 'PROJECT_OSP', PROJECT_OSP);
    