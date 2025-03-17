function varargout = OSP_GUI(varargin)
% OSP_GUI MATLAB code for OSP_GUI.fig
%      OSP_GUI, by itself, creates a new OSP_GUI or raises the existing
%      singleton*.
%
%      H = OSP_GUI returns the handle to a new OSP_GUI or the handle to
%      the existing singleton*.
%
%      OSP_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OSP_GUI.M with the given input arguments.
%
%      OSP_GUI('Property','Value',...) creates a new OSP_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OSP_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OSP_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OSP_GUI

% Last Modified by GUIDE v2.5 22-Nov-2024 10:16:44


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @OSP_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @OSP_GUI_OutputFcn, ...
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


% --- Executes just before OSP_GUI is made visible.
function OSP_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OSP_GUI (see VARARGIN)

% LOGOS
try
    warning('off','all')
    javaFrame = get(hObject,'JavaFrame');
    warning('on','all')
    p = mfilename('fullpath');
    %k = strfind(p,'\OSP_GUI');
    k = strfind(p, [filesep 'OSP_GUI']);
    %filename=[p(1:k-1) '\Logos\Logo_OSP.jpg'];
    filename=[p(1:k-1) filesep 'Logos' filesep 'Logo_OSP.jpg'];
    RGB = imread(filename);
    javaImage = im2java(RGB);
    javaFrame.setFigureIcon(javax.swing.ImageIcon(filename));
end


p = mfilename('fullpath');
%k = strfind(p,'\OSP_GUI');
k = strfind(p, [filesep 'OSP_GUI']);
%filename=[p(1:k-1) '\Logos\XYZ_axes.jpg'];
filename=[p(1:k-1) filesep 'Logos' filesep 'XYZ_axes.jpg'];
[X,map] = imread(filename);
X=imresize(X, [15 15]);
set(handles.pushbutton16, 'CData', X);

p = mfilename('fullpath');
%k = strfind(p,'\OSP_GUI');
k = strfind(p, [filesep 'OSP_GUI']);
%filename=[p(1:k-1) '\Logos\XY_axes.jpg'];
filename=[p(1:k-1) filesep 'Logos' filesep 'XY_axes.jpg'];
[X,map] = imread(filename);
X=imresize(X, [15 15]);
set(handles.pushbutton17, 'CData', X);

p = mfilename('fullpath');
% k = strfind(p,'\OSP_GUI');
k = strfind(p, [filesep 'OSP_GUI']);
%filename=[p(1:k-1) '\Logos\XZ_axes.jpg'];
filename=[p(1:k-1) filesep 'Logos' filesep 'XZ_axes.jpg'];
[X,map] = imread(filename);
X=imresize(X, [15 15]);
set(handles.pushbutton18, 'CData', X);

p = mfilename('fullpath');
%k = strfind(p,'\OSP_GUI');
k = strfind(p, [filesep 'OSP_GUI']);
%filename=[p(1:k-1) '\Logos\YZ_axes.jpg'];
filename=[p(1:k-1) filesep 'Logos' filesep 'YZ_axes.jpg'];
[X,map] = imread(filename);
X=imresize(X, [15 15]);
set(handles.pushbutton19, 'CData', X);


handles.pushbutton8.String = '<HTML>&#128269';
handles.pushbutton10.String = '<HTML>&#x21b7;';
handles.pushbutton11.String = '<HTML>&#9995';
handles.pushbutton13.String = '<HTML>&#9654';
handles.pushbutton14.String = '<HTML>&#x2190';
handles.pushbutton15.String = '<HTML>&#x2192';
handles.pushbutton20.String = '<HTML>&#x2602';

topcolor = [1,1,1];
bottomcolor = [0.9,0.9,1];

ax = handles.axes1;
lim = axis(ax);
xdata = [lim(1) lim(2) lim(2) lim(1)];
ydata = [lim(3) lim(3) lim(4) lim(4)];
cdata(1,1,:) = bottomcolor;
cdata(1,2,:) = bottomcolor;
cdata(1,3,:) = topcolor;
cdata(1,4,:) = topcolor;
p = patch(xdata,ydata,'k','Parent',ax);
set(p,'CData',cdata, ...
    'FaceColor','interp', ...
    'EdgeColor','none');
uistack(p,'bottom')

handles.axes4.Color = 'none';
axis(handles.axes1,'off')
axis(handles.axes2,'off')
axis(handles.axes4,'off')
drawnow

% Load project if previously defined
PROJECT_OSP = evalin('base','PROJECT_OSP');
loadproject_OSP

% Choose default command line output for OSP_GUI
handles.output = hObject;

% MAXIMIZE SCREEN
% screenSize = get(0, 'ScreenSize');
% screenSize(3) = screenSize(3)*0.99;
% screenSize(4) = screenSize(4)*0.99;
% set(handles.figure1, 'Units', 'normalized', 'OuterPosition', [0 0.045 1 0.95]);
% set(handles.figure1, 'Units', 'normalized', 'OuterPosition', [0 0 1 1]);
% screenSize = get(0, 'ScreenSize');
% set(handles.figure1, 'Units', 'pixels', 'Position', screenSize);
w = warning ('off','all');
try
    set(handles.figure1,'visible','on');
    drawnow
    frame_h = get(handles.figure1,'JavaFrame');
    set(frame_h,'Maximized',1);
end
w = warning ('on','all');


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OSP_GUI wait for user response (see UIRESUME)
if usejava('desktop')
    uiwait(handles.figure1);
else
    disp('Running in headless mode: skipping uiwait');
end



% --- Outputs from this function are returned to the command line.
function varargout = OSP_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
% varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PROJECT_OSP = evalin('base','PROJECT_OSP');

path = handles.pushbutton3.UserData;

[file,path] = uigetfile([path,'*.xlsx'],'Load file');
filename = fullfile(path,file);

handles.pushbutton3.UserData = path;
if path ~= 0
    PROJECT_OSP.config.SAP_model = filename;
    assignin('base','PROJECT_OSP',PROJECT_OSP)
    hObject.BackgroundColor = [0.98 0.98 0.98];
    hObject.String = filename;
    set(handles.pushbutton12,'enable','on');
end


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PROJECT_OSP=evalin('base','PROJECT_OSP');

path = handles.pushbutton2.UserData;
[file,path] = uigetfile([path,'*.exe'],'Load file');
filename = fullfile(path,file);

handles.pushbutton4.UserData = path;
if path ~= 0
    PROJECT_OSP.config.SAP_Dir = filename;
    assignin('base','PROJECT_OSP',PROJECT_OSP)
    %     hObject.BackgroundColor = [0.98 0.98 0.98];
    hObject.String = filename;
end

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PROJECT_OSP = evalin('base','PROJECT_OSP');

path = handles.pushbutton3.UserData;
[file,path] = uigetfile([path,'*.dll'],'Load file');
filename = fullfile(path,file);

handles.pushbutton6.UserData = path;
if path ~= 0
    PROJECT_OSP.config.SAP_dll_Dir = filename;
    assignin('base','PROJECT_OSP',PROJECT_OSP)
    %     hObject.BackgroundColor = [0.98 0.98 0.98];
    hObject.String = filename;
end

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if any(cell2mat(handles.uitable1.Data(:,2))) == 0
    f = errordlg('At least one mode must be selected!','Error');
    return
end
set(handles.text18,'visible','on');
drawnow
PROJECT_OSP = evalin('base','PROJECT_OSP');
PROJECT_OSP.config.method = cell2mat(handles.popupmenu3.String(handles.popupmenu3.Value));
PROJECT_OSP.config.Target_DOFs(1) = handles.radiobutton1.Value;
PROJECT_OSP.config.Target_DOFs(2) = handles.radiobutton2.Value;
PROJECT_OSP.config.Target_DOFs(3) = handles.radiobutton3.Value;
handles.text15.String = PROJECT_OSP.config.method;

PROJECT_OSP.config.selmodes = find(cell2mat(handles.uitable1.Data(:,2)));

% -------------------------------------------------------------
% Do not run if the number of DOFs is < number of target modes
% -------------------------------------------------------------
num_target_dofs = sum(PROJECT_OSP.config.Target_DOFs);
unsufficient_dofs = 0;
unsufficient_dofs_setups = [;];
n_target = length(PROJECT_OSP.config.selmodes);
if PROJECT_OSP.geometry.Nsetups == 1
    num_nodes = length(PROJECT_OSP.geometry.candiateNodes);
    num_dofs = num_nodes * num_target_dofs;
    if num_dofs <= n_target
        unsufficient_dofs = 1;
    end
else
    for i=1:PROJECT_OSP.geometry.Nsetups
        setup_label = ['Setup_' num2str(i)];
        num_nodes = length(PROJECT_OSP.geometry.(setup_label));
        num_dofs = num_nodes * num_target_dofs + size(PROJECT_OSP.geometry.References,1);
        if num_dofs <= n_target
            unsufficient_dofs=1;
            unsufficient_dofs_setups = [unsufficient_dofs_setups;[i, num_dofs]];
        end
    end
end

if unsufficient_dofs==1
    if PROJECT_OSP.geometry.Nsetups == 1
        message = ['OSP algorithm cannot run: ' char(10) 'Candidate_DOFs group has ' num2str(num_dofs) ' DOFs defined, but at least the number of target mode shapes (' num2str(n_target) ') plus one are required.' char(10) 'Reduce the number of target modes (or increase the number of DOFs in the SAP2000 model).'];
    else
        setups_as_strings = arrayfun(@num2str, unsufficient_dofs_setups(:,1), 'UniformOutput', false);
        string_setups = strjoin(setups_as_strings, ', ');
        dofs_as_strings = arrayfun(@num2str, unsufficient_dofs_setups(:,2), 'UniformOutput', false);
        string_dofs = strjoin(dofs_as_strings, ', ');
        message = ['OSP algorithm cannot run: ' char(10) 'Setups ' string_setups ' have ' string_dofs ' DOFs defined, but at least the number of target mode shapes (' num2str(n_target) ') are required.' char(10) 'Reduce the number of target modes (or increase the number of DOFs in the SAP2000 model).'];
    end
    f = msgbox(message);
    return % STOP EXECUTION
end
% -------------------------------------------------------------

% -------------------------------------------------------------
% Check how to run
% -------------------------------------------------------------
runGlobalOSP = 1;
try
    existsCandidateDOFs = PROJECT_OSP.config.SAP2000_groups.existsCandidateDOFs;
    existsSetups = PROJECT_OSP.config.SAP2000_groups.existsSetups;
catch
    existsCandidateDOFs = 1;
    existsSetups = 1;
end
if existsSetups && existsCandidateDOFs
    case_opt = 1;
elseif existsCandidateDOFs
    case_opt = 2;
elseif existsSetups
    case_opt = 3;
end

prompt_question = 0;
if (size(PROJECT_OSP.geometry.References,1)>0) && (case_opt == 1 || case_opt == 3)
    prompt_question = 1;
end

if prompt_question
    if case_opt == 1
        % Display a dialog box with two options
        case_opt_text = ['SAP2000 model contains a Candidate_DOFs group and ' num2str(PROJECT_OSP.geometry.Nsetups) ' Setup groups. ' char(10) 'Do you want to run a Global-OSP process (from Candidate_DOFs group) or run a Multisetup one (from Setup_1, ... Setup_' num2str(PROJECT_OSP.geometry.Nsetups) ' groups)?'];
        option_1 = 'Run Global-OSP';
        option_2 = 'Run Multisetup-OSP';
    elseif case_opt == 3
        if size(PROJECT_OSP.geometry.References,1)>0 % ~isfield(PROJECT_OSP.geometry,'References')
            case_opt_text = ['SAP2000 model contains ' num2str(PROJECT_OSP.geometry.Nsetups) ' Setup groups and ' num2str(size(PROJECT_OSP.geometry.References,1)) ' references. ' char(10) 'Do you want to run a Global-OSP process (merging all setups) or run a Multisetup one (with Setup_1, ... Setup_' num2str(PROJECT_OSP.geometry.Nsetups) ' groups and ' num2str(size(PROJECT_OSP.geometry.References,1)) ' references)?'];
            option_1 = 'Run Global-OSP';
            option_2 = 'Run Multisetup-OSP';
        end
    end
    
    choice = questdlg(case_opt_text, ...
        'Type of OSP', ...
        option_1, option_2, option_1);
    
    % Handle response
    switch choice
        case option_1
            runGlobalOSP = 1; % Set the variable for Option 1
        case option_2
            runGlobalOSP = 0; % Set the variable for Option 2
        otherwise
            return; % If user closes the dialog, return
    end
else
    if case_opt == 1
        message = 'A Global-OSP will be run with DOFs from "Candidate_DOFs" SAP2000 group';
    elseif case_opt == 2
        message = 'A Global-OSP will be run with DOFs from "Candidate_DOFs" SAP2000 group';
    elseif case_opt == 3
        message = 'A Global-OSP will be run using all Setup groups as candidate DOFs';
    end
    if usejava('desktop')
        f = msgbox(message);
        uiwait(f); % Wait until the user closes the message box
    else
        disp('Running in headless mode: skipping uiwait');
    end
end

PROJECT_OSP.config.runGlobalOSP = runGlobalOSP;
% -------------------------------------------------------------

% Run OSP
PROJECT_OSP = OSP_run(PROJECT_OSP);

% Select the number of sensors (if there are less nodes than n_modes,
% reduce it)
n_sensors = round(str2double(handles.edit2.String));
if runGlobalOSP
    nsensors_set = cellfun(@(x) size(x,1),PROJECT_OSP.OSP_results.LISTADO_SETUP{1,1});
    n_sensors = min(n_sensors, min(nsensors_set));
else
    for i=1:PROJECT_OSP.geometry.Nsetups
        nsensors_set = cellfun(@(x) size(x,1),PROJECT_OSP.OSP_results.LISTADO_SETUP{1,i});
        n_sensors = min(n_sensors, min(nsensors_set));
    end
end
% for i=1:PROJECT_OSP.geometry.Nsetups
%     nsensors_set = cellfun(@(x) size(x,1),PROJECT_OSP.OSP_results.LISTADO_SETUP{1,i});
%     n_sensors = min(n_sensors, min(nsensors_set));
% end
% if PROJECT_OSP.geometry.Nsetups == 0
%     nsensors_set = cellfun(@(x) size(x,1),PROJECT_OSP.OSP_results.LISTADO_SETUP{1,1});
%     n_sensors = min(n_sensors, min(nsensors_set));
% end

PROJECT_OSP.config.n_sensors = n_sensors;

nsetup = 1;
minED = PROJECT_OSP.OSP_results.LISTADO_SETUP{3,nsetup};


npotential_sensors = numel(minED);
surv_DOF = PROJECT_OSP.OSP_results.LISTADO_SETUP{4,nsetup};
for i = 1:npotential_sensors
    text_i(i) = {int2str(numel(cell2mat(surv_DOF(i))))};
end
handles.popupmenu4.String = text_i;
% ----------------------------------------------------------------------

if ~runGlobalOSP
    if PROJECT_OSP.geometry.Nsetups>0
        set(handles.popupmenu6,'visible','on');
        handles.popupmenu6.String = {};
        for ij = 1:PROJECT_OSP.geometry.Nsetups
            handles.popupmenu6.String(ij) = {['Setup ',int2str(ij)]};
        end
        set(handles.popupmenu6,'enable','on');  % popup menu for setup selection 
        handles.popupmenu6.Value = 1;
    end
else
    set(handles.popupmenu6,'enable','off')
end

nsensors = cellfun(@(x) size(x,1),PROJECT_OSP.OSP_results.LISTADO_SETUP{1,nsetup});
% PROJECT_OSP.config.nsensors = nsensors;
pos = find(nsensors == PROJECT_OSP.config.n_sensors);
handles.popupmenu4.Value = pos;

set(handles.popupmenu1,'visible','off')
set(handles.popupmenu2,'visible','off')
set(handles.slider1,'visible','off')
set(handles.togglebutton2,'visible','on')

cla(handles.axes4)
hold(handles.axes4,'on')
plot(handles.axes4,1:1:numel(minED),minED,'Linewidth',2,'Color','b','Marker','s','MarkerFaceColor',[1,1,1]);
plot(handles.axes4,[pos,pos],[0,minED(pos)],'Linewidth',2,'Color','r','Marker','s','MarkerFaceColor',[1,0,0]);
hold(handles.axes4,'off')
max_num_sensors = 40;
xlim(handles.axes4,[max(1, numel(minED)-max_num_sensors),numel(minED)]); % set variable instead!; before: xlim(handles.axes4,[1,numel(minED)])
handles.edit4.Tooltip = ['Max. N. of sensors: ',int2str(nsensors(1))];
handles.edit4.UserData = [1,numel(minED)];
handles.edit5.UserData = [1,numel(minED)];
xticks(handles.axes4,1:1:numel(minED))
xticklabels(handles.axes4,nsensors)
xlabel(handles.axes4,'N sensors','interpreter','latex')
ylabel(handles.axes4,'min(Ed)','interpreter','latex')
assignin('base','PROJECT_OSP',PROJECT_OSP)

handles.edit4.String = int2str(nsensors(max(1, numel(minED)-max_num_sensors)));
handles.edit5.String = int2str(nsensors(numel(minED)));
set(handles.edit4,'visible','on');
set(handles.edit5,'visible','on');
set(handles.text16,'visible','on');
set(handles.text17,'visible','on');



set(handles.axes2,'visible','off');
set(handles.axes3,'visible','off');
for j = 1:numel(handles.axes2.Children)
    handles.axes2.Children(j).Visible = 'off';
end
for j = 1:numel(handles.axes3.Children)
    handles.axes3.Children(j).Visible = 'off';
end
for j = 1:numel(handles.axes4.Children)
    handles.axes4.Children(j).Visible = 'on';
end
set(handles.axes4,'visible','on');
handles.popupmenu5.Value = 2;  % Set to "Convergence" instead of "Geometry"
handles.axes4.Color = 'none';



confsel = PROJECT_OSP.OSP_results.LISTADO_SETUP{1,nsetup};
EDsel = PROJECT_OSP.OSP_results.LISTADO_SETUP{7,nsetup};
surv_nodes_C = PROJECT_OSP.OSP_results.LISTADO_SETUP{5,nsetup};
surv_dir = PROJECT_OSP.OSP_results.LISTADO_SETUP{6,nsetup};

confsel = confsel{pos};
EDsel = EDsel{pos};
surv_nodes_C = surv_nodes_C{pos};
surv_dir = surv_dir{pos};

[~,I] = sort(EDsel,'descend');
Ref_check = zeros(size(confsel,1),1);
if isfield(PROJECT_OSP.geometry,'References')
    References = PROJECT_OSP.geometry.References;
else
    References = [];
end
for ij = 1:size(References,1)
    if isequal(References(ij,2:end),[1,0,0])
        vect = 1;
    elseif isequal(References(ij,2:end),[0,1,0])
        vect = 2;
    else
        vect = 3;
    end
    Ref_check(find(surv_nodes_C == References(ij,1) & surv_dir == vect)) = 1;
end

Label = confsel(:,2);
T = table(Ref_check(I),EDsel(I),Label(I));
PROJECT_OSP.OSP_results.Table = T;
handles.uitable2.Data = table2cell(T);


if runGlobalOSP
    surv_DOF = PROJECT_OSP.OSP_results.LISTADO_SETUP{4,1};
    surv_DOF_tot(:,1) = surv_DOF{pos};
    node_sel = PROJECT_OSP.OSP_results.LISTADO_SETUP{5,1};
    node_sel_tot(:,1) = node_sel{pos};
    dir_sel = PROJECT_OSP.OSP_results.LISTADO_SETUP{6,1};
    dir_sel_tot(:,1) = dir_sel{pos};
else
    for nsetup = 1:PROJECT_OSP.geometry.Nsetups
        surv_DOF = PROJECT_OSP.OSP_results.LISTADO_SETUP{4,nsetup};
        surv_DOF_tot(:,nsetup) = surv_DOF{pos};
        node_sel = PROJECT_OSP.OSP_results.LISTADO_SETUP{5,nsetup};
        node_sel_tot(:,nsetup) = node_sel{pos};
        dir_sel = PROJECT_OSP.OSP_results.LISTADO_SETUP{6,nsetup};
        dir_sel_tot(:,nsetup) = dir_sel{pos};
    end
end
PROJECT_OSP.OSP_results.surv_DOF = surv_DOF_tot;
PROJECT_OSP.OSP_results.node_sel = node_sel_tot;
PROJECT_OSP.OSP_results.dir_sel = dir_sel_tot;

labels = assign_labels_from_sensorsOSP(node_sel_tot, dir_sel_tot, References);
PROJECT_OSP.OSP_results.labels = labels;

n = max(PROJECT_OSP.geometry.Nsetups,1);
if runGlobalOSP
    n = 1;
end
PROJECT_OSP.geometry.sensorsOSP = zeros(PROJECT_OSP.config.n_sensors,4,n);
for i = 1:n  % setups
    for j  = 1:PROJECT_OSP.config.n_sensors % channels
        PROJECT_OSP.geometry.sensorsOSP(j,1,i) = PROJECT_OSP.OSP_results.node_sel(j,i);
        if PROJECT_OSP.OSP_results.dir_sel(j,i) == 1
            PROJECT_OSP.geometry.sensorsOSP(j,2:4,i) = [1,0,0];
        elseif PROJECT_OSP.OSP_results.dir_sel(j,i) == 2
            PROJECT_OSP.geometry.sensorsOSP(j,2:4,i) = [0,1,0];
        else
            PROJECT_OSP.geometry.sensorsOSP(j,2:4,i) = [0,0,1];
        end
    end
end
% Changes the order for sorting w.r.t. Ed
for nsetup = 1:n
    EDsel = PROJECT_OSP.OSP_results.LISTADO_SETUP{7,nsetup};
    EDsel = EDsel{pos};
    [~,I] = sort(EDsel,'descend');
    PROJECT_OSP.geometry.sensorsOSP(:,:,nsetup) = PROJECT_OSP.geometry.sensorsOSP(I,:,nsetup);
end

if runGlobalOSP
    set(handles.togglebutton5,'enable','on');  % button for generating references
    set(handles.popupmenu8,'enable','on');  % popup menu with the number of references
    set(handles.text19,'enable','on');
else  % popupmenu8 = popup menu that choses the number of references
    set(handles.togglebutton5,'enable','off');  % button for generating references
    if isfield(PROJECT_OSP.geometry, 'References')
        nrefs = size(PROJECT_OSP.geometry.References,1);
        handles.popupmenu8.Value = nrefs; % we set popup menu to the actual number of references
    end
    set(handles.popupmenu8,'enable','off');  % we disable this popup menu (doesn't make sense in a multisetup osp as they are already defined)
end
%    PROJECT_OSP.Style_Options.styleplot.Plotsetups=1;
PROJECT_OSP.Style_Options.styleplot.Plotsetups = ones(PROJECT_OSP.geometry.Nsetups,1);


if isfield(PROJECT_OSP,'OSP_results')
    if isfield(PROJECT_OSP.OSP_results,'LISTADO_SETUP')
        if ~runGlobalOSP
            if PROJECT_OSP.geometry.Nsetups>1
                nsetups = PROJECT_OSP.geometry.Nsetups;
                for i = 1:nsetups
                    eval(['set(handles.radiobutton',int2str(3+i),',''visible'',''on'');'])
                end
            end
        end
    end
end

assignin('base','PROJECT_OSP',PROJECT_OSP)

set(handles.pushbutton7,'enable','on');
set(handles.pushbutton21,'enable','on');

set(handles.text18,'visible','off');
drawnow


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PROJECT_OSP = evalin('base','PROJECT_OSP');

handles.popupmenu5.Value = 1;  % Set to "Geometry" instead of "Convergence"
view(handles.axes2,3)
popupmenu5_Callback(hObject, eventdata, handles)

% Generate Report in Word
[filename, filepath] = uiputfile('Untitled.docx', 'Save to Word');
if length(filename)>2 % Only if the user selected something
    FileName = fullfile(filepath, filename);
    save_to_word
end

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.pushbutton8.Value == 1
    handles.pushbutton10.Value = 0;
    handles.pushbutton9.Value = 0;
    pan off
    rotate3d(handles.axes4,'off')
    rotate3d(handles.axes3,'off')
    % zoom on
    % h = zoom(gcf);
    % setAllowAxesZoom(h,handles.axes3,false);
    % setAllowAxesZoom(h,handles.axes4,true);
    set(gcf, 'WindowScrollWheelFcn' , {@WindowScrollWheelCallback,handles.axes2})
else
    rotate3d(handles.axes4,'off')
    rotate3d(handles.axes3,'off')
    set(gcf, 'WindowScrollWheelFcn' , [])
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.pushbutton10.Value == 1
    pan off
    h = rotate3d;
    h.Enable = 'on';
    setAllowAxesRotate(h,handles.axes2,true);
    setAllowAxesRotate(h,handles.axes3,true);
    setAllowAxesRotate(h,handles.axes1,false);
    setAllowAxesRotate(h,handles.axes4,false);
else
    h = rotate3d;
    h.Enable = 'off';
    rotate3d(handles.axes2,'off')
    rotate3d(handles.axes3,'off')
    rotate3d(handles.axes1,'off')
    rotate3d(handles.axes4,'off')
end

% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.pushbutton11.Value == 1
    handles.pushbutton10.Value = 0;
    handles.pushbutton8.Value = 0;
    rotate3d(handles.axes4,'off')
    rotate3d(handles.axes1,'off')
    % zoom on
    % h = zoom(gcf);
    % setAllowAxesZoom(h,handles.axes3,false);
    % setAllowAxesZoom(h,handles.axes4,true);
    h = pan(gcf);
    setAxes3DPanAndZoomStyle(h,handles.axes2,'camera')
    h.Enable = 'on';
    setAllowAxesPan(h,handles.axes4,false)
    setAllowAxesPan(h,handles.axes1,false)
    setAllowAxesPan(h,handles.axes2,true)
else
    rotate3d(handles.axes4,'off')
    rotate3d(handles.axes1,'off')
    pan(gcf,'off')
    view(handles.axes2,3)
    handles.axes5.View = handles.axes2.View;  % Added on 30/04/24
end

% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Run modal analysis and extract geometry
PROJECT_OSP = evalin('base','PROJECT_OSP');
PROJECT_OSP.config.Nmodes = str2double(handles.edit2.String);

handles.text18.String = 'Running the FEM..... Please wait';
set(handles.text18,'visible','on');
drawnow
PROJECT_OSP = Run_SAP_model_for_OSP(PROJECT_OSP);


% Plot geometry
extramp = handles.slider1.Value;
plot_geometry_modes(handles.axes2,PROJECT_OSP,0,extramp);

nmodes = PROJECT_OSP.config.Nmodes;
for i=1:nmodes
    text(i) = {['Mode ',int2str(i)]};
end

handles.popupmenu2.String = text;
set(handles.popupmenu1,'enable','on')
% set(handles.popupmenu2,'enable','on')

fill_tables_OSP

try  % EGM - 18/02/25
    h = rotate3d;
    h.Enable = 'on';
    setAllowAxesRotate(h,handles.axes2,true);
    setAllowAxesRotate(h,handles.axes1,false);
    setAllowAxesRotate(h,handles.axes4,false);
end

cla(handles.axes4)
set(handles.popupmenu2,'visible','off');
handles.popupmenu5.Value = 1;  % Set to "Geometry" instead of "Convergence"
handles.togglebutton1.Value = 1;
togglebutton1_Callback(hObject, eventdata, handles)
popupmenu5_Callback(hObject, eventdata, handles)
assignin('base','PROJECT_OSP',PROJECT_OSP)
set(handles.pushbutton22,'enable','on');
set(handles.pushbutton23,'enable','on');
set(handles.pushbutton6,'enable','on');
set(handles.text18,'visible','off');




% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
PROJECT_OSP = evalin('base','PROJECT_OSP');
style_to_plot_OSP_2;

if isfield(PROJECT_OSP,'geometry')
    if isfield(PROJECT_OSP.config, 'runGlobalOSP')
        if PROJECT_OSP.config.runGlobalOSP
            PROJECT_OSP.Style_Options.styleplot.Plotref = 0;
        else
            PROJECT_OSP.Style_Options.styleplot.Plotref = handles.radiobutton27.Value;
        end
    elseif isfield(PROJECT_OSP.geometry,'References')
        PROJECT_OSP.Style_Options.styleplot.Plotref = handles.radiobutton27.Value;
    end
    if isfield(PROJECT_OSP.geometry, 'Nsetups')
        for i = 1:PROJECT_OSP.geometry.Nsetups
            eval(['PROJECT_OSP.Style_Options.styleplot.Plotsetups(',int2str(i),') = handles.radiobutton',int2str(3+i),'.Value;']);
        end
    end
end

assist_plot


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


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2

PROJECT_OSP = evalin('base','PROJECT_OSP');

if isequal(cell2mat(handles.popupmenu1.String(handles.popupmenu1.Value)),'Modal Analysis')
    modeplot = handles.popupmenu2.Value;
    extramp = handles.slider1.Value;
    plot_geometry_modes(handles.axes2,PROJECT_OSP,modeplot,extramp,handles.pushbutton13.Value);
end


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


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
minval = -abs(handles.slider1.Value);
maxval = abs(handles.slider1.Value);
nsteps = 7;

PROJECT_OSP = evalin('base','PROJECT_OSP');

modeplot = handles.popupmenu2.Value;

if handles.slider1.Value>0
    seriamp = linspace(maxval,minval,nsteps);
    seriamp = [seriamp,flip(seriamp(1:end-1))];
    seriamp = [seriamp,flip(seriamp(1:end-1))];
else
    seriamp = linspace(minval,maxval,nsteps);
    seriamp = [seriamp,flip(seriamp(1:end-1))];
    seriamp = [seriamp,flip(seriamp(1:end-1))];
end
for i=1:numel(seriamp)
    if handles.pushbutton13.Value==0
        break
    end
    extramp = seriamp(i);
    plot_geometry_modes(handles.axes2,PROJECT_OSP,modeplot,extramp,handles.pushbutton13.Value);
    drawnow
end
handles.pushbutton13.Value = 0;


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

PROJECT_OSP = evalin('base','PROJECT_OSP');
PROJECT_OSP.config.nmodes = str2double(handles.edit2.String);
assignin('base','PROJECT_OSP',PROJECT_OSP)


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


% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
popupmenu2_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

maxNumberOfImages = 100;
hObject.Min=-10;
hObject.Max=10;
hObject.SliderStep=[1/(maxNumberOfImages-1) , 10/(maxNumberOfImages-1) ];
hObject.Value=1;

% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


PROJECT_OSP = evalin('base','PROJECT_OSP');

[filename, filepath] = uiputfile('*.mat', 'Save the project file:');
if length(filename)>2 % Only if the user selected something
    FileName = fullfile(filepath, filename);
    PROJECT_OSP.dirproject = filepath;
    PROJECT_OSP.saveproject = FileName;
    save(FileName, 'PROJECT_OSP','-v7.3','-nocompression');
    
    dotpos = strfind(filename,'.');
    filename = filename(1:dotpos(1)-1);
    handles.edit5.String = filename;
    PROJECT_OSP.projectname = filename;
    assignin('base', 'PROJECT_OSP', PROJECT_OSP);
end


% --------------------------------------------------------------------
function uipushtool2_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filter = '*.mat';
if isempty(hObject.UserData)
    [file,path]=uigetfile(filter,'select a project file');
else
    [file,path]=uigetfile([hObject.UserData,filter],'select a project file');
end

filename=fullfile(path,file);
if file ==0
    return
end
hObject.UserData = path;

handles.text18.String = 'Loading..... Please wait';
set(handles.text18,'visible','on');
drawnow

warning ('off','all');
load(filename)
warning ('on','all');

if exist('PROJECT_OSP','var')
    loadproject_OSP
end
assignin('base', 'PROJECT_OSP', PROJECT_OSP);

if ~isempty(handles.uitable1.Data{1,1})
    set(handles.pushbutton22,'enable','on');
    set(handles.pushbutton23,'enable','on');
end
set(handles.text18,'visible','off');
drawnow


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% SETS 3D VIEW
view(handles.axes2,3)
xlim(handles.axes2,'auto');
ylim(handles.axes2,'auto');
zlim(handles.axes2,'auto');

% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% SETS XY VIEW
view(handles.axes2,[0,90])
xlim(handles.axes2,'auto');
ylim(handles.axes2,'auto');
zlim(handles.axes2,'auto');

% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% SETS XZ VIEW
view(handles.axes2,[0,0])
xlim(handles.axes2,'auto');
ylim(handles.axes2,'auto');
zlim(handles.axes2,'auto');

% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% SETS YZ VIEW
view(handles.axes2,[90,0])
xlim(handles.axes2,'auto');
ylim(handles.axes2,'auto');
zlim(handles.axes2,'auto');

% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


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


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1
if handles.togglebutton1.Value == 1
    handles.togglebutton2.Value = 0;
    handles.togglebutton3.Value = 0;
    set(handles.uipanel1,'visible','on');
    set(handles.uipanel2,'visible','off');
    set(handles.Uitable_Info,'visible','off');
end

% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2

PROJECT_OSP = evalin('base','PROJECT_OSP');
runGlobalOSP = PROJECT_OSP.config.runGlobalOSP;

if ~runGlobalOSP
    if PROJECT_OSP.geometry.Nsetups>0
        set(handles.popupmenu6,'visible','on');
        handles.popupmenu6.String = {};
        for ij = 1:PROJECT_OSP.geometry.Nsetups
            handles.popupmenu6.String(ij) = {['Setup ',int2str(ij)]};
        end
        handles.popupmenu6.Value = 1;
    end
end

if handles.togglebutton2.Value == 1
    handles.togglebutton1.Value = 0;
    handles.togglebutton3.Value = 0;
    set(handles.uipanel1,'visible','off');
    set(handles.uipanel2,'visible','on');
    set(handles.Uitable_Info,'visible','off');
end

popupmenu6_Callback(hObject, eventdata, handles)


% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
PROJECT_OSP = evalin('base','PROJECT_OSP');
PROJECT_OSP.config.n_sensors = str2double(handles.popupmenu4.String(handles.popupmenu4.Value));

nsetup = handles.popupmenu6.Value;
nsensors = cellfun(@(x) size(x,1),PROJECT_OSP.OSP_results.LISTADO_SETUP{1,nsetup});
pos = find(nsensors == PROJECT_OSP.config.n_sensors);

minED = PROJECT_OSP.OSP_results.LISTADO_SETUP{3,nsetup};


cla(handles.axes4)
hold(handles.axes4,'on')
plot(handles.axes4,1:1:numel(minED),minED,'Linewidth',2,'Color','b','Marker','s','MarkerFaceColor',[1,1,1]);
plot(handles.axes4,[pos,pos],[0,minED(pos)],'Linewidth',2,'Color','r','Marker','s','MarkerFaceColor',[1,0,0]);
hold(handles.axes4,'off')
max_num_sensors = 40;
xlim(handles.axes4,[max(1, numel(minED)-max_num_sensors),numel(minED)]) % set variable instead!; before: xlim(handles.axes4,[1,numel(minED)])
xticks(handles.axes4,1:1:numel(minED))
xticklabels(handles.axes4,nsensors)
xlabel(handles.axes4,'N sensors','interpreter','latex')
ylabel(handles.axes4,'min(Ed)','interpreter','latex')
assignin('base','PROJECT_OSP',PROJECT_OSP)

set(handles.axes2,'visible','off');
set(handles.axes3,'visible','off');
for j = 1:numel(handles.axes2.Children)
    handles.axes2.Children(j).Visible = 'off';
end
for j = 1:numel(handles.axes3.Children)
    handles.axes3.Children(j).Visible = 'off';
end
for j = 1:numel(handles.axes4.Children)
    handles.axes4.Children(j).Visible = 'on';
end
set(handles.axes4,'visible','on');
handles.popupmenu5.Value = 2;  % Set to "Convergence" instead of "Geometry"
handles.axes4.Color = 'none';

npotential_sensors = numel(minED);
surv_DOF = PROJECT_OSP.OSP_results.LISTADO_SETUP{4,nsetup};
for i = 1:npotential_sensors
    text_i(i) = {int2str(numel(cell2mat(surv_DOF(i))))};
end
handles.popupmenu4.String = text_i;
handles.popupmenu4.Value = pos;

for i = 1:PROJECT_OSP.config.n_sensors
    text_j(i) = {int2str(i)};
end
handles.popupmenu8.String = text_j;

confsel = PROJECT_OSP.OSP_results.LISTADO_SETUP{1,nsetup};
EDsel = PROJECT_OSP.OSP_results.LISTADO_SETUP{7,nsetup};
surv_nodes_C = PROJECT_OSP.OSP_results.LISTADO_SETUP{5,nsetup};
surv_dir = PROJECT_OSP.OSP_results.LISTADO_SETUP{6,nsetup};

confsel = confsel{pos};
EDsel = EDsel{pos};
surv_nodes_C = surv_nodes_C{pos};
surv_dir = surv_dir{pos};

[~,I] = sort(EDsel,'descend');
Ref_check = zeros(size(confsel,1),1);
if isfield(PROJECT_OSP.geometry,'References')
    References = PROJECT_OSP.geometry.References;
else
    References = [];
end
if isfield(PROJECT_OSP.config, 'runGlobalOSP')
    if PROJECT_OSP.config.runGlobalOSP
        References = [];
    end
end
for ij = 1:size(References,1)
    if isequal(References(ij,2:end),[1,0,0])
        vect = 1;
    elseif isequal(References(ij,2:end),[0,1,0])
        vect = 2;
    else
        vect = 3;
    end
    Ref_check(find(surv_nodes_C == References(ij,1) & surv_dir == vect)) = 1;
end

Label = confsel(:,2);
T = table(Ref_check(I),EDsel(I),Label(I));
PROJECT_OSP.OSP_results.Table = T;
handles.uitable2.Data = table2cell(T);

runGlobalOSP = PROJECT_OSP.config.runGlobalOSP;

if runGlobalOSP % PROJECT_OSP.geometry.Nsetups<2
    surv_DOF = PROJECT_OSP.OSP_results.LISTADO_SETUP{4,1};
    surv_DOF_tot(:,1) = surv_DOF{pos};
    node_sel = PROJECT_OSP.OSP_results.LISTADO_SETUP{5,1};
    node_sel_tot(:,1) = node_sel{pos};
    dir_sel = PROJECT_OSP.OSP_results.LISTADO_SETUP{6,1};
    dir_sel_tot(:,1) = dir_sel{pos};
else
    for nsetup = 1:PROJECT_OSP.geometry.Nsetups
        surv_DOF = PROJECT_OSP.OSP_results.LISTADO_SETUP{4,nsetup};
        surv_DOF_tot(:,nsetup) = surv_DOF{pos};
        node_sel = PROJECT_OSP.OSP_results.LISTADO_SETUP{5,nsetup};
        node_sel_tot(:,nsetup) = node_sel{pos};
        dir_sel = PROJECT_OSP.OSP_results.LISTADO_SETUP{6,nsetup};
        dir_sel_tot(:,nsetup) = dir_sel{pos};
    end
end
PROJECT_OSP.OSP_results.surv_DOF = surv_DOF_tot;
PROJECT_OSP.OSP_results.node_sel = node_sel_tot;
PROJECT_OSP.OSP_results.dir_sel = dir_sel_tot;

labels = assign_labels_from_sensorsOSP(node_sel_tot, dir_sel_tot, References);
PROJECT_OSP.OSP_results.labels = labels;

if runGlobalOSP
    n = 1;
else
    n = max(PROJECT_OSP.geometry.Nsetups,1);
end
PROJECT_OSP.geometry.sensorsOSP = zeros(PROJECT_OSP.config.n_sensors,4,n);
for i = 1:n  % setups
    for j  = 1:PROJECT_OSP.config.n_sensors % channels
        PROJECT_OSP.geometry.sensorsOSP(j,1,i) = PROJECT_OSP.OSP_results.node_sel(j,i);
        if PROJECT_OSP.OSP_results.dir_sel(j,i) == 1
            PROJECT_OSP.geometry.sensorsOSP(j,2:4,i) = [1,0,0];
        elseif PROJECT_OSP.OSP_results.dir_sel(j,i) == 2
            PROJECT_OSP.geometry.sensorsOSP(j,2:4,i) = [0,1,0];
        else
            PROJECT_OSP.geometry.sensorsOSP(j,2:4,i) = [0,0,1];
        end
    end
end

if ~runGlobalOSP
    for nsetup = 1:PROJECT_OSP.geometry.Nsetups
        EDsel = PROJECT_OSP.OSP_results.LISTADO_SETUP{7,nsetup};
        EDsel = EDsel{pos};
        [~,I] = sort(EDsel,'descend');
        PROJECT_OSP.geometry.sensorsOSP(:,:,nsetup) = PROJECT_OSP.geometry.sensorsOSP(I,:,nsetup);
    end
end

assignin('base','PROJECT_OSP',PROJECT_OSP)


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


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5

PROJECT_OSP = evalin('base','PROJECT_OSP');
if handles.popupmenu5.Value == 1  % If "Geometry" instead of "Convergence"
    % Delete convergence plot labels from view
    set(handles.edit4,'visible','off');
    set(handles.edit5,'visible','off');
    set(handles.text16,'visible','off');
    set(handles.text17,'visible','off');
    
    % Plot model geometry
    popupmenu1_Callback(hObject, eventdata, handles)
    set(handles.popupmenu1,'visible','on')
    %     set(handles.popupmenu2,'visible','on')
    %     set(handles.slider1,'visible','on')
    set(handles.axes2,'visible','on');
    set(handles.axes3,'visible','on');
    % Make 3D, XY, XZ, YZ view bottons available
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
    % Remove convergence plot from view
    for j = 1:numel(handles.axes4.Children)
        handles.axes4.Children(j).Visible = 'off';
    end
    set(handles.axes4,'visible','off');
else  % If "Convergence" instead of "Geometry"
    % Plot new plot labels (convergence figure)
    set(handles.edit4,'visible','on');
    set(handles.edit5,'visible','on');
    set(handles.text16,'visible','on');
    set(handles.text17,'visible','on');
    
    % Remove buttons related to Geometry plot
    set(handles.pushbutton16,'visible','off')
    set(handles.pushbutton17,'visible','off')
    set(handles.pushbutton18,'visible','off')
    set(handles.pushbutton19,'visible','off')
    set(handles.slider1,'visible','off')
    set(handles.popupmenu1,'visible','off')
    set(handles.popupmenu2,'visible','off')
    %     set(handles.slider1,'visible','off')
    set(handles.axes2,'visible','off');
    set(handles.axes3,'visible','off');
    
    % Remove from display the model geometry
    for j = 1:numel(handles.axes2.Children)
        handles.axes2.Children(j).Visible = 'off';
    end
    for j = 1:numel(handles.axes3.Children)
        handles.axes3.Children(j).Visible = 'off';
    end
    for j = 1:numel(handles.axes4.Children)
        handles.axes4.Children(j).Visible = 'on';
    end
    set(handles.axes4,'visible','on');
    view(handles.axes4,2)
end
axis(handles.axes1,'off')
axis(handles.axes2,'off')
axis(handles.axes3,'off')

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


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1


% --- Executes on button press in pushbutton20.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

PROJECT_OSP = evalin('base', 'PROJECT_OSP');
style_to_plot_OSP_2

% Only use uiwait if MATLAB is running with a GUI
if usejava('desktop')
    uiwait(style_OSP)
else
    disp('Running in headless mode: skipping uiwait');
end


PROJECT_OSP = evalin('base', 'PROJECT_OSP');


h = rotate3d;
h.Enable = 'on';
setAllowAxesRotate(h,handles.axes2,true);
setAllowAxesRotate(h,handles.axes1,false);
setAllowAxesRotate(h,handles.axes4,false);

cla(handles.axes4)
set(handles.popupmenu2,'visible','off');
handles.popupmenu5.Value = 1;  % Set to "Geometry" instead of "Convergence"
handles.togglebutton1.Value = 1;
togglebutton1_Callback(hObject, eventdata, handles)
popupmenu5_Callback(hObject, eventdata, handles)
assignin('base','PROJECT_OSP',PROJECT_OSP)
set(handles.pushbutton6,'enable','on')


% --- Executes during object deletion, before destroying properties.
function slider1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in togglebutton3.
function togglebutton3_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton3
if handles.togglebutton3.Value == 1
    handles.togglebutton1.Value = 0;
    handles.togglebutton2.Value = 0;
    set(handles.uipanel1,'visible','off');
    set(handles.uipanel2,'visible','off');
    set(handles.Uitable_Info,'visible','on');
    
    PROJECT_OSP = evalin('base','PROJECT_OSP');
    
    if ~isfield(PROJECT_OSP,'geometry')
        return
    end
    handles.text12.String = num2str(PROJECT_OSP.geometry.Nsetups);
    if isfield(PROJECT_OSP.geometry,'References')
        handles.text13.String = num2str(size(PROJECT_OSP.geometry.References,1));
    end
    handles.text11.String = num2str(size(PROJECT_OSP.geometry.nodes,1));
    
    handles.uitable3.Data = PROJECT_OSP.geometry.nodes;
    handles.popupmenu7.String = {};
    if PROJECT_OSP.geometry.Nsetups>0
        handles.popupmenu7.String(1) = {'Nodes'};
        for ijji = 1:PROJECT_OSP.geometry.Nsetups
            handles.popupmenu7.String(ijji+1) = {['Setup-',int2str(ijji)]};
        end
        handles.popupmenu7.String(length(handles.popupmenu7.String)+1) = {'References'};
    else
        handles.popupmenu7.String = {'Nodes'};
    end
    handles.popupmenu7.Value = 1;
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6
PROJECT_OSP = evalin('base','PROJECT_OSP');

if ~isfield(PROJECT_OSP.config,'n_sensors')
    PROJECT_OSP.config.n_sensors = round(str2double(handles.edit2.String));
end

nsetup = handles.popupmenu6.Value;
nsensors = cellfun(@(x) size(x,1),PROJECT_OSP.OSP_results.LISTADO_SETUP{1,nsetup});
pos = find(nsensors == PROJECT_OSP.config.n_sensors);

set(handles.popupmenu1,'visible','off')
set(handles.popupmenu2,'visible','off')
set(handles.slider1,'visible','off')
set(handles.togglebutton2,'visible','on')

minED = PROJECT_OSP.OSP_results.LISTADO_SETUP{3,nsetup};


cla(handles.axes4)
hold(handles.axes4,'on')
plot(handles.axes4,1:1:numel(minED),minED,'Linewidth',2,'Color','b','Marker','s','MarkerFaceColor',[1,1,1]);
plot(handles.axes4,[pos,pos],[0,minED(pos)],'Linewidth',2,'Color','r','Marker','s','MarkerFaceColor',[1,0,0]);
hold(handles.axes4,'off')
max_num_sensors = 40;
xlim(handles.axes4,[max(1, numel(minED)-max_num_sensors),numel(minED)]) % set variable instead!; before: xlim(handles.axes4,[1,numel(minED)])
xticks(handles.axes4,1:1:numel(minED))
xticklabels(handles.axes4,nsensors)
xlabel(handles.axes4,'N sensors','interpreter','latex')
ylabel(handles.axes4,'min(Ed)','interpreter','latex')
assignin('base','PROJECT_OSP',PROJECT_OSP)

set(handles.axes2,'visible','off');
set(handles.axes3,'visible','off');
for j = 1:numel(handles.axes2.Children)
    handles.axes2.Children(j).Visible = 'off';
end
for j = 1:numel(handles.axes3.Children)
    handles.axes3.Children(j).Visible = 'off';
end
for j = 1:numel(handles.axes4.Children)
    handles.axes4.Children(j).Visible = 'on';
end
set(handles.axes4,'visible','on');
handles.popupmenu5.Value = 2;  % Set to "Convergence" instead of "Geometry"
handles.axes4.Color = 'none';

npotential_sensors = numel(minED);
surv_DOF = PROJECT_OSP.OSP_results.LISTADO_SETUP{4,nsetup};
for i = 1:npotential_sensors
    text_i(i) = {int2str(numel(cell2mat(surv_DOF(i))))};
end
handles.popupmenu4.String = text_i;
handles.popupmenu4.Value = pos;
for i = 1:PROJECT_OSP.config.n_sensors
    text_j(i) = {int2str(i)};
end
handles.popupmenu8.String = text_j;


confsel = PROJECT_OSP.OSP_results.LISTADO_SETUP{1,nsetup};
EDsel = PROJECT_OSP.OSP_results.LISTADO_SETUP{7,nsetup};
surv_nodes_C = PROJECT_OSP.OSP_results.LISTADO_SETUP{5,nsetup};
surv_dir = PROJECT_OSP.OSP_results.LISTADO_SETUP{6,nsetup};

confsel = confsel{pos};
EDsel = EDsel{pos};
surv_nodes_C = surv_nodes_C{pos};
surv_dir = surv_dir{pos};

[~,I] = sort(EDsel,'descend');
Ref_check = zeros(size(confsel,1),1);
if isfield(PROJECT_OSP.geometry,'References')
    References = PROJECT_OSP.geometry.References;
else
    References = [];
end
for ij = 1:size(References,1)
    if isequal(References(ij,2:end),[1,0,0])
        vect = 1;
    elseif isequal(References(ij,2:end),[0,1,0])
        vect = 2;
    else
        vect = 3;
    end
    Ref_check(find(surv_nodes_C == References(ij,1) & surv_dir == vect)) = 1;
end

Label = confsel(:,2);
T = table(Ref_check(I),EDsel(I),Label(I));
PROJECT_OSP.OSP_results.Table = T;
handles.uitable2.Data = table2cell(T);

runGlobalOSP = PROJECT_OSP.config.runGlobalOSP;

if runGlobalOSP % PROJECT_OSP.geometry.Nsetups<2
    surv_DOF = PROJECT_OSP.OSP_results.LISTADO_SETUP{4,1};
    surv_DOF_tot(:,1) = surv_DOF{pos};
    node_sel = PROJECT_OSP.OSP_results.LISTADO_SETUP{5,1};
    node_sel_tot(:,1) = node_sel{pos};
    dir_sel = PROJECT_OSP.OSP_results.LISTADO_SETUP{6,1};
    dir_sel_tot(:,1) = dir_sel{pos};
else
    for nsetup = 1:PROJECT_OSP.geometry.Nsetups
        surv_DOF = PROJECT_OSP.OSP_results.LISTADO_SETUP{4,nsetup};
        surv_DOF_tot(:,nsetup) = surv_DOF{pos};
        node_sel = PROJECT_OSP.OSP_results.LISTADO_SETUP{5,nsetup};
        node_sel_tot(:,nsetup) = node_sel{pos};
        dir_sel = PROJECT_OSP.OSP_results.LISTADO_SETUP{6,nsetup};
        dir_sel_tot(:,nsetup) = dir_sel{pos};
    end
end
PROJECT_OSP.OSP_results.surv_DOF = surv_DOF_tot;
PROJECT_OSP.OSP_results.node_sel = node_sel_tot;
PROJECT_OSP.OSP_results.dir_sel = dir_sel_tot;

labels = assign_labels_from_sensorsOSP(node_sel_tot, dir_sel_tot, References);
PROJECT_OSP.OSP_results.labels = labels;

if ~runGlobalOSP
    for nsetup = 1:PROJECT_OSP.geometry.Nsetups
        EDsel = PROJECT_OSP.OSP_results.LISTADO_SETUP{7,nsetup};
        EDsel = EDsel{pos};
        [~,I] = sort(EDsel,'descend');
        PROJECT_OSP.geometry.sensorsOSP(:,:,nsetup) = PROJECT_OSP.geometry.sensorsOSP(I,:,nsetup);
    end
end

assignin('base','PROJECT_OSP',PROJECT_OSP)

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


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7
PROJECT_OSP = evalin('base', 'PROJECT_OSP');
if handles.popupmenu7.Value == 1
    handles.uitable3.ColumnName(1) = {'Node'};
    handles.uitable3.ColumnName(2) = {'x'};
    handles.uitable3.ColumnName(3) = {'y'};
    handles.uitable3.ColumnName(4) = {'z'};
    handles.uitable3.Data = PROJECT_OSP.geometry.nodes;
elseif handles.popupmenu7.Value < numel(handles.popupmenu7.String)
    handles.uitable3.ColumnName(1) = {'Node'};
    handles.uitable3.ColumnName(2) = {'x'};
    handles.uitable3.ColumnName(3) = {'y'};
    handles.uitable3.ColumnName(4) = {'z'};
    setup_field_name = sprintf('Setup_%d', handles.popupmenu7.Value - 1);
    setup_nodes = PROJECT_OSP.geometry.(setup_field_name);
    indices_bool = ismember(PROJECT_OSP.geometry.nodes(:, 1), setup_nodes);
    handles.uitable3.Data = PROJECT_OSP.geometry.nodes(find(indices_bool), :);
    %OLD
    %eval(['handles.uitable3.Data = PROJECT_OSP.geometry.nodes(PROJECT_OSP.geometry.Setup_',int2str(handles.popupmenu7.Value-1),',:);']);
else
    handles.uitable3.ColumnName(1) = {'Node'};
    handles.uitable3.ColumnName(2) = {'UX'};
    handles.uitable3.ColumnName(3) = {'UY'};
    handles.uitable3.ColumnName(4) = {'UZ'};
    handles.uitable3.Data = PROJECT_OSP.geometry.References;
end


% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton5.
function togglebutton5_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton5
dlgTitle    = 'User Question';
dlgQuestion = 'Do you want to create a new model with the selected number of references?';
choice = questdlg(dlgQuestion,dlgTitle,'Yes','No', 'Yes');

if strcmp(choice,'Yes')
    PROJECT_OSP = evalin('base','PROJECT_OSP');
    nref = handles.popupmenu8.Value;
    [filename, filepath] = uiputfile('*.sdb', 'Save the SAP2000 model:');
    if length(filename)>2 % Only if the user selected something
        FileName = fullfile(filepath, filename);
        create_references_SAP(FileName,PROJECT_OSP,nref);
        message = sprintf('Model Successfully Saved in: %s\nRemember creating the (.xlsx) database and reload it', FileName);
        f = msgbox(message);
    end
end

% --- Executes on selection change in popupmenu8.
function popupmenu8_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu8



% --- Executes during object creation, after setting all properties.
function popupmenu8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton1
PROJECT_OSP = evalin('base','PROJECT_OSP');
PROJECT_OSP.config.Target_DOFs(1) = handles.radiobutton1.Value;
PROJECT_OSP.config.Target_DOFs(2) = handles.radiobutton2.Value;
PROJECT_OSP.config.Target_DOFs(3) = handles.radiobutton3.Value;
assignin('base','PROJECT_OSP',PROJECT_OSP)

% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton2
PROJECT_OSP = evalin('base','PROJECT_OSP');
PROJECT_OSP.config.Target_DOFs(1) = handles.radiobutton1.Value;
PROJECT_OSP.config.Target_DOFs(2) = handles.radiobutton2.Value;
PROJECT_OSP.config.Target_DOFs(3) = handles.radiobutton3.Value;
assignin('base','PROJECT_OSP',PROJECT_OSP)

% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton3
PROJECT_OSP = evalin('base','PROJECT_OSP');
PROJECT_OSP.config.Target_DOFs(1) = handles.radiobutton1.Value;
PROJECT_OSP.config.Target_DOFs(2) = handles.radiobutton2.Value;
PROJECT_OSP.config.Target_DOFs(3) = handles.radiobutton3.Value;
assignin('base','PROJECT_OSP',PROJECT_OSP)

% --- Executes on button press in pushbutton21.
function pushbutton21_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PROJECT_OSP = evalin('base','PROJECT_OSP');

style_to_plot_OSP_2
[filename, filepath] = uiputfile('*.dxf', 'Save to AUTOCAD');
if length(filename)>2 % Only if the user selected something
    FileName = fullfile(filepath, filename);
    save_to_cad(FileName,PROJECT_OSP);
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double
handles.edit4.String = round(str2double(handles.edit4.String));
handles.edit5.String = round(str2double(handles.edit5.String));
posa = find(cellfun(@(x) strcmp(x,handles.edit4.String),handles.axes4.XTickLabel));
posb = find(cellfun(@(x) strcmp(x,handles.edit5.String),handles.axes4.XTickLabel));
if isempty(posa)
    posa = 1;
    handles.edit4.String = cell2mat(handles.axes4.XTickLabel(1));
end
if isempty(posb)
    posb = numel(handles.axes4.XTickLabel);
    handles.edit5.String = cell2mat(handles.axes4.XTickLabel(end));
end
xlim(handles.axes4,[posa,posb]);


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



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double
handles.edit4.String = round(str2double(handles.edit4.String));
handles.edit5.String = round(str2double(handles.edit5.String));
posa = find(cellfun(@(x) strcmp(x,handles.edit4.String),handles.axes4.XTickLabel));
posb = find(cellfun(@(x) strcmp(x,handles.edit5.String),handles.axes4.XTickLabel));
if isempty(posa)
    posa = 1;
    handles.edit4.String = cell2mat(handles.axes4.XTickLabel(1));
end
if isempty(posb)
    posb = numel(handles.axes4.XTickLabel);
    handles.edit5.String = cell2mat(handles.axes4.XTickLabel(end));
end
xlim(handles.axes4,[posa,posb]);

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


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton4
popupmenu5_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton5
popupmenu5_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton6.
function radiobutton6_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton6
popupmenu5_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7
popupmenu5_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton8
popupmenu5_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton9.
function radiobutton9_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton9
popupmenu5_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton10.
function radiobutton10_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton10
popupmenu5_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton11.
function radiobutton11_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton11
popupmenu5_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton12.
function radiobutton12_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton12
popupmenu5_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton13.
function radiobutton13_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton13
popupmenu5_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton14.
function radiobutton14_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton14
popupmenu5_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton15.
function radiobutton15_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton15
popupmenu5_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton16.
function radiobutton16_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton16
popupmenu5_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton17.
function radiobutton17_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton17
popupmenu5_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton18.
function radiobutton18_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton18
popupmenu5_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton19.
function radiobutton19_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton19
popupmenu5_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton20.
function radiobutton20_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton20
popupmenu5_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton21.
function radiobutton21_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton21
popupmenu5_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton22.
function radiobutton22_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton22
popupmenu5_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton23.
function radiobutton23_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton23
popupmenu5_Callback(hObject, eventdata, handles)

% --- Executes on button press in radiobutton24.
function radiobutton24_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton24
popupmenu5_Callback(hObject, eventdata, handles)


% --- Executes on button press in radiobutton26.
function radiobutton26_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton26 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton26
PROJECT_OSP = evalin('base','PROJECT_OSP');
if handles.radiobutton26.Value == 1
    if isfield(PROJECT_OSP,'OSP_results')
        if isfield(PROJECT_OSP.OSP_results,'LISTADO_SETUP')
            if size(PROJECT_OSP.OSP_results.LISTADO_SETUP,2)>1
                set(handles.uipanel4,'visible','on');
            end
        end
    end
else
    set(handles.uipanel4,'visible','off');
end

% --- Executes on button press in pushbutton22.
function pushbutton22_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nmodes = size(handles.uitable1.Data,1);
handles.uitable1.Data(:,2) = num2cell(logical(ones(nmodes,1)));

% --- Executes on button press in pushbutton23.
function pushbutton23_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
nmodes = size(handles.uitable1.Data,1);
handles.uitable1.Data(:,2) = num2cell(logical(zeros(nmodes,1)));


% --- Executes on button press in radiobutton27.
function radiobutton27_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton27 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton27
popupmenu5_Callback(hObject, eventdata, handles)
