function varargout = style_OSP(varargin)
% STYLE_OSP MATLAB code for style_OSP.fig
%      STYLE_OSP, by itself, creates a new STYLE_OSP or raises the existing
%      singleton*.
%
%      H = STYLE_OSP returns the handle to a new STYLE_OSP or the handle to
%      the existing singleton*.
%
%      STYLE_OSP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in STYLE_OSP.M with the given input arguments.
%
%      STYLE_OSP('Property','Value',...) creates a new STYLE_OSP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before style_OSP_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to style_OSP_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help style_OSP

% Last Modified by GUIDE v2.5 17-Feb-2025 17:39:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @style_OSP_OpeningFcn, ...
    'gui_OutputFcn',  @style_OSP_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before style_OSP is made visible.
function style_OSP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to style_OSP (see VARARGIN)

% Choose default command line output for style_OSP
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% LOGOS
try
    warning('off','all')
    javaFrame = get(hObject,'JavaFrame');
    warning('on','all')
    p = mfilename('fullpath');
    k = strfind(p, [filesep 'Utils']);
    filename = [p(1:k-1) filesep 'Logos' filesep 'Logo_OSP.jpg'];
    RGB = imread(filename);
    javaImage = im2java(RGB);
    javaFrame.setFigureIcon(javax.swing.ImageIcon(filename));
end


PROJECT_OSP = evalin('base', 'PROJECT_OSP');

style_to_plot_OSP_2

styleplot = PROJECT_OSP.Style_Options.styleplot;
labelplot = PROJECT_OSP.Style_Options.labelplot;

set(handles.pushbutton13,'BackGroundColor',styleplot.stylelinenorm.Color)
set(handles.pushbutton14,'BackGroundColor',styleplot.stylelinenorm2.Color)
set(handles.pushbutton1,'BackGroundColor',styleplot.stylenodes.Color)
set(handles.pushbutton9,'BackGroundColor',styleplot.stylenodes.MarkerFaceColor)

handles.popupmenu6.Value = find(contains(handles.popupmenu6.String,styleplot.OSPsensorstyle.Color));
handles.popupmenu9.Value = find(contains(handles.popupmenu9.String,styleplot.REFsensorstyle.Color));

if ~isfield(PROJECT_OSP.Style_Options.styleplot,'CADsensors')
    PROJECT_OSP.Style_Options.styleplot.CADsensors.length = PROJECT_OSP.Style_Options.styleplot.OSPsensorstyle.length;
    PROJECT_OSP.Style_Options.styleplot.CADsensors.width = PROJECT_OSP.Style_Options.styleplot.OSPsensorstyle.width;
    PROJECT_OSP.Style_Options.styleplot.CADsensors.widtharrow = PROJECT_OSP.Style_Options.styleplot.OSPsensorstyle.widtharrow;
    PROJECT_OSP.Style_Options.styleplot.CADsensors.heightarrow = PROJECT_OSP.Style_Options.styleplot.OSPsensorstyle.heightarrow;
    assignin('base','PROJECT_OSP',PROJECT_OSP)
end
if ~isfield(labelplot,'CAD_labels')
    labelplot.CAD_labels = labelplot.OSP_labels;
    assignin('base','PROJECT_OSP',PROJECT_OSP)
end
if ~isfield(labelplot,'CADFontsize')
    labelplot.CADFontsize = labelplot.OSPFontsize;
    assignin('base','PROJECT_OSP',PROJECT_OSP)
end
if ~isfield(PROJECT_OSP.Style_Options.styleplot,'colormp')
    PROJECT_OSP.Style_Options.styleplot.colormp = 1;
end

styleplot = PROJECT_OSP.Style_Options.styleplot;

set(handles.edit21,'String',num2str(styleplot.CADsensors.length));
set(handles.edit23,'String',num2str(styleplot.CADsensors.heightarrow));
set(handles.edit22,'String',num2str(styleplot.CADsensors.width));
set(handles.edit24,'String',num2str(styleplot.CADsensors.widtharrow));

set(handles.edit1,'String',num2str(styleplot.OSPsensorstyle.length));
set(handles.edit3,'String',num2str(styleplot.OSPsensorstyle.heightarrow));
set(handles.edit2,'String',num2str(styleplot.OSPsensorstyle.width));
set(handles.edit4,'String',num2str(styleplot.OSPsensorstyle.widtharrow));

set(handles.edit15,'String',num2str(styleplot.REFsensorstyle.length));
set(handles.edit17,'String',num2str(styleplot.REFsensorstyle.heightarrow));
set(handles.edit16,'String',num2str(styleplot.REFsensorstyle.width));
set(handles.edit18,'String',num2str(styleplot.REFsensorstyle.widtharrow));

set(handles.edit5,'String',num2str(styleplot.stylenodes.MarkerSize));
set(handles.edit19,'String',num2str(styleplot.stylelinenorm.LineWidth));
set(handles.edit20,'String',num2str(styleplot.stylelinenorm2.LineWidth));

IndexC = strfind(handles.popupmenu1.String,styleplot.stylenodes.Marker);
Index = find(not(cellfun('isempty',IndexC)));
set(handles.popupmenu1,'Value',Index)

IndexC = strfind(handles.popupmenu15.String,styleplot.stylelinenorm.LineStyle);
Index = find(not(cellfun('isempty',IndexC)));
txt=handles.popupmenu15.String;
for i=1:numel(Index)
    if strcmp(char(txt(Index(i))),styleplot.stylelinenorm.LineStyle)==1
        set(handles.popupmenu15,'Value',Index(i))
    end
end

IndexC = strfind(handles.popupmenu16.String,styleplot.stylelinenorm2.LineStyle);
Index = find(not(cellfun('isempty',IndexC)));
txt=handles.popupmenu16.String;
for i=1:numel(Index)
    if strcmp(char(txt(Index(i))),styleplot.stylelinenorm2.LineStyle)==1
        set(handles.popupmenu16,'Value',Index(i))
    end
end

handles.popupmenu19.Value = PROJECT_OSP.Style_Options.styleplot.colormp;
handles.popupmenu10.Value = find(cellfun(@(x) str2double(x),handles.popupmenu10.String)==labelplot.nodeFontsize);
handles.popupmenu12.Value = find(cellfun(@(x) str2double(x),handles.popupmenu12.String)==labelplot.OSPFontsize);
handles.popupmenu18.Value = find(cellfun(@(x) str2double(x),handles.popupmenu18.String)==labelplot.CADFontsize);
handles.popupmenu13.Value = find(cellfun(@(x) str2double(x),handles.popupmenu13.String)==labelplot.REFFontsize);

% % Allow maximize/minimize (aslc 19/02/25)
% set(hObject, 'Resize', 'on');                 % Enable resizing
% set(hObject, 'WindowStyle', 'normal');        % Ensure normal behavior
% set(hObject, 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);  % Maximize

if labelplot.labelnodes==1
    handles.radiobutton1.Value=1;
end
if labelplot.stylelinenorm==1
    handles.radiobutton2.Value=1;
end
if labelplot.OSP_labels==1
    handles.radiobutton3.Value=1;
end
if labelplot.CAD_labels==1
    handles.radiobutton10.Value=1;
end
if labelplot.reflabels==1
    handles.radiobutton6.Value=1;
end

% UIWAIT makes style_OSP wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = style_OSP_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PROJECT_OSP = evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

c = uisetcolor;
if numel(c) == 3
    set(hObject,'BackGroundColor',c)
    
    styleplot.stylenodes.Color = c;
    PROJECT_OSP.Style_Options.styleplot = styleplot;
    assignin('base', 'PROJECT_OSP', PROJECT_OSP);
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

c = uisetcolor;
if c  ~= 0
    set(hObject,'BackGroundColor',c)
    
    styleplot.colorplanestyle.Color=c;
    PROJECT_OSP.Style_Options.styleplot=styleplot;
    assignin('base', 'PROJECT_OSP', PROJECT_OSP);
end


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

c = uisetcolor;
if c  ~= 0
    set(hObject,'BackGroundColor',c)
    
    styleplot.rigiplanestyle.Color=c;
    PROJECT_OSP.Style_Options.styleplot=styleplot;
    assignin('base', 'PROJECT_OSP', PROJECT_OSP);
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

c = uisetcolor;
if numel(c) == 3
    set(hObject,'BackGroundColor',c)
    
    styleplot.stylelinenorm.Color=c;
    PROJECT_OSP.Style_Options.styleplot=styleplot;
    assignin('base', 'PROJECT_OSP', PROJECT_OSP);
end

% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

styleplot.colorplanestyle.FaceAlpha=hObject.Value;
PROJECT_OSP.Style_Options.styleplot=styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

styleplot.rigiplanestyle.FaceAlpha=hObject.Value;
PROJECT_OSP.Style_Options.styleplot=styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);





% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6

PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

options=hObject.String;
styleplot.OSPsensorstyle.Color=char(options(handles.popupmenu6.Value));
PROJECT_OSP.Style_Options.styleplot=styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
PROJECT_OSP = evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

styleplot.OSPsensorstyle.length = str2double(hObject.String);
PROJECT_OSP.Style_Options.styleplot = styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
PROJECT_OSP = evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

styleplot.OSPsensorstyle.width = str2double(hObject.String);
PROJECT_OSP.Style_Options.styleplot = styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double
PROJECT_OSP = evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

styleplot.OSPsensorstyle.heightarrow = str2double(hObject.String);
PROJECT_OSP.Style_Options.styleplot = styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
PROJECT_OSP = evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

styleplot.OSPsensorstyle.widtharrow = str2double(hObject.String);
PROJECT_OSP.Style_Options.styleplot = styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

options=hObject.String;
styleplot.linkstyle.Marker=char(options(hObject.Value));
PROJECT_OSP.Style_Options.styleplot=styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

options=hObject.String;
styleplot.linkstyle2.Marker=char(options(hObject.Value));
PROJECT_OSP.Style_Options.styleplot=styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

options=hObject.String;
styleplot.stylelinenorm.LineStyle=char(options(hObject.Value));
PROJECT_OSP.Style_Options.styleplot=styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

c = uisetcolor;
if numel(c) == 3
    set(hObject,'BackGroundColor',c)
    
    styleplot.gridstyle.Color=c;
    PROJECT_OSP.Style_Options.styleplot=styleplot;
    assignin('base', 'PROJECT_OSP', PROJECT_OSP);
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

options=hObject.String;
styleplot.gridstyle.LineStyle=char(options(hObject.Value));
PROJECT_OSP.Style_Options.styleplot=styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

options=hObject.String;
styleplot.stylenodes.Marker=char(options(hObject.Value));
PROJECT_OSP.Style_Options.styleplot=styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

styleplot.stylelinenorm.LineWidth=str2double(hObject.String);
PROJECT_OSP.Style_Options.styleplot=styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

styleplot.stylenodes.MarkerSize=str2double(hObject.String);
PROJECT_OSP.Style_Options.styleplot=styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

c = uisetcolor;
if numel(c) == 3
    set(hObject,'BackGroundColor',c)
    
    styleplot.stylenodes.MarkerFaceColor=c;
    PROJECT_OSP.Style_Options.styleplot=styleplot;
    assignin('base', 'PROJECT_OSP', PROJECT_OSP);
end

% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
PROJECT_OSP = evalin('base', 'PROJECT_OSP');
labelplot = PROJECT_OSP.Style_Options.labelplot;

if hObject.Value==1
    labelplot.OSP_labels = 1;
else
    labelplot.OSP_labels = 0;
end

PROJECT_OSP.Style_Options.labelplot = labelplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
labelplot = PROJECT_OSP.Style_Options.labelplot;

if hObject.Value==1
    labelplot.stylelinenorm=1;
else
    labelplot.stylelinenorm=0;
end

PROJECT_OSP.Style_Options.labelplot=labelplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
labelplot = PROJECT_OSP.Style_Options.labelplot;

if hObject.Value==1
    labelplot.labelnodes=1;
else
    labelplot.labelnodes=0;
end

PROJECT_OSP.Style_Options.labelplot=labelplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);


% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
labelplot = PROJECT_OSP.Style_Options.labelplot;

if hObject.Value==1
    labelplot.reflabels = 1;
else
    labelplot.reflabels = 0;
end

PROJECT_OSP.Style_Options.labelplot=labelplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes on selection change in popupmenu13.
function popupmenu13_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu13 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu13
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
labelplot = PROJECT_OSP.Style_Options.labelplot;
%labelplot.insensorFontsize = str2double(handles.popupmenu13.String(handles.popupmenu13.Value));
labelplot.REFFontsize = str2double(handles.popupmenu13.String(handles.popupmenu13.Value));
PROJECT_OSP.Style_Options.labelplot=labelplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);



% --- Executes during object creation, after setting all properties.
function popupmenu13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu12.
function popupmenu12_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu12
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
labelplot = PROJECT_OSP.Style_Options.labelplot;
labelplot.OSPFontsize = str2double(handles.popupmenu12.String(handles.popupmenu12.Value));
PROJECT_OSP.Style_Options.labelplot = labelplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);


% --- Executes during object creation, after setting all properties.
function popupmenu12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu11.
function popupmenu11_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu11
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
labelplot = PROJECT_OSP.Style_Options.labelplot;
labelplot.lineFontsize = str2double(handles.popupmenu11.String(handles.popupmenu11.Value));
PROJECT_OSP.Style_Options.labelplot=labelplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes during object creation, after setting all properties.
function popupmenu11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu10.
function popupmenu10_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu10
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
labelplot = PROJECT_OSP.Style_Options.labelplot;
labelplot.nodeFontsize = str2double(handles.popupmenu10.String(handles.popupmenu10.Value));
PROJECT_OSP.Style_Options.labelplot=labelplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);


% --- Executes during object creation, after setting all properties.
function popupmenu10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu9.
function popupmenu9_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu9 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu9

PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

options=hObject.String;
%styleplot.insensorstyle.Color=char(options(hObject.Value));
styleplot.REFsensorstyle.Color=char(options(hObject.Value));
PROJECT_OSP.Style_Options.styleplot=styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes during object creation, after setting all properties.
function popupmenu9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit15_Callback(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit15 as text
%        str2double(get(hObject,'String')) returns contents of edit15 as a double
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

%styleplot.insensorstyle.length=str2double(hObject.String);
styleplot.REFsensorstyle.length=str2double(hObject.String);
PROJECT_OSP.Style_Options.styleplot=styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);



% --- Executes during object creation, after setting all properties.
function edit15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit16_Callback(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit16 as text
%        str2double(get(hObject,'String')) returns contents of edit16 as a double
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

%styleplot.insensorstyle.width=str2double(hObject.String);
styleplot.REFsensorstyle.width=str2double(hObject.String);
PROJECT_OSP.Style_Options.styleplot=styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);


% --- Executes during object creation, after setting all properties.
function edit16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit17_Callback(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit17 as text
%        str2double(get(hObject,'String')) returns contents of edit17 as a double
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

%styleplot.insensorstyle.heightarrow=str2double(hObject.String);
styleplot.REFsensorstyle.heightarrow=str2double(hObject.String);
PROJECT_OSP.Style_Options.styleplot=styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);



% --- Executes during object creation, after setting all properties.
function edit17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit18_Callback(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit18 as text
%        str2double(get(hObject,'String')) returns contents of edit18 as a double
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

%styleplot.insensorstyle.widtharrow=str2double(hObject.String);
styleplot.REFsensorstyle.widtharrow=str2double(hObject.String);
PROJECT_OSP.Style_Options.styleplot=styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);


% --- Executes during object creation, after setting all properties.
function edit18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

c = uisetcolor;
if numel(c) == 3
    handles.pushbutton11.BackgroundColor = c;
    styleplot.colorplanestyle.edgeColor = c;
    PROJECT_OSP.Style_Options.styleplot = styleplot;
    assignin('base', 'PROJECT_OSP', PROJECT_OSP);
end



% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

c = uisetcolor;
if numel(c) == 3
    handles.pushbutton10.BackgroundColor = c;
    styleplot.rigidplanestyle.edgeColor = c;
    PROJECT_OSP.Style_Options.styleplot = styleplot;
    assignin('base', 'PROJECT_OSP', PROJECT_OSP);
end


% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

if handles.radiobutton8.Value == 1
    styleplot.colorplanestyle.edgeColor = 'none';
    set(handles.text44,'enable','off')
    set(handles.pushbutton11,'enable','off')
else
    styleplot.colorplanestyle.edgeColor = handles.pushbutton11.BackgroundColor;
    set(handles.text44,'enable','on')
    set(handles.pushbutton11,'enable','on')
end

PROJECT_OSP.Style_Options.styleplot = styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7

if handles.radiobutton7.Value == 0
    set(handles.text43,'enable','on')
    set(handles.pushbutton10,'enable','on')
else
    set(handles.text43,'enable','off')
    set(handles.pushbutton10,'enable','off')
end


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

c = uisetcolor;
if numel(c) == 3
    set(hObject,'BackGroundColor',c)
    
    styleplot.axesStyle.Color=c;
    PROJECT_OSP.Style_Options.styleplot=styleplot;
    assignin('base', 'PROJECT_OSP', PROJECT_OSP);
end


% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton9
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

styleplot.axesStyle.Hide = handles.radiobutton9.Value;
PROJECT_OSP.Style_Options.styleplot=styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes on selection change in popupmenu14.
function popupmenu14_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu14 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu14
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

styleplot.axesStyle.FontSize = str2double(handles.popupmenu14.String(handles.popupmenu14.Value));
PROJECT_OSP.Style_Options.styleplot=styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);


% --- Executes during object creation, after setting all properties.
function popupmenu14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit19_Callback(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit19 as text
%        str2double(get(hObject,'String')) returns contents of edit19 as a double
PROJECT_OSP = evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

styleplot.stylelinenorm.LineWidth = str2double(hObject.String);
PROJECT_OSP.Style_Options.styleplot = styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);


% --- Executes during object creation, after setting all properties.
function edit19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PROJECT_OSP = evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

c = uisetcolor;
if numel(c) == 3
    set(hObject,'BackGroundColor',c)
    
    styleplot.stylelinenorm.Color = c;
    PROJECT_OSP.Style_Options.styleplot=styleplot;
    assignin('base', 'PROJECT_OSP', PROJECT_OSP);
end

% --- Executes on selection change in popupmenu15.
function popupmenu15_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu15 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu15
PROJECT_OSP = evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

options=hObject.String;
styleplot.stylelinenorm.LineStyle = char(options(hObject.Value));
PROJECT_OSP.Style_Options.styleplot=styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes during object creation, after setting all properties.
function popupmenu15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit20_Callback(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit20 as text
%        str2double(get(hObject,'String')) returns contents of edit20 as a double


% --- Executes during object creation, after setting all properties.
function edit20_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu16.
function popupmenu16_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu16 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu16


% --- Executes during object creation, after setting all properties.
function popupmenu16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu18.
function popupmenu18_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu18 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu18
PROJECT_OSP=evalin('base', 'PROJECT_OSP');
labelplot = PROJECT_OSP.Style_Options.labelplot;
labelplot.CADFontsize = str2double(handles.popupmenu18.String(handles.popupmenu18.Value));
PROJECT_OSP.Style_Options.labelplot = labelplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes during object creation, after setting all properties.
function popupmenu18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit21_Callback(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit21 as text
%        str2double(get(hObject,'String')) returns contents of edit21 as a double
PROJECT_OSP = evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

styleplot.CADsensors.length = str2double(hObject.String);
PROJECT_OSP.Style_Options.styleplot = styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes during object creation, after setting all properties.
function edit21_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit22_Callback(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit22 as text
%        str2double(get(hObject,'String')) returns contents of edit22 as a double
PROJECT_OSP = evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

styleplot.CADsensors.width = str2double(hObject.String);
PROJECT_OSP.Style_Options.styleplot = styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);


% --- Executes during object creation, after setting all properties.
function edit22_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit23 as text
%        str2double(get(hObject,'String')) returns contents of edit23 as a double
PROJECT_OSP = evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

styleplot.CADsensors.heightarrow = str2double(hObject.String);
PROJECT_OSP.Style_Options.styleplot = styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit24 as text
%        str2double(get(hObject,'String')) returns contents of edit24 as a double
PROJECT_OSP = evalin('base', 'PROJECT_OSP');
styleplot = PROJECT_OSP.Style_Options.styleplot;

styleplot.CADsensors.widtharrow = str2double(hObject.String);
PROJECT_OSP.Style_Options.styleplot = styleplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton10.
function radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton10
PROJECT_OSP = evalin('base', 'PROJECT_OSP');
labelplot = PROJECT_OSP.Style_Options.labelplot;

if hObject.Value==1
    labelplot.CAD_labels = 1;
else
    labelplot.CAD_labels = 0;
end

PROJECT_OSP.Style_Options.labelplot = labelplot;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);


% --- Executes on selection change in popupmenu19.
function popupmenu19_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu19 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu19

PROJECT_OSP=evalin('base', 'PROJECT_OSP');
PROJECT_OSP.Style_Options.styleplot.colormp = handles.popupmenu19.Value;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

% --- Executes during object creation, after setting all properties.
function popupmenu19_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PROJECT_OSP = evalin('base', 'PROJECT_OSP');
save_figures = get(hObject,'Value');
PROJECT_OSP.config.WordReport.save_figures = save_figures;
assignin('base', 'PROJECT_OSP', PROJECT_OSP);


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% Retrieve current PROJECT_OSP
PROJECT_OSP = evalin('base', 'PROJECT_OSP');

% Open folder selection dialog
folderPath = uigetdir('', 'Select Save Folder');

% If the user selected a folder (and did not cancel)
if folderPath ~= 0
    % Store the selected folder path
    PROJECT_OSP.config.WordReport.Path = folderPath;

    % Update button text (truncate if necessary)
    maxLength = 70;
    if length(folderPath) > maxLength
        displayPath = ['...', folderPath(end-maxLength+3:end)];
    else
        displayPath = folderPath;
    end
    set(hObject, 'String', displayPath);

    % Store updated PROJECT_OSP back in the base workspace
    assignin('base', 'PROJECT_OSP', PROJECT_OSP);
end
